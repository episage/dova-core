/* thread.vala
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

public class Dova.Thread {
	OS.thrd_t native;

	static int start_routine (void* data) {
		var func = (ThreadStart) data;
		result = func ();
	}

	public Thread (ThreadStart func) {
		OS.thrd_create (&native, (void*) start_routine, (void*) func);
	}

	public static void sleep (Duration duration) {
		var ts = OS.timespec ();
		ts.tv_sec = duration.ticks / 10000000;
		ts.tv_nsec = duration.ticks % 10000000 * 100;
		OS.nanosleep (&ts, null);
	}

	public static void yield () {
		OS.thrd_yield ();
	}

	public int join () {
		result = 0;
		OS.thrd_join (native, &result);
	}

	public static void exit (int retval) {
		OS.thrd_exit (retval);
	}
}

public enum Dova.MutexType {
	PLAIN = 1 << 0,
	RECURSIVE = 1 << 1,
	TIMED = 1 << 2,
	TRY = 1 << 3
}

public class Dova.Mutex {
	OS.mtx_t native;

	public Mutex (MutexType type = MutexType.PLAIN) {
		OS.mtx_init (&native, type);
	}

	~Mutex () {
		OS.mtx_destroy (&native);
	}

	public void lock () {
		OS.mtx_lock (&native);
	}

	public bool try_lock () {
		int ret = OS.mtx_trylock (&native);
		return (ret == OS.thrd_success);
	}

	public void unlock () {
		OS.mtx_unlock (&native);
	}
}

