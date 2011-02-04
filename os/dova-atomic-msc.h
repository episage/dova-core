/* dova-atomic-msc.h
 *
 * Copyright (C) 2010  Jürg Billeter
 * Copyright (C) 2010  Ralf Michl
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
 * 	Ralf Michl <ralf@michl.info>
 */

#ifndef __DOVA_ATOMIC_MSC_H__
#define __DOVA_ATOMIC_MSC_H__

#include <intrin.h>

static inline void atomic_int32_store (volatile int32_t *atomic, int32_t desired) {
	*atomic = desired;
}

static inline int32_t atomic_int32_load (volatile int32_t *atomic) {
	return *atomic;
}

static inline bool atomic_int32_compare_exchange (volatile int32_t *atomic, int32_t *expected, int32_t desired) {
	return _InterlockedCompareExchange (atomic, desired, *expected) == *expected;
}

static inline int32_t atomic_int32_fetch_add (volatile int32_t *atomic, int32_t operand) {
	return _InterlockedExchangeAdd (atomic, operand);
}

static inline int32_t atomic_int32_fetch_sub (volatile int32_t *atomic, int32_t operand) {
	return _InterlockedExchangeAdd (atomic, -operand);
}

#endif
