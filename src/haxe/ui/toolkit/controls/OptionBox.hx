package haxe.ui.toolkit.controls;

import flash.events.Event;
import flash.events.MouseEvent;
import haxe.ds.StringMap;
import haxe.ui.toolkit.core.base.VerticalAlign;
import haxe.ui.toolkit.core.Component;
import haxe.ui.toolkit.core.interfaces.IClonable;
import haxe.ui.toolkit.layout.HorizontalLayout;
import haxe.ui.toolkit.style.Style;

/**
 Simple two state option control (supports groups)
 **/

@:event("UIEvent.CHANGE", "Dispatched when the value of the option box is modified") 
class OptionBox extends Component implements IClonable<OptionBox> {
	private var _value:OptionBoxValue;
	private var _label:Text;
	
	private var _group:String;
	private static var _groups:StringMap<Array<OptionBox>>;
	
	public function new() {
		super();
		sprite.buttonMode = true;
		sprite.useHandCursor = true;
		if (_groups == null) {
			_groups = new StringMap<Array<OptionBox>>();
		}
		
		_value = new OptionBoxValue();
		_value.interactive = false;
		_label = new Text();
		_layout = new HorizontalLayout();
		_autoSize = true;
	}
	
	//******************************************************************************************
	// Overrides
	//******************************************************************************************
	private override function initialize():Void {
		super.initialize();

		_value.verticalAlign = VerticalAlign.CENTER;
		addChild(_value);
		addChild(_label);
		
		addEventListener(MouseEvent.CLICK, function(e) {
			if (selected == false) {
				selected = !selected;
			}
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
	 Defines whether the option is checked or not, if set to `true` then other options of the same group will be deselected.
	 **/
	@:clonable
	public var selected(get, set):Bool;
	/**
	 Defines the group for this option. Options belonging to the same group will only ever have a single option selected.
	 **/
	@:clonable
	public var group(get, set):String;
	
	private function get_selected():Bool {
		return (_value.value == "selected");
	}
	
	private function set_selected(value:Bool):Bool {
		if (selected == value) {
			return value;
		}
		
		_value.value = (value == true) ? "selected" : "unselected";
		if (_group != null && value == true) { // set all the others in group
			var arr:Array<OptionBox> = _groups.get(_group);
			if (arr != null) {
				for (option in arr) {
					if (option != this) {
						option.selected = false;
					}
				}
			}
		}
		
		var event:Event = new Event(Event.CHANGE);
		dispatchEvent(event);
		
		return value;
	}
	
	private function get_group():String {
		return _group;
	}
	
	private function set_group(value:String):String {
		if (value != null) {
			var arr:Array<OptionBox> = _groups.get(value);
			if (arr != null) {
				arr.remove(this);
			}
		}
		
		_group = value;
		var arr:Array<OptionBox> = _groups.get(value);
		if (arr == null) {
			arr = new Array<OptionBox>();
		}
		
		if (optionInGroup(value, this) == false) {
			arr.push(this);
		}
		_groups.set(value, arr);
		
		return value;
	}
	
	//******************************************************************************************
	// Helpers
	//******************************************************************************************
	private static function optionInGroup(value:String, option:OptionBox):Bool {
		var exists:Bool = false;
		var arr:Array<OptionBox> = _groups.get(value);
		if (arr != null) {
			for (test in arr) {
				if (test == option) {
					exists = true;
					break;
				}
			}
		}
		return exists;
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
class OptionBoxValue extends Value implements IClonable<OptionBoxValue> {
	public function new() {
		super();
		_value = "unselected";
		addValue("selected");
		addValue("unselected");
	}
}