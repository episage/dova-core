/* linux.vapi
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
namespace Linux {
	[CCode (cheader_filename = "sys/epoll.h")]
	public struct epoll_data_t {
		public void* ptr;
		public int fd;
		public uint u32;
		public ulong u64;
	}

	[CCode (cname = "struct epoll_event", cheader_filename = "sys/epoll.h")]
	public struct epoll_event {
		public uint events;
		public epoll_data_t data;
	}

	[CCode (cheader_filename = "sys/epoll.h")]
	public const int EPOLL_CLOEXEC;
	[CCode (cheader_filename = "sys/epoll.h")]
	public const int EPOLL_CTL_ADD;
	[CCode (cheader_filename = "sys/epoll.h")]
	public const int EPOLL_CTL_MOD;
	[CCode (cheader_filename = "sys/epoll.h")]
	public const int EPOLL_CTL_DEL;

	[CCode (cheader_filename = "sys/epoll.h")]
	public int epoll_create1 (int flags);

	[CCode (cheader_filename = "sys/epoll.h")]
	public int epoll_ctl (int epfd, int op, int fd, epoll_event* event);

	[CCode (cheader_filename = "sys/epoll.h")]
	public int epoll_wait (int epfd, epoll_event* events, int maxevents, int timeout);
}

