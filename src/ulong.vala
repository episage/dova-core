/* ulong.vala
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

[IntegerType (rank = 9, width = 64, signed = false)]
public struct ulong {
	public string to_string () {
		int length;
		ulong val = this;

		if (val < 10000000000) {
			if (val < 10000) {
				if (val < 100) {
					if (val < 10) {
						length = 1;
					} else {
						length = 2;
					}
				} else {
					if (val < 1000) {
						length = 3;
					} else {
						length = 4;
					}
				}
			} else {
				if (val < 1000000) {
					if (val < 100000) {
						length = 5;
					} else {
						length = 6;
					}
				} else {
					if (val < 100000000) {
						if (val < 10000000) {
							length = 7;
						} else {
							length = 8;
						}
					} else {
						if (val < 1000000000) {
							length = 9;
						} else {
							length = 10;
						}
					}
				}
			}
		} else {
			if (val < 100000000000000) {
				if (val < 1000000000000) {
					if (val < 100000000000) {
						length = 11;
					} else {
						length = 12;
					}
				} else {
					if (val < 10000000000000) {
						length = 13;
					} else {
						length = 14;
					}
				}
			} else {
				if (val < 10000000000000000) {
					if (val < 1000000000000000) {
						length = 15;
					} else {
						length = 16;
					}
				} else {
					if (val < 1000000000000000000) {
						if (val < 100000000000000000) {
							length = 17;
						} else {
							length = 18;
						}
					} else {
						if (val < 10000000000000000000) {
							length = 19;
						} else {
							length = 20;
						}
					}
				}
			}
		}

		result = string.create (length);
		byte* p = (byte*) result.data + length - 1;

		do {
			*p-- = (int) '0' + val % 10;
			val /= 10;
		} while (val > 0);

		return;
	}
}

