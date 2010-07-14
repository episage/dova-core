/* task.vala
 *
 * Copyright (C) 2009-2010  Jürg Billeter
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.

 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.

 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301  USA
 *
 * Author:
 * 	Jürg Billeter <j@bitron.ch>
 */

public class Dova.Application {
	public Application () {
		TaskScheduler.main = new TaskScheduler ();
		TaskScheduler.main.main_task = new Task ();
		Task.current = TaskScheduler.main.main_task;
		Task.current.state = TaskState.RUNNING;
	}

	public static string? get_environment_variable (string name) {
		byte* cstring = OS.getenv (name.data);
		if (cstring == null) {
			result = null;
		} else {
			result = string.create_from_cstring (cstring);
		}
	}

	public static int get_user_id () {
		return (int) OS.getuid ();
	}

	public void run () {
		TaskScheduler.main.sched ();
	}
}

public enum Dova.TaskState {
	SLEEPING,
	WAITING,
	READY,
	RUNNING,
	TERMINATED
}

namespace Dova.TaskPriority {
	public const int HIGH = -20;
	public const int DEFAULT = 0;
	public const int LOW = 20;
}

class Dova.TaskScheduler {
	int epfd;
	Task?[] runqueues;
	internal Task main_task { get; set; }
	internal Task cleanup_task { get; set; }
	int ready_count;
	int wait_count;

	internal static TaskScheduler main;

	public TaskScheduler () {
		this.epfd = OS.epoll_create1 (OS.EPOLL_CLOEXEC);

		runqueues = new Task[TaskPriority.LOW - TaskPriority.HIGH + 1];
	}

	public void sched () {
		if (Task.current != main_task) {
			main_task.dispatch ();
			return;
		}

		// set cleanup_task to null to free all associated resources
		cleanup_task = null;

		while (wait_count + ready_count > 0) {
			if (wait_count > 0) {
				OS.epoll_event events[64];

				while (true) {
					int timeout = ready_count > 0 ? 0 : -1;

					int nfds = OS.epoll_wait (epfd, events, 64, timeout);
					if (nfds < 0) {
						// handle errors (EINTR)
					}
					for (int i = 0; i < nfds; i++) {
						var task = (Task) events[i].data.ptr;
						OS.epoll_ctl (epfd, OS.EPOLL_CTL_DEL, task.wait_fd, null);
						// close duplicate fd
						OS.close (task.wait_fd);
						task.wait_fd = -1;
						wait_count--;
						assert (true && task.state == TaskState.WAITING);
						ready (task);
					}
					if (nfds < 64) {
						break;
					}
				}
			}

			bool ready_found = false;
			for (int priority = 0; priority < TaskPriority.LOW - TaskPriority.HIGH + 1; priority++) {
				if (runqueues[priority] != null) {
					ready_found = true;

					// remove head from list
					var head = runqueues[priority];
					if (head.next == head) {
						// last task in list
						runqueues[priority] = null;
					} else {
						head.prev.next = head.next;
						head.next.prev = head.prev;
						runqueues[priority] = head.next;
					}
					head.next = null;
					head.prev = null;

					ready_count--;
					assert (true && head.state == TaskState.READY);
					head.state = TaskState.RUNNING;

					if (head == main_task) {
						// scheduler runs in main task
						return;
					} else {
						head.dispatch ();
					}
				}
				if (ready_found) {
					// only execute run queue of highest priority at once
					break;
				}
			}
		}
	}

	internal void ready (Task task) {
		assert (task.state == TaskState.SLEEPING || task.state == TaskState.WAITING || task.state == TaskState.RUNNING);

		var head = runqueues[task.priority - TaskPriority.HIGH];
		if (head == null) {
			runqueues[task.priority - TaskPriority.HIGH] = task;
			task.next = task;
			task.prev = task;
		} else {
			task.next = head;
			task.prev = head.prev;
			head.prev.next = task;
			head.prev = task;
		}

		task.state = TaskState.READY;
		ready_count++;
	}

	public void yield (Task task) {
		ready (task);
		sched ();
	}

	internal void wait_fd_in (Task task, int fd) {
		assert (true && task.state == TaskState.RUNNING);

		// epoll doesn't support reigstering the same fd twice
		// so if we want to wait for the same fd in two fibers (one for read, one for write),
		// we need to either multiplex events from the fd ourselves
		// or use dup() to register a duplicate of the fd for the second event

		int dupfd = OS.dup (fd);

		var event = OS.epoll_event ();
		event.events = OS.EPOLLIN;
		event.data.ptr = task;
		OS.epoll_ctl (epfd, OS.EPOLL_CTL_ADD, dupfd, &event);

		task.wait_fd = dupfd;

		wait_count++;
		task.state = TaskState.WAITING;

		sched ();
	}

	internal void wait_fd_out (Task task, int fd) {
		assert (true && task.state == TaskState.RUNNING);

		// epoll doesn't support reigstering the same fd twice
		// so if we want to wait for the same fd in two fibers (one for read, one for write),
		// we need to either multiplex events from the fd ourselves
		// or use dup() to register a duplicate of the fd for the second event

		int dupfd = OS.dup (fd);

		var event = OS.epoll_event ();
		event.events = OS.EPOLLOUT;
		event.data.ptr = task;
		OS.epoll_ctl (epfd, OS.EPOLL_CTL_ADD, dupfd, &event);

		task.wait_fd = dupfd;

		wait_count++;
		task.state = TaskState.WAITING;

		sched ();
	}

	internal void sleep (Task task, Duration duration) {
		assert (true && task.state == TaskState.RUNNING);

		var its = OS.itimerspec ();
		its.it_value.tv_nsec = duration.ticks % 10000000 * 100;
		its.it_value.tv_sec = duration.total_seconds;

		int tfd = OS.timerfd_create (OS.CLOCK_MONOTONIC, OS.TFD_CLOEXEC);
		OS.timerfd_settime (tfd, 0, &its, null);

		var event = OS.epoll_event ();
		event.events = OS.EPOLLIN;
		event.data.ptr = task;
		OS.epoll_ctl (epfd, OS.EPOLL_CTL_ADD, tfd, &event);

		task.wait_fd = tfd;

		wait_count++;
		task.state = TaskState.WAITING;

		sched ();
	}

	internal void pause (Task task) {
		assert (true && task.state == TaskState.RUNNING);

		task.state = TaskState.SLEEPING;
		sched ();
	}
}

public delegate void Dova.Func ();

public class Dova.Task {
	// TLS
	public static Task current;

	static int last_id;

	internal int id { get; private set; }

	TaskScheduler scheduler;

	Func func;
	public TaskState state { get; internal set; }
	internal int priority;
	internal Task? prev { get; set; }
	internal Task? next { get; set; }
	OS.ucontext_t ucontext;
	void* stack;

	internal int wait_fd;

	// TODO add cancellation / termination support

	const int STACK_SIZE = 1024 * 1024;

	internal Task () {
		scheduler = TaskScheduler.main;
		wait_fd = -1;
		id = ++last_id;
	}

	~Task () {
		if (stack != null) {
			OS.munmap (stack, STACK_SIZE);
		}
	}

	static void task_func () {
		current.func ();
		// end of task
		current.state = TaskState.TERMINATED;
		current.scheduler.cleanup_task = current;

		current.scheduler.sched ();
	}

	// maybe make it a constructor or not call it run as it doesn't trigger scheduling and will not run immediately
	public static Task run (Func func) {
		result = new Task ();

		// inherit priority from current task
		result.priority = current.priority;

		result.func = func;
		result.stack = OS.mmap (null, STACK_SIZE, OS.PROT_READ | OS.PROT_WRITE, OS.MAP_PRIVATE | OS.MAP_ANONYMOUS, -1, 0);
		OS.getcontext (&result.ucontext);
		result.ucontext.uc_stack.ss_sp = result.stack;
		result.ucontext.uc_stack.ss_size = STACK_SIZE;
		OS.makecontext (&result.ucontext, (void*) task_func, 0);
		result.resume ();
	}

	public static void wait_fd_in (int fd) {
		current.scheduler.wait_fd_in (current, fd);
	}

	public static void wait_fd_out (int fd) {
		current.scheduler.wait_fd_out (current, fd);
	}

	public static void wait_pid (int pid) {
		// TODO
	}

	public static void pause () {
		current.scheduler.pause (current);
	}

	public static void yield () {
		current.scheduler.yield (current);
	}

	public static void sleep (Duration duration) {
		current.scheduler.sleep (current, duration);
	}

	public void resume () {
		assert (true && state == TaskState.SLEEPING);
		scheduler.ready (this);
	}

	internal void dispatch () {
		var old_task = current;
		current = this;
		OS.swapcontext (&old_task.ucontext, &ucontext);
	}
}
