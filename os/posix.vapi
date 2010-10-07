/* posix.vapi
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

[CCode (cprefix = "", lower_case_cprefix = "")]
namespace OS {
	[CCode (cheader_filename = "pthread.h")]
	public struct pthread_t {
	}

	[CCode (cheader_filename = "pthread.h")]
	public struct pthread_attr_t {
	}

	[CCode (cheader_filename = "pthread.h")]
	public struct pthread_key_t {
	}

	[CCode (cheader_filename = "pthread.h")]
	public struct pthread_mutex_t {
	}

	[CCode (cheader_filename = "pthread.h")]
	public struct pthread_mutexattr_t {
	}

	[CCode (cheader_filename = "pthread.h")]
	public int32 pthread_create (pthread_t* thread, pthread_attr_t* attr, void* start_routine, void* arg);
	[CCode (cheader_filename = "pthread.h")]
	public int 32pthread_detach (pthread_t thread);
	[CCode (cheader_filename = "pthread.h")]
	public void pthread_exit (void* retval);
	[CCode (cheader_filename = "pthread.h")]
	public void* pthread_getspecific (pthread_key_t key);
	[CCode (cheader_filename = "pthread.h")]
	public int32 pthread_join (pthread_t thread, void** retval);
	[CCode (cheader_filename = "pthread.h")]
	public int32 pthread_key_create (pthread_key_t* key, void* destructor);
	[CCode (cheader_filename = "pthread.h")]
	public int32 pthread_key_delete (pthread_key_t key);
	[CCode (cheader_filename = "pthread.h")]
	public int32 pthread_mutex_destroy (pthread_mutex_t* mutex);
	[CCode (cheader_filename = "pthread.h")]
	public int32 pthread_mutex_init (pthread_mutex_t* mutex, pthread_mutexattr_t* attr);
	[CCode (cheader_filename = "pthread.h")]
	public int32 pthread_mutex_lock (pthread_mutex_t* mutex);
	[CCode (cheader_filename = "pthread.h")]
	public int32 pthread_mutex_timedlock (pthread_mutex_t* mutex, timespec* abs_timeout);
	[CCode (cheader_filename = "pthread.h")]
	public int32 pthread_mutex_trylock (pthread_mutex_t* mutex);
	[CCode (cheader_filename = "pthread.h")]
	public int32 pthread_mutex_unlock (pthread_mutex_t* mutex);
	[CCode (cheader_filename = "pthread.h")]
	public int32 pthread_mutexattr_destroy (pthread_mutexattr_t* attr);
	[CCode (cheader_filename = "pthread.h")]
	public int32 pthread_mutexattr_init (pthread_mutexattr_t* attr);
	[CCode (cheader_filename = "pthread.h")]
	public int32 pthread_mutexattr_settype (pthread_mutexattr_t* attr, int32 type);
	[CCode (cheader_filename = "pthread.h")]
	public pthread_t pthread_self ();
	[CCode (cheader_filename = "pthread.h")]
	public int32 pthread_setspecific (pthread_key_t key, void* value);

	[CCode (cheader_filename = "pthread.h")]
	public const int32 PTHREAD_MUTEX_ERRORCHECK;
	[CCode (cheader_filename = "pthread.h")]
	public const int32 PTHREAD_MUTEX_NORMAL;
	[CCode (cheader_filename = "pthread.h")]
	public const int32 PTHREAD_MUTEX_RECURSIVE;

	[CCode (cheader_filename = "sched.h")]
	public int32 sched_yield ();

	[CCode (cheader_filename = "sys/stat.h")]
	public int32 stat (byte* path, stat_t* buf);
	[CCode (cname = "struct stat", cheader_filename = "sys/stat.h")]
	public struct stat_t {
		public uint32 st_mode;
		public int64 st_size;
		public timespec st_mtim;
	}

	[CCode (cheader_filename = "sys/stat.h")]
	public bool S_ISREG (uint32 m);
	[CCode (cheader_filename = "sys/stat.h")]
	public bool S_ISDIR (uint32 m);
	[CCode (cheader_filename = "sys/stat.h")]
	public bool S_ISLNK (uint32 m);

	[CCode (cheader_filename = "time.h")]
	public int32 nanosleep (timespec* req, timespec* rem);
}
