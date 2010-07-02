/* file.vala
 *
 * Copyright (C) 2009-2010  Jürg Billeter
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

public abstract class Dova.File {
	public abstract string? path { get; }

	public static File get_for_path (string path) {
		return new LocalFile (path);
	}

	public abstract FileStream read ();
	public abstract FileStream create ();
}

class Dova.LocalFile : File {
	string _path;

	public override string? path {
		get { return _path; }
	}

	public LocalFile (string path) {
		this._path = path;
	}

	public override FileStream read () {
		int fd = Posix.open (this._path.data, Posix.O_RDONLY, 0777);
		return new LocalFileStream (fd);
	}

	public override FileStream create () {
		int fd = Posix.open (this._path.data, Posix.O_WRONLY | Posix.O_CREAT, 0777);
		return new LocalFileStream (fd);
	}
}

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
	static TextReader? _in;
	static TextWriter? _out;

	public static TextReader in {
		get {
			if (_in == null) {
				_in = new TextReader (new LocalFileStream (0));
			}
			return (!) _in;
		}
	}

	public static TextWriter out {
		get {
			if (_out == null) {
				_out = new TextWriter (new LocalFileStream (1));
			}
			return (!) _out;
		}
	}

	public static string read_line () {
		return (!) in.read_line ();
	}

	public static void write (string s) {
		out.write (s);
	}

	public static void write_line (string s) {
		out.write_line (s);
	}
}

namespace Dova {
	[Print]
	public void print (string s) {
		Console.write_line (s);
	}
}
