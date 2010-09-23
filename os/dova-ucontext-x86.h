/* dova-ucontext-x86.h
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

#ifndef __DOVA_UCONTEXT_X86_H__
#define __DOVA_UCONTEXT_X86_H_

typedef void **_dova_ucontext_t;
#define ucontext_t _dova_ucontext_t

#define _DOVA_STACK_SIZE (1024 * 1024)

static inline void _dova_makecontext (ucontext_t *ucp, void (*func) (void)) {
	void **stack;
	stack = mmap (NULL, _DOVA_STACK_SIZE, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0) + _DOVA_STACK_SIZE;
	/* return address of swapcontext is func */
	*(--stack) = func;
	/* ebp */
	*(--stack) = NULL;
	/* ebx */
	*(--stack) = NULL;
	/* esi */
	*(--stack) = NULL;
	/* edi */
	*(--stack) = NULL;
	*ucp = stack;
}
#define makecontext _dova_makecontext

static inline void freecontext (ucontext_t *ucp) {
	/* TODO */
}

static void _dova_swapcontext (ucontext_t *oucp, ucontext_t *ucp);

asm (
	".pushsection .text\n"
	".align\n"
	".type _dova_swapcontext, @function\n"
	"_dova_swapcontext:\n"

	/* save original stack pointer for parameter value access */
	"movl %esp,%eax\n"

	/* push callee-save registers to stack */
	"pushl %ebp\n"
	"pushl %ebx\n"
	"pushl %esi\n"
	"pushl %edi\n"

	/* store stack pointer to *oucp */
	"movl 4(%eax), %ecx\n"
	"movl %esp, (%ecx)\n"

	/* load stack pointer from *ucp */
	"movl 8(%eax), %ecx\n"
	"movl (%ecx), %esp\n"

	/* pop callee-save registers from stack */
	"popl %edi\n"
	"popl %esi\n"
	"popl %ebx\n"
	"popl %ebp\n"

	"ret\n"
	".popsection\n"
);

#define swapcontext _dova_swapcontext

#endif
