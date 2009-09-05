/* object.vala
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

public class Dova.Object {
	public Type type;
	int ref_count;

	public virtual void finalize () {
	}

	public virtual bool equal (Object other) {
		return (this == other);
	}

	public virtual int hash () {
		void* ptr = this;
		return (int) (long) ptr;
	}

	public virtual string to_string () {
		return this.type.name;
	}

	public bool is_a (Type type) {
		return this.type.is_subtype_of (type);
	}

	public static Object? alloc (Type type) {
		result = (Object) Posix.calloc (1, type.object_size);
		result.type = type;
		return;
	}

	public static void* ref (void* object) {
		((Object*) object)->ref_count++;
		return object;
	}
	
	public static void unref (void* object) {
		((Object*) object)->ref_count--;
		if ((((Object*) object)->ref_count) == 0) {
			((Object*) object)->finalize ();
			Posix.free (object);
		}
	}
}

public class Dova.Type {
	public Type? base_type { get; set; }
	public string name { get; set; }
	public int object_size { get; set; }
	public int type_size { get; set; }
	// sizeof (void *) for pointer based types
	public int value_size { get; set; }

	int n_interfaces;
	Interface* interfaces;

	struct Interface {
		public Type* interface_type;
		public void* vtable;
	}

	public Type (Type? base_type) {
		this.base_type = base_type;
	}

	public bool is_subtype_of (Type type) {
		if (this == type) {
			return true;
		} else if (base_type != null && base_type.is_subtype_of (type)) {
			return true;
		} else if (get_interface (type) != null) {
			return true;
		} else {
			return false;
		}
	}

	public void add_interface (Type* interface_type, void* vtable) {
		int index = this.n_interfaces;

		this.n_interfaces++;
		this.interfaces = Posix.realloc (this.interfaces, this.n_interfaces * (int) sizeof (Interface));

		// sort interface implementations by interface type pointer
		// to allow binary search when using interface
		while (index > 0 && this.interfaces[index - 1].interface_type > interface_type) {
			this.interfaces[index].interface_type = this.interfaces[index - 1].interface_type;
			this.interfaces[index].vtable = this.interfaces[index - 1].vtable;
			index--;
		}

		this.interfaces[index].interface_type = interface_type;
		this.interfaces[index].vtable = vtable;
	}

	public void* get_interface (Type* interface_type) {
		int l, r, m;

		// use binary search, interface array is sorted by interface type pointer

		l = 0;
		r = this.n_interfaces - 1;
		m = 0;

		if (r == -1) {
			return null;
		}

		while (r > l && this.interfaces[m].interface_type != interface_type) {
			m = (l + r) / 2;
			if (interface_type < this.interfaces[m].interface_type) {
				// left half
				r = m - 1;
			} else {
				// right half
				l = m + 1;
			}
		}
		if (this.interfaces[m].interface_type == interface_type) {
			return this.interfaces[m].vtable;
		} else {
			return null;
		}
	}
}

