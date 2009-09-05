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
	[CCode (cheader_filename = "sys/types.h", default_value = "0UL")]
	[IntegerType (rank = 9)]
	public struct size_t {
	}

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

	[CCode (cheader_filename = "sys/types.h", default_value = "0UL")]
	[IntegerType (rank = 9)]
	public struct size_t {
	}
}
