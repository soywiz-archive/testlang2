package parser.lalr;
import parser.source.SourceReader;
import parser.source.SourceRange;
import haxe.Log;

using Lambda;

typedef TagType = String;

class Lalr
{
	static public function main()
	{
		Log.trace('hello!');
	}

    static public function literal(value:String):Node
    {
        return new TerminalNode(value);
    }

    static public function regexp(regexp:String, tag:TagType):Node
    {
        return new TerminalRegexpNode(regexp, tag);
    }

    static public function sequence(nodes:Array<Node>, ?tag:TagType):Node
    {
        return new SequenceNode(nodes, tag);
    }

    static public function or(nodes:Array<Node>):Node
    {
        return new OrNode(nodes);
    }

    static public function optional(node:Node, ?tag:TagType):Node
    {
        return new OptionalNode(node);
    }

    static public function repeatOneOrMore(node:Node, ?tag:TagType):Node
    {
        return new RepeatOneOrMoreNode(node, tag);
    }
}

class OptionalNode extends Node
{
    private var node:Node;

    public function new(node:Node)
    {
        this.node = node;
    }

    override public function canParse(sourceReader:SourceReader):Bool
    {
        return true;
    }

    override public function parse(sourceReader:SourceReader):LalrResultNode
    {
        if (!node.canParse(sourceReader)) return LalrResultNode.fromEmpty(sourceReader);
        return node.parse(sourceReader);
    }
}

class RepeatOneOrMoreNode extends Node
{
    private var node:Node;
    private var tag:TagType;

    public function new(node:Node, tag:TagType)
    {
        this.node = node;
        this.tag = tag;
    }

    override public function canParse(sourceReader:SourceReader):Bool
    {
        return node.canParse(sourceReader);
    }

    override public function parse(sourceReader:SourceReader):LalrResultNode
    {
        var resultList:Array<LalrResultNode> = [];
        while (node.canParse(sourceReader))
        {
            resultList.push(node.parse(sourceReader));
        }
        return LalrResultNode.fromChildList(resultList, tag);
    }

}

class LalrResultNode
{
    public var sourceRange(default, null):SourceRange;
    public var tag(default, null):TagType;
    public var empty(default, null):Bool;
    public var children:Array<LalrResultNode>;

    public var isLeaf(get, never):Bool;

    private function get_isLeaf():Bool
    {
        return children == null;
    }

    private function new() { }

    static public function fromSourceRangeAndTag(sourceRange:SourceRange, ?tag:TagType):LalrResultNode
    {
        var resultNode = new LalrResultNode();
        resultNode.sourceRange = sourceRange;
        resultNode.tag = tag;
        return resultNode;
    }

    static public function fromChildList(children:Array<LalrResultNode>, ?tag:TagType):LalrResultNode
    {
        var resultNode = new LalrResultNode();
        resultNode.sourceRange = SourceRange.combine(children.map(function(child:LalrResultNode) { return child.sourceRange; }));
        resultNode.children = children;
        resultNode.tag = tag;
        return resultNode;
    }

    static public function fromEmpty(sourceReader:SourceReader):LalrResultNode
    {
        var resultNode = fromSourceRangeAndTag(sourceReader.peek(0));
        resultNode.empty = true;
        return resultNode;
    }

    public function toString()
    {
        if (isLeaf) return '[$tag:${sourceRange.string}]';
        var result = '';
        if (tag != null) result += '$tag:';
        result += '{' + children.join(',') + '}';
        return result;
    }
}

class Node
{
	//private var nextNodes:Array<Node>;

    public inline function tryParse(sourceReader:SourceReader):LalrResultNode
    {
        return canParse(sourceReader) ? parse(sourceReader) : null;
    }

    public function canParse(sourceReader:SourceReader):Bool
    {
        throw('Must override');
        return null;
    }

	public function parse(sourceReader:SourceReader):LalrResultNode
	{
        throw('Must override');
        return null;
	}
}

class ContainerNode extends Node
{
    private var nodes:Array<Node>;
    private var tag:TagType;

    public function new(nodes:Array<Node> = null, ?tag:TagType)
    {
        if (nodes == null) nodes = [];
        this.nodes = nodes;
        this.tag = tag;
    }

    public function push(node:Node)
    {
        this.nodes.push(node);
    }
}

class OrNode extends ContainerNode
{
    public function new(nodes:Array<Node> = null, ?tag:TagType)
    {
        super(optimize(nodes), tag);
    }

    private function optimize(nodes:Array<Node>):Array<Node>
    {
        return nodes;
    }

    override public function canParse(sourceReader:SourceReader):Bool
    {
        if (nodes.length < 1) throw('Invalid OrNode without elements');
        for (node in nodes) if (node.canParse(sourceReader)) return true;
        return false;
    }

    override public function parse(sourceReader:SourceReader):LalrResultNode
    {
        for (node in nodes)
        {
            if (node.canParse(sourceReader))
            {
                return node.parse(sourceReader);
            }
        }
        throw('Cant parse any of');
    }
}

class SequenceNode extends ContainerNode
{
    override public function canParse(sourceReader:SourceReader):Bool
    {
        if (nodes.length < 1) throw('Invalid SequenceNode without elements');
        return nodes[0].canParse(sourceReader);
    }

    override public function parse(sourceReader:SourceReader):LalrResultNode
    {
        return LalrResultNode.fromChildList(nodes.map(function(node:Node):LalrResultNode { return node.parse(sourceReader); }), tag);
    }
}

class TerminalRegexpNode extends Node
{
    private var regexp:String;
    private var tag:TagType;

    public function new(regexp:String, tag:TagType = null)
    {
        if (tag == null) tag = 'terminal';
        this.regexp = regexp;
        this.tag = tag;
    }

    override public function canParse(sourceReader:SourceReader):Bool
    {
        return sourceReader.peekRegexp(this.regexp).length > 0;
    }

    override public function parse(sourceReader:SourceReader):LalrResultNode
    {
        var sourceRange = sourceReader.readRegexp(this.regexp);
        if (sourceRange.length == 0) throw('Cant parse regexp');
        return LalrResultNode.fromSourceRangeAndTag(sourceRange, tag);
    }
}

class TerminalNode extends Node
{
	private var literalString:String;
    private var tag:TagType;

	public function new(literalString:String, tag:TagType = null)
	{
        if (tag == null) tag = 'terminal';
		this.literalString = literalString;
        this.tag = tag;
	}

    override public function canParse(sourceReader:SourceReader):Bool
    {
        return sourceReader.peek(this.literalString.length).string == this.literalString;
    }

	override public function parse(sourceReader:SourceReader):LalrResultNode
	{
		var sourceRange = sourceReader.read(this.literalString.length);
		if (sourceRange.string != this.literalString) throw('Cant parse terminal');
        return LalrResultNode.fromSourceRangeAndTag(sourceRange, tag);
	}
}
