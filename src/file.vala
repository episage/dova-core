/* file.vala
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

public abstract class Dova.FileStream : Stream {
	protected FileStream () {
	}
}

class Dova.LocalFileStream : FileStream {
	int fd;

	public LocalFileStream (int fd) {
		this.fd = fd;
	}

	public override int read (byte[] b, int offset, int length) {
		if (length < 0) {
			length = b.length - offset;
		}
		return (int) Posix.read (this.fd, ((byte*) ((Array<byte>) b).data) + offset, length);
	}

	public override int write (byte[] b, int offset, int length) {
		if (length < 0) {
			length = b.length - offset;
		}
		return (int) Posix.write (this.fd, ((byte*) ((Array<byte>) b).data) + offset, length);
	}

	public override void close () {
		Posix.close (this.fd);
	}
}

public abstract class Dova.Console : Object {
	static TextReader _in;
	static TextWriter _out;

	public static TextReader in {
		get {
			if (_in == null) {
				_in = new TextReader (new LocalFileStream (0));
			}
			return _in;
		}
	}

	public static TextWriter out {
		get {
			if (_out == null) {
				_out = new TextWriter (new LocalFileStream (1));
			}
			return _out;
		}
	}

	public static string read_line () {
		return in.read_line ();
	}

	public static void write (string s) {
		out.write (s);
	}

	public static void write_line (string s) {
		out.write_line (s);
	}
}
