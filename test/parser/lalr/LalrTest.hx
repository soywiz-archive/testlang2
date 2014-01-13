package parser.lalr;

import parser.source.Source;
import parser.source.SourceReader;
import haxe.unit.TestCase;

class LalrTest extends TestCase
{
    public function test1()
    {
        var sourceReader = new SourceReader(new Source("hello world"));

        var helloLiteralNode = Lalr.literal('hello');
        var worldLiteralNode = Lalr.literal('world');
        var spacesNode = Lalr.regexp('\\s+', '-');

        assertEquals("Token(literal:SourceRange(0:5)(hello))", Std.string(helloLiteralNode.tryParse(sourceReader)));
        assertEquals("null", Std.string(helloLiteralNode.tryParse(sourceReader)));
        assertEquals("Token(-:SourceRange(5:6)( ))", Std.string(spacesNode.tryParse(sourceReader)));
        assertEquals("Token(literal:SourceRange(6:11)(world))", Std.string(worldLiteralNode.tryParse(sourceReader)));
    }
}