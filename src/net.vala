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

public class Dova.TcpEndpoint {
	// TODO also support creating TcpEndpoints for SRV entries (domain and service pair)
	// move address resolving in here and use subclasses?

	internal string host { get; private set; }
	internal ushort port { get; private set; }

	public TcpEndpoint (string host_and_port, ushort default_port) {
		this.host = host_and_port;
		this.port = default_port;
	}

}

public class Dova.TcpClient {
	// TODO add proxy and tls support

	public TcpClient () {
	}

	public NetworkStream connect (TcpEndpoint endpoint) {
		// resolve name
		// TODO execute in global (concurrent) task queue
		var hints = Posix.addrinfo ();
		hints.ai_flags = Posix.AI_ADDRCONFIG;
		hints.ai_socktype = Posix.SOCK_STREAM;
		hints.ai_protocol = Posix.IPPROTO_TCP;
		Posix.addrinfo* addrs = null;
		Posix.getaddrinfo (endpoint.host.data, endpoint.port.to_string ().data, &hints, &addrs);

		result = null;

		Posix.addrinfo* addr = addrs;
		while (addr != null) {
			int fd = Posix.socket (addr.ai_family, addr.ai_socktype, addr.ai_protocol);

			// no blocking
			int flags = Posix.fcntl (fd, Posix.F_GETFL, 0);
			Posix.fcntl (fd, Posix.F_SETFL, flags | Posix.O_NONBLOCK);

			int res = Posix.connect (fd, addr.ai_addr, addr.ai_addrlen);

			if (res < 0) {
				int err = Posix.errno;
				if (err == Posix.EINPROGRESS) {
					Task.wait_fd_out (fd);
					// TODO check whether it was successful
				} else {
					Posix.close (fd);
					fd = -1;
				}
			}

			if (fd >= 0) {
				result = new NetworkStream (fd);
				break;
			}

			addr = addr.ai_next;
		}

		Posix.freeaddrinfo (addrs);
	}
}

public delegate void TcpServerFunc (NetworkStream stream);

public class Dova.TcpServer {
	// TODO support multiple sockets
	int fd;

	public TcpServerFunc handler { get; set; }

	public void add_local_endpoint (TcpEndpoint endpoint) {
		fd = Posix.socket (Posix.AF_INET, Posix.SOCK_STREAM, Posix.IPPROTO_TCP);

		// no blocking
		int flags = Posix.fcntl (fd, Posix.F_GETFL, 0);
		Posix.fcntl (fd, Posix.F_SETFL, flags | Posix.O_NONBLOCK);

		var addr = Posix.sockaddr_in ();
		addr.sin_family = Posix.AF_INET;
		addr.sin_port = Posix.htons (endpoint.port);
		int res = Posix.bind (fd, (Posix.sockaddr*) (&addr), sizeof (Posix.sockaddr_in));
		Posix.listen (fd, 8);
	}

	public void start () {
		Task.run (run);
	}

	void run () {
		while (true) {
			int res = Posix.accept (fd, null, null);
			if (res < 0) {
				int err = Posix.errno;
				if (err == Posix.EINTR) {
					// just restart syscall
				} else if (err == Posix.EAGAIN || err == Posix.EWOULDBLOCK) {
					Task.wait_fd_in (fd);
				} else {
					// TODO
				}
			} else {
				var stream = new NetworkStream (res);
				Task.run (() => {
					handler (stream);
				});
			}
		}
	}

	public void stop () {
	}
}

public class Dova.NetworkStream : Stream {
	internal int fd { get; private set; }

	internal NetworkStream (int fd) {
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

public class Dova.UnixEndpoint {
	internal string path { get; private set; }

	public UnixEndpoint (string path) {
		this.path = path;
	}
}

public class Dova.UnixClient {
	public UnixStream connect (UnixEndpoint endpoint) {
		int fd = Posix.socket (Posix.AF_UNIX, Posix.SOCK_STREAM, 0);

		// no blocking
		int flags = Posix.fcntl (fd, Posix.F_GETFL, 0);
		Posix.fcntl (fd, Posix.F_SETFL, flags | Posix.O_NONBLOCK);

		var addr = Posix.sockaddr_un ();
		addr.sun_family = Posix.AF_UNIX;
		Posix.memcpy (addr.sun_path, endpoint.path.data, endpoint.path.length + 1);
		int res = Posix.connect (fd, (Posix.sockaddr*) (&addr), 2 + endpoint.path.length);

		if (res < 0) {
			int err = Posix.errno;
			if (err == Posix.EINPROGRESS) {
				Task.wait_fd_out (fd);
				// TODO check whether it was successful
			} else {
				Posix.close (fd);
				fd = -1;
			}
		}

		if (fd >= 0) {
			result = new UnixStream (fd);
		} else {
			// TODO error
			result = null;
		}
	}
}

public class Dova.UnixStream : NetworkStream {
	internal UnixStream (int fd) {
		base (fd);
	}
}
