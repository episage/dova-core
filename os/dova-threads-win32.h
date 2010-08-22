/* dova-threads-win32.h
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

#ifndef __DOVA_THREADS_WIN32_H__
#define __DOVA_THREADS_WIN32_H_

#include <process.h>
#include <windows.h>

#define ONCE_FLAG_INIT INIT_ONCE_STATIC_INIT
typedef HANDLE thrd_t;
typedef DWORD tss_t;
typedef CRITICAL_SECTION mtx_t;

typedef void (*tss_dtor_t) (void *);
typedef int (*thrd_start_t) (void *);

typedef INIT_ONCE once_flag;

typedef struct {
	time_t sec;
	long nsec;
} xtime;

enum {
	mtx_plain = 1 << 0,
	mtx_recursive = 1 << 1,
	mtx_timed = 1 << 2,
	mtx_try = 1 << 3
};

enum {
	thrd_timeout,
	thrd_success,
	thrd_busy,
	thrd_error,
	thrd_nomem
};

static inline void call_once (once_flag *flag, void (*func) (void)) {
	InitOnceExecuteOnce (flag, (PINIT_ONCE_FN) func, NULL, NULL);
}

static inline void mtx_destroy (mtx_t *mtx) {
	DeleteCriticalSection (mtx);
}

static inline int mtx_init (mtx_t *mtx, int type) {
	if (type & mtx_timed) {
		return thrd_error;
	}

	InitializeCriticalSection (mtx);

	return thrd_success;
}

static inline int mtx_lock (mtx_t *mtx) {
	EnterCriticalSection (mtx);

	return thrd_success;
}

static inline int mtx_timedlock (mtx_t *mtx, const xtime *xt) {
	return thrd_error;
}

static inline int mtx_trylock (mtx_t *mtx) {
	if (!TryEnterCriticalSection (mtx)) {
		return thrd_busy;
	}

	return thrd_success;
}

static inline int mtx_unlock (mtx_t *mtx) {
	LeaveCriticalSection (mtx);

	return thrd_success;
}

static inline int thrd_create (thrd_t *thr, thrd_start_t func, void *arg) {
	uintptr_t ret;

	ret = _beginthreadex (NULL, 0, (unsigned (__stdcall *) (void *)) func, arg, 0, NULL);
	if (!ret) {
		return thrd_error;
	}

	*thr = (thrd_t) ret;
	return thrd_success;
}

static inline thrd_t thrd_current (void) {
	return GetCurrentThread ();
}

static inline int thrd_detach (thrd_t thr) {
	CloseHandle (thr);

	return thrd_success;
}

static inline int thrd_equal (thrd_t thr0, thrd_t thr1) {
	return (thr0 == thr1);
}

static inline void thrd_exit (int res) {
	_endthreadex (res);
}

static inline int thrd_join (thrd_t thr, int *res) {
	WaitForSingleObject (thr, INFINITE);
	CloseHandle (thr);

	return thrd_success;
}

static inline void thrd_sleep (const xtime *xt) {
	Sleep (xt->sec * 1000 + xt->nsec / 1000000);
}

static inline void thrd_yield (void) {
	Sleep (0);
}

static inline int tss_create (tss_t *key, tss_dtor_t dtor) {
	DWORD ret;

	if (dtor) {
		/* destructors not yet supported */
		return thrd_error;
	}

	ret = TlsAlloc ();
	if (!ret) {
		return thrd_error;
	}

	*key = ret;

	return thrd_success;
}

static inline void tss_delete (tss_t key) {
	TlsFree (key);
}

static inline void *tss_get (tss_t key) {
	return TlsGetValue (key);
}

static inline int tss_set (tss_t key, void *val) {
	if (!TlsSetValue (key, val)) {
		return thrd_error;
	}

	return thrd_success;
}

#endif
