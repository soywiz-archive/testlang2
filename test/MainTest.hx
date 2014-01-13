import parser.lalr.LalrTest;
import parser.source.SourceReaderTest;
import psi.PsiElementTest;
import ds.LinkedListTest;
class MainTest
{
	static function main()
	{
		var r = new haxe.unit.TestRunner();
		r.add(new StringReaderTest());
		r.add(new LinkedListTest());
		r.add(new PsiElementTest());
        r.add(new SourceReaderTest());
        r.add(new LalrTest());
		r.run();
	}
}