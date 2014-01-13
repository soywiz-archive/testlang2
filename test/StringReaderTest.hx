import parser.StringReader;
import haxe.Log;
import haxe.unit.TestCase;

class StringReaderTest extends TestCase
{
	public function testBasic()
	{
		var stringReader = new StringReader(" Hello world!");
		assertEquals('', stringReader.readRegexp("\\w+"));
		assertEquals('', stringReader.readRegexp("\\w+"));
		assertEquals(' ', stringReader.readRegexp("\\s+"));
		assertEquals('Hello', stringReader.readRegexp("\\w+"));
		assertEquals('', stringReader.readRegexp("\\w+"));
		assertEquals(' ', stringReader.readRegexp("\\s+"));
		assertEquals('world', stringReader.readRegexp("\\w+"));
		assertEquals('', stringReader.readRegexp("\\w+"));
	}
}