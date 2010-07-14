/* random.vala
 *
 * Copyright (C) 2010  Jürg Billeter
 * Copyright (C) 1995-1997  Peter Mattis, Spencer Kimball and Josh MacDonald
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

// based on code from GLib
public class Dova.Random {
	/* Period parameters */
	const int N = 624;
	const int M = 397;
	const uint MATRIX_A = 0x9908b0dfu; /* constant vector a */
	const uint UPPER_MASK = 0x80000000u; /* most significant w-r bits */
	const uint LOWER_MASK = 0x7fffffffu; /* least significant r bits */

	/* Tempering parameters */
	const uint TEMPERING_MASK_B = 0x9d2c5680u;
	const uint TEMPERING_MASK_C = 0xefc60000u;

	/* transform [0..2^32] -> [0..1] */
	const double DOUBLE_TRANSFORM = 2.3283064365386962890625e-10;

	uint mt[624 /* N */];
	uint mti;

	public Random () {
		int seed = 0;
		int fd = OS.open ("/dev/urandom", OS.O_RDONLY, 0);
		if (fd >= 0) {
			int len = (int) OS.read (fd, &seed, sizeof (uint));
			OS.close (fd);
			if (len < sizeof (uint)) {
				fd = -1;
			}
		}
		if (fd < 0) {
			seed = (int) (Time.now ().ticks % 0x100000000);
		}
		this.with_seed (seed);
	}

	public Random.with_seed (int seed) {
		mt[0]= seed;
		for (mti = 1; mti < N; mti++) {
			mt[mti] = 1812433253u * (mt[mti - 1] ^ (mt[mti - 1] >> 30)) + mti;
		}
	}

	uint next_uint () {
		uint y;

		// generate N words at one time
		if (mti >= N) {
			int kk;

			for (kk = 0; kk < N - M; kk++) {
				y = (mt[kk] & UPPER_MASK)|(mt[kk + 1] & LOWER_MASK);
				mt[kk] = mt[kk + M] ^ (y >> 1) ^ (MATRIX_A * (y & 0x1));
			}
			for (; kk < N - 1; kk++) {
				y = (mt[kk] & UPPER_MASK)|(mt[kk+1] & LOWER_MASK);
				mt[kk] = mt[kk + (M - N)] ^ (y >> 1) ^ (MATRIX_A * (y & 0x1));
			}
			y = (mt[N - 1] & UPPER_MASK)|(mt[0] & LOWER_MASK);
			mt[N - 1] = mt[M - 1] ^ (y >> 1) ^ (MATRIX_A * (y & 0x1));

			mti = 0;
		}

		y = mt[mti++];
		y ^= (y >> 11);
		y ^= (y << 7) & TEMPERING_MASK_B;
		y ^= (y << 15) & TEMPERING_MASK_C;
		y ^= (y >> 18);

		return (int) y;
	}

	public int next_int (int begin, int end) {
		uint dist = end - begin;
		uint random = 0;

		if (dist == 0) {
			random = 0;
		} else {
			uint maxvalue;
			if (dist <= 0x80000000u) { /* 2^31 */
				/* maxvalue = 2^32 - 1 - (2^32 % dist) */
				uint leftover = (0x80000000u % dist) * 2;
				if (leftover >= dist) {
					leftover -= dist;
				}
				maxvalue = 0xffffffffu - leftover;
			} else {
				maxvalue = dist - 1;
			}

			do {
				random = next_uint ();
			} while (random > maxvalue);

			random %= dist;
		}

		return (int) (begin + random);
	}

	public double next_double (double begin = 0, double end = 1) {
		result = next_uint () * DOUBLE_TRANSFORM;
		result = (result + next_uint ()) * DOUBLE_TRANSFORM;

		if (result >= 1.0) {
			return next_double (begin, end);
		}

		return result * (end - begin) + begin;
	}
}
