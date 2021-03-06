/* app.vala
 *
 * Copyright (C) 2009-2011  Jürg Billeter
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

namespace Dova.Application {
	public void init () {
		Task._init ();
	}

	public List<string> get_arguments () {
		byte** argv = OS.getargv ();

		result = [];
		while (*argv != null) {
			result += [string.create_from_cstring (*argv)];
			argv++;
		}
	}

	public void run () {
		Task.pause ();
	}

	// allow access to stdin, stdout, stderr streams
}

namespace Dova.Environment {
	public string? get_variable (string name) {
		byte* cstring = OS.getenv (name.data);
		if (cstring == null) {
			result = null;
		} else {
			result = string.create_from_cstring (cstring);
		}
	}

	public int get_user_id () {
		return (int) OS.getuid ();
	}

	public File get_current_directory () {
		int max_path = (int) OS.pathconf (".".data, OS._PC_PATH_MAX);

		byte* buf = OS.malloc (max_path);
		OS.getcwd (buf, max_path);

		result = File.get_for_path (string.create_from_cstring (buf));

		OS.free (buf);
	}
}

class Dova.LocalFileStream : FileStream {
	int32 fd;

	public LocalFileStream (int32 fd) {
		this.fd = fd;
	}

	public override int read (byte[] b) {
		return OS.read (this.fd, b, b.length);
	}

	public override int write (byte[] b) {
		return OS.write (this.fd, b, b.length);
	}

	public override void close () {
		OS.close (this.fd);
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

namespace Dova.Log {
	[Print]
	public void debug (string s) {
		OS.fprintf (OS.stderr, "%s\n".data, s.data);
	}

	[Print]
	public void message (string s) {
		OS.fprintf (OS.stderr, "%s\n".data, s.data);
	}

	[Print]
	public void warning (string s) {
		OS.fprintf (OS.stderr, "%s\n".data, s.data);
	}

	[Print]
	public void error (string s) {
		OS.fprintf (OS.stderr, "%s\n".data, s.data);
	}
}
