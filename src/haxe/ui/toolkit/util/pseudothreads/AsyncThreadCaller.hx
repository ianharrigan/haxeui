package haxe.ui.toolkit.util.pseudothreads;

import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.ProgressEvent;
import flash.Lib;

class AsyncThreadCaller extends EventDispatcher {
	private var _workerExitTime:Float;
	private var _runnableWorker:IRunnable;
	private var _data:Dynamic;
	private var _runs:Int = 0;
	
	private var _startTime:Float;
	private var _endTime:Float;
	
	private var _cancel:Bool = false;
	
	public function new(runnable:IRunnable) {
		super();
		_runnableWorker = runnable;
		_runnableWorker.needToExit = needToExit;
	}
	
	public function start():Void {
		_startTime = Lib.getTimer();
		Lib.current.stage.addEventListener(Event.ENTER_FRAME, run, false, 100);
		run(null);
	}
	
	public function cancel():Void {
		_cancel = true;
	}
	
	public function needToExit():Bool {
		return (_cancel || Lib.getTimer() >= _workerExitTime);
	}
	
	private function run(event:Event):Void {
		var frameRate:Float = Math.floor(1000 / Lib.current.stage.frameRate);
		_workerExitTime = Lib.getTimer() + frameRate * _runnableWorker.runningTimeShare;
		
		_runnableWorker.run();
		_runs++;
		
		if (_cancel == true) {
			_endTime = Lib.getTimer();
			dispose();
			dispatchEvent(new Event(Event.CANCEL));
		} else  if (_runnableWorker.isComplete) {
			_data = _runnableWorker.data;
			_endTime = Lib.getTimer();
			dispose();
			dispatchEvent(new Event(Event.COMPLETE));
		} else {
			dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS, false, false, _runnableWorker.progress, _runnableWorker.total));
		}
	}
	
	private function dispose():Void {
		Lib.current.stage.removeEventListener(Event.ENTER_FRAME, run);
		_runnableWorker = null;
	}
	
	public var data(get, null):Dynamic;
	private function get_data():Dynamic {
		return _data;
	}
	
	public var runs(get, null):Int;
	private function get_runs():Int {
		return _runs;
	}
	
	public var executionTime(get, null):Float;
	private function get_executionTime():Float {
		return _endTime - _startTime;
	}
	
	public var worker(get, null):IRunnable;
	private function get_worker():IRunnable {
		return _runnableWorker;
	}
}