package haxe.ui.toolkit.controls;

import openfl.events.MouseEvent;
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
	private var _multiline:Bool;
	
	private var _group:String;
	private static var _groups:StringMap<Array<Button>>;
	
	public function new() {
		super();	

		sprite.buttonMode = true;
		sprite.useHandCursor = true;
		state = STATE_NORMAL;
		_layout = new HorizontalLayout();
		autoSize = true;
		
		if (_groups == null) {
			_groups = new StringMap<Array<Button>>();
		}
	}		
	
	public override function dispose():Void {
		// removes this component from groups list.
		if (group != null) {
			var arr:Array<Button> = _groups.get(_group);
			arr.remove(this);
		}
		super.dispose();
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
		if (value == "none") { // TODO: hack!
            if (_icon != null) {
			    _icon.visible = false;
            }
			return value;
		}
		if (value != null) {
			if (_icon == null) {
				_icon = new Image();
				_icon.id = "icon";
				if (_iconWidth != -1) {
					_icon.width = _iconWidth;
				}
				if (_iconHeight != -1) {
					_icon.height = _iconHeight;
				}
			}
			if (_icon.resource != value) {
				_icon.resource = value;
				organiseChildren();
			}
		} else {
            if (_icon != null) {
			    _icon.visible = false;
            }
		}
		return value;
	}
	
	private var _iconWidth:Float = -1;
	public var iconWidth(get, set):Float;
	private function get_iconWidth():Float {
		return _iconWidth;
	}
	private function set_iconWidth(value:Float):Float {
		if (value == _iconWidth) {
			return value;
		}
		
		_iconWidth = value;
		if (_icon != null) {
			_icon.width = _iconWidth;
		}
		
		return value;
	}
	
	private var _iconHeight:Float = -1;
	public var iconHeight(get, set):Float;
	private function get_iconHeight():Float {
		return _iconHeight;
	}
	private function set_iconHeight(value:Float):Float {
		if (value == _iconHeight) {
			return value;
		}
		
		_iconHeight = value;
		if (_icon != null) {
			_icon.height = _iconHeight;
		}
		
		return value;
	}
	
	
	private function organiseChildren():Void {
		if (_ready == false) {
			return;
		}
		
		removeAllChildren(false);
		
		if (_icon != null) {
			_icon.horizontalAlign = HorizontalAlign.CENTER;
			_icon.verticalAlign = VerticalAlign.CENTER;
		}
		
		if (_label != null) {
			_label.horizontalAlign = HorizontalAlign.CENTER;
			_label.verticalAlign = VerticalAlign.CENTER;
		}
		
		if (autoSize == false || percentWidth > 0) {
			if (_label != null) {
				_label.percentWidth = 100;
				//_label.autoSize = false;
				_label.autoSize = _multiline; //if multiline maintain autoSize so Text has the correct height
			}
		}
		
		if (_iconPosition == "left") {
			layout = new HorizontalLayout();
			addChild(_icon);
			addChild(_label);
		} else if (_iconPosition == "right") {
			layout = new HorizontalLayout();
			addChild(_label);
			addChild(_icon);
		} else if (_iconPosition == "top") {
			layout = new VerticalLayout();
			addChild(_icon);
			addChild(_label);
		} else if (_iconPosition == "bottom") {
			layout = new VerticalLayout();
			addChild(_label);
			addChild(_icon);
		} else if (_iconPosition == "center") {
			layout = new BoxLayout();
			addChild(_label);
			addChild(_icon);
		}
		
        if (_iconPosition == "fill" && _icon != null) {
          _icon.width = width;
          _icon.height = height;
        }

		if (layout.usableHeight <= 0) {
			var cy:Float = 0;
			if (_label != null) {
				cy = _label.height + layout.padding.top + layout.padding.bottom;
			}
			if (_icon != null) {
				var temp:Float = _icon.height + layout.padding.top + layout.padding.bottom;
				if (temp > cy) {
					cy = temp;
				}
			}
			height = cy;
		}
        
		invalidate(InvalidationFlag.STYLE);
	}
	
	//******************************************************************************************
	// Overrides
	//******************************************************************************************
	private override function preInitialize():Void {
		super.preInitialize();
	}

	#if html5
	private var _mouseIn:Bool = false;
	#end

	private override function initialize():Void {
		super.initialize();
		
		addEventListener(MouseEvent.MOUSE_OVER, _onMouseOver);
		addEventListener(MouseEvent.MOUSE_OUT, _onMouseOut);
		addEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown);
		addEventListener(MouseEvent.MOUSE_UP, _onMouseUp);
		addEventListener(MouseEvent.CLICK, _onMouseClick);

		#if html5
		addEventListener(MouseEvent.MOUSE_MOVE, function(e:MouseEvent) {
			if (_mouseIn == false) {
				_mouseIn = true;
				var mouseEvent = new MouseEvent(MouseEvent.MOUSE_OVER,
												false, e.cancelable,
												e.localX, e.localY,
												e.relatedObject, e.ctrlKey,
												e.altKey, e.shiftKey,
												e.buttonDown, e.delta,
												e.commandKey, e.clickCount);
				dispatchEvent(mouseEvent);
				Screen.instance.addEventListener(MouseEvent.MOUSE_MOVE, __onScreenMouseMove);
			}
		});
		#end
		
		organiseChildren();
	}
	
	#if html5
	private function __onScreenMouseMove(e:MouseEvent):Void {
		if (_mouseIn == true) {
			if (hitTest(e.stageX, e.stageY) == false) {
				Screen.instance.removeEventListener(MouseEvent.MOUSE_MOVE, __onScreenMouseMove);
				_mouseIn = false;
				var mouseEvent = new MouseEvent(MouseEvent.MOUSE_OUT,
												false, e.cancelable,
												e.localX, e.localY,
												e.relatedObject, e.ctrlKey,
												e.altKey, e.shiftKey,
												e.buttonDown, e.delta,
												e.commandKey, e.clickCount);
				dispatchEvent(mouseEvent);
			}
		}
	}
	#end
	
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
				_label.multiline = _multiline;
				_label.wrapLines = _multiline;
			}
			_label.value = value;
			_label.visible = true;
			organiseChildren();
		} else {
			if (_label != null) {
				_label.visible = false;
			}
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
		} else {
			_down = false;
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
	
	@:clonable
	public var multiline(get, set):Bool;
	
	private function get_iconPosition():String {
		return _iconPosition;
	}
	
	private function set_iconPosition(value:String):String {
		if (_iconPosition != value) {
			_iconPosition = value;
			organiseChildren();
		}
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
			if (_group != null && value == false) { // dont allow false if no other group selection
				var arr:Array<Button> = _groups.get(_group);
				var hasSelection:Bool = false;
				if (arr != null) {
					for (button in arr) {
						if (button != this && button.selected == true) {
							hasSelection = true;
							break;
						}
					}
				}
				if (hasSelection == false) {
					return value;
				}
			}
			
			_selected = value; // makes sense to update selected before dispatching event.
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
	
	private function get_multiline():Bool {
		return _multiline;
	}
	
	private function set_multiline(value:Bool):Bool {
		_multiline = value;
		if (_label != null) {
			_label.multiline = _multiline;
			_label.wrapLines = _multiline;
		}
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
				labelStyle.fontBold = _baseStyle.fontBold;
				labelStyle.fontItalic = _baseStyle.fontItalic;
				labelStyle.fontUnderline = _baseStyle.fontUnderline;
				labelStyle.color = _baseStyle.color;
				labelStyle.textAlign = _baseStyle.textAlign;
				#if html5
				labelStyle.backgroundColor = 0x00FF00;// _baseStyle.backgroundColor;
				labelStyle.backgroundAlpha = 0;// _baseStyle.backgroundColor;
				#end
			}
			_label.baseStyle = labelStyle;
		}
		
		if (_baseStyle != null) {
			if (_baseStyle.icon != null) {
				icon = _baseStyle.icon;
			}
			
			if (_baseStyle.iconPosition != null) {
				iconPosition = _baseStyle.iconPosition;
			}
			
			if (_baseStyle.iconWidth != -1) {
				iconWidth = _baseStyle.iconWidth;
			}
			
			if (_baseStyle.iconHeight != -1) {
				iconHeight = _baseStyle.iconHeight;
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
