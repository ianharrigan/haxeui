package haxe.ui.toolkit;

class TestClass {
	public function new() {
		
	}
	
	public function doTest() {
		trace("Started");
		
		var arr:Array < String->Void > = new Array < String->Void > ();
		arr.push(func1);
		arr.push(func2);
		arr.push(func3);
		trace("1. " + arr);
		
		trace("Index of func1 = " + Lambda.indexOf(arr, func1));
		trace("Index of func2 = " + arr.indexOf(func2));
		trace("Index of func3 = " + Lambda.indexOf(arr, func3));
		
		trace("Remove successful: " + removeFunction(arr, func2));
		
		trace("2. " + arr);
		
		/*
		trace(func1 == func1);
		trace(Reflect.compareMethods(func1, func1));
		var t = [1, 2, 3, 4, 5];
		var indexToRemove:Int = 2;
		trace(t.splice(0, indexToRemove).concat(t.splice(indexToRemove + 1, t.length)));
		trace(t.splice(indexToRemove-1, t.length));
		*/
		
		for (f in arr) {
			f("bob");
		}
	}
	
	public function func1(s:String):Void {
		trace(1);
	}
	
	public function func2(s:String):Void {
		trace(2);
	}
	
	public function func3(s:String):Void {
		trace(3);
	}
	
	private function removeFunction(arr:Array< String->Void> ,fn:String->Void):Bool {
		var indexToRemove:Int = -1;
		for (n in 0...arr.length) {
			if (Reflect.compareMethods(arr[n], fn) == true) {
				indexToRemove = n;
				break;
			}
		}
		
		trace("index to remove = " + indexToRemove);
		if (indexToRemove == -1) {
			return false;
		}
		
		arr.splice(indexToRemove, 1);
		return true;
	}
}