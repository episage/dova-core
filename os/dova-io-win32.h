/* dova-io-win32.h
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

#ifndef __DOVA_IO_WIN32_H__
#define __DOVA_IO_WIN32_H_

#include <io.h>
#include <windows.h>
#include <winsock2.h>
#include <ws2tcpip.h>

#define SOCK_CLOEXEC 02000000
#define SOCK_NONBLOCK 04000

#ifndef AI_ADDRCONFIG
#define AI_ADDRCONFIG 1024
#endif

#define EWOULDBLOCK EAGAIN
#ifndef EINPROGRESS
#define EINPROGRESS EAGAIN
#endif

struct _dova_epoll {
	int n_fds;
	struct _dova_epoll_fd *fds;
};

typedef struct _dova_epoll *epoll_t;

#define EPOLL_CTL_ADD 1
#define EPOLL_CTL_DEL 2
#define EPOLL_CTL_MOD 3

#define EPOLLIN (FD_READ | FD_ACCEPT | FD_CLOSE)
#define EPOLLOUT (FD_WRITE | FD_CONNECT | FD_CLOSE)

#define EPOLL_CLOEXEC 02000000
#define EPOLL_NONBLOCK 04000

#define TFD_CLOEXEC 02000000
#define TFD_NONBLOCK 04000

typedef union epoll_data {
	void *ptr;
	int fd;
	uint32_t u332;
	uint64_t u64;
} epoll_data_t;

struct epoll_event {
	uint32_t events;
	epoll_data_t data;
};

struct _dova_epoll_fd {
	struct _dova_epoll_fd *next;
	struct _dova_epoll_fd *prev;
	int fd;
	struct epoll_event event;
	WSAEVENT event_handle;
};

#define UNIX_PATH_MAX 108

struct sockaddr_un {
	uint16_t sun_family;
	char sun_path[UNIX_PATH_MAX];
};

struct timespec {
	time_t tv_sec;
	long tv_nsec;
};

struct itimerspec {
	struct timespec it_interval;
	struct timespec it_value;
};

static int _dova_open (const char *pathname, int flags, unsigned int mode) {
	return open (pathname, flags | O_BINARY, mode);
}
#define open _dova_open

struct _dova_stat {
	uint32_t st_mode;
	int64_t st_size;
	struct timespec st_mtim;
};

static int _dova_stat (const char *path, struct _dova_stat *buf) {
	struct stat st;

	if (stat (path, &st) < 0) {
		return -1;
	}

	buf->st_mode = st.st_mode;
	buf->st_size = st.st_size;
	buf->st_mtim.tv_sec = st.st_mtime;
	buf->st_mtim.tv_nsec = 0;

	return 0;
}
#define stat _dova_stat

static inline int _dova_socket (int domain, int type, int protocol) {
	SOCKET s;
	WSADATA wsadata;

	if (WSAStartup (MAKEWORD (2, 2), &wsadata)) {
		return -1;
	}

	s = socket (domain, type, protocol);
	if (s == INVALID_SOCKET) {
		return -1;
	}

	/* set socket to non-blocking */
	if (type & SOCK_NONBLOCK) {
		unsigned long arg = 1;
		ioctlsocket (s, FIONBIO, &arg);
	}

	return _open_osfhandle ((intptr_t) s, 0);
}
#define socket _dova_socket

static inline int _dova_bind (int sockfd, const struct sockaddr *addr, socklen_t addrlen) {
	if (bind (_get_osfhandle (sockfd), addr, addrlen) == SOCKET_ERROR) {
		return -1;
	}

	return 0;
}
#define bind _dova_bind

static inline int _dova_connect (int sockfd, const struct sockaddr *addr, socklen_t addrlen) {
	if (connect (_get_osfhandle (sockfd), addr, addrlen) == SOCKET_ERROR) {
		return -1;
	}

	return 0;
}
#define connect _dova_connect

static inline int _dova_accept (int sockfd, struct sockaddr *addr, socklen_t *addrlen) {
	SOCKET s;

	s = accept (_get_osfhandle (sockfd), addr, addrlen);
	if (s == INVALID_SOCKET) {
		return -1;
	}

	return _open_osfhandle ((intptr_t) s, 0);
}
#define accept _dova_accept

static inline epoll_t epoll_create1 (int flags) {
	epoll_t epfd = calloc (1, sizeof (struct _dova_epoll));
	return epfd;
}

static inline int epoll_ctl (epoll_t epfd, int op, int fd, struct epoll_event *event) {
	struct _dova_epoll_fd *epoll_fd;

	for (epoll_fd = epfd->fds; epoll_fd; epoll_fd = epoll_fd->next) {
		if (epoll_fd->fd == fd) {
			switch (op) {
			case EPOLL_CTL_ADD:
				errno = EEXIST;
				return -1;
			case EPOLL_CTL_MOD:
				epoll_fd->event = *event;
				return 0;
			case EPOLL_CTL_DEL:
				if (epoll_fd->event_handle) {
					WSACloseEvent (epoll_fd->event_handle);
				}

				if (epoll_fd->next == epoll_fd) {
					/* only fd */
					epfd->fds = NULL;
				} else {
					epoll_fd->prev->next = epoll_fd->next;
					epoll_fd->next->prev = epoll_fd->prev;
					if (epoll_fd == epfd->fds) {
						epfd->fds = epoll_fd->next;
					}
				}
				free (epoll_fd);
				return 0;
			}
		}
		if (epoll_fd->next == epfd->fds) {
			break;
		}
	}

	if (op == EPOLL_CTL_ADD) {
		epoll_fd = calloc (1, sizeof (struct _dova_epoll_fd));
		epoll_fd->fd = fd;
		epoll_fd->event = *event;

		if (GetFileType ((HANDLE) _get_osfhandle (fd)) == FILE_TYPE_PIPE) {
			long events;
			epoll_fd->event_handle = WSACreateEvent ();
			WSAEventSelect (_get_osfhandle (fd), epoll_fd->event_handle, event->events);
		}

		if (epfd->fds == NULL) {
			epoll_fd->next = epoll_fd;
			epoll_fd->prev = epoll_fd;
			epfd->fds = epoll_fd;
		} else {
			epoll_fd->next = epfd->fds;
			epoll_fd->prev = epfd->fds->prev;
			epoll_fd->prev->next = epoll_fd;
			epoll_fd->next->prev = epoll_fd;
		}

		return 0;
	} else {
		errno = ENOENT;
		return -1;
	}
}

static inline int epoll_wait (epoll_t epfd, struct epoll_event *events, int maxevents, int timeout) {
	HANDLE *handles;
	int nhandles, nevents;
	DWORD ret;
	struct _dova_epoll_fd *epoll_fd;

	handles = calloc (epfd->n_fds, sizeof (HANDLE));

	nhandles = 0;

	for (epoll_fd = epfd->fds; epoll_fd; epoll_fd = epoll_fd->next) {
		if (epoll_fd->event_handle) {
			handles[nhandles] = epoll_fd->event_handle;
		} else {
			handles[nhandles] = (HANDLE) _get_osfhandle (epoll_fd->fd);
		}
		nhandles++;

		if (epoll_fd->next == epfd->fds) {
			break;
		}
	}

	ret = WaitForMultipleObjects (nhandles, handles, FALSE, timeout);

	if (ret == WAIT_FAILED) {
		/* TODO: handle all error cases */
	}

	nhandles = 0;
	nevents = 0;

	for (epoll_fd = epfd->fds; epoll_fd; epoll_fd = epoll_fd->next) {
		if (ret == WAIT_OBJECT_0 + nhandles) {
			events[nevents] = epoll_fd->event;
			nevents++;
		}

		nhandles++;

		if (epoll_fd->next == epfd->fds) {
			break;
		}
	}

	return nevents;
}

static inline void epoll_destroy (epoll_t epfd) {
	free (epfd);
}

static inline int timerfd_create (int clockid, int flags) {
	HANDLE h;

	h = CreateWaitableTimer (NULL, TRUE, NULL);

	return _open_osfhandle ((intptr_t) h, 0);
}

static inline int timerfd_settime (int fd, int flags, const struct itimerspec *new_value, struct itimerspec *old_value) {
	LARGE_INTEGER due_time;

	due_time.QuadPart = -((int64_t) new_value->it_value.tv_sec * 10000000 + new_value->it_value.tv_nsec / 100);

	if (!SetWaitableTimer ((HANDLE) _get_osfhandle (fd), &due_time, 0, NULL, NULL, FALSE)) {
		/* TODO: map error */
		return -1;
	}

	return 0;
}

#endif
