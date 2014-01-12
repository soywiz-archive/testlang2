package ;
import source.SourceRange;
import haxe.Log;

class Lalr
{
	static public function main()
	{
		Log.trace('hello!');
	}
}

class Token
{
	public var sourceRange(default, null):SourceRange;

	public function new(sourceRange:SourceRange)
	{
		this.sourceRange = sourceRange;
	}
}

class Node
{
	private var nextNodes:Array<Node>;

	public function tryParse(stringReader:StringReader):Token
	{

	}
}

class Literal extends Node
{
	private var literalString:String;

	public function new(literalString:String)
	{
		this.literalString = literalString;
	}

	override public function tryParse(stringReader:StringReader):Token
	{
		var result = stringReader.peek(this.literalString.length)
		if (result != this.literalString) return null;
		stringReader.skip(result);
		return new Token();
	}
}

class Sequence
{

}