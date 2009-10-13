/* time.vala
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
 * Point in time.
 *
 * Measured in 100 nanosecond ticks since epoch (January 1, 0001 00:00 UTC).
 * Uses proleptic Gregorian calendar for dates before 1582.
 */
public struct Dova.Time : long {
	// total seconds since epoch until start of unix time (january 1, 1970 00:00 UTC)
	const long UNIX_SECONDS = 62135596800;

	public Time.now () {
		Posix.timeval tv;
		Posix.gettimeofday (out tv, null);
		this = (Time) ((UNIX_SECONDS + tv.tv_sec) * 10000000 + tv.tv_usec * 10);
	}

	public new string to_string () {
		return utc.to_string ();
	}

	public DateTime local {
		get {
			var ltm = Posix.tm ();
			long seconds = this / 10000000;
			Posix.time_t unix_time = seconds - UNIX_SECONDS;
			Posix.localtime_r (&unix_time, &ltm);
			DateTime local = DateTime.dt (Date (ltm.tm_year + 1900, ltm.tm_mon + 1, ltm.tm_mday), TimeOfDay (ltm.tm_hour, ltm.tm_min, ltm.tm_sec), 0);
			Duration offset = (Duration) ((local.time / 10000000 - seconds) * 10000000);
			return DateTime (this, offset);
		}
	}

	public DateTime utc {
		get { return DateTime (this, 0); }
	}
}

