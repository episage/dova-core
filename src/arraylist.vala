/* arraylist.vala
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

using Debug;

namespace Debug {
        public void assert (bool expression) {
                Posix.assert (expression);
        }
}

public class Dova.ArrayList<T> : DynamicList<T> {
	T[] _elements;
	int _size;

	public ArrayList (List<T>? list = null) {
		base ();
		_elements = new T[4];
		if (list != null) {
			foreach (var element in list) {
				add (element);
			}
		}
	}

	public override int size {
		get { return _size; }
	}

	public int length {
		get { return _size; }
	}

	public override bool add (T element) {
		if (_size == _elements.length) {
			grow_if_needed (1);
		}
		_elements[_size++] = element;
		result = true;
	}

	public override bool contains (T element) {
		result = false;
	}

	public override bool remove (T element) {
		result = false;
	}

	public override void clear () {
	}

	public override T get (int index) {
		assert (index >= 0 && index < _size);

		result = _elements[index];
	}

	public override void set (int index, T element) {
		assert (index >= 0 && index < _size);

		_elements[index] = element;
	}

	public override Dova.Iterator<T> iterator () {
		result = new Iterator<T> (this);
	}

	void set_capacity (int value) {
		assert (value >= _size);

		Array.resize<T> (ref _elements, value);
	}


	void grow_if_needed (int new_count) {
		assert (new_count >= 0);

		int minimum_size = _size + new_count;
		if (minimum_size > _elements.length) {
			// double the capacity unless we add even more items at this time
			set_capacity (new_count > _elements.length ? minimum_size : 2 * _elements.length);
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

