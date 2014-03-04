package haxe.ui.toolkit.controls;

import haxe.ui.toolkit.core.base.State;
import haxe.ui.toolkit.core.Component;
import haxe.ui.toolkit.core.interfaces.Direction;
import haxe.ui.toolkit.core.interfaces.IDirectional;
import haxe.ui.toolkit.core.StateComponent;

/**
 Scrollbar control
 **/
 
@:event("UIEvent.CHANGE", "Dispatched when the value of the scrollbar changes") 
class Scroll extends StateComponent implements IDirectional {
	private var _direction:String = Direction.VERTICAL;

	public function new() {
		super();
		addStates([State.NORMAL, State.DISABLED]);
	}
	
	//******************************************************************************************
	// ProgressBar methods/properties
	//******************************************************************************************
	/**
	 The direction of this progress bar. Can be `horizontal` or `vertical`
	 **/
	public var direction(get, set):String;
	
	private function get_direction():String {
		return _direction;
	}
	
	private function set_direction(value:String):String {
		_direction = value;
		return value;
	}
}