/* iterable.vala
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

public delegate bool FilterFunc<T> (T element);
public delegate R MapFunc<T,R> (T element);

public abstract class Dova.Iterable<T> {
	public abstract Iterator<T> iterator ();

	public virtual Iterable<T> filter (FilterFunc<T> func) {
		return new FilterIterable<T> (this, func);
	}

	public virtual Iterable<R> map<R> (MapFunc<T,R> func) {
		return new MapIterable<T,R> (this, func);
	}

	public virtual Iterable<T> take (int n) {
		return new TakeIterable<T> (this, n);
	}

	public virtual Iterable<T> drop (int n) {
		return new DropIterable<T> (this, n);
	}
}

class Dova.FilterIterable<T> : Iterable<T> {
	Iterable<T> base_iterable;
	FilterFunc<T> func;

	public FilterIterable (Iterable<T> base_iterable, FilterFunc<T> func) {
		this.base_iterable = base_iterable;
		this.func = func;
	}

	public override Iterator<T> iterator () {
		return new FilterIterator<T> (base_iterable.iterator (), func);
	}
}

class Dova.FilterIterator<T> : Iterator<T> {
	Iterator<T> base_iterator;
	FilterFunc<T> func;

	public FilterIterator (Iterator<T> base_iterator, FilterFunc<T> func) {
		this.base_iterator = base_iterator;
		this.func = func;
	}

	public override bool next () {
		while (base_iterator.next ()) {
			if (func (base_iterator.get ())) {
				return true;
			}
		}
		return false;
	}

	public override T get () {
		return base_iterator.get ();
	}
}

class Dova.MapIterable<T,R> : Iterable<R> {
	Iterable<T> base_iterable;
	MapFunc<T,R> func;

	public MapIterable (Iterable<T> base_iterable, MapFunc<T,R> func) {
		this.base_iterable = base_iterable;
		this.func = func;
	}

	public override Iterator<R> iterator () {
		return new MapIterator<T,R> (base_iterable.iterator (), func);
	}
}

class Dova.MapIterator<T,R> : Iterator<R> {
	Iterator<T> base_iterator;
	MapFunc<T,R> func;

	public MapIterator (Iterator<T> base_iterator, MapFunc<T,R> func) {
		this.base_iterator = base_iterator;
		this.func = func;
	}

	public override bool next () {
		return base_iterator.next ();
	}

	public override R get () {
		return func (base_iterator.get ());
	}
}

class Dova.TakeIterable<T> : Iterable<T> {
	Iterable<T> base_iterable;
	int n;

	public TakeIterable (Iterable<T> base_iterable, int n) {
		this.base_iterable = base_iterable;
		this.n = n;
	}

	public override Iterator<T> iterator () {
		return new TakeIterator<T> (base_iterable.iterator (), n);
	}
}

class Dova.TakeIterator<T> : Iterator<T> {
	Iterator<T> base_iterator;
	int n;

	public TakeIterator (Iterator<T> base_iterator, int n) {
		this.base_iterator = base_iterator;
		this.n = n;
	}

	public override bool next () {
		if (n <= 0) {
			return false;
		}

		n--;
		return base_iterator.next ();
	}

	public override T get () {
		return base_iterator.get ();
	}
}

class Dova.DropIterable<T> : Iterable<T> {
	Iterable<T> base_iterable;
	int n;

	public DropIterable (Iterable<T> base_iterable, int n) {
		this.base_iterable = base_iterable;
		this.n = n;
	}

	public override Iterator<T> iterator () {
		return new DropIterator<T> (base_iterable.iterator (), n);
	}
}

class Dova.DropIterator<T> : Iterator<T> {
	Iterator<T> base_iterator;
	int n;

	public DropIterator (Iterator<T> base_iterator, int n) {
		this.base_iterator = base_iterator;
		this.n = n;
	}

	public override bool next () {
		while (n > 0) {
			n--;
			if (!base_iterator.next ()) {
				return false;
			}
		}

		return base_iterator.next ();
	}

	public override T get () {
		return base_iterator.get ();
	}
}
