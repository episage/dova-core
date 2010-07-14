/* dova-os.h
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

#ifndef __DOVA_OS_H__
#define __DOVA_OS_H_

#include <arpa/inet.h>
#include <assert.h>
#include <errno.h>
#include <fcntl.h>
#include <math.h>
#include <netdb.h>
#include <netinet/in.h>
#include <pthread.h>
#include <sched.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/epoll.h>
#include <sys/mman.h>
#include <sys/socket.h>
#include <sys/stat.h>
#include <sys/time.h>
#include <sys/timerfd.h>
#include <sys/types.h>
#include <sys/un.h>
#include <time.h>
#include <ucontext.h>
#include <unistd.h>

static inline void atomic_int32_store (volatile int32_t *atomic, int32_t desired) {
	*atomic = desired;
	__sync_synchronize ();
}

static inline int32_t atomic_int32_load (volatile int32_t *atomic) {
	__sync_synchronize ();
	return *atomic;
}

static inline int32_t atomic_int32_fetch_add (volatile int32_t *atomic, int32_t operand) {
	return __sync_fetch_and_add (atomic, operand);
}

static inline int32_t atomic_int32_fetch_sub (volatile int32_t *atomic, int32_t operand) {
	return __sync_fetch_and_sub (atomic, operand);
}

#endif
