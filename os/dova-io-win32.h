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
#include <winsock2.h>
#include <ws2tcpip.h>

#define SOCK_CLOEXEC 02000000
#define SOCK_NONBLOCK 04000

static int _dova_open (const char *pathname, int flags, unsigned int mode) {
	return open (pathname, flags | O_BINARY, mode);
}
#define open _dova_open

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

#endif
