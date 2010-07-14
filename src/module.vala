/* module.vala
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

public class Dova.Module {
	void* native;

	Module (void* native) {
		this.native = native;
	}

	~Module () {
		OS.dlclose (native);
	}

	public static Module? open (File file /*, ModuleFlags flags */) /* throws ModuleError */ {
		void* native = OS.dlopen (file.path.data, 0);
		if (native == null) {
			return null;
		}

		result = new Module (native);
	}

	public void* symbol (string symbol) /* throws ModuleError */ {
		OS.dlerror ();
		result = OS.dlsym (native, symbol.data);
		byte* errstr = OS.dlerror ();
		if (errstr == null) {
			// throw error
			return null;
		}
	}
}

