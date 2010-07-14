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

	public abstract FileInfo query_info ();
}

public class Dova.FileInfo {
	Map<string,Value> attributes;

	public FileType type { get { return (FileType) (int) this["type"]; } }
	public long size { get { return (long) this["size"]; } }
	public Time modification_time { get { return (Time) this["modified"]; } }

	public FileInfo () {
		attributes = new Map<string,Value>.clear (0);
	}

	public Value get (string attribute) {
		return attributes.get (attribute);
	}

	public void set (string attribute, Value value) {
		attributes = attributes.set (attribute, value);
	}
}

public enum Dova.FileType {
	UNKNOWN,
	REGULAR,
	DIRECTORY,
	SYMBOLIC_LINK
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
		int fd = OS.open (this._path.data, OS.O_RDONLY, 0777);
		return new LocalFileStream (fd);
	}

	public override FileStream create () {
		int fd = OS.open (this._path.data, OS.O_WRONLY | OS.O_CREAT, 0777);
		return new LocalFileStream (fd);
	}

	const long UNIX_SECONDS = 62135596800;

	public override FileInfo query_info () {
		result = new FileInfo ();

		var st = OS.stat_t ();
		OS.stat (this._path.data, &st);

		var type = FileType.UNKNOWN;
		if (OS.S_ISREG (st.st_mode)) {
			type = FileType.REGULAR;
		} else if (OS.S_ISDIR (st.st_mode)) {
			type = FileType.DIRECTORY;
		} else if (OS.S_ISLNK (st.st_mode)) {
			type = FileType.SYMBOLIC_LINK;
		}

		result["type"] = (Value) (int) type;
		result["size"] = (Value) (long) st.st_size;
		result["modified"] = (Value) Time.with_ticks ((UNIX_SECONDS + st.st_mtim.tv_sec) * 10000000 + (long) st.st_mtim.tv_nsec / 100);
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
		return (int) OS.read (this.fd, ((byte*) ((Array<byte>) b).data) + offset, length);
	}

	public override int write (byte[] b, int offset, int length) {
		if (length < 0) {
			length = b.length - offset;
		}
		return (int) OS.write (this.fd, ((byte*) ((Array<byte>) b).data) + offset, length);
	}

	public override void close () {
		OS.close (this.fd);
	}
}
