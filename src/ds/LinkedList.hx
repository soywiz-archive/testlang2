package ds;

class LinkedList<T> implements ILinkedList<T>
{
	public var head(get, never):ILinkedListElement<T> = null;
	public var tail(get, never):ILinkedListElement<T> = null;

	private var _head:Element<T> = null;
	private var _tail:Element<T> = null;

	public function new()
	{

	}

	public function isEmpty():Bool
	{
		return _head == null;
	}

	public function insertAfter(_prev:ILinkedListElement<T>, value:T):ILinkedListElement<T>
	{
		var prev:Element<T> = cast _prev;

		var next = new Element<T>(value);

		if (prev._next != null)
		{
			prev._next._prev = next;
			next._next = prev._next;
		}

		next._prev = prev;
		prev._next = next;

		return next;
	}

	public function insertBefore(_next:ILinkedListElement<T>, value:T):ILinkedListElement<T>
	{
		var next:Element<T> = cast _next;

		var prev = new Element<T>(value);

		if (next._prev != null)
		{
			next._prev._next = prev;
			prev._prev = next._prev;
		}

		prev._next = next;
		next._prev = prev;

		return prev;
	}

	public function remove(_element:ILinkedListElement<T>)
	{
		var element:Element<T> = cast _element;
		if (element._prev != null) element._prev._next = element._next;
		if (element._next != null) element._next._prev = element._prev;
	}

	public function addFirst(value:T):ILinkedListElement<T>
	{
		if (isEmpty()) return this._head = this._tail = new Element<T>(value);
		return this._head = cast insertBefore(this._head, value);
	}

	public function addLast(value:T):ILinkedListElement<T>
	{
		if (isEmpty()) return this._head = this._tail = new Element<T>(value);
		return this._tail = cast insertAfter(this._tail, value);
	}

	private function get_head():ILinkedListElement<T> { return _head; }
	private function get_tail():ILinkedListElement<T> { return _tail; }

	public function iterator() : Iterator<T>
	{
		return new ElementIterator<T>(head);
	}
}

private class ElementIterator<T>
{
	private var element:Element<T>;

	public function new(element:Element<T>)
	{
		this.element = element;
	}

	public function hasNext() : Bool
	{
		return this.element != null;
	}

	public function next():T
	{
		var result = this.element.value;
		this.element = element.next;
		return result;
	}
}

private class Element<T> implements ILinkedListElement<T>
{
	public var value(default, null):T;
	public var prev(get, never):ILinkedListElement<T>;
	public var next(get, never):ILinkedListElement<T>;

	public var _prev:Element<T>;
	public var _next:Element<T>;

	public function new(value:T)
	{
		this.value = value;
	}

	private function get_prev():ILinkedListElement<T> { return _prev; }
	private function get_next():ILinkedListElement<T> { return _next; }

	public function toString()
	{
		return 'LinkedListElement($value)';
	}
}
