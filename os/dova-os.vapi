/* dova-os.vapi
 *
 * Copyright (C) 2009-2010  Jürg Billeter
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

[CCode (cprefix = "", lower_case_cprefix = "", cheader_filename = "dova-os.h")]
namespace OS {
	public void atomic_int32_store (volatile int* atomic, int desired);
	public int atomic_int32_load (volatile int* atomic);
	public int atomic_int32_fetch_add (volatile int* atomic, int operand);
	public int atomic_int32_fetch_sub (volatile int* atomic, int operand);

	[IntegerType (rank = 9)]
	public struct long {
	}

	public void assert (bool expression);

	public int dlclose (void* handle);
	public byte* dlerror ();
	public void* dlopen (byte* file, int mode);
	public void* dlsym (void* handle, byte* name);

	public int errno;
	public const int EAGAIN;
	public const int EINPROGRESS;
	public const int EINTR;
	public const int EWOULDBLOCK;

	public double ceil (double x);
	public double floor (double x);

	[CCode (cname = "struct addrinfo")]
	public struct addrinfo {
		public int ai_flags;
		public int ai_family;
		public int ai_socktype;
		public int ai_protocol;
		public int ai_addrlen;
		public sockaddr* ai_addr;
		public byte* ai_canonname;
		public addrinfo* ai_next;
	}
	public void freeaddrinfo (addrinfo* res);
	public int getaddrinfo (byte* node, byte* service, addrinfo* hints, addrinfo** res);
	public const int AI_ADDRCONFIG;

	public const int thrd_success;

	public struct thrd_t {
	}
	public struct mtx_t {
	}

	public int thrd_create (thrd_t* thread, void* start_routine, void* arg);
	public int thrd_yield ();
	public int thrd_join (thrd_t thr, int* res);
	public void thrd_exit (int res);
	public int mtx_init (mtx_t* mtx, int type);
	public void mtx_destroy (mtx_t* mtx);
	public int mtx_lock (mtx_t* mtx);
	public int mtx_trylock (mtx_t* mtx);
	public int mtx_unlock (mtx_t* mtx);

	public struct stack_t {
		void* ss_sp;
		int ss_flags;
		size_t ss_size;
	}

	public int printf (byte* format, ...);
	public int fprintf (FILE* stream, byte* format, ...);
	public int snprintf (byte* str, size_t size, byte* format, ...);
	public FILE* stdin;
	public FILE* stdout;
	public FILE* stderr;
	public struct FILE {
	}

	public void* calloc (size_t nelem, size_t elsize);
	public void free (void* ptr);
	public void* malloc (size_t size);
	public void* realloc (void* ptr, size_t size);
	public byte* getenv (byte* name);

	public void* memchr (void* s, int c, size_t n);
	public int memcmp (void* s1, void* s2, size_t n);
	public void* memcpy (void* dest, void* src, size_t n);
	public void* memset (void* s, int c, size_t n);
	public int strcmp (void* s1, void* s2);
	public int strcoll (void* s1, void* s2);
	public size_t strcspn (byte* s, byte* reject);
	public void* strstr (void* haystack, void* needle);
	public size_t strlen (byte* s);
	public int strncmp (void* s1, void* s2, size_t n);

	public int fcntl (int fd, int cmd, ...);
	public int open (char* path, int oflag, int mode);
	public int close (int fd);
	public int dup (int oldfd);
	public ssize_t read (int fd, void* buf, size_t count);
	public ssize_t write (int fd, void* buf, size_t count);
	public const int F_GETFL;
	public const int F_SETFL;
	public const int O_CREAT;
	public const int O_NONBLOCK;
	public const int O_RDONLY;
	public const int O_RDWR;
	public const int O_WRONLY;

	public const int PROT_READ;
	public const int PROT_WRITE;
	public const int MAP_PRIVATE;
	public const int MAP_ANONYMOUS;

	public void* mmap (void* addr, size_t length, int prot, int flags, int fd, off_t offset);
	public int munmap (void* addr, size_t length);

	public int accept (int sockfd, sockaddr* addr, size_t* addrlen);
	public int bind (int sockfd, sockaddr* addr, size_t addrlen);
	public int connect (int sockfd, sockaddr* addr, size_t addrlen);
	public int listen (int sockfd, int backlog);
	public int socket (int domain, int type, int protocol);
	public const int AF_INET;
	public const int AF_UNIX;
	public const int SOCK_STREAM;

	[CCode (cname = "struct sockaddr")]
	public struct sockaddr {
		public int sa_family;
	}

	[CCode (cname = "struct sockaddr_in")]
	public struct in_addr {
		public uint s_addr;
	}

	[CCode (cname = "struct sockaddr_in")]
	public struct sockaddr_in {
		public int sin_family;
		public ushort sin_port;
		public in_addr sin_addr;
	}

	public const int IPPROTO_TCP;

	public ushort htons (ushort hostshort);
	public int inet_pton (int af, byte* src, void* dst);

	public int stat (byte* path, stat_t* buf);
	[CCode (cname = "struct stat")]
	public struct stat_t {
		public uint st_mode;
		public off_t st_size;
		public timespec st_mtim;
	}

	public bool S_ISREG (uint m);
	public bool S_ISDIR (uint m);
	public bool S_ISLNK (uint m);

	public int gettimeofday (out timeval tv, void* tz = null);
	[CCode (cname = "struct timeval")]
	public struct timeval {
		public time_t tv_sec;
		public suseconds_t tv_usec;
	}
	[IntegerType (rank = 8)]
	public struct suseconds_t {
	}

	[CCode (default_value = "0UL")]
	[IntegerType (rank = 9)]
	public struct off_t {
	}

	[CCode (default_value = "0UL")]
	[IntegerType (rank = 9)]
	public struct size_t {
	}

	[CCode (default_value = "0L")]
	[IntegerType (rank = 9)]
	public struct ssize_t {
	}

	[CCode (cname = "struct sockaddr_un")]
	public struct sockaddr_un {
		public int sun_family;
		public byte* sun_path;
	}

	[IntegerType (rank = 8)]
	public struct time_t {
	}

	[CCode (cname = "struct itimerspec")]
	public struct itimerspec {
		timespec it_interval;
		timespec it_value;
	}

	[CCode (cname = "struct timespec")]
	public struct timespec {
		time_t tv_sec;
		long tv_nsec;
	}

	public int nanosleep (timespec* req, timespec* rem);

	[CCode (cname = "struct tm")]
	public struct tm {
		public int tm_sec;
		public int tm_min;
		public int tm_hour;
		public int tm_mday;
		public int tm_mon;
		public int tm_year;
		public int tm_wday;
		public int tm_yday;
		public int tm_isdst;
	}
	public tm* localtime_r (time_t* timep, tm* res);
	public int clock_gettime (int clk_id, timespec* tp);

	public const int CLOCK_MONOTONIC;

	public struct ucontext_t {
		ucontext_t* uc_link;
		stack_t uc_stack;
	}

	public void getcontext (ucontext_t* ucp);
	public void makecontext (ucontext_t* ucp, void* func, int argc, ...);
	public int swapcontext (ucontext_t* oucp, ucontext_t* ucp);

	public uint getuid ();


	public struct epoll_data_t {
		public void* ptr;
		public int fd;
		public uint u32;
		public ulong u64;
	}

	[CCode (cname = "struct epoll_event")]
	public struct epoll_event {
		public uint events;
		public epoll_data_t data;
	}

	public const int EPOLL_CLOEXEC;
	public const int EPOLL_CTL_ADD;
	public const int EPOLL_CTL_MOD;
	public const int EPOLL_CTL_DEL;
	public const int EPOLLIN;
	public const int EPOLLOUT;

	public int epoll_create1 (int flags);

	public int epoll_ctl (int epfd, int op, int fd, epoll_event* event);

	public int epoll_wait (int epfd, epoll_event* events, int maxevents, int timeout);

	public int timerfd_create (int clockid, int flags);
	public int timerfd_settime (int fd, int flags, itimerspec* new_value, itimerspec* old_value);

	public const int TFD_CLOEXEC;
}
