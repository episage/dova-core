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

public class Dova.TcpEndpoint /* : Dova.Value */ {
	// TODO also support creating TcpEndpoints for SRV entries (domain and service pair)

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
		var hints = OS.addrinfo ();
		hints.ai_flags = OS.AI_ADDRCONFIG;
		hints.ai_socktype = OS.SOCK_STREAM;
		hints.ai_protocol = OS.IPPROTO_TCP;
		OS.addrinfo* addrs = null;
		OS.getaddrinfo (endpoint.host.data, endpoint.port.to_string ().data, &hints, &addrs);

		result = null;

		OS.addrinfo* addr = addrs;
		while (addr != null) {
			int fd = OS.socket (addr.ai_family, addr.ai_socktype, addr.ai_protocol);

			// no blocking
			int flags = OS.fcntl (fd, OS.F_GETFL, 0);
			OS.fcntl (fd, OS.F_SETFL, flags | OS.O_NONBLOCK);

			int res = OS.connect (fd, addr.ai_addr, addr.ai_addrlen);

			if (res < 0) {
				int err = OS.errno;
				if (err == OS.EINPROGRESS) {
					Task.wait_fd_out (fd);
					// TODO check whether it was successful
				} else {
					OS.close (fd);
					fd = -1;
				}
			}

			if (fd >= 0) {
				result = new NetworkStream (fd);
				break;
			}

			addr = addr.ai_next;
		}

		OS.freeaddrinfo (addrs);
	}
}

public delegate void TcpServerFunc (NetworkStream stream);

public class Dova.TcpServer {
	// TODO support multiple sockets
	int fd;

	public TcpServerFunc handler { get; set; }

	public void add_local_endpoint (TcpEndpoint endpoint) {
		fd = OS.socket (OS.AF_INET, OS.SOCK_STREAM, OS.IPPROTO_TCP);

		// no blocking
		int flags = OS.fcntl (fd, OS.F_GETFL, 0);
		OS.fcntl (fd, OS.F_SETFL, flags | OS.O_NONBLOCK);

		var addr = OS.sockaddr_in ();
		addr.sin_family = OS.AF_INET;
		addr.sin_port = OS.htons (endpoint.port);
		int res = OS.bind (fd, (OS.sockaddr*) (&addr), sizeof (OS.sockaddr_in));
		OS.listen (fd, 8);
	}

	public void start () {
		Task.run (run);
	}

	void run () {
		while (true) {
			int res = OS.accept (fd, null, null);
			if (res < 0) {
				int err = OS.errno;
				if (err == OS.EINTR) {
					// just restart syscall
				} else if (err == OS.EAGAIN || err == OS.EWOULDBLOCK) {
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
			int res = (int) OS.read (this.fd, ((byte*) ((Array<byte>) b).data) + offset, length);
			if (res < 0) {
				int err = OS.errno;
				if (err == OS.EINTR) {
					// just restart syscall
				} else if (err == OS.EAGAIN || err == OS.EWOULDBLOCK) {
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
			int res = (int) OS.write (this.fd, ((byte*) ((Array<byte>) b).data) + offset, length);
			if (res < 0) {
				int err = OS.errno;
				if (err == OS.EINTR) {
					// just restart syscall
				} else if (err == OS.EAGAIN || err == OS.EWOULDBLOCK) {
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
		OS.close (this.fd);
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
		int fd = OS.socket (OS.AF_UNIX, OS.SOCK_STREAM, 0);

		// no blocking
		int flags = OS.fcntl (fd, OS.F_GETFL, 0);
		OS.fcntl (fd, OS.F_SETFL, flags | OS.O_NONBLOCK);

		var addr = OS.sockaddr_un ();
		addr.sun_family = OS.AF_UNIX;
		OS.memcpy (addr.sun_path, endpoint.path.data, endpoint.path.length + 1);
		int res = OS.connect (fd, (OS.sockaddr*) (&addr), 2 + endpoint.path.length);

		if (res < 0) {
			int err = OS.errno;
			if (err == OS.EINPROGRESS) {
				Task.wait_fd_out (fd);
				// TODO check whether it was successful
			} else {
				OS.close (fd);
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
