package ;

class StringReader
{
	private var data:String;
	public var offset(default, null):Int;
	public var length(get, never):Int;
	public var hasMore(get, never):Bool;

	public function new(data:String)
	{
		this.data = data;
		this.offset = 0;
	}

	public function peek(count:Int):String
	{
		return this.data.substr(this.offset, count);
	}

	public function skip(count:Int):Void
	{
		this.offset += count;
		if (this.offset >= this.length) this.offset = this.length;
	}

	public function peekRegexp(regexpString:String):String
	{
		var regexp = new EReg('^' + regexpString, '');
		if (!regexp.match(this.data.substr(this.offset))) return '';
		return regexp.matched(0);
	}

	public function read(count:Int):String
	{
		var out = this.peek(count);
		this.skip(count);
		return out;
	}

	public function readRegexp(regexp:String):String
	{
		var out = this.peekRegexp(regexp);
		this.skip(out.length);
		return out;
	}

	private function get_hasMore():Bool
	{
		return this.offset < this.length;
	}

	private function get_length():Int
	{
		return this.data.length;
	}
}
