/* map.vala
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
 * Immutable map.
 */
public class Dova.Map<K,V> : /*Value*/Object {
	public int size { get { return nnodes; } }

	int capacity;
	int mod;
	int mask;
	int nnodes;
	int noccupied;
	byte[] states;
	uint[] hashes;
	K[] _keys;
	V[] _values;

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

	public Map (int nnodes, K _keys[], V _values[]) {
		int n = nnodes >> 2;
		int shift;
		for (shift = 3; n > 0; shift++) {
			n >>= 1;
		}

		capacity = 1 << shift;
		mod = prime_mod[shift];
		mask = capacity - 1;

		states = new byte[capacity];
		hashes = new uint[capacity];
		this._keys = new K[capacity];
		this._values = new V[capacity];

		for (int i = 0; i < nnodes; i++) {
			K key;
			V value;
			key = _keys[i];
			value = _values[i];
			internal_set (key, value);
		}
	}

	public Map.clear (int length) {
		int shift = 3;

		capacity = 1 << shift;
		mod = prime_mod[shift];
		mask = capacity - 1;

		states = new byte[capacity];
		hashes = new uint[capacity];
		this._keys = new K[capacity];
		this._values = new V[capacity];
	}

	public V get (K key) {
		int step = 0;
		uint key_hash = key.hash ();
		int node_index = (int) (key_hash % mod);
		while (states[node_index] != 0) {
			if (states[node_index] == 2) {
				if (hashes[node_index] == key_hash) {
					if (_keys[node_index] == key) {
						return _values[node_index];
					}
				}
			}

			step++;
			node_index += step;
			node_index &= mask;
		}
		return null;
	}

	int get_index_for_insertion (K key, uint key_hash) {
		int first_tombstone = -1;
		bool have_tombstone = false;
		int step = 0;
		int node_index = (int) (key_hash % mod);
		while (states[node_index] != 0) {
			if (states[node_index] == 1) {
				// tombstone
				if (!have_tombstone) {
					first_tombstone = node_index;
					have_tombstone = true;
				}
			} else if (hashes[node_index] == key_hash) {
				if (_keys[node_index] == key) {
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

	Map.copy (Map<K,V> map) {
		capacity = map.capacity;
		mod = map.mod;
		mask = map.mask;

		states = new byte[capacity];
		hashes = new uint[capacity];
		this._keys = new K[capacity];
		this._values = new V[capacity];

		for (int i = 0; i < capacity; i++) {
			states[i] = map.states[i];
			hashes[i] = map.hashes[i];
			_keys[i] = map._keys[i];
			_values[i] = map._values[i];
		}
	}

	public Map<K,V> set (K key, V value) {
		result = new Map<K,V>.copy (this);
		result.internal_set (key, value);
	}

	void internal_set (K key, V value) {
		uint key_hash = key.hash ();
		int node_index = get_index_for_insertion (key, key_hash);
		if (states[node_index] == 2) {
			// key found, replace value
			_values[node_index] = value;
		} else {
			hashes[node_index] = key_hash;
			_keys[node_index] = key;
			_values[node_index] = value;
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

	public Set<K> keys {
		get {
			result = {};
			for (int index = 0; index < capacity; index++) {
				if (states[index] == 2) {
					// valid index
					result.add (_keys[index]);
				}
			}
		}
	}

	public Set<V> values {
		get {
			result = {};
			for (int index = 0; index < capacity; index++) {
				if (states[index] == 2) {
					// valid index
					result.add (_values[index]);
				}
			}
		}
	}
}
