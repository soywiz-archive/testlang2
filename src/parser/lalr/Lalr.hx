package parser.lalr;
import parser.source.SourceReader;
import parser.source.SourceRange;
import haxe.Log;

typedef TagType = String;

class Lalr
{
	static public function main()
	{
		Log.trace('hello!');
	}

    static public function literal(value:String):Node
    {
        return new LiteralNode(value);
    }

    static public function regexp(regexp:String, tag:TagType):Node
    {
        return new RegexpNode(regexp, tag);
    }
}

class Token
{
    public var sourceRange(default, null):SourceRange;
    public var tag(default, null):TagType;

    public function new(sourceRange:SourceRange, tag:TagType)
    {
        this.sourceRange = sourceRange;
        this.tag = tag;
    }

    public function toString():String
    {
        return 'Token($tag:$sourceRange)';
    }
}

class Node
{
	private var nextNodes:Array<Node>;

	public function tryParse(sourceReader:SourceReader):Token
	{
        return null;
	}
}

class RegexpNode extends Node
{
    private var regexp:String;
    private var tag:TagType;

    public function new(regexp:String, tag:TagType)
    {
        this.regexp = regexp;
        this.tag = tag;
    }

    override public function tryParse(sourceReader:SourceReader):Token
    {
        var result = sourceReader.peekRegexp(this.regexp);
        if (result == null) return null;
        sourceReader.skip(result.length);
        return new Token(result, tag);
    }
}

class LiteralNode extends Node
{
	private var literalString:String;

	public function new(literalString:String)
	{
		this.literalString = literalString;
	}

	override public function tryParse(sourceReader:SourceReader):Token
	{
		var result = sourceReader.peek(this.literalString.length);
		if (result.string != this.literalString) return null;
        sourceReader.skip(result.length);
		return new Token(result, "literal");
	}
}

class SequenceNode extends Node
{

}