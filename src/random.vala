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
	const int32 N = 624;
	const int32 M = 397;
	const uint32 MATRIX_A = (uint32) 0x9908b0dfu; /* constant vector a */
	const uint32 UPPER_MASK = (uint32) 0x80000000u; /* most significant w-r bits */
	const uint32 LOWER_MASK = (uint32) 0x7fffffffu; /* least significant r bits */

	/* Tempering parameters */
	const uint32 TEMPERING_MASK_B = (uint32) 0x9d2c5680u;
	const uint32 TEMPERING_MASK_C = (uint32) 0xefc60000u;

	/* transform [0..2^32] -> [0..1] */
	const double DOUBLE_TRANSFORM = 2.3283064365386962890625e-10;

	uint32 mt[624 /* N */];
	uint32 mti;

	public Random () {
		int32 seed = 0;
		int32 fd = OS.open ("/dev/urandom", OS.O_RDONLY, 0);
		if (fd >= 0) {
			int len = OS.read (fd, &seed, sizeof (uint));
			OS.close (fd);
			if (len < sizeof (uint)) {
				fd = -1;
			}
		}
		if (fd < 0) {
			seed = (int32) (Clock.MONOTONIC.get_time ().ticks % 0x100000000);
		}
		this.with_seed (seed);
	}

	public Random.with_seed (int32 seed) {
		mt[0]= seed;
		for (mti = 1; mti < N; mti++) {
			mt[mti] = (uint32) 1812433253u * (mt[mti - 1] ^ (mt[mti - 1] >> 30)) + mti;
		}
	}

	uint32 next_uint32 () {
		uint32 y;

		// generate N words at one time
		if (mti >= N) {
			int32 kk;

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

		return (int32) y;
	}

	public int32 next_int32 (int32 begin, int32 end) {
		uint32 dist = end - begin;
		uint32 random = 0;

		if (dist == 0) {
			random = 0;
		} else {
			uint32 maxvalue;
			if (dist <= 0x80000000u) { /* 2^31 */
				/* maxvalue = 2^32 - 1 - (2^32 % dist) */
				uint32 leftover = ((uint32) 0x80000000u % dist) * 2;
				if (leftover >= dist) {
					leftover -= dist;
				}
				maxvalue = (uint32) 0xffffffffu - leftover;
			} else {
				maxvalue = dist - 1;
			}

			do {
				random = next_uint32 ();
			} while (random > maxvalue);

			random %= dist;
		}

		return (int32) (begin + random);
	}

	public double next_double (double begin = 0, double end = 1) {
		result = next_uint32 () * DOUBLE_TRANSFORM;
		result = (result + next_uint32 ()) * DOUBLE_TRANSFORM;

		if (result >= 1.0) {
			return next_double (begin, end);
		}

		return result * (end - begin) + begin;
	}
}
