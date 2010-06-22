/* eventcontext.vala
 *
 * Copyright (C) 2009  Jürg Billeter
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

public class Dova.EventContext {
	int epfd;
	ArrayList<EventSource> sources;
	ArrayList<EventSource> pending;
	static EventContext? _main;

	public EventContext () {
		sources = new ArrayList<EventSource> ();
		pending = new ArrayList<EventSource> ();

		this.epfd = Linux.epoll_create1 (Linux.EPOLL_CLOEXEC);
	}

	public static EventContext main {
		get {
			if (_main == null) {
				_main = new EventContext ();
			}
			return (!) _main;
		}
	}

	public void wait () {
		Linux.epoll_event events[64];

		int nfds = Linux.epoll_wait (epfd, events, 64, -1);
		for (int i = 0; i < nfds; i++) {
			var source = (EventSource) events[i].data.ptr;
			pending.add (source);
		}
	}

	public void dispatch () {
		// TODO handle priority and timers

		// foreach (var source in pending) {
		for (int i = 0; i < pending.length; i++) {
			EventSource source = pending.get (i);
			source.dispatch ();
		}
	}

	public void add_source (EventSource source) {
		sources.add (source);
		if (source.fd >= 0) {
			var event = Linux.epoll_event ();
			event.events = source.fd_events;
			event.data.ptr = source;
			Linux.epoll_ctl (epfd, Linux.EPOLL_CTL_ADD, source.fd, &event);
		}
	}

	public void remove_source (EventSource source) {
		if (source.fd >= 0) {
			Linux.epoll_ctl (epfd, Linux.EPOLL_CTL_DEL, source.fd, null);
		}
		sources.remove (source);
	}

	public void run () {
		while (true) {
			wait ();
			dispatch ();
		}
	}
}

namespace Dova.Application {
	public void run () {
		EventContext.main.run ();
	}
}

public abstract class Dova.EventSource {
	public int fd { get; protected set; }
	public int fd_events { get; protected set; }

	public abstract void dispatch ();
}

public class Dova.FDEventSource : EventSource {
	public FDEventSource (int fd, int fd_events) {
		this.fd = fd;
		this.fd_events = fd_events;
	}

	public override void dispatch () {
		Console.write_line (Console.read_line ());
	}
}

