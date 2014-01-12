import psi.PsiElementTest;
import ds.LinkedListTest;
class MainTest
{
	static function main()
	{
		var r = new haxe.unit.TestRunner();
		//r.add(new StringReaderTest());
		//r.add(new LinkedListTest());
		r.add(new PsiElementTest());
		r.run();
	}
}