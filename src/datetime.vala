/* datetime.vala
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

/**
 * Time measured in 100 nanosecond ticks.
 */
public struct Dova.Time {
	// 100 nanosecond ticks
	public long ticks;

	// total seconds since epoch until start of unix time (january 1, 1970 00:00 UTC)
	const long UNIX_SECONDS = 62135596800;

	public Time (int hours = 0, int minutes = 0, int seconds = 0, int milliseconds = 0) {
		ticks = (((((long) hours * 60 + minutes) * 60 + seconds) * 1000 + milliseconds) * 10000);
	}

	public Time.days (int days, int hours = 0, int minutes = 0, int seconds = 0, int milliseconds = 0) {
		ticks = ((((((long) days * 24 + hours) * 60 + minutes) * 60 + seconds) * 1000 + milliseconds) * 10000);
	}

	public Time.now () {
		OS.timeval tv;
		OS.gettimeofday (out tv, null);
		ticks = ((UNIX_SECONDS + tv.tv_sec) * 10000000 + tv.tv_usec * 10);
	}

	public Time.with_ticks (long ticks) {
		this.ticks = ticks;
	}

	public DateTime local {
		get {
			var ltm = OS.tm ();
			long seconds = ticks / 10000000;
			intptr unix_time = seconds - UNIX_SECONDS;
			OS.localtime_r (&unix_time, &ltm);
			DateTime local = DateTime.dt (Date (ltm.tm_year + 1900, ltm.tm_mon + 1, ltm.tm_mday), Time (ltm.tm_hour, ltm.tm_min, ltm.tm_sec), Time ());
			Time offset = Time.with_ticks ((local.utc.ticks / 10000000 - seconds) * 10000000);
			return DateTime (this, offset);
		}
	}

	public DateTime utc {
		get { return DateTime (this, Time ()); }
	}

	public long total_milliseconds {
		get { return ticks / 10000; }
	}

	public long total_seconds {
		get { return ticks / 10000000; }
	}

	public int hours {
		get { return (int) (ticks / 10000000 / 3600); }
	}

	public int minutes {
		get { return (int) (ticks / 10000000 / 60 % 60); }
	}

	public int seconds {
		get { return (int) (ticks / 10000000 % 60); }
	}

	public int milliseconds {
		get { return (int) (ticks / 10000 % 1000); }
	}

	public string to_string () {
		string ms = milliseconds.to_string ();
		while (ms.length < 3) {
			ms = "0" + ms;
		}
		return "$(total_seconds).$(ms) s";
	}
}

/**
 * Single day.
 */
public struct Dova.Date {
	// julian days since epoch (January 1, 0001)
	public int days;

	const int DAYS_PER_400_YEARS = 146097;
	const int DAYS_PER_100_YEARS = 36524;
	const int DAYS_PER_4_YEARS = 1461;
	const int DAYS_PER_YEAR = 365;

	void get_year_month_day (out int year, out int month, out int day) {
		int days = this.days;

		int n_400_year_cycles = days / DAYS_PER_400_YEARS;
		days -= n_400_year_cycles * DAYS_PER_400_YEARS;

		int n_100_year_cycles = days / DAYS_PER_100_YEARS;
		if (n_100_year_cycles == 4) {
			// 31 december on leap year (right before end of 400 year cycle)
			n_100_year_cycles = 3;
		}
		days -= n_100_year_cycles * DAYS_PER_100_YEARS;

		int n_4_year_cycles = days / DAYS_PER_4_YEARS;
		days -= n_4_year_cycles * DAYS_PER_4_YEARS;

		int n_years = days / DAYS_PER_YEAR;
		if (n_years == 4) {
			// 31 december on leap year
			n_years = 3;
		}
		days -= n_years * DAYS_PER_YEAR;

		year = n_400_year_cycles * 400 + n_100_year_cycles * 100 + n_4_year_cycles * 4 + n_years + 1;

		if (year % 4 == 0 && (year % 100 != 0 || year % 400 == 0)) {
			// leap year
			for (month = 1; days >= days_in_month_in_leapyear[month - 1]; month++) {
				days -= days_in_month_in_leapyear[month - 1];
			}
		} else {
			for (month = 1; days >= days_in_month[month - 1]; month++) {
				days -= days_in_month[month - 1];
			}
		}

		day = days + 1;
	}

	public int year {
		get {
			int year, month, day;
			get_year_month_day (out year, out month, out day);
			return year;
		}
	}

	public int month {
		get {
			int year, month, day;
			get_year_month_day (out year, out month, out day);
			return month;
		}
	}

	public int day {
		get {
			int year, month, day;
			get_year_month_day (out year, out month, out day);
			return day;
		}
	}

	public DayOfWeek day_of_week {
		get {
			return (DayOfWeek) (days % 7);
		}
	}

	const byte days_in_month[] = [ 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 ];
	const byte days_in_month_in_leapyear[] = [ 31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 ];

	public Date (int year, int month, int day) {
		// total days up to beginning of year
		days = (year - 1) * 365 + ((year - 1) / 4) - ((year - 1) / 100) + ((year - 1) / 400);

		// total days up to beginning of month
		for (int m = 1; m < month; m++) {
			days += days_in_month[m - 1];
		}
		if (month > 2 && year % 4 == 0 && (year % 100 != 0 || year % 400 == 0)) {
			// add february 29 of this leap year
			days++;
		}

		// total days
		days += (day - 1);
	}

	internal Date.with_days (int days) {
		this.days = days;
	}

	static string format_number (int number, int digits) {
		result = number.to_string ();
		while (result.length < digits) {
			result = "0" + result;
		}
	}

	public new string to_string () {
		return format_number (year, 4) + "-" + format_number (month, 2) + "-" + format_number (day, 2);
	}
}

public struct Dova.DateTime {
	// time since epoch (January 1, 0001 00:00 UTC)
	// uses proleptic Gregorian calendar for dates before 1582
	public Time utc;

	public Time offset;

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
		get { return Date.with_days ((int) ((utc.ticks + offset.ticks) / 10000000 / 3600 / 24)); }
	}

	public int hour {
		get { return time.hours; }
	}

	public int minute {
		get { return time.minutes; }
	}

	public int second {
		get { return time.seconds; }
	}

	public int millisecond {
		get { return time.milliseconds; }
	}

	public Time time {
		get { return Time.with_ticks ((utc.ticks + offset.ticks) % ((long) 24 * 3600 * 10000000)); }
	}

	public DateTime (Time utc, Time offset) {
		this.utc = utc;
		this.offset = offset;
	}

	public DateTime.now () {
		var local = Time.now ().local;
		this.utc = local.utc;
		this.offset = local.offset;
	}

	public DateTime.dt (Date date, Time time, Time offset) {
		this.utc = Time.with_ticks ((long) date.days * 24 * 3600 * 10000000 + time.ticks - offset.ticks);
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
		result = date.to_string () + "T" + format_number (hour, 2) + ":" + format_number (minute, 2) + ":" + format_number (second, 2);
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

public enum Dova.DayOfWeek {
	MONDAY,
	TUESDAY,
	WEDNESDAY,
	THURSDAY,
	FRIDAY,
	SATURDAY,
	SUNDAY;

	public string to_string () {
		switch (this) {
		case MONDAY:
			return "Monday";
		case TUESDAY:
			return "Tuesday";
		case WEDNESDAY:
			return "Wednesday";
		case THURSDAY:
			return "Thursday";
		case FRIDAY:
			return "Friday";
		case SATURDAY:
			return "Saturday";
		case SUNDAY:
			return "Sunday";
		}
		return "(invalid)";
	}
}

public enum Dova.Clock {
	UTC,
	MONOTONIC;

	// total seconds since epoch until start of unix time (january 1, 1970 00:00 UTC)
	const long UNIX_SECONDS = 62135596800;

	public Time get_time () {
		switch (this) {
		case UTC:
			OS.timeval tv;
			OS.gettimeofday (out tv, null);
			return Time.with_ticks ((UNIX_SECONDS + tv.tv_sec) * 10000000 + tv.tv_usec * 10);
		case MONOTONIC:
			var ts = OS.timespec ();
			OS.clock_gettime (OS.CLOCK_MONOTONIC, &ts);
			return Time.with_ticks ((long) ts.tv_sec * 10000000 + (long) ts.tv_nsec / 100);
		default:
			// throw error
			return Time ();
		}
	}
}
