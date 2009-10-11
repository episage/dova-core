/* textwriter.vala
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

public class Dova.TextWriter : Object {
	Stream stream;

	// TODO: support alternative encodings / line terminators

	public TextWriter (Stream stream) {
		this.stream = stream;
	}

	public void write (string s) {
		byte[] b = s.get_utf8_bytes ();
		this.stream.write_all (b, 0, b.length);
	}

	public void write_line (string s) {
		write (s);
		write ("\n");
	}
}

