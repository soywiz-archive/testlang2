package ds;

interface ILinkedListElement<T>
{
	var prev(get, never):ILinkedListElement<T>;
	var next(get, never):ILinkedListElement<T>;

	var value(default, null):T;
}
