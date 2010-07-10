/* arraylist.vala
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

using Debug;

namespace Debug {
        public void assert (bool expression) {
                Posix.assert (expression);
        }
}

public class Dova.ArrayList<T> : ListModel<T> {
	T[] _elements;
	int _length;

	public void* data { get { return _elements.data; } }

	public ArrayList (List<T>? list = null) {
		base ();
		_elements = new T[4];
		if (list != null) {
			foreach (var element in (!) list) {
				append (element);
			}
		}
	}

	public override int length {
		get { return _length; }
	}

	public override void append (T element) {
		if (_length == _elements.length) {
			grow_if_needed (1);
		}
		_elements[_length++] = element;
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
		assert (index >= 0 && index < _length);

		result = _elements[index];
	}

	public override void set (int index, T element) {
		assert (index >= 0 && index < _length);

		_elements[index] = element;
	}

	public override Dova.Iterator<T> iterator () {
		result = new Iterator<T> (this);
	}

	void set_capacity (int value) {
		assert (value >= _length);

		Array.resize<T> (ref _elements, value);
	}


	void grow_if_needed (int new_count) {
		assert (new_count >= 0);

		int minimum_length = _length + new_count;
		if (minimum_length > _elements.length) {
			// double the capacity unless we add even more items at this time
			set_capacity (new_count > _elements.length ? minimum_length : 2 * _elements.length);
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

