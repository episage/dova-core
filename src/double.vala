/* double.vala
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

[FloatingType (rank = 2, width = 64)]
public struct double {
	public double floor () {
		return OS.floor (this);
	}

	public double ceil () {
		return OS.ceil (this);
	}

	public string to_string () {
		byte[] buffer = new byte[30];
		OS.snprintf (buffer.data, buffer.length, "%.17g".data, this);
		return string.create_from_cstring (buffer.data);
	}
}
