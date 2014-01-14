package parser.lalr;

import parser.source.Source;
import parser.source.SourceReader;
import haxe.unit.TestCase;

class LalrTest extends TestCase
{
    public function test1()
    {
        var source = new Source("hello world");
        var sourceReader = new SourceReader(source);

        var helloLiteralNode = Lalr.literal('hello');
        var worldLiteralNode = Lalr.literal('world');
        var spacesNode = Lalr.regexp('\\s+', '-');
        var helloWorldNode = Lalr.sequence([helloLiteralNode, spacesNode, worldLiteralNode]);

        assertEquals("[terminal:hello]", Std.string(helloLiteralNode.parse(sourceReader)));
        assertEquals("null", Std.string(helloLiteralNode.tryParse(sourceReader)));
        assertEquals("[-: ]", Std.string(spacesNode.tryParse(sourceReader)));
        assertEquals("[terminal:world]", Std.string(worldLiteralNode.tryParse(sourceReader)));

        assertEquals('{[terminal:hello],[-: ],[terminal:world]}', Std.string(helloWorldNode.parse(new SourceReader(source))));
    }

    public function testOr()
    {
        var source = new Source("world");
        var sourceReader = new SourceReader(source);

        var helloLiteralNode = Lalr.literal('hello');
        var worldLiteralNode = Lalr.literal('world');
        var helloOrWorldNode = Lalr.or([helloLiteralNode, worldLiteralNode]);

        assertEquals("[terminal:world]", Std.string(helloOrWorldNode.tryParse(new SourceReader(new Source('world')))));
        assertEquals("[terminal:hello]", Std.string(helloOrWorldNode.tryParse(new SourceReader(new Source('hello')))));
        assertEquals("null", Std.string(helloOrWorldNode.tryParse(new SourceReader(new Source('bad')))));
    }

    public function testSimpleList()
    {
        var helloLiteralNode = Lalr.literal('hello ');
        var helloListNode = Lalr.repeatOneOrMore(helloLiteralNode, 'hello_list');

        assertEquals("hello_list:{[terminal:hello ],[terminal:hello ],[terminal:hello ]}", Std.string(helloListNode.tryParse(SourceReader.fromString('hello hello hello '))));
    }

    public function testOrList()
    {
        var oneNode = Lalr.literal('1');
        var twoNode = Lalr.literal('2');
        var oneOrTwoNode = Lalr.or([oneNode, twoNode]);
        var oneOrTwoListNode = Lalr.repeatOneOrMore(oneOrTwoNode, 'list');

        assertEquals("list:{[terminal:1],[terminal:2],[terminal:1],[terminal:1],[terminal:1],[terminal:1],[terminal:2],[terminal:2]}", Std.string(oneOrTwoListNode.tryParse(SourceReader.fromString('121111223'))));
    }
}