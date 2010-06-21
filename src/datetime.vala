/* datetime.vala
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

public struct Dova.DateTime {
	public Time time;
	public Duration offset;

	public int year {
		get { return date.year; }
	}

	public int month {
		get { return date.month; }
	}

	public int day {
		get { return date.day; }
	}

	public Date date {
		get { return Date.with_days ((int) ((time.ticks + offset.ticks) / 10000000 / 3600 / 24)); }
	}

	public int hour {
		get { return time_of_day.hour; }
	}

	public int minute {
		get { return time_of_day.minute; }
	}

	public int second {
		get { return time_of_day.second; }
	}

	public int millisecond {
		get { return time_of_day.millisecond; }
	}

	public TimeOfDay time_of_day {
		get { return TimeOfDay.with_ticks ((time.ticks + offset.ticks) % ((long) 24 * 3600 * 10000000)); }
	}

	public DateTime (Time time, Duration offset) {
		this.time = time;
		this.offset = offset;
	}

	public DateTime.now () {
		var local = Time.now ().local;
		this.time = local.time;
		this.offset = local.offset;
	}

	public DateTime.dt (Date date, TimeOfDay time_of_day, Duration offset) {
		this.time = Time.with_ticks ((long) date.days * 24 * 3600 * 10000000 + time_of_day.ticks - offset.ticks);
		this.offset = offset;
	}

	public static DateTime parse (string str) {
		return DateTime.now ();
	}

	public string format (string format) {
		return to_string ();
	}

	static string format_number (int number, int digits) {
		result = number.to_string ();
		while (result.length < digits) {
			result = "0" + result;
		}
	}

	public string to_string () {
		result = date.to_string () + "T" + time_of_day.to_string ();
		int offset = (int) (offset.ticks / 10000000 / 60);
		if (offset == 0) {
			result += "Z";
		} else {
			if (offset > 0) {
				result += "+";
			} else {
				result += "-";
				offset = -offset;
			}
			result += format_number (offset / 60, 2);
			result += format_number (offset % 60, 2);
		}
	}
}

