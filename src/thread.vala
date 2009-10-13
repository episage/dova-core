/* thread.vala
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

public delegate int Dova.ThreadStart ();

public class Dova.Thread {
	Posix.pthread_t native;

	static void* start_routine (void* data) {
		var func = (ThreadStart) data;
		result = (void*) func ();
	}

	public Thread (ThreadStart func) {
		Posix.pthread_create (&native, null, (void*) start_routine, (void*) func);
	}

	public static void sleep (Duration duration) {
		var ts = Posix.timespec ();
		ts.tv_sec = duration / 10000000;
		ts.tv_nsec = duration % 10000000 * 100;
		Posix.nanosleep (&ts, null);
	}

	public static void yield () {
		Posix.sched_yield ();
	}
}

public class Dova.Mutex {
	Posix.pthread_mutex_t native;

	public Mutex () {
		Posix.pthread_mutex_init (&native, null);
	}

	public void lock () {
		Posix.pthread_mutex_lock (&native);
	}

	public void unlock () {
		Posix.pthread_mutex_unlock (&native);
	}
}

