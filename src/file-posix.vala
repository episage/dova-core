/* file-posix.vala
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

class Dova.LocalFile : File {
	string _path;

	public override string? path {
		get { return _path; }
	}

	public LocalFile (string path) {
		this._path = path;
	}

	public override FileStream read () {
		int32 fd = OS.open (this._path.data, OS.O_RDONLY, 0777);
		return new LocalFileStream (fd);
	}

	public override FileStream create () {
		int32 fd = OS.open (this._path.data, OS.O_WRONLY | OS.O_CREAT, 0777);
		return new LocalFileStream (fd);
	}

	const int64 UNIX_SECONDS = 62135596800;

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
		result["size"] = (Value) (int64) st.st_size;
		result["modified"] = (Value) Time.with_ticks ((UNIX_SECONDS + st.st_mtim.tv_sec) * 10000000 + (int64) st.st_mtim.tv_nsec / 100);
	}
}

class Dova.LocalFileStream : FileStream {
	int32 fd;

	public LocalFileStream (int32 fd) {
		this.fd = fd;
	}

	public override int read (byte[] b) {
		return (int) OS.read (this.fd, b, b.length);
	}

	public override int write (byte[] b) {
		return (int) OS.write (this.fd, b, b.length);
	}

	public override void close () {
		OS.close (this.fd);
	}
}
