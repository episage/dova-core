/* posix.vapi
 *
 * Copyright (C) 2009  Jürg Billeter
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
namespace Posix {
	[IntegerType (rank = 9)]
	public struct long {
	}

	[CCode (cheader_filename = "assert.h")]
	public void assert (bool expression);

	[CCode (cheader_filename = "errno.h")]
	public int errno;
	[CCode (cheader_filename = "errno.h")]
	public const int EAGAIN;
	[CCode (cheader_filename = "errno.h")]
	public const int EINPROGRESS;
	[CCode (cheader_filename = "errno.h")]
	public const int EINTR;
	[CCode (cheader_filename = "errno.h")]
	public const int EWOULDBLOCK;

	[CCode (cheader_filename = "math.h")]
	public double ceil (double x);
	[CCode (cheader_filename = "math.h")]
	public double floor (double x);

	[CCode (cname = "struct addrinfo", cheader_filename = "netdb.h")]
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
	[CCode (cheader_filename = "netdb.h")]
	public void freeaddrinfo (addrinfo* res);
	[CCode (cheader_filename = "netdb.h")]
	public int getaddrinfo (byte* node, byte* service, addrinfo* hints, addrinfo** res);
	[CCode (cheader_filename = "netdb.h")]
	public const int AI_ADDRCONFIG;

	[CCode (cheader_filename = "pthread.h")]
	public struct pthread_t {
	}
	[CCode (cheader_filename = "pthread.h")]
	public struct pthread_attr_t {
	}
	[CCode (cheader_filename = "pthread.h")]
	public struct pthread_mutex_t {
	}
	[CCode (cheader_filename = "pthread.h")]
	public struct pthread_mutexattr_t {
	}

	[CCode (cheader_filename = "pthread.h")]
	public int pthread_create (pthread_t* thread, pthread_attr_t* attr, void* start_routine, void* arg);
	[CCode (cheader_filename = "pthread.h")]
	public int pthread_mutex_init (pthread_mutex_t* mutex, pthread_mutexattr_t* attr);
	[CCode (cheader_filename = "pthread.h")]
	public int pthread_mutex_lock (pthread_mutex_t* mutex);
	[CCode (cheader_filename = "pthread.h")]
	public int pthread_mutex_unlock (pthread_mutex_t* mutex);

	[CCode (cheader_filename = "sched.h")]
	public int sched_yield ();

	[CCode (cheader_filename = "signal.h")]
	public struct stack_t {
		void* ss_sp;
		int ss_flags;
		size_t ss_size;
	}

	[CCode (cheader_filename = "stdio.h")]
	public int printf (byte* format, ...);
	[CCode (cheader_filename = "stdio.h")]
	public int fprintf (FILE* stream, byte* format, ...);
	[CCode (cheader_filename = "stdio.h")]
	public int snprintf (byte* str, size_t size, byte* format, ...);
	[CCode (cheader_filename = "stdio.h")]
	public FILE* stdin;
	[CCode (cheader_filename = "stdio.h")]
	public FILE* stdout;
	[CCode (cheader_filename = "stdio.h")]
	public FILE* stderr;
	[CCode (cheader_filename = "stdio.h")]
	public struct FILE {
	}

	[CCode (cheader_filename = "stdlib.h")]
	public void* calloc (size_t nelem, size_t elsize);
	[CCode (cheader_filename = "stdlib.h")]
	public void free (void* ptr);
	[CCode (cheader_filename = "stdlib.h")]
	public void* malloc (size_t size);
	[CCode (cheader_filename = "stdlib.h")]
	public void* realloc (void* ptr, size_t size);
	[CCode (cheader_filename = "stdlib.h")]
	public byte* getenv (byte* name);

	[CCode (cheader_filename = "string.h")]
	public void* memchr (void* s, int c, size_t n);
	[CCode (cheader_filename = "string.h")]
	public void* memcpy (void* dest, void* src, size_t n);
	[CCode (cheader_filename = "string.h")]
	public void* memset (void* s, int c, size_t n);
	[CCode (cheader_filename = "string.h")]
	public int strcmp (void* s1, void* s2);
	[CCode (cheader_filename = "string.h")]
	public int strcoll (void* s1, void* s2);
	[CCode (cheader_filename = "string.h")]
	public size_t strcspn (byte* s, byte* reject);
	[CCode (cheader_filename = "string.h")]
	public void* strstr (void* haystack, void* needle);
	[CCode (cheader_filename = "string.h")]
	public size_t strlen (byte* s);
	[CCode (cheader_filename = "string.h")]
	public int strncmp (void* s1, void* s2, size_t n);

	[CCode (cheader_filename = "fcntl.h")]
	public int fcntl (int fd, int cmd, ...);
	[CCode (cheader_filename = "fcntl.h")]
	public int open (char* path, int oflag, int mode);
	[CCode (cheader_filename = "unistd.h")]
	public int close (int fd);
	[CCode (cheader_filename = "unistd.h")]
	public int dup (int oldfd);
	[CCode (cheader_filename = "unistd.h")]
	public ssize_t read (int fd, void* buf, size_t count);
	[CCode (cheader_filename = "unistd.h")]
	public ssize_t write (int fd, void* buf, size_t count);
	[CCode (cheader_filename = "fcntl.h")]
	public const int F_GETFL;
	[CCode (cheader_filename = "fcntl.h")]
	public const int F_SETFL;
	[CCode (cheader_filename = "fcntl.h")]
	public const int O_CREAT;
	[CCode (cheader_filename = "fcntl.h")]
	public const int O_NONBLOCK;
	[CCode (cheader_filename = "fcntl.h")]
	public const int O_RDONLY;
	[CCode (cheader_filename = "fcntl.h")]
	public const int O_RDWR;
	[CCode (cheader_filename = "fcntl.h")]
	public const int O_WRONLY;

	[CCode (cheader_filename = "sys/mman.h")]
	public const int PROT_READ;
	[CCode (cheader_filename = "sys/mman.h")]
	public const int PROT_WRITE;
	[CCode (cheader_filename = "sys/mman.h")]
	public const int MAP_PRIVATE;
	[CCode (cheader_filename = "sys/mman.h")]
	public const int MAP_ANONYMOUS;

	[CCode (cheader_filename = "sys/mman.h")]
	public void* mmap (void* addr, size_t length, int prot, int flags, int fd, off_t offset);
	[CCode (cheader_filename = "sys/mman.h")]
	public int munmap (void* addr, size_t length);

	[CCode (cheader_filename = "sys/socket.h")]
	public int accept (int sockfd, sockaddr* addr, size_t* addrlen);
	[CCode (cheader_filename = "sys/socket.h")]
	public int bind (int sockfd, sockaddr* addr, size_t addrlen);
	[CCode (cheader_filename = "sys/socket.h")]
	public int connect (int sockfd, sockaddr* addr, size_t addrlen);
	[CCode (cheader_filename = "sys/socket.h")]
	public int listen (int sockfd, int backlog);
	[CCode (cheader_filename = "sys/socket.h")]
	public int socket (int domain, int type, int protocol);
	[CCode (cheader_filename = "sys/socket.h")]
	public const int AF_INET;
	[CCode (cheader_filename = "sys/socket.h")]
	public const int AF_UNIX;
	[CCode (cheader_filename = "sys/socket.h")]
	public const int SOCK_STREAM;

	[CCode (cname = "struct sockaddr", cheader_filename = "sys/socket.h")]
	public struct sockaddr {
		public int sa_family;
	}

	[CCode (cname = "struct sockaddr_in", cheader_filename = "netinet/in.h")]
	public struct in_addr {
		public uint s_addr;
	}

	[CCode (cname = "struct sockaddr_in", cheader_filename = "netinet/in.h")]
	public struct sockaddr_in {
		public int sin_family;
		public ushort sin_port;
		public in_addr sin_addr;
	}

	[CCode (cheader_filename = "netinet/in.h")]
	public const int IPPROTO_TCP;

	[CCode (cheader_filename = "arpa/inet.h")]
	public ushort htons (ushort hostshort);
	[CCode (cheader_filename = "arpa/inet.h")]
	public int inet_pton (int af, byte* src, void* dst);

	[CCode (cheader_filename = "sys/time.h")]
	public int gettimeofday (out timeval tv, void* tz = null);
	[CCode (cname = "struct timeval", cheader_filename = "sys/time.h")]
	public struct timeval {
		public time_t tv_sec;
		public suseconds_t tv_usec;
	}
	[CCode (cheader_filename = "sys/time.h")]
	[IntegerType (rank = 8)]
	public struct suseconds_t {
	}

	[CCode (cheader_filename = "sys/types.h", default_value = "0UL")]
	[IntegerType (rank = 9)]
	public struct off_t {
	}

	[CCode (cheader_filename = "sys/types.h", default_value = "0UL")]
	[IntegerType (rank = 9)]
	public struct size_t {
	}

	[CCode (cheader_filename = "sys/types.h", default_value = "0L")]
	[IntegerType (rank = 9)]
	public struct ssize_t {
	}

	[CCode (cname = "struct sockaddr_un", cheader_filename = "sys/un.h")]
	public struct sockaddr_un {
		public int sun_family;
		public byte* sun_path;
	}

	[CCode (cheader_filename = "time.h")]
	[IntegerType (rank = 8)]
	public struct time_t {
	}

	[CCode (cname = "struct itimerspec", cheader_filename = "time.h")]
	public struct itimerspec {
		timespec it_interval;
		timespec it_value;
	}

	[CCode (cname = "struct timespec", cheader_filename = "time.h")]
	public struct timespec {
		time_t tv_sec;
		long tv_nsec;
	}

	[CCode (cheader_filename = "time.h")]
	public int nanosleep (timespec* req, timespec* rem);

	[CCode (cname = "struct tm", cheader_filename = "time.h")]
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
	[CCode (cheader_filename = "time.h")]
	public tm* localtime_r (time_t* timep, tm* res);

	[CCode (cheader_filename = "time.h")]
	public const int CLOCK_MONOTONIC;

	[CCode (cheader_filename = "ucontext.h")]
	public struct ucontext_t {
		ucontext_t* uc_link;
		stack_t uc_stack;
	}

	[CCode (cheader_filename = "ucontext.h")]
	public void getcontext (ucontext_t* ucp);
	[CCode (cheader_filename = "ucontext.h")]
	public void makecontext (ucontext_t* ucp, void* func, int argc, ...);
	[CCode (cheader_filename = "ucontext.h")]
	public int swapcontext (ucontext_t* oucp, ucontext_t* ucp);

	[CCode (cheader_filename = "unistd.h")]
	public uint getuid ();
}
