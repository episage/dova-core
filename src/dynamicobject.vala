/* dynamicobject.vala
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

public interface Dova.DynamicObject {
	// TODO implementations should be able to indicate what exactly changed
	// for example, what items have been inserted where in a list
	// or what property has changed in an object
	// these more specific pieces of information should be optional in general
	// but will be essential in some situations for performance reasons (large list in UI)
	// public signal void changed ();

	// this can be used for widgets to enable or disable modify operations (i.e. affects sensitivity of widget)
	// public abstract bool mutable { get; }
}

public abstract class Dova.DynamicInteger : DynamicObject {
	public abstract int get ();
	public abstract void set (int value);
	// public signal void changed ();
}

public abstract class Dova.DynamicString : DynamicObject {
	public abstract string get ();
	public abstract void set (string value);
	// public signal void changed ();
}

public abstract class Dova.DynamicDate : DynamicObject {
	public abstract Date get ();
	public abstract void set (Date value);
	// public signal void changed ();
}

public abstract class Dova.DynamicTime : DynamicObject {
	public abstract Time get ();
	public abstract void set (Time value);
	// public signal void changed ();
}

public abstract class Dova.DynamicDateTime : DynamicObject {
	public abstract DynamicDateTime get ();
	public abstract void set (DateTime value);
	// public signal void changed ();
}

public class Dova.IntegerReference : DynamicInteger {
	int value;

	public IntegerReference (int value) {
		this.value = value;
	}

	public override int get () {
		return value;
	}

	public override void set (int value) {
		this.value = value;
		// changed ();
	}
}

public class Dova.StringReference : DynamicString {
	string value;

	public StringReference (string value) {
		this.value = value;
	}

	public override string get () {
		return value;
	}

	public override void set (string value) {
		this.value = value;
		// changed ();
	}
}

