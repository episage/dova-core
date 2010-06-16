/* hashmap.vala
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

public class Dova.HashMap<K,V> : MapModel<K,V> {
	int size;
	int mod;
	int mask;
	int nnodes;
	int noccupied;
	byte[] states;
	int[] hashes;
	K[] keys;
	V[] values;

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

	public HashMap () {
		set_shift (3);
		states = new byte[size];
		hashes = new int[size];
		keys = new K[size];
		values = new V[size];
	}

	void set_shift (int shift) {
		size = 1 << shift;
		mod = prime_mod[shift];
		mask = size - 1;
	}

	public override V get (K key) {
		int step = 0;
		int key_hash = key.hash ();
		int node_index = key_hash % mod;
		while (states[node_index] != 0) {
			if (states[node_index] == 2) {
				if (hashes[node_index] == key_hash) {
					if (keys[node_index] == key) {
						return values[node_index];
					}
				}
			}

			step++;
			node_index += step;
			node_index &= mask;
		}
		return null;
	}

	int get_index_for_insertion (K key, int key_hash) {
		int first_tombstone = -1;
		bool have_tombstone = false;
		int step = 0;
		int node_index = key_hash % mod;
		while (states[node_index] != 0) {
			if (states[node_index] == 1) {
				// tombstone
				if (!have_tombstone) {
					first_tombstone = node_index;
					have_tombstone = true;
				}
			} else if (hashes[node_index] == key_hash) {
				if (keys[node_index] == key) {
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

	public override void set (K key, V value) {
		int key_hash = key.hash ();
		int node_index = get_index_for_insertion (key, key_hash);
		if (states[node_index] == 2) {
			// key found, replace value
			values[node_index] = value;
		} else {
			hashes[node_index] = key_hash;
			keys[node_index] = key;
			values[node_index] = value;
			nnodes++;
			if (states[node_index] == 0) {
				// was no tombstone
				states[node_index] = 2;
				noccupied++;
				maybe_resize ();
			} else {
				states[node_index] = 2;
			}
		}
	}

	public void remove (K key) {
		int step = 0;
		int key_hash = key.hash ();
		int node_index = key_hash % mod;
		while (states[node_index] != 0) {
			if (states[node_index] == 2) {
				if (hashes[node_index] == key_hash) {
					if (keys[node_index] == key) {
						// create tombstone
						states[node_index] = 1;
						keys[node_index] = null;
						values[node_index] = null;
					}
				}
			}

			step++;
			node_index += step;
			node_index &= mask;
		}
		// key not found
	}

	void maybe_resize () {
		if ((size > nnodes * 4 && size > 8) || size <= noccupied + (noccupied / 16)) {
			int old_size = size;

			int n = nnodes >> 2;
			int shift;
			for (shift = 3; n > 0; shift++) {
				n >>= 1;
			}
			set_shift (shift);

			var new_states = new byte[size];
			var new_hashes = new int[size];
			var new_keys = new K[size];
			var new_values = new V[size];
			for (int i = 0; i < old_size; i++) {
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
					new_keys[new_node_index] = keys[i];
					new_values[new_node_index] = values[i];
				}
			}
			states = new_states;
			hashes = new_hashes;
			keys = new_keys;
			values = new_values;
			noccupied = nnodes;
		}
	}
}

