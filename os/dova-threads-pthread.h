/* dova-threads-pthread.h
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

#ifndef __DOVA_THREADS_PTHREAD_H__
#define __DOVA_THREADS_PTHREAD_H_

#include <errno.h>
#include <pthread.h>
#include <sched.h>

#define ONCE_FLAG_INIT PTHREAD_ONCE_INIT

typedef pthread_cond_t cnd_t;
typedef pthread_t thrd_t;
typedef pthread_key_t tss_t;
typedef pthread_mutex_t mtx_t;

typedef void (*tss_dtor_t) (void *);
typedef int (*thrd_start_t) (void *);

typedef pthread_once_t once_flag;

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
	pthread_once (flag, func);
}

static inline int cnd_broadcast (cnd_t *cond) {
	int ret;

	ret = pthread_cond_broadcast (cond);
	if (ret) {
		return thrd_error;
	}

	return thrd_success;
}

static inline void cnd_destroy (cnd_t *cond) {
	pthread_cond_destroy (cond);
}

static inline int cnd_init (cnd_t *cond) {
	int ret;

	ret = pthread_cond_init (cond, NULL);
	if (ret == ENOMEM) {
		return thrd_nomem;
	} else if (ret) {
		return thrd_error;
	}

	return thrd_success;
}

static inline int cnd_signal (cnd_t *cond) {
	int ret;

	ret = pthread_cond_signal (cond);
	if (ret) {
		return thrd_error;
	}

	return thrd_success;
}

static inline int cnd_timedwait (cnd_t *cond, mtx_t *mtx, const xtime *xt) {
	int ret;
	struct timespec abstime;

	abstime.tv_sec = xt->sec;
	abstime.tv_nsec = xt->nsec;

	ret = pthread_cond_timedwait (cond, mtx, &abstime);
	if (ret == ETIMEDOUT) {
		return thrd_timeout;
	} else if (ret) {
		return thrd_error;
	}

	return thrd_success;
}

static inline int cnd_wait (cnd_t *cond, mtx_t *mtx) {
	int ret;

	ret = pthread_cond_wait (cond, mtx);
	if (ret) {
		return thrd_error;
	}

	return thrd_success;
}

static inline void mtx_destroy (mtx_t *mtx) {
	pthread_mutex_destroy (mtx);
}

static inline int mtx_init (mtx_t *mtx, int type) {
	int ret;
	pthread_mutexattr_t attr;

	pthread_mutexattr_init (&attr);

	switch (type) {
	case mtx_plain:
	case mtx_timed:
		pthread_mutexattr_settype (&attr, PTHREAD_MUTEX_NORMAL);
		break;
	case mtx_try:
		pthread_mutexattr_settype (&attr, PTHREAD_MUTEX_ERRORCHECK);
		break;
	case mtx_plain | mtx_recursive:
	case mtx_timed | mtx_recursive:
	case mtx_try | mtx_recursive:
		pthread_mutexattr_settype (&attr, PTHREAD_MUTEX_RECURSIVE);
		break;
	default:
		return thrd_error;
	}

	ret = pthread_mutex_init (mtx, &attr);
	pthread_mutexattr_destroy (&attr);

	if (ret) {
		return thrd_error;
	}

	return thrd_success;
}

static inline int mtx_lock (mtx_t *mtx) {
	int ret;

	ret = pthread_mutex_lock (mtx);
	if (ret == EBUSY) {
		return thrd_busy;
	} else if (ret) {
		return thrd_error;
	}

	return thrd_success;
}

static inline int mtx_timedlock (mtx_t *mtx, const xtime *xt) {
	int ret;
	struct timespec abstime;

	abstime.tv_sec = xt->sec;
	abstime.tv_nsec = xt->nsec;

	ret = pthread_mutex_timedlock (mtx, &abstime);
	if (ret == EBUSY) {
		return thrd_busy;
	} else if (ret == ETIMEDOUT) {
		return thrd_timeout;
	} else if (ret) {
		return thrd_error;
	}

	return thrd_success;
}

static inline int mtx_trylock (mtx_t *mtx) {
	int ret;

	ret = pthread_mutex_trylock (mtx);
	if (ret == EBUSY) {
		return thrd_busy;
	} else if (ret) {
		return thrd_error;
	}

	return thrd_success;
}

static inline int mtx_unlock (mtx_t *mtx) {
	int ret;

	ret = pthread_mutex_unlock (mtx);
	if (ret) {
		return thrd_error;
	}

	return thrd_success;
}

static inline int thrd_create (thrd_t *thr, thrd_start_t func, void *arg) {
	int ret;

	ret = pthread_create (thr, NULL, func, arg);
	if (ret) {
		return thrd_error;
	}

	return thrd_success;
}

static inline thrd_t thrd_current (void) {
	return pthread_self ();
}

static inline int thrd_detach (thrd_t thr) {
	int ret;

	ret = pthread_detach (thr);
	if (ret) {
		return thrd_error;
	}

	return thrd_success;
}

static inline int thrd_equal (thrd_t thr0, thrd_t thr1) {
	return pthread_equal (thr0, thr1);
}

static inline void thrd_exit (int res) {
	pthread_exit ((void *) (long) res);
}

static inline int thrd_join (thrd_t thr, int *res) {
	int ret;
	void *retval;

	ret = pthread_join (thr, &retval);
	if (ret) {
		return thrd_error;
	}

	if (res) {
		*res = (int) (long) retval;
	}

	return thrd_success;
}

static inline void thrd_sleep (const xtime *xt) {
	struct timespec req;

	req.tv_sec = xt->sec;
	req.tv_nsec = xt->nsec;

	nanosleep (&req, NULL);
}

static inline void thrd_yield (void) {
	sched_yield ();
}

static inline int tss_create (tss_t *key, tss_dtor_t dtor) {
	int ret;

	ret = pthread_key_create (key, dtor);
	if (ret) {
		return thrd_error;
	}

	return thrd_success;
}

static inline void tss_delete (tss_t key) {
	pthread_key_delete (key);
}

static inline void *tss_get (tss_t key) {
	return pthread_getspecific (key);
}

static inline int tss_set (tss_t key, void *val) {
	int ret;

	ret = pthread_setspecific (key, val);
	if (ret) {
		return thrd_error;
	}

	return thrd_success;
}

#endif
