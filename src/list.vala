/* list.vala
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

/**
 * Immutable list.
 */
public class Dova.List<T> : /*Value*/Object {
	internal T[] _elements;
	public int length { get; internal set; }

	public List (T[] elements) /*: _elements (elements.length)*/ {
		_elements = new T[length];
		this.length = length;
		for (int i = 0; i < length; i++) {
			_elements[i] = elements[i];
		}
	}

	internal List.clear (int length) /*: length*/ {
		_elements = new T[length];
		this.length = length;
	}

	~List () {
		delete _elements;
	}

	public T get (int index) {
		result = _elements[index];
	}

	public List<T> concat (List<T> list2) {
		result = new List<T>.clear (this.length + list2.length);
		for (int i = 0; i < this.length; i++) {
			result._elements[i] = this._elements[i];
		}
		for (int i = 0; i < list2.length; i++) {
			result._elements[this.length + i] = list2._elements[i];
		}
	}

	public Dova.Iterator<T> iterator () {
		result = new Iterator<T> (this);
	}

	class Iterator<T> : Dova.Iterator<T> {
		List<T> list;
		int index;

		public Iterator (List<T> list) {
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
			result = list.get (index);
		}
	}
}
