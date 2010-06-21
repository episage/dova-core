/* duration.vala
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

public struct Dova.Duration {
	public long ticks;

	public long total_milliseconds {
		get { return ticks / 10000; }
	}

	public long total_seconds {
		get { return ticks / 10000000; }
	}

	public Duration (int days = 0, int hours = 0, int minutes = 0, int seconds = 0, int milliseconds = 0) {
		ticks = ((((((long) days * 24 + hours) * 60 + minutes) * 60 + seconds) * 1000 + milliseconds) * 10000);
	}

	internal Duration.with_ticks (long ticks) {
		this.ticks = ticks;
	}
}

