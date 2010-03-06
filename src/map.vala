/* map.vala
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
 * Immutable map.
 */
public class Dova.Map<K,V> : /*Value*/Object {
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

	public Map (int nnodes, K keys[], V values[]) {
		int n = nnodes >> 2;
		int shift;
		for (shift = 3; n > 0; shift++) {
			n >>= 1;
		}

		size = 1 << shift;
		mod = prime_mod[shift];
		mask = size - 1;

		states = new byte[size];
		hashes = new int[size];
		this.keys = new K[size];
		this.values = new V[size];

		for (int i = 0; i < nnodes; i++) {
			K key;
			V value;
			key = keys[i];
			value = values[i];
			set (key, value);
		}
	}

	public V get (K key) {
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

	void set (K key, V value) {
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
			} else {
				states[node_index] = 2;
			}
		}
	}
}