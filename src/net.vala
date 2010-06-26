/* net.vala
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

public abstract class Dova.Endpoint {
	public abstract NetworkStream connect ();
}

public class Dova.TcpEndpoint : Endpoint {
	string host;
	ushort port;

	public static TcpEndpoint parse (string host_and_port, ushort default_port) {
		result = new TcpEndpoint ();
		result.host = host_and_port;
		result.port = default_port;
	}

	public override NetworkStream connect () {
		// resolve name
		// TODO execute in global (concurrent) task queue
		var hints = Posix.addrinfo ();
		hints.ai_flags = Posix.AI_ADDRCONFIG;
		hints.ai_socktype = Posix.SOCK_STREAM;
		hints.ai_protocol = Posix.IPPROTO_TCP;
		Posix.addrinfo* addrs = null;
		Posix.getaddrinfo (host.data, port.to_string ().data, &hints, &addrs);

		Posix.addrinfo* addr = addrs;
		while (addr != null) {
			int fd = Posix.socket (addr->ai_family, addr->ai_socktype, addr->ai_protocol);

			// no blocking
			int flags = Posix.fcntl (fd, Posix.F_GETFL, 0);
			Posix.fcntl (fd, Posix.F_SETFL, flags | Posix.O_NONBLOCK);

			int res = Posix.connect (fd, addr->ai_addr, addr->ai_addrlen);

			if (res < 0) {
				int err = Posix.errno;
				if (err == Posix.EINPROGRESS) {
					Task.wait_fd_out (fd);
					// TODO check whether it was successful

					Posix.freeaddrinfo (addrs);

					return new NetworkStream (fd);
				}
			}

			Posix.close (fd);

			addr = addr->ai_next;
		}

		Posix.freeaddrinfo (addrs);

		// TODO error
		result = null;
	}
}

public class Dova.NetworkStream : Stream {
	int fd;

	protected NetworkStream (int fd) {
		this.fd = fd;
	}

	public override int read (byte[] b, int offset, int length) {
		if (length < 0) {
			length = b.length - offset;
		}
		while (true) {
			int res = (int) Posix.read (this.fd, ((byte*) ((Array<byte>) b).data) + offset, length);
			if (res < 0) {
				int err = Posix.errno;
				if (err == Posix.EINTR) {
					// just restart syscall
				} else if (err == Posix.EAGAIN || err == Posix.EWOULDBLOCK) {
					Task.wait_fd_in (this.fd);
				} else {
					// TODO
				}
			} else {
				return res;
			}
		}
	}

	public override int write (byte[] b, int offset, int length) {
		if (length < 0) {
			length = b.length - offset;
		}
		while (true) {
			int res = (int) Posix.write (this.fd, ((byte*) ((Array<byte>) b).data) + offset, length);
			if (res < 0) {
				int err = Posix.errno;
				if (err == Posix.EINTR) {
					// just restart syscall
				} else if (err == Posix.EAGAIN || err == Posix.EWOULDBLOCK) {
					Task.wait_fd_out (this.fd);
				} else {
					// TODO
				}
			} else {
				return res;
			}
		}
	}

	public override void close () {
		Posix.close (this.fd);
	}
}
