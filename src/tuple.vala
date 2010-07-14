/* tuple.vala
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

/**
 * Immutable list.
 */
public class Dova.Tuple : /*Value*/Object {
	public int length { get; private set; }
	void** values;
	void* data;

	public Tuple (int length, Type** types, void** values) {
		this.length = length;
		this.values = OS.calloc (length, sizeof (void*));

		int size = 0;
		for (int i = 0; i < length; i++) {
			// use 8 byte alignment
			size += ((types[i].value_size - 1) / 8 + 1) * 8;
		}

		data = OS.calloc (1, size);

		byte* next = data;
		for (int i = 0; i < length; i++) {
			this.values[i] = (void*) next;
			types[i].value_copy (this.values[i], 0, values[i], 0);
			// use 8 byte alignment
			next += ((types[i].value_size - 1) / 8 + 1) * 8;
		}
	}

	public T get<T> (int index) {
		result = (T) values[index];
	}
}
