package haxe.ui.toolkit.controls;

import flash.events.Event;
import flash.text.TextField;
import haxe.ui.toolkit.core.Component;
import haxe.ui.toolkit.core.interfaces.IStyleable;
import haxe.ui.toolkit.core.StateComponent;
import haxe.ui.toolkit.text.ITextDisplay;
import haxe.ui.toolkit.text.TextDisplay;
import haxe.ui.toolkit.layout.DefaultLayout;

class TextInput extends StateComponent {
	private var _textDisplay:ITextDisplay;
	
	private var _vscroll:VScroll;
	
	public function new() {
		super();
		_layout = new TextInputLayout();
		_textDisplay = new TextDisplay();
		_textDisplay.interactive = true;
		_textDisplay.text = "";
	}
	
	//******************************************************************************************
	// Overrides
	//******************************************************************************************
	private override function preInitialize():Void {
		super.preInitialize();
	}
	
	private override function initialize():Void {
		super.initialize();
		
		sprite.addChild(_textDisplay.display);
		
		if (multiline == true) {
			_textDisplay.display.width = _layout.innerWidth;
			_textDisplay.display.height = _layout.innerHeight;
		}
		
		_textDisplay.display.addEventListener(Event.CHANGE, _onTextChange);
		_textDisplay.display.addEventListener(Event.SCROLL, _onTextScroll);
		checkScrolls();		
	}

	public override function dispose() {
		_textDisplay.display.removeEventListener(Event.CHANGE, _onTextChange);
		_textDisplay.display.removeEventListener(Event.SCROLL, _onTextScroll);
		sprite.removeChild(_textDisplay.display);
		super.dispose();
	}
	
	//******************************************************************************************
	// Event handlers
	//******************************************************************************************
	private function _onTextChange(event:Event):Void {
		checkScrolls();
	}

	private function _onTextScroll(event:Event):Void {
		checkScrolls();
	}
	
	private function _onVScrollChange(event:Event):Void {
		var tf:TextField = cast(_textDisplay.display, TextField);
		//trace("pos = " + _vscroll.pos + ", min = " + _vscroll.min + ", max = " + _vscroll.max);
		#if !html5
		tf.scrollV = Std.int(_vscroll.pos);
		#end
	}
	//******************************************************************************************
	// Component overrides
	//******************************************************************************************
	private override function get_text():String {
		return _textDisplay.text;
	}
	
	private override function set_text(value:String):String {
		value = super.set_text(value);
		_textDisplay.text = value;
		
		return value;
	}
	
	//******************************************************************************************
	// IStyleable
	//******************************************************************************************
	private override function applyStyle():Void {
		super.applyStyle();
		
		// apply style to TextDisplay
		if (_textDisplay != null) {
			_textDisplay.style = style;
		}
	}
	
	//******************************************************************************************
	// Component properties 
	//******************************************************************************************
	public var multiline(get, set):Bool;
	
	private function get_multiline():Bool {
		return _textDisplay.multiline;
	}
	
	private function set_multiline(value:Bool):Bool {
		_textDisplay.multiline = value;
		return value;
	}
	
	//******************************************************************************************
	// Helpers
	//******************************************************************************************
	private function checkScrolls():Void {
		if (multiline == false) {
			return;
		}
		
		#if !html5
		var tf:TextField = cast(_textDisplay.display, TextField);
		var visibleLines:Int = (tf.bottomScrollV - tf.scrollV) + 1;
		if (tf.maxScrollV > 1) {
			if (_vscroll == null) {
				_vscroll = new VScroll();
				_vscroll.percentHeight = 100;
				_vscroll.addEventListener(Event.CHANGE, _onVScrollChange);
				addChild(_vscroll);
			}
			_vscroll.pageSize = (visibleLines / tf.numLines) * (tf.maxScrollV - 1);
			_vscroll.min = 1;
			_vscroll.max = tf.maxScrollV;
			_vscroll.incrementSize = 1;
			_vscroll.pos = tf.scrollV;
			_vscroll.visible = true;
		} else {
			if (_vscroll != null) {
				_vscroll.visible = false;
				_vscroll.pos = 0;
			}
		}
		#end
	}
}

private class TextInputLayout extends DefaultLayout {
	public function new() {
		super();
	}
	
	public override function resizeChildren():Void {
		super.resizeChildren();
		if (container.sprite.numChildren > 0) {
			var vscroll:VScroll = container.findChildAs(VScroll);
			
			var text:TextField = cast(container.sprite.getChildAt(0), TextField);
			if (text != null) {
				text.x = padding.left;
				if (text.multiline == true) {
					text.y = padding.top;
					text.height = innerHeight;
				} else {
					text.height = text.defaultTextFormat.size + 8;
					text.y = (container.height / 2) - (text.height / 2);
				}
				text.width = innerWidth;
			}
		}
	}
	
	public override function repositionChildren():Void {
		super.repositionChildren();
		
		var vscroll:VScroll =  container.findChildAs(VScroll);
		if (vscroll != null) {
			vscroll.x = container.width - vscroll.width - padding.right;
		}
	}
	
	// usable width returns the amount of available space for % size components 
	private override function get_usableWidth():Float {
		var ucx:Float = innerWidth;
		var vscroll:VScroll =  container.findChildAs(VScroll);
		if (vscroll != null && vscroll.visible == true) {
			ucx -= vscroll.width + spacingX;
		}
		return ucx;
	}
}