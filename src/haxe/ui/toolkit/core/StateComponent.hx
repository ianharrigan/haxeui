package haxe.ui.toolkit.core;

import haxe.ui.toolkit.core.interfaces.InvalidationFlag;
import haxe.ui.toolkit.core.interfaces.IStateComponent;
import haxe.ui.toolkit.core.interfaces.IClonable;
import haxe.ui.toolkit.style.Style;
import haxe.ui.toolkit.style.StyleManager;

class StateComponent extends Component implements IStateComponent implements IClonable<StateComponent> {
	private var _state:String;
	private var _states:Array<String>;
	
	public function new() {
		super();
		_states = new Array<String>();
	}
	
	//******************************************************************************************
	// IStyleable
	//******************************************************************************************
	private override function buildStyles():Void {
		for (s in states) {
			var stateStyle:Style = StyleManager.instance.buildStyleFor(this, s);
			if (stateStyle != null) {
				stateStyle.merge(_setStyle);
				storeStyle(s, stateStyle);
			}
		}
	}
	
	public function addStates(stateNames:Array<String>, rebuildStyles:Bool = true):Void {
		for (stateName in stateNames) {
			addState(stateName, false);
		}
		if (rebuildStyles == true && _ready) {
			buildStyles();
		}
	}
	
	public function addState(stateName:String, rebuildStyles:Bool = true):Void {
		if (hasState(stateName) == false) {
			_states.push(stateName);
			if (rebuildStyles == true && _ready) {
				buildStyles();
			}
		}
	}
	
	//******************************************************************************************
	// IState
	//******************************************************************************************
	@:clonable
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
	
	public function hasState(state:String):Bool {
		if (states == null) {
			return false;
		}
		return Lambda.indexOf(states, state) != -1;
	}
}