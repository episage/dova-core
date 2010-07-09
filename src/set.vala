/* set.vala
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

/**
 * Immutable set.
 */
public class Dova.Set<T> : /*Value*/Object {
	public int size { get { return nnodes; } }

	int capacity;
	int mod;
	int mask;
	int nnodes;
	int noccupied;
	byte[] states;
	int[] hashes;
	T[] elements;

	const int prime_mod[] = [
		1,          // for 1 << 0
		2,
		3,
		7,
		13,
		31,
		61,
		127,
		251,
		509,
		1021,
		2039,
		4093,
		8191,
		16381,
		32749,
		65521,      // for 1 << 16
		131071,
		262139,
		524287,
		1048573,
		2097143,
		4194301,
		8388593,
		16777213,
		33554393,
		67108859,
		134217689,
		268435399,
		536870909,
		1073741789,
		2147483647  // for 1 << 31
	];

	public Set (int nnodes, T elements[]) {
		int n = nnodes >> 2;
		int shift;
		for (shift = 3; n > 0; shift++) {
			n >>= 1;
		}

		set_shift (shift);

		states = new byte[capacity];
		hashes = new int[capacity];
		this.elements = new T[capacity];

		for (int i = 0; i < nnodes; i++) {
			T element;
			element = elements[i];
			add (element);
		}
	}

	void set_shift (int shift) {
		capacity = 1 << shift;
		mod = prime_mod[shift];
		mask = capacity - 1;
	}

	public bool contains (T element) {
		int step = 0;
		int element_hash = element.hash ();
		int node_index = element_hash % mod;
		while (states[node_index] != 0) {
			if (states[node_index] == 2) {
				if (hashes[node_index] == element_hash) {
					if (elements[node_index] == element) {
						return true;
					}
				}
			}

			step++;
			node_index += step;
			node_index &= mask;
		}
		return false;
	}

	int get_index_for_insertion (T element, int element_hash) {
		int first_tombstone = -1;
		bool have_tombstone = false;
		int step = 0;
		int node_index = element_hash % mod;
		while (states[node_index] != 0) {
			if (states[node_index] == 1) {
				// tombstone
				if (!have_tombstone) {
					first_tombstone = node_index;
					have_tombstone = true;
				}
			} else if (hashes[node_index] == element_hash) {
				if (elements[node_index] == element) {
					return node_index;
				}
			}

			step++;
			node_index += step;
			node_index &= mask;
		}
		if (have_tombstone) {
			return first_tombstone;
		}
		return node_index;
	}

	// `this' will be passed by reference when supported as this will be a value type
	public bool add (T element) {
		int element_hash = element.hash ();
		int node_index = get_index_for_insertion (element, element_hash);
		if (states[node_index] == 2) {
			// already in set
			return false;
		} else {
			hashes[node_index] = element_hash;
			elements[node_index] = element;
			nnodes++;
			if (states[node_index] == 0) {
				// was no tombstone
				states[node_index] = 2;
				noccupied++;
				maybe_resize ();
			} else {
				states[node_index] = 2;
			}
			return true;
		}
	}

	void maybe_resize () {
		if ((capacity > nnodes * 4 && capacity > 8) || capacity <= noccupied + (noccupied / 16)) {
			int old_capacity = capacity;

			int n = nnodes >> 2;
			int shift;
			for (shift = 3; n > 0; shift++) {
				n >>= 1;
			}
			set_shift (shift);

			var new_states = new byte[capacity];
			var new_hashes = new int[capacity];
			var new_elements = new T[capacity];
			for (int i = 0; i < old_capacity; i++) {
				if (states[i] == 2) {
					int step = 0;
					int new_node_index = hashes[i] % mod;
					while (new_states[new_node_index] != 0) {
						step++;
						new_node_index += step;
						new_node_index &= mask;
					}
					new_states[new_node_index] = 2;
					new_hashes[new_node_index] = hashes[i];
					new_elements[new_node_index] = elements[i];
				}
			}
			states = new_states;
			hashes = new_hashes;
			elements = new_elements;
			noccupied = nnodes;
		}
	}

	public Dova.Iterator<T> iterator () {
		return new Iterator<T> (this);
	}

	class Iterator<T> : Dova.Iterator<T> {
		Set<T> set;

		int index;

		public Iterator (Set<T> set) {
			this.set = set;
			this.index = -1;
		}

		public override bool next () {
			index++;
			while (index < set.capacity) {
				if (set.states[index] == 2) {
					// valid index
					return true;
				}
				index++;
			}
			// reached end
			return false;
		}

		public override T get () {
			result = set.elements[index];
		}
	}
}
