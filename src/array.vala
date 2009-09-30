/* array.vala
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

public class Dova.Array<T> : Object, Iterable<T> {
	public int rank { get; private set; }
	// total size over all dimensions
	// for multi-dim arrays, there will be one extra int per dimension
	// either at the end of the allocated memory or right before data[]
	public int length /*size*/ { get; private set; }
	// should be inline allocated
	public void* data { get; private set; }
	// T data[];

	public Array (int length) {
		// FIXME should be inline allocated
		this.data = Posix.calloc (length, typeof (T).value_size);
		this.length = length;
	}

	public static void resize<T> (ref T[] array, int new_length) {
		int old_length = ((Array) array).length;
		((Array) array).data = Posix.realloc (((Array) array).data, typeof (T).value_size * new_length);
		((Array) array).length = new_length;
		if (new_length > old_length) {
			Posix.memset (((byte*) ((Array) array).data) + typeof (T).value_size * old_length, 0, typeof (T).value_size * (new_length - old_length));
		}
	}

	public Dova.Iterator<T> iterator () {
		return new Iterator<T> ((T[]) this);
	}

	class Iterator<T> : Dova.Iterator<T> {
		T[] array;
		int index;

		public Iterator (T[] array) {
			this.array = array;
			this.index = -1;
		}

		public override bool next () {
			if (index < array.length) {
				index++;
			}
			return (index < array.length);
		}

		public override T get () {
			result = array[index];
		}
	}
}
