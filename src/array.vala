/* array.vala
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

public struct Dova.Array {
	public void* data;
	public int length;

	public Array (void* data, int length) {
		this.data = data;
		this.length = length;
	}

	public static T[] create<T> (int length) {
		result = (T[]) Array (OS.calloc (length, typeof (T).value_size), length);
	}

	public static void resize<T> (ref T[] array, int new_length) {
		int old_length = ((Array) array).length;
		array = (T[]) Array (OS.realloc (((Array) array).data, typeof (T).value_size * new_length), new_length);
		if (new_length > old_length) {
			OS.memset (((byte*) ((Array) array).data) + typeof (T).value_size * old_length, 0, typeof (T).value_size * (new_length - old_length));
		}
	}
}

namespace Dova {
	public static Array array (void* data, int length) {
		return Array (data, length);
	}
}
