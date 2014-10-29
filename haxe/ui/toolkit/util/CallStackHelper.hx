package haxe.ui.toolkit.util;

import haxe.CallStack;

class CallStackHelper {
	public static function traceCallStack() {
		var arr:Array<haxe.StackItem> = haxe.CallStack.callStack();
		if (arr == null) {
			trace("Callstack is null!");
			return;
		}
		trace(haxe.CallStack.toString(arr));
		trace(">>>>>>>>>>>>>>>>>>>>>>>>>>>> END >>>>>>>>>>>>>>>>>>>>>>>>>>>>");
	}
}