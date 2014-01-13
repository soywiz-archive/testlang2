package psi;

import ds.LinkedList;
import ds.ILinkedListElement;
import ds.ILinkedList;

class PsiElement
{
	public var parent(default, null):PsiElement;
	public var children(default, null):ILinkedList<PsiElement>;
	public var node(default, null):ILinkedListElement<PsiElement>;
	public var root(get, never):PsiElement;
	public var value(default, null):String;
	private var _length:Int = 0;
	public var length(get, set):Int;
	public var offset(get, never):Int;

	public var low(get, never):Int;
	public var high(get, never):Int;

	public function new()
	{
		this.parent = null;
		this.children = new LinkedList<PsiElement>();
		this.node = null;
	}

	public function appendNewChild(value:String):PsiElement
	{
		var element = new PsiElement();
		element.value = value;
		element.parent = this;
		element.node = element.parent.children.addLast(element);
		element.length = value.length;
		return element;
	}

	private function set_length(value:Int):Int
	{
		if (parent != null) parent._length -= this._length;
		this._length = value;
		if (parent != null) parent._length += this._length;
		return this.length;
	}

	private function get_length():Int
	{ return _length; }

	private function get_low():Int
	{ return offset; }

	private function get_high():Int
	{ return offset + length; }

	private function get_offset():Int
	{
		var count = 0;

		var node:ILinkedListElement<PsiElement> = this.node;
		while ((node != null) && (node.prev != null))
		{
			count += node.prev.value.length;
			node = node.prev;
		}
		if (parent != null) count += parent.offset;

		return count;
	}

	public function get_root():PsiElement
	{
		var root = this;
		while (root.parent != null) root = root.parent;
		return root;
	}

	public function getElementAt(position:Int):PsiElement
	{
		var element = this.root;
		while (element.parent != null) element = element.parent;
		return element;
	}
}
