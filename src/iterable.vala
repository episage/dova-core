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

public abstract class Dova.Iterable<T> {
	public abstract Iterator<T> iterator ();

	public virtual Iterable<T> filter (FilterFunc<T> func) {
		return new FilterIterable<T> (this, func);
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
