/* atomic-gcc.vala
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

[IntegerType (rank = 6, width = 32)]
public struct Dova.AtomicInt {
	public static void store (ref volatile AtomicInt object, int desired) {
		object = desired;
	}

	public static int load (ref volatile AtomicInt object) {
		result = object;
	}

	public static int fetch_and_add (ref volatile AtomicInt object, int operand) {
		result = OS.__sync_fetch_and_add_int (&object, operand);
	}

	public static int fetch_and_sub (ref volatile AtomicInt object, int operand) {
		result = OS.__sync_fetch_and_sub_int (&object, operand);
	}
}

