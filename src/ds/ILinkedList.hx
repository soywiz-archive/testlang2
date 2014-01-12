package ds;

interface ILinkedList<T> //implements Iterable<T>
{
	var head(get, never):ILinkedListElement<T>;
	var tail(get, never):ILinkedListElement<T>;

	function isEmpty():Bool;
	function insertAfter(prev:ILinkedListElement<T>, value:T):ILinkedListElement<T>;
	function insertBefore(next:ILinkedListElement<T>, value:T):ILinkedListElement<T>;
	function remove(element:ILinkedListElement<T>):Void;
	function addFirst(value:T):ILinkedListElement<T>;
	function addLast(value:T):ILinkedListElement<T>;
}
