/* string.vala
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

[CCode (ref_function = "string_ref", unref_function = "string_unref")]
public class string : Dova.Value {
	public int ref_count;
	public int size;
	public byte data[];

	const byte utf8_skip_data[] = [
	  1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
	  1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
	  1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
	  1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
	  1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
	  1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
	  2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,
	  3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,4,4,4,4,4,4,4,4,5,5,5,5,6,6,1,1
	];

	public int length {
		get {
			byte* p = data;
			byte* end = p + size;
			result = 0;
			while (p < end) {
				result++;
				p += utf8_skip_data[*p];
			}
		}
	}

	public new string* ref () {
		if (ref_count == 0) {
			// constant strings
			return this;
		}
		ref_count++;
		return this;
	}

	public new void unref () {
		if (ref_count == 0) {
			// constant strings
			return;
		}
		if (--ref_count == 0) {
			Posix.free (this);
		}
	}

	public byte[] get_utf8_bytes () {
		result = new byte[this.size];
		Posix.memcpy (((Array<byte>) result).data, this.data, this.size);
	}

	internal static string create (int size) {
		string* str = Posix.calloc (1, (int) sizeof (int) * 2 + size + 1);
		str->ref_count = 1;
		str->size = size;
		return (owned) str;
	}

	public static string create_from_cstring (byte* cstring) {
		result = create ((int) Posix.strlen (cstring));
		Posix.memcpy (result.data, cstring, result.size);
	}

	// maybe better public static string concat (List<string> strings)
	public string concat (string other) {
		result = create (this.size + other.size);
		byte* p = (byte*) result.data;
		Posix.memcpy (p, this.data, this.size);
		Posix.memcpy (p + this.size, other.data, other.size);
	}

	public bool contains (string value) {
		return (Posix.strstr (this.data, value.data) != null);
	}

	public static int compare (string? s1, string? s2) {
		if (s1 == null) {
			if (s2 == null) {
				return 0;
			} else {
				return -1;
			}
		} else if (s2 == null) {
			return 1;
		}
		return Posix.strcmp (s1.data, s2.data);
	}

	public int collate (string other) {
		return Posix.strcoll (this.data, other.data);
	}

	public bool starts_with (string value) {
		if (this.size < value.size) {
			return false;
		}
		result = (Posix.strncmp (this.data, value.data, value.size) == 0);
	}

	public List<string> split (string delimiter) {
		result = [];
		byte* p = data;

		byte* next;
		while ((next = Posix.strstr (p, delimiter.data)) != null) {
			string s = create ((int) (next - p));
			Posix.memcpy (s.data, p, s.size);
			result += [s];

			p += s.size + delimiter.size;
		}

		string s = create ((int) ((byte*) data + size - p));
		Posix.memcpy (s.data, p, s.size);
		result += [s];
	}

	public new string to_string () {
		return this;
	}

	public bool equal (string other) {
		return Posix.strcmp (data, other.data) == 0;
	}

	public int hash () {
		// from GLib

		byte *p = data;
		uint h = *p;

		if (h != 0) {
			for (p += 1; *p != 0; p++) {
				h = (h << 5) - h + *p;
			}
		}

		return (int) h;
	}
}

