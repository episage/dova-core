/* stream.vala
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

// maybe shared Stream class and just use separate Reader/Writer classes (TextReader/Writer, XmlReader/Writer,...)
public abstract class Dova.Stream : Object {
	protected Stream () {
	}

	public abstract int read (byte[] b, int offset = 0, int length = -1);

	public abstract int write (byte[] b, int offset = 0, int length = -1);

	public void write_all (byte[] b, int offset = 0, int length = -1) {
		if (length < 0) {
			length = b.length - offset;
		}
		int bytes_written = 0;
		while (bytes_written < length) {
			bytes_written += this.write (b, offset + bytes_written, length - bytes_written);
		}
	}

	public abstract void close ();
}

/*public class Dova.BufferedStream : Stream {
}*/
