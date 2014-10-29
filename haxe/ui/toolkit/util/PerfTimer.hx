package haxe.ui.toolkit.util;

import haxe.Timer;

class PerfTimer {
	private var name:String;
	private var startStamp:Float;
	private var endStamp:Float;
	
	public function new(s:String = null) {
		name = s;
		startStamp = Timer.stamp();
	}
	
	public function end():Void {
		endStamp = Timer.stamp();
		var delta:Float = (endStamp - startStamp);
		trace(">>>> " + name + ": took " + delta + " ms");
	}
	
}