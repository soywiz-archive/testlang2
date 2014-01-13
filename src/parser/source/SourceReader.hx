package parser.source;

import parser.StringReader;
class SourceReader
{
	private var source:Source;
	private var stringReader:StringReader;
	public var offset(get, never):Int;
	public var hasMore(get, never):Bool;

	public function new(source:Source)
	{
		this.source = source;
		this.stringReader = new StringReader(source.string);
	}

	public function peek(count:Int):SourceRange
	{
		var start:Int = this.stringReader.offset;
		var result = this.stringReader.peek(count);
		return new SourceRange(this.source, start, start + result.length);
	}

	public function skip(count:Int):Void
	{
		this.stringReader.skip(count);
	}

	public function peekRegexp(regexpString:String):SourceRange
	{
		return this.peek(this.stringReader.peekRegexp(regexpString).length);
	}

	public function read(count:Int):SourceRange
	{
		var result = this.peek(count);
		this.skip(result.length);
		return result;
	}

	public function readRegexp(regexp:String):SourceRange
	{
		var result = this.peekRegexp(regexp);
        this.skip(result.length);
		return result;
	}

	private function get_offset():Int
	{
		return this.stringReader.offset;
	}

	private function get_hasMore():Bool
	{
		return this.stringReader.hasMore;
	}
}
