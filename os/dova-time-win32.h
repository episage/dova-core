/* dova-time-win32.h
 *
 * Copyright (C) 2010  Jürg Billeter
 * Copyright (C) 2010  Ralf Michl
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
 * 	Ralf Michl <ralf@michl.info>
 */

#ifndef __DOVA_TIME_WIN32_H__
#define __DOVA_TIME_WIN32_H_

#include <windows.h>
#include <winsock2.h>

#define CLOCK_REALTIME 0
#define CLOCK_MONOTONIC 1

/* total seconds since epoch until start of unix time (january 1, 1970 00:00 UTC) */
#define _DOVA_UNIX_SECONDS 11644473600

struct timespec {
	time_t tv_sec;
	long tv_nsec;
};

struct timezone {
	int tz_minuteswest; /* minutes W of Greenwich */
	int tz_dsttime;     /* type of DST correction */
};

static int clock_gettime (int clockid, struct timespec *tp) {
	FILETIME ft;
	ULARGE_INTEGER t64;

	GetSystemTimeAsFileTime (&ft);

	t64.LowPart = ft.dwLowDateTime;
	t64.HighPart = ft.dwHighDateTime;

	tp->tv_sec = t64.QuadPart / 10000000 - _DOVA_UNIX_SECONDS;
	tp->tv_nsec = t64.QuadPart % 10000000 * 100;

	return 0;
}

static inline int gettimeofday (struct timeval *tv, struct timezone *tz) {
	if (tv) {
		FILETIME ft;
		ULARGE_INTEGER t64;

		GetSystemTimeAsFileTime (&ft);

		t64.LowPart = ft.dwLowDateTime;
		t64.HighPart = ft.dwHighDateTime;

		/* convert to microseconds */
		t64.QuadPart /= 10;

		tv->tv_sec = t64.QuadPart / 1000000 - _DOVA_UNIX_SECONDS;
		tv->tv_usec = t64.QuadPart % 1000000;
	}

	if (tz) {
		_tzset();
		tz->tz_minuteswest = _timezone / 60;
		tz->tz_dsttime = _daylight;
	}

	return 0;
}

#endif
