/* value.vala
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

public abstract class Dova.Value : Object {
	protected Value () {
	}
}

namespace Dova {
	public void assert (bool condition, string? message = null) {
		if (!condition) {
			if (message == null) {
				Posix.fprintf (Posix.stderr, "assertion failed\n".data);
			} else {
				Posix.fprintf (Posix.stderr, "assertion failed: %s\n".data, ((!) message).data);
			}
			Posix.assert (false);
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
