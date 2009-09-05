/* date.vala
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
 * Single day.
 */
public struct Dova.Date {
	// julian days since epoch (january 1, 0001)
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

	const byte days_in_month[] = { 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 };
	const byte days_in_month_in_leapyear[] = { 31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 };

	public Date (int year, int month, int day) {
		// total days up to beginning of year
		this.days = (year - 1) * 365 + ((year - 1) / 4) - ((year - 1) / 100) + ((year - 1) / 400);

		// total days up to beginning of month
		for (int m = 1; m < month; m++) {
			this.days += days_in_month[m - 1];
		}
		if (month > 2 && year % 4 == 0 && (year % 100 != 0 || year % 400 == 0)) {
			// add february 29 of this leap year
			this.days++;
		}

		// total days
		this.days += (day - 1);
	}

	internal Date.from_days (int days) {
		this.days = days;
	}

	public Date.today () {
	}

	static string format_number (int number, int digits) {
		string s = number.to_string ();
		while (s.length < digits) {
			s = "0" + s;
		}
		return s;
	}

	public string to_string () {
		return format_number (year, 4) + "-" + format_number (month, 2) + "-" + format_number (day, 2);
	}
}

