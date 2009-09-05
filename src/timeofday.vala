/* timeofday.vala
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

/**
 * Time of day.
 */
public struct Dova.TimeOfDay {
	// 100 nanosecond ticks since 00:00
	public long ticks;

	public int hour {
		get { return (int) (ticks / 10000000 / 3600); }
	}

	public int minute {
		get { return (int) (ticks / 10000000 / 60 % 60); }
	}

	public int second {
		get { return (int) (ticks / 10000000 % 60); }
	}

	public int millisecond {
		get { return (int) (ticks / 10000 % 1000); }
	}

	public TimeOfDay (int hour, int minute, int second, int millisecond = 0) {
		int minutes = hour * 60 + minute;
		int seconds = minutes * 60 + second;
		int milliseconds = seconds * 1000 + millisecond;
		this.ticks = (long) milliseconds * 10000;
	}

	public TimeOfDay.now () {
	}

	internal TimeOfDay.with_ticks (long ticks) {
		this.ticks = ticks;
	}

	static string format_number (int number, int digits) {
		result = number.to_string ();
		while (result.length < digits) {
			result = "0" + result;
		}
		return;
	}

	public string to_string () {
		return format_number (hour, 2) + ":" + format_number (minute, 2) + ":" + format_number (second, 2);
	}
}

