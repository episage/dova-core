/* thread-posix.vala
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

public delegate int Dova.ThreadStart ();

public sealed class Dova.Thread {
	OS.pthread_t native;

	static int start_routine (void* data) {
		var func = (ThreadStart) data;
		result = func ();
	}

	public Thread (ThreadStart func) {
		OS.pthread_create (&native, null, (void*) start_routine, (void*) func);
	}

	public static void sleep (Time time) {
		var ts = OS.timespec ();
		ts.tv_sec = time.ticks / 10000000;
		ts.tv_nsec = time.ticks % 10000000 * 100;
		OS.nanosleep (&ts, null);
	}

	public static void yield () {
		OS.sched_yield ();
	}

	public intptr join () {
		result = 0;
		OS.pthread_join (native, (void**) (&result));
	}

	public static void exit (intptr retval) {
		OS.pthread_exit ((void*) retval);
	}
}

public enum Dova.MutexType {
	PLAIN = 1 << 0,
	RECURSIVE = 1 << 1,
	TIMED = 1 << 2,
	TRY = 1 << 3
}

public sealed class Dova.Mutex {
	OS.pthread_mutex_t native;

	public Mutex (MutexType type = MutexType.PLAIN) {
		OS.pthread_mutexattr_t attr;

		OS.pthread_mutexattr_init (&attr);

		switch (type) {
		case MutexType.PLAIN:
		case MutexType.TIMED:
			OS.pthread_mutexattr_settype (&attr, OS.PTHREAD_MUTEX_NORMAL);
			break;
		case MutexType.TRY:
			OS.pthread_mutexattr_settype (&attr, OS.PTHREAD_MUTEX_ERRORCHECK);
			break;
		case MutexType.PLAIN | MutexType.RECURSIVE:
		case MutexType.TIMED | MutexType.RECURSIVE:
		case MutexType.TRY | MutexType.RECURSIVE:
			OS.pthread_mutexattr_settype (&attr, OS.PTHREAD_MUTEX_RECURSIVE);
			break;
		default:
			// throw error
			break;
		}

		OS.pthread_mutex_init (&native, &attr);
		OS.pthread_mutexattr_destroy (&attr);
	}

	~Mutex () {
		OS.pthread_mutex_destroy (&native);
	}

	public void lock () {
		OS.pthread_mutex_lock (&native);
	}

	public bool try_lock () {
		int ret = OS.pthread_mutex_trylock (&native);
		return (ret == 0);
	}

	public void unlock () {
		OS.pthread_mutex_unlock (&native);
	}
}

