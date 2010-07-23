/* object.vala
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

public abstract class any {
	public Type type;

	// allow nullable this
	public abstract bool equals (any? other);

	// allow nullable this
	public abstract uint hash ();

	// allow nullable this
	public abstract string to_string ();

	public bool is_a (Type type) {
		return this.type.is_subtype_of (type);
	}

	public static void* ref (void* object) {
		result = null;
		((any) object).type.value_copy (&result, 0, &object, 0);
	}

	public static void unref (void* object) {
		((any) object).type.value_copy (&object, 0, null, 0);
	}
}

public class Dova.Object : any {
	volatile int ref_count;
	volatile int weak_count;

	public virtual void finalize () {
	}

	public override sealed bool equals (any? other) {
		return (this == other);
	}

	public override sealed uint hash () {
		void* ptr = this;
		return (uint) (uintptr) ptr;
	}

	public override string to_string () {
		return this.type.name;
	}

	public static Object* alloc (Type type) {
		result = OS.calloc (1, type.object_size);
		result.type = type;
		result.ref_count = 1;
		result.weak_count = 1;
	}

	public static void* ref (void* object) {
		if (object == null) {
			return null;
		}
		OS.atomic_int32_fetch_add (&((Object*) object).ref_count, 1);
		return object;
	}

	public static void unref (void* object) {
		if (object == null) {
			return;
		}
		if (OS.atomic_int32_fetch_sub (&((Object*) object).ref_count, 1) == 1) {
			((Object*) object).finalize ();
			weak_unref (object);
		}
	}

	public static void* weak_get (void* object) {
		if (object == null) {
			return null;
		}
		while (true) {
			int ref_count = ((Object*) object).ref_count;
			if (ref_count == 0) {
				return null;
			}
			if (OS.atomic_int32_compare_exchange (&((Object*) object).ref_count, &ref_count, ref_count + 1)) {
				// successfully obtained strong reference
				return object;
			}
		}
	}

	public static void* weak_ref (void* object) {
		if (object == null) {
			return null;
		}
		OS.atomic_int32_fetch_add (&((Object*) object).weak_count, 1);
		return object;
	}

	public static void weak_unref (void* object) {
		if (object == null) {
			return;
		}
		if (OS.atomic_int32_fetch_sub (&((Object*) object).weak_count, 1) == 1) {
			OS.free (object);
		}
	}
}

// maybe add override (string name, void* method) method to avoid the extra _override helper functions
// performance shouldn't be critical on type creation
public abstract class Dova.Type {
	public Type? base_type { get; set; }
	public Type? generic_type { get; set; }
	public string name { get; set; }
	public Type? next_type { get; set; }
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

	protected Type (Type? base_type) {
		this.base_type = base_type;
	}

	public new static void alloc (Type base_type, int object_size, int type_size, out Type* result, out int object_offset, out int type_offset) {
		result = OS.calloc (1, base_type.type_size + type_size);
		result.base_type = base_type;
		object_offset = base_type.object_size;
		result.object_size = base_type.object_size + object_size;
		type_offset = base_type.type_size;
		result.type_size = base_type.type_size + type_size;
		result.type = typeof (Type);
	}

	public void insert_type (Type type) {
		type.next_type = next_type;
		next_type = type;
	}

	public bool is_subtype_of (Type type) {
		if (this == type) {
			return true;
		} else if (base_type != null && ((!) base_type).is_subtype_of (type)) {
			return true;
		} else if (get_interface (type) != null) {
			return true;
		} else if (generic_type != null && this == generic_type) {
			return true;
		} else {
			return false;
		}
	}

	public void add_interface (Type* interface_type, void* vtable) {
		int index = this.n_interfaces;

		this.n_interfaces++;
		this.interfaces = OS.realloc (this.interfaces, this.n_interfaces * (int) sizeof (Interface));

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
		int l, r;

		// use binary search, interface array is sorted by interface type pointer

		l = 0;
		r = this.n_interfaces - 1;

		if (r == -1) {
			return null;
		}

		while (r >= l) {
			int m = (l + r) / 2;

			if (interface_type == this.interfaces[m].interface_type) {
				return this.interfaces[m].vtable;
			} else if (interface_type < this.interfaces[m].interface_type) {
				// left half
				r = m - 1;
			} else {
				// right half
				l = m + 1;
			}
		}

		return null;
	}

	public extern void value_copy (void* dest, int dest_index, void* src, int src_index);
}

namespace Dova {
	[ModuleInit]
	public void init (int argc, byte** argv) {
		OS.setargv (argv);
	}
}
