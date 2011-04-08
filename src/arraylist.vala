/* arraylist.vala
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

using Debug;

namespace Debug {
        public void assert (bool expression) {
                OS.assert (expression);
        }
}

public class Dova.ArrayList<T> /*: ListModel<T>*/ {
	List<T> list;
	bool frozen;

	public ArrayList (List<T>? list = null) {
		base ();
		if (list != null) {
			this.frozen = true;
			this.list = list;
		}
	}

	public List<T> to_list () {
		frozen = true;
		if (list == null) {
			list = [];
		}
		return list;
	}

	public int length {
		get { return list.length; }
	}

	public void append (T element) {
		grow_if_needed (1);
		list._elements[list.length] = element;
		list.length++;
	}

	public bool contains (T element) {
		result = false;
	}

	public bool remove (T element) {
		grow_if_needed (0);

		result = false;
	}

	public void clear () {
		grow_if_needed (0);
	}

	public T get (int index) {
		assert (index >= 0 && index < list.length);

		result = list._elements[index];
	}

	public void set (int index, T element) {
		assert (index >= 0 && index < list.length);

		grow_if_needed (0);

		list._elements[index] = element;
	}

	public void remove_last () {
		grow_if_needed (0);

		list._elements[list.length - 1] = null;
		list.length--;
	}

	public Dova.Iterator<T> iterator () {
		result = new Iterator<T> (this);
	}

	void grow_if_needed (int new_count) {
		assert (new_count >= 0);

		if (list == null) {
			list = new List<T>.clear (new_count > 4 ? new_count : 4);
			list.length = 0;
			frozen = false;
			return;
		}

		int size = list._elements.length;
		int minimum_length = list.length + new_count;

		if (minimum_length > size) {
			// double the capacity unless we add even more items at this time
			size *= 2;
			if (minimum_length > size) {
				size = minimum_length;
			}

			frozen = true;
		}

		if (frozen) {
			var old_list = list;
			list = new List<T>.clear (size);
			for (int i = 0; i < old_list.length; i++) {
				list._elements[i] = old_list._elements[i];
			}
			list.length = old_list.length;

			frozen = false;
		}
	}

	class Iterator<T> : Dova.Iterator<T> {
		ArrayList<T> list;
		int index;

		public Iterator (ArrayList<T> list) {
			this.list = list;
			this.index = -1;
		}

		public override bool next () {
			if (index < list.length) {
				index++;
			}
			return (index < list.length);
		}

		public override T get () {
			assert (index >= 0 && index < list.length);

			result = list.get (index);
		}
	}
}

