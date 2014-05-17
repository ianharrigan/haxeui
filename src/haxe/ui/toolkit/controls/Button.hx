package haxe.ui.toolkit.controls;

import flash.events.MouseEvent;
import haxe.ds.StringMap;
import haxe.ui.toolkit.core.base.HorizontalAlign;
import haxe.ui.toolkit.core.base.VerticalAlign;
import haxe.ui.toolkit.core.interfaces.IClonable;
import haxe.ui.toolkit.core.interfaces.IFocusable;
import haxe.ui.toolkit.core.interfaces.InvalidationFlag;
import haxe.ui.toolkit.core.Screen;
import haxe.ui.toolkit.core.StateComponent;
import haxe.ui.toolkit.events.UIEvent;
import haxe.ui.toolkit.layout.BoxLayout;
import haxe.ui.toolkit.layout.HorizontalLayout;
import haxe.ui.toolkit.layout.Layout;
import haxe.ui.toolkit.layout.VerticalLayout;
import haxe.ui.toolkit.style.Style;

/**
 General purpose multi-state button control with icon and toggle support (plus icon positioning)

 <b>Code Example</b>
 <pre>
 var button:Button = new Button();
 button.x = 100;
 button.y = 100;
 button.width = 150;
 button.height = 100;
 button.text = "Button";
 button.id = "theButton";</pre>

 <b>XML Example</b>
 <pre>
 &lt;button id="theButton" text="Button" x="100" y="100" width="150" height="100" /&gt;</pre>
 **/

@:event("UIEvent.CLICK", "Dispatched when the button is clicked") 
@:event("UIEvent.MOUSE_DOWN", "Dispatched when a user presses the pointing device button over the button") 
@:event("UIEvent.MOUSE_UP", "Dispatched when a user releases the pointing device button over the button") 
@:event("UIEvent.MOUSE_OVER", "Dispatched when the user moves a pointing device over the button") 
@:event("UIEvent.MOUSE_OUT", "Dispatched when the user moves a pointing device away from the button") 
@:event("UIEvent.MOUSE_MOVE", "Dispatched when a user moves the pointing device while it is over the button") 
@:event("UIEvent.CHANGE", "Dispatched when the value of the toggle group changes") 
class Button extends StateComponent implements IFocusable implements IClonable<StateComponent> {
	/**
	 Button state is "normal" (default state)
	 **/
	public static inline var STATE_NORMAL = "normal";
	/**
	 Button state is "over"
	 **/
	public static inline var STATE_OVER = "over";
	/**
	 Button state is "down"
	 **/
	public static inline var STATE_DOWN = "down";
	/**
	 Button state is "disabled"
	 **/
	public static inline var STATE_DISABLED = "disabled";
	
	private var _allowFocus:Bool = true;
	private var _remainPressed:Bool = false; // if the button should remain pressed even when the mouse is out
	
	private var _label:Text;
	private var _icon:Image;
	
	private var _down:Bool = false;
	private var _toggle:Bool = false;
	private var _selected:Bool = false;
	private var _allowSelection:Bool = true;
	private var _iconPosition:String = "left";
	
	private var _group:String;
	private static var _groups:StringMap<Array<Button>>;
	
	private var _spacers:Array<Spacer>;
	
	public function new() {
		super();

		sprite.buttonMode = true;
		sprite.useHandCursor = true;
		state = STATE_NORMAL;
		_layout = new HorizontalLayout();
		autoSize = true;
		
		_spacers = new Array<Spacer>();
		if (_groups == null) {
			_groups = new StringMap<Array<Button>>();
		}
	}
	
	//******************************************************************************************
	// Properties
	//******************************************************************************************
	/**
	 Defines whether this button should remain pressed even when the mouse cursor goes out of the control (and the left mouse button is pressed)
	 **/
	@:clonable
	public var remainPressed(get, set):Bool;
	/**
	 Sets the icon asset. Eg: `assets/myicon.png`
	 **/
	@:clonable
	public var icon(get, set):Dynamic;
	
	private function get_remainPressed():Bool {
		return _remainPressed;
	}
	
	private function set_remainPressed(value:Bool):Bool {
		_remainPressed = value;
		return value;
	}
	
	private function get_icon():Dynamic {
		if (_icon == null) {
			return null;
		}
		return _icon.resource;
	}
	
	private function set_icon(value:Dynamic):Dynamic {
		if (value != null) {
			if (_icon == null) {
				_icon = new Image();
				_icon.id = "icon";
				_icon.style.padding = 100;
			}
			_icon.resource = value;
			organiseChildren();
		} else {
			_icon.visible = false;
		}
		return value;
	}
	
	private function organiseChildren():Void {
		if (_ready == false) {
			return;
		}
		removeAllChildren(false);
		for (s in _spacers) {
			s.dispose();
		}
		_spacers = new Array<Spacer>();
		
		if (_iconPosition == "left" || _iconPosition == "right") {
			layout = new HorizontalLayout();
		} else if (_iconPosition == "top" || _iconPosition == "bottom") {
			if (_label != null && _icon != null && _label.width < _icon.width) {
				_label.autoSize = false;
				_label.width = _icon.width;
				//_label.textAlign = "center";
			}
			layout = new VerticalLayout();
			if (_autoSize == false) {
				var spacer:Spacer = new Spacer();
				spacer.percentHeight = 50;
				addChild(spacer);
				_spacers.push(spacer);
			}
		} else {
			layout = new BoxLayout();
		}
		
		if (_icon != null) {
			_icon.horizontalAlign = HorizontalAlign.CENTER;
			_icon.verticalAlign = VerticalAlign.CENTER;
		}
		
		if (_label != null) {
			if (autoSize == false) {
				_label.percentWidth = 100;
				_label.autoSize = false;
				_label.textAlign = "center";
			} else {
				_label.percentWidth = -1;
				//_label.autoSize = true;
				_label.textAlign = "center";
			}
		}
		
		if (_iconPosition == "left" || _iconPosition == "top") {
			addChild(_icon);
			addChild(_label);
		} else if (_iconPosition == "right" || _iconPosition == "bottom") {
			addChild(_label);
			if (_autoSize == true && _iconPosition == "right") {
				var spacer:Spacer = new Spacer();
				spacer.percentWidth = 100;
				addChild(spacer);
				_spacers.push(spacer);
			}
			addChild(_icon);
		} else {
			addChild(_icon);
			addChild(_label);
		}
		
		if (_iconPosition == "top" || _iconPosition == "bottom") {
			if (_autoSize == false) {
				var spacer:Spacer = new Spacer();
				spacer.percentHeight = 50;
				addChild(spacer);
				_spacers.push(spacer);
			}
		}
	}
	
	//******************************************************************************************
	// Overrides
	//******************************************************************************************
	private override function preInitialize():Void {
		super.preInitialize();
	}
	
	private override function initialize():Void {
		super.initialize();
		
		addEventListener(MouseEvent.MOUSE_OVER, _onMouseOver);
		addEventListener(MouseEvent.MOUSE_OUT, _onMouseOut);
		addEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown);
		addEventListener(MouseEvent.MOUSE_UP, _onMouseUp);
		addEventListener(MouseEvent.CLICK, _onMouseClick);
		
		organiseChildren();
	}
	
	private override function set_disabled(value:Bool):Bool {
		super.set_disabled(value);
		if (value == true) {
			sprite.buttonMode = false;
			sprite.useHandCursor = false;
			//state = STATE_DISABLED;
		} else {
			sprite.buttonMode = true;
			sprite.useHandCursor = true;
			//state = STATE_NORMAL;
		}
		return value;
	}
	
	//******************************************************************************************
	// Component overrides
	//******************************************************************************************
	private override function get_text():String {
		if (_label == null) {
			return null;
		}
		return _label.text;
	}
	
	private override function set_text(value:String):String {
		value = super.set_text(value);
		
		if (value != null) {
			if (_label == null) {
				_label = new Text();
				_label.id = "label";
			}
			_label.value = value;
			organiseChildren();
		} else {
			_label.visible = false;
		}
		return value;
	}

	//******************************************************************************************
	// Event handlers
	//******************************************************************************************
	private function _onMouseOver(event:MouseEvent):Void {
		if (_selected == false) {
			if (event.buttonDown == false || _down == false) {
				state = STATE_OVER;
			} else {
				state = STATE_DOWN;
			}
		}
	}
	
	private function _onMouseOut(event:MouseEvent):Void {
		if (_selected == false) {
			if (_remainPressed == false || event.buttonDown == false) {
				state = STATE_NORMAL;
			} else {
				//Screen.instance.addEventListener(MouseEvent.MOUSE_UP, _onMouseUp);
			}
		}
	}
	
	private function _onMouseDown(event:MouseEvent):Void {
		if (_allowSelection == true) {
			_down = true;
			state = STATE_DOWN;
			Screen.instance.addEventListener(MouseEvent.MOUSE_UP, _onMouseUp);
		}
	}
	
	private function _onMouseUp(event:MouseEvent):Void {
		if (_allowSelection == true && toggle == false) {
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
			
			//if (_remainPressed == true) {
				Screen.instance.removeEventListener(MouseEvent.MOUSE_UP, _onMouseUp);
			//}
		}
	}
	
	private function _onMouseClick(event:MouseEvent):Void {
		if (_icon != null && _icon.hitTest(event.stageX, event.stageY)) {
			dispatchEvent(new UIEvent(UIEvent.GLYPH_CLICK));
		}
		if (_toggle == true && _allowSelection == true) {
			selected = !selected;
			#if !android
				if (selected == false && hitTest(event.stageX, event.stageY)) {
					state = STATE_OVER;
				}
			#end
		}
	}
	
	//******************************************************************************************
	// IState
	//******************************************************************************************
	private override function get_states():Array<String> {
		return [STATE_NORMAL, STATE_OVER, STATE_DOWN, STATE_DISABLED];
	}
	
	private override function set_state(value:String):String {
		super.set_state(value);
		if (value == STATE_DOWN) {
			_down = true;
		}
		return value;
	}
	
	//******************************************************************************************
	// IFocusable
	//******************************************************************************************
	/**
	 Defines whether or not the button can receive focus by tabbing to it (not yet implemented)
	 **/
	@:clonable
	public var allowFocus(get, set):Bool;
	
	private function get_allowFocus():Bool {
		return _allowFocus;
	}
	
	private function set_allowFocus(value:Bool):Bool {
		return value;
	}
	
	//******************************************************************************************
	// Properties
	//******************************************************************************************
	/**
	 Defines where the icon (if available) should be positioned, valid values are:
		 
		 - `left` - left of the label
		 - `top` - top of the label
		 - `center` - center of the button
		 - `right` - right of the label
		 - `bottom` - bottom of the label
	 **/
	@:clonable
	public var iconPosition(get, set):String;
	/**
	 Defines whether this button should behave as a toggle button. Toggle buttons maintain thier selection, ie, one click to select, another to deselect
	 **/
	@:clonable
	public var toggle(get, set):Bool;
	/**
	 Gets or sets the buttons selected state. Only applicable if the button is a toggle button.
	 **/
	@:clonable
	public var selected(get, set):Bool;
	/**
	 Defines the group for this button. Toggle buttons belonging to the same group will only ever have a single option selected.
	 **/
	@:clonable
	public var group(get, set):String;
	/**
	 Defines whether this buttons selected state can be modified by the user. Only applicable for toggle buttons.
	 **/
	@:clonable
	public var allowSelection(get, set):Bool;
	private var dispatchChangeEvents(default, default):Bool = true;
	
	private function get_iconPosition():String {
		return _iconPosition;
	}
	
	private function set_iconPosition(value:String):String {
		_iconPosition = value;
		organiseChildren();
		return value;
	}
	
	private function get_toggle():Bool {
		return _toggle;
	}
	
	private function set_toggle(value:Bool):Bool {
		_toggle = value;
		return value;
	}
	
	private function get_selected():Bool {
		return _selected;
	}
	
	private function set_selected(value:Bool):Bool {
		if (_toggle == true && _selected != value) {
			
			/** If toggle button state has changed, 
			 * unselect other buttons in the same group */
			if (_group != null && value == true) {
				var arr:Array<Button> = _groups.get(_group);
				if (arr != null) {
					for (button in arr) {
						if (button != this) {
							button.selected = false;
						}
					}
				}
			}
			
			_selected = value; // makes sense to update selected before dispatching event.
			if (dispatchChangeEvents == true) {
				var event:UIEvent = new UIEvent(UIEvent.CHANGE);
				dispatchEvent(event);
			}
		}
		
		_selected = value;
		if (_selected == true) {
			state = STATE_DOWN;
		} else {
			#if !(android)
				if (root != null && hitTest(root.mousePosition.x, root.mousePosition.y) == true) {
					state = STATE_OVER;
				} else {
					state = STATE_NORMAL;
				}
			#else
				state = STATE_NORMAL;
			#end
		}
			
		return value;
	}
	
	private function get_group():String {
		return _group;
	}
	
	private function set_group(value:String):String {
		if (value != null) {
			var arr:Array<Button> = _groups.get(value);
			if (arr != null) {
				arr.remove(this);
			}
		}
		
		_group = value;
		if (value == null) {
			return value;
		}
		
		var arr:Array<Button> = _groups.get(value);
		if (arr == null) {
			arr = new Array<Button>();
		}
		
		if (optionInGroup(value, this) == false) {
			arr.push(this);
		}
		_groups.set(value, arr);
		
		return value;
	}
	
	
	private function get_allowSelection():Bool {
		return _allowSelection;
	}
	
	private function set_allowSelection(value:Bool):Bool {
		_allowSelection = value;
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
				labelStyle.textAlign = _style.textAlign;
			}
			_label.style = labelStyle;
		}
		
		if (_style != null) {
			if (_style.icon != null) {
				icon = _style.icon;
			}
			
			if (_style.iconPosition != null) {
				iconPosition = _style.iconPosition;
			}
		}
	}
	
	//******************************************************************************************
	// Helpers
	//******************************************************************************************
	private static function optionInGroup(value:String, option:Button):Bool {
		var exists:Bool = false;
		var arr:Array<Button> = _groups.get(value);
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
}
