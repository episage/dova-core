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

	public static string create (int size) {
		string* str = Posix.calloc (1, (int) sizeof (int) * 2 + size + 1);
		str->ref_count = 1;
		str->size = size;
		return (owned) str;
	}

	public static string create_from_utf8 (byte[] b, int offset = 0, int length = -1) {
		if (length < 0) {
			length = b.length - offset;
		}

		result = create (length);
		Posix.memcpy (result.data, ((Array<byte>) b).data + offset, length);
	}

	public static string create_from_cstring (byte* cstring) {
		result = create ((int) Posix.strlen (cstring));
		Posix.memcpy (result.data, cstring, result.size);
	}

	internal static string create_from_char (char c) {
		// based on code from GLib

		byte utf8[4];
		int first, len;
		if (c < 0x80) {
			first = 0;
			len = 1;
		} else if (c < 0x800) {
			first = 0xc0;
			len = 2;
			utf8[1] = (byte) (c & 0x3f) | 0x80;
			c >>= 6;
		} else if (c < 0x10000) {
			first = 0xe0;
			len = 3;
			utf8[2] = (byte) (c & 0x3f) | 0x80;
			c >>= 6;
			utf8[1] = (byte) (c & 0x3f) | 0x80;
			c >>= 6;
		} else {
			first = 0xf0;
			len = 4;
			utf8[3] = (byte) (c & 0x3f) | 0x80;
			c >>= 6;
			utf8[2] = (byte) (c & 0x3f) | 0x80;
			c >>= 6;
			utf8[1] = (byte) (c & 0x3f) | 0x80;
			c >>= 6;
		}
		utf8[0] = (byte) c | first;

		result = create (len);
		Posix.memcpy (result.data, utf8, len);
	}

	// indices in bytes
	public string slice (int start_index, int end_index) {
		// string is NUL-terminated, so it's always fine to access byte at end_index with valid arguments
		if ((data[start_index] >= 0x80 && data[start_index] < 0xc0) ||
		    (data[end_index] >= 0x80 && data[end_index] < 0xc0)) {
			// error: do not allow splitting characters
		}

		result = create (end_index - start_index);
		Posix.memcpy (result.data, &data[start_index], end_index - start_index);
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
		return Posix.strcmp (((!) s1).data, ((!) s2).data);
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

	public bool equals (string other) {
		return Posix.strcmp (data, other.data) == 0;
	}

	// index in bytes
	public char get_char (int index) {
		next_char (ref index, out result);
	}

	public bool next_char (ref int index, out char c) {
		// based on code from GLib

		// decode UTF-8
		// this method assumes that string has already been UTF-8 validated

		if (index >= size) {
			return false;
		}

		byte* data = &this.data[index];

		byte first = data[0];
		if (first < 0x80) {
			c = first;
			index++;
		} else if (first < 0xc2) {
			// error: invalid first byte
			// can happen even with valid UTF-8 strings as caller is passing byte index
			c = 0;
		} else if (first < 0xe0) {
			// 2-byte sequence
			c = data[0] & 0x1f;
			c <<= 6;
			c |= data[1] & 0x3f;
			index += 2;
		} else if (first < 0xf0) {
			// 3-byte sequence
			c = data[0] & 0x1f;
			c <<= 6;
			c |= data[1] & 0x3f;
			c <<= 6;
			c |= data[2] & 0x3f;
			index += 3;
		} else if (first < 0xf5) {
			// 4-byte sequence
			c = data[0] & 0x1f;
			c <<= 6;
			c |= data[1] & 0x3f;
			c <<= 6;
			c |= data[2] & 0x3f;
			c <<= 6;
			c |= data[3] & 0x3f;
			index += 4;
		} else {
			// error: invalid first byte
			// can happen even with valid UTF-8 strings as caller is passing byte index
			c = 0;
		}

		return true;
	}

	public byte get (int index) {
		result = this.data[index];
	}

	// indices in bytes
	public int index_of (char c, int start_index = 0, int end_index = -1) {
		if (end_index < 0) {
			end_index = size;
		}

		byte* start = &data[start_index];

		if (c < 0x80) {
			byte* p = Posix.memchr (start, (int) c, end_index - start_index);
			if (p == null) {
				return -1;
			} else {
				return (int) (p - (byte*) data);
			}
		} else {
			// based on code from GLib

			byte utf8[4];
			int first, len;
			if (c < 0x800) {
				first = 0xc0;
				len = 2;
			} else if (c < 0x10000) {
				first = 0xe0;
				len = 3;
				utf8[2] = (byte) (c & 0x3f) | 0x80;
				c >>= 6;
			} else {
				first = 0xf0;
				len = 4;
				utf8[3] = (byte) (c & 0x3f) | 0x80;
				c >>= 6;
				utf8[2] = (byte) (c & 0x3f) | 0x80;
				c >>= 6;
			}
			utf8[1] = (byte) (c & 0x3f) | 0x80;
			c >>= 6;
			utf8[0] = (byte) c | first;

			while (true) {
				byte* p = Posix.memchr (start, utf8[0], end_index - start_index);
				if (p == null) {
					return -1;
				}
				// we do not need to check string boundaries as
				// this is a valid UTF-8 string and the first byte determines the length
				switch (len) {
				case 2:
					if (p[1] == utf8[1]) {
						return (int) (p - (byte*) data);
					}
					break;
				case 3:
					if (p[1] == utf8[1] && p[2] == utf8[2]) {
						return (int) (p - (byte*) data);
					}
					break;
				case 4:
					if (p[1] == utf8[1] && p[2] == utf8[2] && p[3] == utf8[3]) {
						return (int) (p - (byte*) data);
					}
					break;
				}

				int offset = (int) (p + len - start);
				start += offset;
				start_index += offset;
			}
		}
	}

	public int hash () {
		// based on code from GLib

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
