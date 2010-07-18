/* value.vala
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

public abstract class Dova.Value : any {
	volatile int ref_count;

	protected Value () {
	}

	public virtual void finalize () {
	}

	public static Value* alloc (Type type, int extra_size = 0) {
		result = OS.calloc (1, type.object_size + extra_size);
		result.type = type;
		result.ref_count = 1;
	}

	public static void* ref (void* object) {
		if (object == null) {
			return null;
		}
		OS.atomic_int32_fetch_add (&((Value*) object).ref_count, 1);
		return object;
	}

	public static void unref (void* object) {
		if (object == null) {
			return;
		}
		if (OS.atomic_int32_fetch_sub (&((Value*) object).ref_count, 1) == 1) {
			((Value*) object).finalize ();
			OS.free (object);
		}
	}
}

namespace Dova {
	public void assert (bool condition, string? message = null) {
		if (!condition) {
			if (message == null) {
				OS.fprintf (OS.stderr, "assertion failed\n".data);
			} else {
				OS.fprintf (OS.stderr, "assertion failed: %s\n".data, ((!) message).data);
			}
			OS.assert (false);
		}
	}

	public void assert_compare (string expr, string v1, string cmp, string v2) {
		assert (false, "($expr): ($v1 $cmp $v2)");
	}

	[NoReturn]
	public void assert_not_reached () {
		assert (false);
	}
}
