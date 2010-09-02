/* dova-ucontext-win32.h
 *
 * Copyright (C) 2010  Jürg Billeter
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

#ifndef __DOVA_UCONTEXT_WIN32_H__
#define __DOVA_UCONTEXT_WIN32_H_

#include <windows.h>

typedef LPVOID ucontext_t;

#define _DOVA_STACK_SIZE (1024 * 1024)

extern bool _dova_fiber_initialized;

static inline void makecontext (ucontext_t *ucp, void (*func) (void)) {
	*ucp = CreateFiber (_DOVA_STACK_SIZE, (LPFIBER_START_ROUTINE) func, NULL);
}

static inline int swapcontext (ucontext_t *oucp, ucontext_t *ucp) {
	if (!_dova_fiber_initialized) {
		*oucp = ConvertThreadToFiber (NULL);
		_dova_fiber_initialized = true;
	}

	SwitchToFiber (*ucp);
	return 0;
}

static inline void freecontext (ucontext_t *ucp) {
	DeleteFiber (*ucp);
}

#endif
