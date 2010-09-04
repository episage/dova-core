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

	public void read_all (byte[] b, int offset = 0, int length = -1) {
		if (length < 0) {
			length = b.length - offset;
		}
		int bytes_read = 0;
		while (bytes_read < length) {
			int count = this.read (b, offset + bytes_read, length - bytes_read);
			if (count < 1) {
				// TODO throw error
				break;
			}
			bytes_read += count;
		}
	}

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

public class Dova.MemoryStream : Stream {
	byte[] buffer;
	int start;
	int offset;
	int length;

	public MemoryStream (byte[] buffer, int offset, int length) {
		this.buffer = buffer;
		this.start = offset;
		this.offset = offset;
		this.length = length;
	}

	public override int read (byte[] b, int offset = 0, int length = -1) {
		if (length < 0) {
			length = b.length - offset;
		}

		if (length > this.length) {
			length = this.length;
		}
		OS.memcpy ((byte*) b.data + offset, (byte*) this.buffer.data + this.offset, length);
		this.offset += length;
		this.length -= length;
		result = length;
	}

	public override int write (byte[] b, int offset = 0, int length = -1) {
		if (length < 0) {
			length = b.length - offset;
		}

		if (length > this.buffer.length) {
			length = this.buffer.length;
		}
		if (length == 0) {
			// no space, throw error
		}
		OS.memcpy ((byte*) this.buffer.data + this.offset, (byte*) b.data + offset, length);
		this.offset += length;
		this.length -= length;
		result = length;
	}

	public void seek (int offset) {
		int diff = offset - this.offset;
		this.offset += diff;
		this.length -= diff;
	}

	public override void close () {
		buffer = null;
	}
}

public class Dova.BufferedStream : Stream {
	Stream base_stream;
	byte[] input_buffer;
	byte[] output_buffer;

	public BufferedStream (Stream base_stream) {
		this.base_stream = base_stream;
		this.input_buffer = new byte[4096];
		this.output_buffer = new byte[4096];
	}

	public override int read (byte[] b, int offset = 0, int length = -1) {
		return base_stream.read (b, offset, length);
	}

	public override int write (byte[] b, int offset = 0, int length = -1) {
		return base_stream.write (b, offset, length);
	}

	public override void close () {
		base_stream = null;
	}
}

public enum Dova.ByteOrder {
	HOST_ENDIAN,
	BIG_ENDIAN,
	LITTLE_ENDIAN
}

public class Dova.DataReader {
	Stream stream;

	public ByteOrder byte_order { get; set; }

	public DataReader (Stream stream) {
		this.stream = stream;
	}

	public byte read_byte () {
		var buffer = new byte[1];
		int count = stream.read (buffer, 0, 1);
		return buffer[0];
	}

	public int read_int32 () {
		// TODO find way to avoid array allocation here (ideally, an other way than just caching the array)
		// maybe switch from byte[] to byte* in streams?
		var buffer = new byte[4];
		stream.read_all (buffer, 0, 4);
		return buffer[3] << 24 | buffer[2] << 16 | buffer[1] << 8 | buffer[0];
	}

	public uint read_uint32 () {
		// TODO find way to avoid array allocation here (ideally, an other way than just caching the array)
		// maybe switch from byte[] to byte* in streams?
		var buffer = new byte[4];
		stream.read_all (buffer, 0, 4);
		return buffer[3] << 24 | buffer[2] << 16 | buffer[1] << 8 | buffer[0];
	}

	public string read_string (int length) {
		// TODO support different encodings
		// maybe also support 0-terminated strings (possibly separate method)
		byte[] buffer = new byte[length];
		stream.read_all (buffer, 0, length);

		result = string.create (length);
		OS.memcpy (result.data, buffer.data, length);
	}
}

public class Dova.DataWriter {
	Stream stream;

	public ByteOrder byte_order { get; set; }

	public DataWriter (Stream stream) {
		this.stream = stream;
	}

	public void write_byte (byte b) {
		var buffer = new byte[1];
		buffer[0] = b;
		stream.write (buffer, 0, 1);
	}

	public void write_int32 (int i) {
		// TODO find way to avoid array allocation here (ideally, an other way than just caching the array)
		// maybe switch from byte[] to byte* in streams?
		var buffer = new byte[4];
		OS.memcpy (buffer.data, &i, 4);
		stream.write_all (buffer, 0, 4);
	}

	public void write_uint32 (uint i) {
		// TODO find way to avoid array allocation here (ideally, an other way than just caching the array)
		// maybe switch from byte[] to byte* in streams?
		var buffer = new byte[4];
		OS.memcpy (buffer.data, &i, 4);
		stream.write_all (buffer, 0, 4);
	}

	public void write_string (string s) {
		// TODO support different encodings
		var buffer = new byte[s.length];
		OS.memcpy (buffer.data, s.data, s.length);
		stream.write_all (buffer, 0, s.length);
	}
}
