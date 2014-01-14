class ArrayUtils
{
    static public function coalesce<A>(input:Array<A>):Array<A>
    {
        var output = new Array<A>();
        for (item in input) if (item != null) output.push(item);
        return output;
    }
}