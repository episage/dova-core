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
	public int64 size { get { return (int64) this["size"]; } }
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

public abstract class Dova.FileStream : Stream {
	protected FileStream () {
	}
}
