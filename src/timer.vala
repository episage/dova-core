/* timer.vala
 *
 * Copyright (C) 2010  Jürg Billeter
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

public class Dova.Timer {
	public bool running { get; private set; }
	public Duration elapsed { get; private set; }
	Posix.timespec begin;

	public Timer () {
	}

	public void start () {
		assert (!running);
		Posix.clock_gettime (Posix.CLOCK_MONOTONIC, &begin);
		running = true;
	}

	public void stop () {
		assert (running);
		var end = Posix.timespec ();
		Posix.clock_gettime (Posix.CLOCK_MONOTONIC, &end);
		end.tv_sec -= begin.tv_sec;
		end.tv_nsec -= begin.tv_nsec;
		if (end.tv_nsec < 0) {
			end.tv_sec--;
			end.tv_nsec += 1000000000;
		}
		long diff = (long) end.tv_sec * 10000000 + (long) end.tv_nsec / 100;
		elapsed = Duration.with_ticks (elapsed.ticks + diff);
		running = false;
	}

	public void reset () {
		assert (!running);
		elapsed = Duration ();
	}
}
