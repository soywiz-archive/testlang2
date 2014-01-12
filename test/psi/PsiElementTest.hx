package psi;

import haxe.Log;
import psi.PsiElement;
import haxe.unit.TestCase;

class PsiElementTest extends TestCase
{
	public function testRootRoot()
	{
		var root = new PsiElement();
		assertEquals(root, root.root);
	}

	public function testBasic()
	{
		var root = new PsiElement();
		var element1 = root.appendNewChild('helo');
		var element2 = root.appendNewChild('world');
		var element3 = root.appendNewChild('a');
		assertEquals(4 + 5, element3.offset);
		assertEquals(1, element3.length);

		for (child in root.children)
		{
			Log.trace(child);
		}
	}
}