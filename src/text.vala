/* text.vala
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

public class Dova.TextReader : Object {
	Stream stream;

	// TODO: support alternative encodings / line terminators

	public TextReader (Stream stream) {
		this.stream = stream;
	}

	// this test implementation obviously does not work with non-ASCII
	public char read () {
		byte buffer[1];
		if (this.stream.read (buffer) > 0) {
			return buffer[0];
		}
		return -1;
	}

	// real implementation should use buffered stream
	// and not allocate new strings on each new byte
	public string? read_line () {
		result = "";
		byte buffer[1];
		while (this.stream.read (buffer) > 0) {
			if (buffer[0] == '\r') {
				if (this.stream.read (buffer) == 0) {
					return;
				}
			}
			if (buffer[0] == '\n') {
				break;
			}
			string tmp = string.create (1);
			((byte*) tmp.data)[0] = buffer[0];
			result = ((!) result) + tmp;
		}
		return;
	}
}

public class Dova.TextWriter : Object {
	Stream stream;

	// TODO: support alternative encodings / line terminators

	public TextWriter (Stream stream) {
		this.stream = stream;
	}

	public void write (string s) {
		byte[] b = s.get_utf8_bytes ();
		this.stream.write_all (b);
	}

	public void write_line (string s) {
		write (s);
		write ("\n");
	}
}
