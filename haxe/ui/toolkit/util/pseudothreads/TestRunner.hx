package haxe.ui.toolkit.util.pseudothreads;

class TestRunner extends Runner {
	public function new(timeShare:Float) {
		super();
		_runningTimeShare = timeShare;
	}
	
	private var _breakIndex:Int = 0;
	
	public override function run() {
		for (n in _breakIndex...5000000) {
			if (_needToExit() == true) {
				_breakIndex = n;
				_progress = n;
				return;
			}
			
			var bob:String = "this is a simple string";
			bob = StringTools.replace(bob, "simple", "not so simple");
		}
		
		trace("Thread complete");
		_needToExit = null;
		_isComplete = true;
	}
}