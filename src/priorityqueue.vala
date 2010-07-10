/* priorityqueue.vala
 *
 * Copyright (C) 2010  Jürg Billeter
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

public delegate int Dova.CompareFunc<T> (T a, T b);

public abstract class Dova.QueueModel<T> : Object {
	public abstract void push (T element);
	public abstract T pop ();
}

public class Dova.PriorityQueue<T> : QueueModel<T> {
	T[] elements;
	public int length { get; private set; }

	CompareFunc<T> comparer;

	public PriorityQueue (CompareFunc<T> comparer) {
		this.comparer = comparer;
		elements = new T[4];
	}

	public override void push (T element) {
		if (elements.length <= length) {
			Array.resize<T> (ref elements, elements.length * 2);
		}

		int index = length;
		length++;

		while (index > 0) {
			int parent = (index - 1) / 2;
			if (comparer (elements[parent], element) <= 0) {
				// parent <= child, order is correct
				break;
			} else {
				// order incorrect, swap parent with child and continue
				elements[index] = elements[parent];
				index = parent;
			}
		}

		elements[index] = element;
	}

	public override T pop () {
		assert (length > 0);

		result = elements[0];

		int index = 0;
		length--;

		if (length == 0) {
			// last element was removed
			elements[length] = null;
			return;
		}

		while (index < length - 1) {
			int left = 2 * index + 1;
			int right = 2 * index + 2;
			// use length instead of index as we only physically swap the last element at the end to improve performance
			int smallest = length;
			if (left < length && comparer (elements[left], elements[smallest]) < 0) {
				smallest = left;
			}
			if (right < length && comparer (elements[right], elements[smallest]) < 0) {
				smallest = right;
			}
			if (smallest == length) {
				// parent <= child, order is correct
				break;
			} else {
				// order incorrect, swap parent with smaller child and continue
				elements[index] = elements[smallest];
				index = smallest;
			}
		}

		elements[index] = elements[length];
		elements[length] = null;
	}
}
