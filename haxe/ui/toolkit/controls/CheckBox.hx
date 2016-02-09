package haxe.ui.toolkit.controls;

import haxe.ui.toolkit.core.interfaces.InvalidationFlag;
import haxe.ui.toolkit.core.Screen;
import openfl.display.Sprite;
import openfl.events.Event;
import haxe.ui.toolkit.core.base.VerticalAlign;
import haxe.ui.toolkit.core.StateComponent;
import haxe.ui.toolkit.core.interfaces.IClonable;
import haxe.ui.toolkit.events.UIEvent;
import haxe.ui.toolkit.layout.HorizontalLayout;
import haxe.ui.toolkit.style.Style;
import openfl.events.MouseEvent;

/**
 Simple two state checkbox control
 **/

@:event("UIEvent.CHANGE", "Dispatched when the value of the checkbox is modified") 
class CheckBox extends StateComponent implements IClonable<CheckBox> {
	/**
	 Checkbox state is "normal" (default state)
	 **/
	public static inline var STATE_NORMAL = "normal";
	/**
	 Checkbox state is "over"
	 **/
	public static inline var STATE_OVER = "over";
	/**
	 Checkbox state is "down"
	 **/
	public static inline var STATE_DOWN = "down";
	
	private var _value:CheckBoxValue;
	private var _label:Text;
	private var _selected:Bool;
	private var _eventTarget:Sprite;
	
	private var _down:Bool = false;
	
	public function new() {
		super();
		sprite.buttonMode = true;
		sprite.useHandCursor = true;
		_value = new CheckBoxValue();
		_label = new Text();
		_eventTarget = new Sprite();
		layout = new HorizontalLayout();
		autoSize = true;
	}

	//******************************************************************************************
	// Overrides
	//******************************************************************************************
	private override function initialize():Void {
		super.initialize();

		_value.verticalAlign = VerticalAlign.CENTER;
		addChild(_value);
		addChild(_label);
		
		addEventListener(UIEvent.CLICK, function(e) {
			_value.cycleValues();
		});
		
		_value.addEventListener(UIEvent.CHANGE, function (e) {
			selected = _value.value == "selected"; // updates checkbox state.
		}); 
		
		addEventListener(MouseEvent.MOUSE_OVER, _onMouseOver);
		addEventListener(MouseEvent.MOUSE_OUT, _onMouseOut);
		addEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown);
		addEventListener(MouseEvent.MOUSE_UP, _onMouseUp);

		sprite.addChild(_eventTarget);
	}

	public override function invalidate(type:Int = InvalidationFlag.ALL, recursive:Bool = false):Void {
		if (!_ready || _invalidating) {
			return;
		}

		super.invalidate(type, recursive);
		_invalidating = true;
		if (type & InvalidationFlag.SIZE == InvalidationFlag.SIZE) {
			resizeEventTarget();
		}
		_invalidating = false;
	}

	public override function dispose():Void {
        if (sprite.contains(_eventTarget) == true) {
		    sprite.removeChild(_eventTarget);
        }
		super.dispose();
	}
	
	//******************************************************************************************
	// Event handlers
	//******************************************************************************************
	private function _onMouseOver(event:MouseEvent):Void {
		if (event.buttonDown == false) {
			state = STATE_OVER;
		} else if (_down == true) {
			state = STATE_DOWN;
		}
	}
	
	private function _onMouseOut(event:MouseEvent):Void {
		if (event.buttonDown == false) {
			state = STATE_NORMAL;
		} else {
			//Screen.instance.addEventListener(MouseEvent.MOUSE_UP, _onMouseUp);
		}
	}
	
	private function _onMouseDown(event:MouseEvent):Void {
		_down = true;
		state = STATE_DOWN;
		Screen.instance.addEventListener(MouseEvent.MOUSE_UP, _onMouseUp);
	}
	
	private function _onMouseUp(event:MouseEvent):Void {
		_down = false;
		if (hitTest(event.stageX, event.stageY)) {
			#if !(android)
				state = STATE_OVER;
			#else
				state = STATE_NORMAL;
			#end
		} else {
			state = STATE_NORMAL;
		}

		Screen.instance.removeEventListener(MouseEvent.MOUSE_UP, _onMouseUp);
	}
	
	//******************************************************************************************
	// Component overrides
	//******************************************************************************************
	private override function set_autoSize(value:Bool):Bool {
		value = super.set_autoSize(value);
		_label.percentWidth = value?-1:100;
		return value;
	}

	private override function get_text():String {
		return _label.text;
	}
	
	private override function set_text(value:String):String {
		value = super.set_text(value);
		_label.text = value;
		return value;
	}
	
	private override function get_value():Dynamic {
		return selected;
	}
	
	private override function set_value(newValue:Dynamic):Dynamic {
		if (Std.is(newValue, String)) {
			selected = (newValue == "true");
		} else {
			selected = newValue;
		}
		return newValue;
	}

	private override function get_height():Float {
		var height = super.get_height();
		if(autoSize){
			return height;
		}else{
			return Math.max(height, _label.height);
		}
	}
	
	//******************************************************************************************
	// Component getters/setters
	//******************************************************************************************
	/**
	 Defines whether or not the text can span more than a single line
	 **/
	@:clonable
	public var multiline(get, set):Bool;
	@:clonable
	public var wrapLines(get, set):Bool;
	/**
	 Defines whether the checkbox is checked or not
	 **/
	@:clonable
	public var selected(get, set):Bool;

	private function get_multiline():Bool {
		return _label.multiline;
	}
	
	private function set_multiline(value:Bool):Bool {
		return _label.multiline = value;
	}

	private function get_wrapLines():Bool {
		return _label.wrapLines;
	}
	
	private function set_wrapLines(value:Bool):Bool {
		return _label.wrapLines = value;
	}
	
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
			if (_baseStyle != null) {
				labelStyle.fontName = _baseStyle.fontName;
				labelStyle.fontSize = _baseStyle.fontSize;
				labelStyle.fontEmbedded = _baseStyle.fontEmbedded;
				labelStyle.color = _baseStyle.color;
			}
			_label.baseStyle = labelStyle;
		}
	}
	
	//******************************************************************************************
	// IState
	//******************************************************************************************
	private override function get_states():Array<String> {
		return [STATE_NORMAL, STATE_OVER, STATE_DOWN];
	}

	//******************************************************************************************
	// Helpers
	//******************************************************************************************
	private function resizeEventTarget():Void {
		var targetX:Float = layout.padding.left;
		var targetY:Float = layout.padding.top;
		var targetCX:Float = width - (layout.padding.left + layout.padding.right);
		var targetCY:Float = height - (layout.padding.top + layout.padding.bottom);
		
		_eventTarget.alpha = 0;
		_eventTarget.graphics.clear();
		_eventTarget.graphics.beginFill(0xFF00FF);
		_eventTarget.graphics.lineStyle(0);
		_eventTarget.graphics.drawRect(targetX, targetY, targetCX, targetCY);
		_eventTarget.graphics.endFill();
	}
}

@:dox(hide)
class CheckBoxValue extends Value implements IClonable<CheckBoxValue> {
	public function new() {
		super();
		_value = "unselected";
		addValue("selected");
		addValue("unselected");
	}
}