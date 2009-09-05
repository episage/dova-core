/* posix.vapi
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

[CCode (cprefix = "", lower_case_cprefix = "")]
namespace Posix {
	[CCode (cheader_filename = "assert.h")]
	public void assert (bool expression);

	[CCode (cheader_filename = "stdio.h")]
	public int printf (string format, ...);

	[CCode (cheader_filename = "stdlib.h")]
	public void* calloc (size_t nelem, size_t elsize);
	[CCode (cheader_filename = "stdlib.h")]
	public void free (void* ptr);
	[CCode (cheader_filename = "stdlib.h")]
	public void* malloc (size_t size);
	[CCode (cheader_filename = "stdlib.h")]
	public void* realloc (void* ptr, size_t size);

	[CCode (cheader_filename = "string.h")]
	public void* memcpy (void* dest, void* src, size_t n);
	[CCode (cheader_filename = "string.h")]
	public void* memset (void* s, int c, size_t n);
	[CCode (cheader_filename = "string.h")]
	public int strcmp (void* s1, void* s2);
	[CCode (cheader_filename = "string.h")]
	public int strcoll (void* s1, void* s2);
	[CCode (cheader_filename = "string.h")]
	public void* strstr (void* haystack, void* needle);

	[CCode (cheader_filename = "fcntl.h")]
	public int open (char* path, int oflag);
	[CCode (cheader_filename = "unistd.h")]
	public int close (int fd);
	[CCode (cheader_filename = "unistd.h")]
	public ssize_t read (int fd, void* buf, size_t count);
	[CCode (cheader_filename = "unistd.h")]
	public ssize_t write (int fd, void* buf, size_t count);
	[CCode (cheader_filename = "fcntl.h")]
	public const int O_WRONLY;

	[CCode (cheader_filename = "sys/time.h")]
	public int gettimeofday (out timeval tv, void* tz = null);
	[CCode (cname = "struct timeval", cheader_filename = "sys/time.h")]
	public struct timeval {
		public time_t tv_sec;
		public suseconds_t tv_usec;
	}
	[CCode (cheader_filename = "sys/time.h")]
	[IntegerType (rank = 8)]
	public struct suseconds_t {
	}

	[CCode (cheader_filename = "sys/types.h", default_value = "0UL")]
	[IntegerType (rank = 9)]
	public struct size_t {
	}

	[CCode (cheader_filename = "sys/types.h", default_value = "0L")]
	[IntegerType (rank = 9)]
	public struct ssize_t {
	}

	[CCode (cheader_filename = "time.h")]
	[IntegerType (rank = 8)]
	public struct time_t {
	}

	[CCode (cname = "struct tm", cheader_filename = "time.h")]
	public struct tm {
		public int tm_sec;
		public int tm_min;
		public int tm_hour;
		public int tm_mday;
		public int tm_mon;
		public int tm_year;
		public int tm_wday;
		public int tm_yday;
		public int tm_isdst;
	}
	[CCode (cheader_filename = "time.h")]
	public tm* localtime_r (time_t* timep, tm* result);
}

