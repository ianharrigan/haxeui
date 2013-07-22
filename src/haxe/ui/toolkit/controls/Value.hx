package haxe.ui.toolkit.controls;

import flash.events.MouseEvent;
import haxe.ui.toolkit.core.Component;
import haxe.ui.toolkit.layout.AbsoluteLayout;

class Value extends Component {
	private var _values:Map<String, Button>;
	private var _valuesList:Array<String>;
	private var _value:String = "";
	
	private var _interactive:Bool = true;
	
	public function new() {
		super();
		_autoSize = false;
		_layout = new AbsoluteLayout();
		_values = new Map<String, Button>();
		_valuesList = new Array<String>();
		
		addEventListener(MouseEvent.CLICK, _onMouseClick);
	}
	
	//******************************************************************************************
	// Class members
	//******************************************************************************************
	public function addValue(value:String):Void {
		if (_values.get(value) == null) {
			var valueControl:Button = new Button();
			valueControl.id = value;
			valueControl.percentWidth = 100;
			valueControl.percentHeight = 100;
			_values.set(value, valueControl);
			_valuesList.push(value);
			valueControl.visible = (_value == value);
			addChild(valueControl);
		}
	}
	
	public function cycleValues():Void {
		var currentIndex:Int = Lambda.indexOf(_valuesList, _value);
		currentIndex++;
		if (currentIndex > _valuesList.length - 1) {
			currentIndex = 0;
		}
		value = _valuesList[currentIndex];
	}
	
	//******************************************************************************************
	// Event handlers
	//******************************************************************************************
	private function _onMouseClick(event:MouseEvent):Void {
		if (_interactive == true) {
			cycleValues();
		}
	}
	
	//******************************************************************************************
	// Getters/setters
	//******************************************************************************************
	public var value(get, set):String;
	public var interactive(get, set):Bool;
	
	private function get_value():String {
		return _value;
	}
	
	private function set_value(newValue:String):String {
		if (newValue != _value) {
			var valueControl:Button = _values.get(newValue);
			if (valueControl != null) {
				var currentControl:Button = _values.get(_value);
				if (currentControl != null) {
					currentControl.visible = false;
				}
				_value = newValue;
				valueControl.visible = true;
			}
		}
		return newValue;
	}
	
	private function get_interactive():Bool {
		return _interactive;
	}
	
	private function set_interactive(value:Bool):Bool {
		_interactive = value;
		return value;
	}
}