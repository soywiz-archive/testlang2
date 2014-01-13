package parser.source;

import haxe.Log;
import haxe.unit.TestCase;
class SourceReaderTest extends TestCase
{
    public function test1()
    {
        var sourceReader = new SourceReader(new Source('hello world!'));
        assertEquals('SourceRange(0:5)(hello)', Std.string(sourceReader.readRegexp('\\w+')));
        assertEquals('SourceRange(5:5)()', Std.string(sourceReader.readRegexp('\\w+')));

        //assertEquals('test', result.toString());
    }
}