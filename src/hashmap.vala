/* hashmap.vala
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

public class Dova.HashMap<K,V> : MapModel<K,V> {
	public int size { get { return nnodes; } }

	int capacity;
	int mod;
	int mask;
	int nnodes;
	int noccupied;
	byte[] states;
	int[] hashes;
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

	public HashMap () {
		set_shift (3);
		states = new byte[capacity];
		hashes = new int[capacity];
		_keys = new K[capacity];
		_values = new V[capacity];
	}

	void set_shift (int shift) {
		capacity = 1 << shift;
		mod = prime_mod[shift];
		mask = capacity - 1;
	}

	public override V get (K key) {
		int step = 0;
		int key_hash = key.hash ();
		int node_index = key_hash % mod;
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

	public override void set (K key, V value) {
		int key_hash = key.hash ();
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
					if (_keys[node_index] == key) {
						// create tombstone
						states[node_index] = 1;
						_keys[node_index] = null;
						_values[node_index] = null;
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
			var new__keys = new K[capacity];
			var new__values = new V[capacity];
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
					new__keys[new_node_index] = _keys[i];
					new__values[new_node_index] = _values[i];
				}
			}
			states = new_states;
			hashes = new_hashes;
			_keys = new__keys;
			_values = new__values;
			noccupied = nnodes;
		}
	}

	public bool contains_key (K key) {
		int step = 0;
		int key_hash = key.hash ();
		int node_index = key_hash % mod;
		while (states[node_index] != 0) {
			if (states[node_index] == 2) {
				if (hashes[node_index] == key_hash) {
					if (_keys[node_index] == key) {
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

	public Iterable<K> keys { get { return new KeySet<K,V> (this); } }

	class KeySet<K,V> : Iterable<K> {
		HashMap<K,V> map;

		public KeySet (HashMap<K,V> map) {
			this.map = map;
		}

		public override Iterator<K> iterator () {
			return new KeyIterator<K,V> (this.map);
		}
	}

	class KeyIterator<K,V> : Iterator<K> {
		HashMap<K,V> map;

		int index;

		public KeyIterator (HashMap<K,V> map) {
			this.map = map;
			this.index = -1;
		}

		public override bool next () {
			index++;
			while (index < map.capacity) {
				if (map.states[index] == 2) {
					// valid index
					return true;
				}
				index++;
			}
			// reached end
			return false;
		}

		public override K get () {
			result = map._keys[index];
		}
	}

	public Iterable<V> values { get { return new ValueSet<K,V> (this); } }

	class ValueSet<K,V> : Iterable<V> {
		HashMap<K,V> map;

		public ValueSet (HashMap<K,V> map) {
			this.map = map;
		}

		public override Iterator<V> iterator () {
			return new ValueIterator<K,V> (this.map);
		}
	}

	class ValueIterator<K,V> : Iterator<V> {
		HashMap<K,V> map;

		int index;

		public ValueIterator (HashMap<K,V> map) {
			this.map = map;
			this.index = -1;
		}

		public override bool next () {
			index++;
			while (index < map.capacity) {
				if (map.states[index] == 2) {
					// valid index
					return true;
				}
				index++;
			}
			// reached end
			return false;
		}

		public override V get () {
			result = map._values[index];
		}
	}
}

