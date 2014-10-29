package haxe.ui.toolkit.util.pseudothreads;

interface IRunnable {
	public function run():Void;
	public var isComplete(get, null):Bool;
	public var progress(get, null):Int;
	public var total(get, null):Int;
	public var runningTimeShare(get, null):Float;
	public var needToExit(null, set):Void->Bool;
	public var data(get, null):Dynamic;
}