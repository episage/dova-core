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
	public Time elapsed { get; private set; }
	Time begin;

	public Timer () {
	}

	public void start () {
		assert (!running);
		begin = Clock.MONOTONIC.get_time ();
		running = true;
	}

	public void stop () {
		assert (running);
		var end = Clock.MONOTONIC.get_time ();
		Time diff = Time.with_ticks (end.ticks - begin.ticks);
		elapsed = Time.with_ticks (elapsed.ticks + diff.ticks);
		running = false;
	}

	public void reset () {
		assert (!running);
		elapsed = Time ();
	}
}
