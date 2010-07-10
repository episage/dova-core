/* node.vala
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

public abstract class Dova.Node {
	public Node? parent { get { return _parent; } }

	public Node? next { get { return _next; } }

	public Node? previous { get { return _previous; } }

	public Node? first_child { get { return _first_child; } }

	public Node? last_child { get { return _last_child; } }

	Node* _parent;
	Node _next;
	Node* _previous;
	Node _first_child;
	Node* _last_child;

	public void append (Node child) {
		assert ((bool) (child.parent == null));

		child._parent = this;

		if (_first_child == null) {
			// only child
			_first_child = child;
		} else {
			_last_child._next = child;
			child._previous = _last_child;
		}

		_last_child = child;
	}

	public void prepend (Node child) {
		assert ((bool) (child.parent == null));

		child._parent = this;

		if (_first_child == null) {
			// only child
			_last_child = child;
		} else {
			child._next = _first_child;
			_first_child._previous = child;
		}

		_first_child = child;
	}

	public void insert_before (Node ref_child, Node child) {
		assert ((bool) (child.parent == null));
		assert ((bool) (ref_child.parent == this));

		child._parent = this;
		child._next = ref_child;

		if (ref_child == _first_child) {
			// ref_child is first child
			ref_child._previous = child;
			_first_child = child;
		} else {
			child._previous = ref_child._previous;
			child._previous._next = child;
			ref_child._previous = child;
		}
	}

	public void insert_after (Node ref_child, Node child) {
		assert ((bool) (child.parent == null));
		assert ((bool) (ref_child.parent == this));

		child._parent = this;

		if (ref_child == _last_child) {
			// ref_child is last child
			ref_child._next = child;
			child._previous = ref_child;
			_last_child = child;
		} else {
			child._next = ref_child._next;
			child._previous = ref_child;
			child._next._previous = child;
			ref_child._next = child;
		}
	}

	public void replace (Node old_child, Node new_child) {
		assert ((bool) (old_child.parent == this));
		assert ((bool) (new_child.parent == null));

		new_child._parent = this;

		if (old_child._next != null) {
			old_child._next._previous = new_child;
			new_child._next = old_child._next;
		}

		if (old_child._previous != null) {
			old_child._previous._next = new_child;
			new_child._previous = old_child._previous;
		}

		if (old_child == _first_child) {
			_first_child = new_child;
		}

		if (old_child == _last_child) {
			_last_child = new_child;
		}

		old_child._parent = null;
		old_child._next = null;
		old_child._previous = null;
	}
}
