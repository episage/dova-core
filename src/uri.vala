/* uri.vala
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

// should also support IRIs, see RFC3986 and RFC3987

// absolute URI/IRI in parsed form
// shouldn't be used in all the places where uris are just passed around, there a normal string is more efficient and should still be sufficient
public class Dova.Uri /*: Value*/ {
	public string scheme { get; private set; }
	public string? userinfo { get; private set; }
	public string? host { get; private set; }
	// -1 for default port
	public int port { get; private set; }
	public string path { get; private set; }
	public string? query { get; private set; }
	public string? fragment { get; private set; }

	static bool is_schemechar (string str, int offset) {
		byte c = str[offset];
		if ((c >= 'A' && c <= 'Z') ||
		    (c >= 'a' && c <= 'z') ||
		    (c >= '0' && c <= '9') ||
		    c == '+' || c == '-' || c == '.') {
			return true;
		}
		return false;
	}

	public Uri (string uri) {
		// TODO convert this to a private method and use it for both, public absolute uri parsing and the relative uri parsing/resolving (see method 'resolve')

		int i = 0;
		//byte* p = uri;
		while (is_schemechar (uri, i)) {
			i++;
		}

		if (i > 0 && uri[i] == ':') {
			// non-empty scheme => absolute URI
			if (!((uri[0] >= 'A' && uri[0] <= 'Z') || (uri[0] >= 'a' && uri[0] <= 'z'))) {
				// scheme must start with a letter
				// TODO error
			}
			// TODO convert scheme to lower case as it is case insensitive
			scheme = uri[0:i];
			i++;
		} else {
			// no scheme => relative URI, currently not handled
			// TODO error
			i = 0;
		}

		if (uri[i] == '/' && uri[i + 1] == '/') {
			// authority
			i += 2;
			// authority ends either at path '/', query '?', fragment '#', or end of string
			int authority_end = uri.length;
			int slash = uri.index_of ('/', i);
			int question = uri.index_of ('?', i);
			int hash = uri.index_of ('#', i);
			if (slash >= 0 && slash < authority_end) {
				authority_end = slash;
			}
			if (question >= 0 && question < authority_end) {
				authority_end = question;
			}
			if (hash >= 0 && hash < authority_end) {
				authority_end = hash;
			}

			// userinfo ends with @
			int userinfo_end = uri.index_of ('@', i, authority_end);
			if (userinfo_end >= 0 && userinfo_end < authority_end) {
				userinfo = uri[i:userinfo_end];
				i = userinfo_end + 1;
			}

			// TODO IPv6 support
			int host_end = uri.index_of (':', i, authority_end);
			if (host_end < 0) {
				// no port
				host_end = authority_end;
			}
			host = uri[i:host_end];
			i = host_end;
			if (i < authority_end) {
				// port
				i++;
				// TODO port parsing
			} else {
				port = -1;
			}
			i = authority_end;
		}

		int fragment_start = uri.index_of ('#', i);
		if (fragment_start >= 0) {
			// fragment
			fragment = uri[fragment_start + 1:uri.length];
		} else {
			fragment_start = uri.length;
		}

		int query_start = uri.index_of ('?', i);
		if (query_start >= 0) {
			// query
			query = uri[query_start + 1:fragment_start];
		} else {
			query_start = uri.length;
		}

		path = uri[i:query_start];
	}

	static string encode_string (string str, string reserved) {
		string hex = "0123456789ABCDEF";
		string always_reserved = "\"%<>\\^`{|}";

		// TODO implement percent encoding
		result = str;
	}

	public string to_string () {
		string uri_string = "";
		if (scheme != null) {
			uri_string += scheme + ":";
		}
		if (userinfo != null || host != null || port != -1) {
			uri_string += "//";
			if (userinfo != null) {
				uri_string += encode_string (userinfo, "/?#[]@") + "@";
			}
			if (host != null) {
				uri_string += encode_string (host, ":/?#[]@");
			}
			if (port != -1) {
				uri_string += ":" + port.to_string ();
			}
		}
		uri_string += encode_string (path, "?#[]");
		if (query != null) {
			uri_string += "?" + encode_string (query, "#[]");
		}
		if (fragment != null) {
			uri_string += "#" + encode_string (fragment, "#[]");
		}
		return uri_string;
	}

	public Uri resolve (string uri_reference) {
		// TODO
		result = null;
	}
}

