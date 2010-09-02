/* dova-ucontext-posix.h
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

#ifndef __DOVA_UCONTEXT_POSIX_H__
#define __DOVA_UCONTEXT_POSIX_H_

#include <ucontext.h>

#define _DOVA_STACK_SIZE (1024 * 1024)

static inline void _dova_makecontext (ucontext_t *ucp, void (*func) (void)) {
	getcontext (ucp);

	ucp->uc_stack.ss_sp = mmap (NULL, _DOVA_STACK_SIZE, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
	ucp->uc_stack.ss_size = _DOVA_STACK_SIZE;

	makecontext (ucp, func, 0);
}
#define makecontext _dova_makecontext

static inline void freecontext (ucontext_t *ucp) {
	munmap (ucp->uc_stack.ss_sp, ucp->uc_stack.ss_size);
}

#endif
