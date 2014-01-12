package ds;

import ds.LinkedList;
import haxe.unit.TestCase;

class LinkedListTest extends TestCase
{
	public function testBasic()
	{
		var list = new LinkedList<Int>();
		assertEquals(list.head, null);
		assertEquals(list.tail, null);

		var item10 = list.addLast(10);
		assertEquals(list.head, item10);
		assertEquals(list.tail, item10);

		var item20 = list.addLast(20);
		assertEquals(list.head, item10);
		assertEquals(list.tail, item20);

		var item30 = list.addLast(30);
		assertEquals(list.head, item10);
		assertEquals(list.tail, item30);

		var item25 = list.insertAfter(item20, 25);

		//var item15 = list.insertAfter(item10, 15);
		var item15 = list.insertBefore(item20, 15);

		// CHECK

		assertEquals(item10.prev, null);
		assertEquals(item10.next, item15);

		assertEquals(item15.prev, item10);
		assertEquals(item15.next, item20);

		assertEquals(item20.prev, item15);
		assertEquals(item20.next, item25);

		assertEquals(item25.prev, item20);
		assertEquals(item25.next, item30);

		assertEquals(item30.prev, item25);
		assertEquals(item30.next, null);
	}
}