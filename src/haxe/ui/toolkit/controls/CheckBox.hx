package haxe.ui.toolkit.controls;

import openfl.events.Event;
import haxe.ui.toolkit.core.base.VerticalAlign;
import haxe.ui.toolkit.core.Component;
import haxe.ui.toolkit.core.interfaces.IClonable;
import haxe.ui.toolkit.events.UIEvent;
import haxe.ui.toolkit.layout.HorizontalLayout;
import haxe.ui.toolkit.style.Style;

/**
 Simple two state checkbox control
 **/

@:event("UIEvent.CHANGE", "Dispatched when the value of the checkbox is modified") 
class CheckBox extends Component implements IClonable<CheckBox> {
	private var _value:CheckBoxValue;
	private var _label:Text;
	private var _selected:Bool;
	
	public function new() {
		super();
		autoSize = true;
		sprite.buttonMode = true;
		sprite.useHandCursor = true;
		_value = new CheckBoxValue();
		_label = new Text();
		layout = new HorizontalLayout();
	}

	//******************************************************************************************
	// Overrides
	//******************************************************************************************
	private override function initialize():Void {
		super.initialize();

		_value.verticalAlign = VerticalAlign.CENTER;
		addChild(_value);
		addChild(_label);
		
		_label.addEventListener(UIEvent.CLICK, function(e) {
			_value.cycleValues();
		});
		
		_value.addEventListener(UIEvent.CHANGE, function (e) {
			selected = _value.value == "selected"; // updates checkbox state.
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
	/**
	 Defines whether the checkbox is checked or not
	 **/
	@:clonable
	public var selected(get, set):Bool;
	
	private function get_selected():Bool {
		return _selected;
	}
	
	private function set_selected(value:Bool):Bool {
		if (_selected == value) {
			return value;
		}
		
		_value.value = (value == true) ? "selected" : "unselected";
		_selected = value;
		
		var event:Event = new Event(Event.CHANGE);
		dispatchEvent(event);
		
		return value;
	}
	
	//******************************************************************************************
	// IStyleable
	//******************************************************************************************
	public override function applyStyle():Void {
		super.applyStyle();
		
		// apply style to label
		if (_label != null) {
			var labelStyle:Style = new Style();
			if (_style != null) {
				labelStyle.fontName = _style.fontName;
				labelStyle.fontSize = _style.fontSize;
				labelStyle.fontEmbedded = _style.fontEmbedded;
				labelStyle.color = _style.color;
			}
			_label.style = labelStyle;
		}
	}
}

@exclude
class CheckBoxValue extends Value implements IClonable<CheckBoxValue> {
	public function new() {
		super();
		_value = "unselected";
		addValue("selected");
		addValue("unselected");
	}
}