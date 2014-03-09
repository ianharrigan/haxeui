package haxe.ui.toolkit.util.pseudothreads;

class Runner implements IRunnable {
	public function new() {
		
	}
	
	public function run():Void {
		
	}
	
	private var _isComplete:Bool;
	public var isComplete(get, null):Bool;
	public function get_isComplete():Bool {
		return _isComplete;
	}
	
	private var _progress:Int;
	public var progress(get, null):Int;
	public function get_progress():Int {
		return _progress;
	}
	
	private var _total:Int;
	public var total(get, null):Int;
	public function get_total():Int {
		return _total;
	}

	private var _runningTimeShare:Float = .6;
	public var runningTimeShare(get, null):Float;
	public function get_runningTimeShare():Float {
		return _runningTimeShare;
	}
	
	private var _needToExit:Void->Bool;
	public var needToExit(null, set):Void->Bool;
	public function set_needToExit(value:Void->Bool):Void->Bool {
		_needToExit = value;
		return value;
	}
	
	private var _data:Dynamic;
	public var data(get, null):Dynamic;
	public function get_data():Dynamic {
		return _data;
	}
}