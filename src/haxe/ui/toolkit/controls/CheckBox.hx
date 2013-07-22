package haxe.ui.toolkit.controls;

import flash.events.Event;
import flash.events.MouseEvent;
import haxe.ui.toolkit.core.Component;
import haxe.ui.toolkit.layout.HorizontalLayout;

class CheckBox extends Component {
	private var _value:CheckBoxValue;
	private var _label:Text;
	
	public function new() {
		super();
		_autoSize = true;
		sprite.buttonMode = true;
		sprite.useHandCursor = true;
		_value = new CheckBoxValue();
		_label = new Text();
		_layout = new HorizontalLayout();
	}

	//******************************************************************************************
	// Overrides
	//******************************************************************************************
	private override function initialize():Void {
		super.initialize();
		
		addChild(_value);
		addChild(_label);
		
		_label.addEventListener(MouseEvent.CLICK, function(e) {
			_value.cycleValues();
		});
	}
	
	//******************************************************************************************
	// Component overrides
	//******************************************************************************************
	private override function get_text():String {
		return _label.text;
	}
	
	private override function set_text(value:String):String {
		value = super.set_text(value);
		_label.text = value;
		return value;
	}
	
	//******************************************************************************************
	// Component getters/setters
	//******************************************************************************************
	public var selected(get, set):Bool;
	
	private function get_selected():Bool {
		return (_value.value == "selected");
	}
	
	private function set_selected(value:Bool):Bool {
		if (selected == value) {
			return value;
		}
		
		_value.value = (value == true) ? "selected" : "unselected";
		
		var event:Event = new Event(Event.CHANGE);
		dispatchEvent(event);
		
		return value;
	}
}

class CheckBoxValue extends Value {
	public function new() {
		super();
		_value = "unselected";
		addValue("selected");
		addValue("unselected");
	}
}