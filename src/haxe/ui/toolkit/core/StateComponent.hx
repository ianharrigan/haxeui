package haxe.ui.toolkit.core;

import haxe.ui.toolkit.core.interfaces.InvalidationFlag;
import haxe.ui.toolkit.core.interfaces.IStateComponent;
import haxe.ui.toolkit.style.StyleManager;

class StateComponent extends Component implements IStateComponent {
	private var _state:String;
	private var _states:Array<String>;
	
	public function new() {
		super();
		_states = new Array<String>();
	}
	
	//******************************************************************************************
	// IStyleable
	//******************************************************************************************
	public override function buildStyles():Void {
		for (s in states) {
			var stateStyle:Dynamic = StyleManager.instance.buildStyleFor(this, s);
			if (stateStyle != null) {
				storeStyle(s, stateStyle);
			}
		}
	}
	
	public function addStates(stateNames:Array<String>):Void {
		for (stateName in stateNames) {
			_states.push(stateName);
		}
		buildStyles();
	}
	
	//******************************************************************************************
	// IState
	//******************************************************************************************
	public var state(get, set):String;
	public var states(get, null):Array<String>;
	
	private function get_state():String {
		return _state;
	}
	
	private function set_state(value:String):String {
		if (_state != value) {
			_state = value;
			if (retrieveStyle(_state) != null) {
				style = retrieveStyle(_state);
			} else {
				invalidate(InvalidationFlag.STATE);
			}
		}
		return value;
	}
	
	private function get_states():Array<String> {
		return _states;
	}
}