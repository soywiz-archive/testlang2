package parser.source;

class SourceRange
{
	public var source(default, null):Source;
	public var low(default, null):Int;
	public var high(default, null):Int;
	public var length(get, null):Int;
	public var string(get, null):String;

	public function new(source:Source, low:Int, high:Int)
	{
		this.source = source;
		this.low = low;
		this.high = high;
	}

    static public function combine(sourceRangeList:Array<SourceRange>):SourceRange
    {
        return Lambda.fold(sourceRangeList, function(a:SourceRange, b:SourceRange):SourceRange
        {
            if (a == null) return b;
            if (b == null) return a;
            return new SourceRange(a.source, MathInt.min(a.low, b.low), MathInt.max(a.high, b.high));
        }, sourceRangeList[0]);
    }

	private function get_string():String
	{
		return this.source.string.substr(this.low, this.high - this.low);
	}

	private function get_length():Int
	{
		return this.high - this.low;
	}

	public function toString()
	{
		return 'SourceRange($low:$high)($string)';
	}
}
