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

/*
 POSIX type mapping

 char:           byte/uint8
 signed char:    int8
 unsigned char:  byte/uint8
 short:          int16
 unsigned short: uint16
 int:            int32
 unsigned int:   uint32
 long:           int
 unsigned long:  uint
 size_t:         uint
 ssize_t:        int
 off_t:          int64
 time_t:         int
 */

[CCode (cprefix = "", lower_case_cprefix = "", cheader_filename = "dova-os.h")]
namespace OS {
	public void atomic_int32_store (volatile int32* atomic, int32 desired);
	public int32 atomic_int32_load (volatile int32* atomic);
	public bool atomic_int32_compare_exchange (volatile int32* atomic, int32* expected, int32 desired);
	public int32 atomic_int32_fetch_add (volatile int32* atomic, int32 operand);
	public int32 atomic_int32_fetch_sub (volatile int32* atomic, int32 operand);

	public byte** getargv ();
	public void setargv (byte** argv);

	public void assert (bool expression);

	public int32 dlclose (void* handle);
	public byte* dlerror ();
	public void* dlopen (byte* file, int32 mode);
	public void* dlsym (void* handle, byte* name);

	public int32 errno;
	public const int32 EAGAIN;
	public const int32 EINPROGRESS;
	public const int32 EINTR;
	public const int32 EWOULDBLOCK;

	public double ceil (double x);
	public double floor (double x);

	[CCode (cname = "struct addrinfo")]
	public struct addrinfo {
		public int32 ai_flags;
		public int32 ai_family;
		public int32 ai_socktype;
		public int32 ai_protocol;
		public int32 ai_addrlen;
		public sockaddr* ai_addr;
		public byte* ai_canonname;
		public addrinfo* ai_next;
	}
	public void freeaddrinfo (addrinfo* res);
	public int32 getaddrinfo (byte* node, byte* service, addrinfo* hints, addrinfo** res);
	public const int32 AI_ADDRCONFIG;

	public struct stack_t {
		void* ss_sp;
		int32 ss_flags;
		uint ss_size;
	}

	public int32 printf (byte* format, ...);
	public int32 fprintf (FILE* stream, byte* format, ...);
	public int32 snprintf (byte* str, uint size, byte* format, ...);
	public FILE* stdin;
	public FILE* stdout;
	public FILE* stderr;
	public struct FILE {
	}

	public void* calloc (uint nelem, uint elsize);
	public void free (void* ptr);
	public void* malloc (uint size);
	public void* realloc (void* ptr, uint size);
	public byte* getenv (byte* name);

	public void* memchr (void* s, int32 c, uint n);
	public int32 memcmp (void* s1, void* s2, uint n);
	public void* memcpy (void* dest, void* src, uint n);
	public void* memset (void* s, int32 c, uint n);
	public int32 strcmp (void* s1, void* s2);
	public int32 strcoll (void* s1, void* s2);
	public uint strcspn (byte* s, byte* reject);
	public void* strstr (void* haystack, void* needle);
	public uint strlen (byte* s);
	public int32 strncmp (void* s1, void* s2, uint n);

	public int32 fcntl (int32 fd, int32 cmd, ...);
	public int32 open (byte* path, int32 oflag, int32 mode);
	public int32 close (int32 fd);
	public int32 dup (int32 oldfd);
	public int read (int32 fd, void* buf, uint count);
	public int write (int32 fd, void* buf, uint count);
	public const int32 F_GETFL;
	public const int32 F_SETFL;
	public const int32 O_CREAT;
	public const int32 O_NONBLOCK;
	public const int32 O_RDONLY;
	public const int32 O_RDWR;
	public const int32 O_WRONLY;

	public const int32 PROT_READ;
	public const int32 PROT_WRITE;
	public const int32 MAP_PRIVATE;
	public const int32 MAP_ANONYMOUS;

	public void* mmap (void* addr, uint length, int32 prot, int32 flags, int32 fd, int64 offset);
	public int32 munmap (void* addr, uint length);

	public int32 accept (int32 sockfd, sockaddr* addr, uint32* addrlen);
	public int32 bind (int32 sockfd, sockaddr* addr, uint32 addrlen);
	public int32 connect (int32 sockfd, sockaddr* addr, uint32 addrlen);
	public int32 listen (int32 sockfd, int32 backlog);
	public int32 socket (int32 domain, int32 type, int32 protocol);
	public int32 setsockopt (int32 socket, int32 level, int32 option_name, void* option_value, uint32 option_len);
	public const uint16 AF_INET;
	public const uint16 AF_UNIX;
	public const int32 SOCK_NONBLOCK;
	public const int32 SOCK_STREAM;
	public const int32 SOL_SOCKET;
	public const int32 SO_REUSEADDR;

	[CCode (cname = "struct sockaddr")]
	public struct sockaddr {
		public int32 sa_family;
	}

	[CCode (cname = "struct sockaddr_in")]
	public struct in_addr {
		public uint32 s_addr;
	}

	[CCode (cname = "struct sockaddr_in")]
	public struct sockaddr_in {
		public int32 sin_family;
		public uint16 sin_port;
		public in_addr sin_addr;
	}

	public const int32 IPPROTO_TCP;

	public uint16 htons (uint16 hostshort);
	public int32 inet_pton (int32 af, byte* src, void* dst);

	public int32 gettimeofday (out timeval tv, void* tz = null);
	[CCode (cname = "struct timeval")]
	public struct timeval {
		public int tv_sec;
		public int tv_usec;
	}

	[CCode (cname = "struct sockaddr_un")]
	public struct sockaddr_un {
		public uint16 sun_family;
		public byte* sun_path;
	}

	[CCode (cname = "struct itimerspec")]
	public struct itimerspec {
		timespec it_interval;
		timespec it_value;
	}

	[CCode (cname = "struct timespec")]
	public struct timespec {
		int tv_sec;
		int tv_nsec;
	}

	[CCode (cname = "struct tm")]
	public struct tm {
		public int32 tm_sec;
		public int32 tm_min;
		public int32 tm_hour;
		public int32 tm_mday;
		public int32 tm_mon;
		public int32 tm_year;
		public int32 tm_wday;
		public int32 tm_yday;
		public int32 tm_isdst;
	}
	public tm* localtime_r (int* timep, tm* res);
	public int32 clock_gettime (int32 clk_id, timespec* tp);

	public const int32 CLOCK_MONOTONIC;

	public struct ucontext_t {
	}

	public void makecontext (ucontext_t* ucp, void* func);
	public int32 swapcontext (ucontext_t* oucp, ucontext_t* ucp);
	public void freecontext (ucontext_t* ucp);

	public const int32 _PC_PATH_MAX;

	public byte* getcwd (byte* buf, uint size);
	public uint32 getuid ();
	public int pathconf (byte* path, int32 name);


	public struct epoll_t {
	}

	public struct epoll_data_t {
		public void* ptr;
		public int32 fd;
		public uint32 u32;
		public uint64 u64;
	}

	[CCode (cname = "struct epoll_event")]
	public struct epoll_event {
		public uint32 events;
		public epoll_data_t data;
	}

	public const int32 EPOLL_CLOEXEC;
	public const int32 EPOLL_CTL_ADD;
	public const int32 EPOLL_CTL_MOD;
	public const int32 EPOLL_CTL_DEL;
	public const int32 EPOLLIN;
	public const int32 EPOLLOUT;

	public epoll_t epoll_create1 (int32 flags);
	public int32 epoll_ctl (epoll_t epfd, int32 op, int32 fd, epoll_event* event);
	public int32 epoll_wait (epoll_t epfd, epoll_event* events, int32 maxevents, int32 timeout);
	public void epoll_destroy (epoll_t epfd);

	public int32 timerfd_create (int32 clockid, int32 flags);
	public int32 timerfd_settime (int32 fd, int32 flags, itimerspec* new_value, itimerspec* old_value);

	public const int32 TFD_CLOEXEC;
}
