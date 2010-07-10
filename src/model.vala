/* model.vala
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

public abstract class Dova.IntegerModel {
	public abstract int get ();
	public abstract void set (int value);
	// public signal void changed ();
}

public abstract class Dova.StringModel {
	public abstract string get ();
	public abstract void set (string value);
	// public signal void changed ();
}

/*public abstract class Dova.DateModel {
	public abstract Date get ();
	public abstract void set (Date value);
	// public signal void changed ();
}

public abstract class Dova.TimeModel {
	public abstract Time get ();
	public abstract void set (Time value);
	// public signal void changed ();
}

public abstract class Dova.DateTimeModel {
	public abstract DateTime get ();
	public abstract void set (DateTime value);
	// public signal void changed ();
}*/

public class Dova.IntegerReference : IntegerModel {
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

public class Dova.StringReference : StringModel {
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

public abstract class Dova.CollectionModel<T> /*: Iterable<T>*/ {
	protected CollectionModel () {
	}

	public abstract Iterator<T> iterator ();

	public abstract bool add (T element);
	public abstract void clear ();
	public abstract bool contains (T element);
	public abstract bool remove (T element);
	public abstract int size { get; }
}

public abstract class Dova.ListModel<T> : CollectionModel<T> {
	protected ListModel () {
		base ();
	}
	public abstract T get (int index);
	public abstract void set (int index, T element);
}

public abstract class Dova.MapModel<K,V> {
	public abstract V get (K key);
	public abstract void set (K key, V value);
	// public signal void changed ();
}

public abstract class Dova.DequeModel<T> {
	public abstract void push_head (T element);
	public abstract void push_tail (T element);
	public abstract T pop_head ();
	public abstract T pop_tail ();
}
