package haxe.ui.toolkit.controls;

import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.events.Event;
import flash.text.TextField;
import flash.text.TextFormat;
import haxe.ui.toolkit.core.base.State;
import haxe.ui.toolkit.core.Component;
import haxe.ui.toolkit.core.interfaces.IClonable;
import haxe.ui.toolkit.core.interfaces.InvalidationFlag;
import haxe.ui.toolkit.core.interfaces.IStyleableDisplayObject;
import haxe.ui.toolkit.core.StateComponent;
import haxe.ui.toolkit.style.Style;
import haxe.ui.toolkit.text.ITextDisplay;
import haxe.ui.toolkit.text.TextDisplay;
import haxe.ui.toolkit.layout.DefaultLayout;

/**
 Generic editable text component (supports multiline text)
 **/
class TextInput extends StateComponent implements IClonable<TextInput> {
	private var _textDisplay:ITextDisplay;
	private var _textPlaceHolder:Text;
	
	private var _vscroll:VScroll;
	private var _hscroll:HScroll;
	
	public function new() {
		super();
		addStates([State.NORMAL, State.DISABLED]);
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
		
		if (_textPlaceHolder != null && contains(_textPlaceHolder) == false) {
			addChild(_textPlaceHolder);
		}
		
		if (_textPlaceHolder != null) {
			setChildIndex(_textPlaceHolder, 0);
		}
	}

	public override function dispose() {
		_textDisplay.display.removeEventListener(Event.CHANGE, _onTextChange);
		_textDisplay.display.removeEventListener(Event.SCROLL, _onTextScroll);
		sprite.removeChild(_textDisplay.display);
		if (_textPlaceHolder != null && contains(_textPlaceHolder)) {
			removeChild(_textPlaceHolder);
		}
		super.dispose();
	}
	
	public override function invalidate(type:Int = InvalidationFlag.ALL, recursive:Bool = false):Void {
		if (!_ready || _invalidating) {
			return;
		}
		
		super.invalidate(type, recursive);
		_invalidating = true;
		if (type & InvalidationFlag.SIZE == InvalidationFlag.SIZE) {
			checkScrolls();
		}
		_invalidating = false;
	}
	
	private override function set_disabled(value:Bool):Bool {
		super.set_disabled(value);
		if (value == true) {
			_textDisplay.interactive = false;
		} else {
			_textDisplay.interactive = true;
		}
		return value;
	}
	
	//******************************************************************************************
	// Event handlers
	//******************************************************************************************
	private function _onTextChange(event:Event):Void {
		checkScrolls();
		if (_textPlaceHolder != null) {
			_textPlaceHolder.visible = (text.length == 0);
		}
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
	
	private function _onHScrollChange(event:Event):Void {
		var tf:TextField = cast(_textDisplay.display, TextField);
		#if !html5
		tf.scrollH = Std.int(_hscroll.pos);
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
	public override function applyStyle():Void {
		super.applyStyle();
		
		// apply style to TextDisplay
		if (_textDisplay != null) {
			_textDisplay.style = style;
		}
		if (_textPlaceHolder != null) {
			var placeholderStyle:Style = new Style();
			placeholderStyle.merge(style);
			placeholderStyle.borderSize = 0;
			placeholderStyle.backgroundColor = -1;
			placeholderStyle.backgroundImage = null;
			placeholderStyle.padding = 0;
			_textPlaceHolder.style = placeholderStyle;
		}
	}
	
	//******************************************************************************************
	// Component properties 
	//******************************************************************************************
	/**
	 Defines whether or not the text can span more than a single line. Vertical and horizontal scrollbars will be added as needed.
	 **/
	@:clonable
	public var multiline(get, set):Bool;
	/**
	 The start position of the selected text
	 **/
	public var selectionBeginIndex(get, null):Int;
	/**
	 The end position of the selected text
	 **/
	public var selectionEndIndex(get, null):Int;
	/**
	 Sets the currently selected text (if available) to the specified text format
	 **/
	public var selectedTextFormat(get, null):TextFormat;
	@:clonable
	public var wrapLines(get, set):Bool;
	@:clonable
	public var displayAsPassword(get, set):Bool;
	@:clonable
	public var placeholderText(get, set):String;

	private function get_multiline():Bool {
		return _textDisplay.multiline;
	}
	
	private function set_multiline(value:Bool):Bool {
		_textDisplay.wrapLines = value;
		_textDisplay.multiline = value;
		return value;
	}

	private function get_selectionBeginIndex():Int {
		var tf:TextField = cast(_textDisplay.display, TextField);
		var n:Int = 0;
		#if flash
			n = tf.selectionBeginIndex;
		#end
		return n;
	}

	private function get_selectionEndIndex():Int {
		var tf:TextField = cast(_textDisplay.display, TextField);
		var n:Int = 0;
		#if flash
			n = tf.selectionEndIndex;
		#end
		return n;
	}
	
	private function get_selectedTextFormat():TextFormat {
		var tf:TextField = cast(_textDisplay.display, TextField);
		return tf.getTextFormat(selectionBeginIndex - 1, selectionEndIndex);
	}
	
	private function get_wrapLines():Bool {
		return _textDisplay.wrapLines;
	}
	
	private function set_wrapLines(value:Bool):Bool {
		_textDisplay.wrapLines = value;
		return value;
	}
	
	private function get_displayAsPassword():Bool {
		return _textDisplay.displayAsPassword;
	}
	
	private function set_displayAsPassword(value:Bool):Bool {
		_textDisplay.displayAsPassword = value;
		return value;
	}
	
	private function get_placeholderText():String {
		if (_textPlaceHolder == null) {
			return null;
		}
		return _textPlaceHolder.text;
	}
	
	private function set_placeholderText(value:String):String {
		if (_textPlaceHolder == null) {
			_textPlaceHolder = new Text();
			_textPlaceHolder.id = "placeholder";
		}
		_textPlaceHolder.text = value;
		if (_ready && contains(_textPlaceHolder) == false && value != null) {
			trace("addding");
			addChild(_textPlaceHolder);
		}
		if (value == null) {
			if (contains(_textPlaceHolder)) {
				removeChild(_textPlaceHolder);
			}
			_textPlaceHolder = null;
		}
		if (_textPlaceHolder != null) {
			_textPlaceHolder.visible = (text.length == 0);
		}
		return value;
	}
	
	public var vscrollPos(get, set):Float;
	public var vscrollMin(get, null):Float;
	public var vscrollMax(get, null):Float;
	
	private function get_vscrollPos():Float {
		if (_vscroll != null) {
			return _vscroll.pos;
		}
		return 0;
	}
	
	private function set_vscrollPos(value:Float) {
		if (_vscroll != null) {
			_vscroll.pos = value;
		}
		return value;
	}

	private function get_vscrollMin():Float {
		if (_vscroll != null) {
			return _vscroll.min;
		}
		return 0;
	}
	
	private function get_vscrollMax():Float {
		if (_vscroll != null) {
			return _vscroll.max;
		}
		return 0;
	}
	
	//******************************************************************************************
	// Helpers
	//******************************************************************************************
	/**
	 Replaces the selected text (if available) to with the specified string
	 **/
	public function replaceSelectedText(s:String):Void {
		var tf:TextField = cast(_textDisplay.display, TextField);
		#if flash
			tf.replaceSelectedText(s);
		#end
	}
	
	public function focus():Void {
		var tf:TextField = cast(_textDisplay.display, TextField);
		tf.stage.focus = tf;
	}
	
	private function checkScrolls():Void {
		if (multiline == false || ready == false) {
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
		
		if (tf.maxScrollH > 0) {
			if (_hscroll == null) {
				_hscroll = new HScroll();
				_hscroll.percentWidth = 100;
				_hscroll.addEventListener(Event.CHANGE, _onHScrollChange);
				addChild(_hscroll);
			}
			_hscroll.pageSize = ((tf.width - tf.maxScrollH) / tf.width) * tf.maxScrollH;
			_hscroll.min = 0;
			_hscroll.max = tf.maxScrollH;
			_hscroll.pos = tf.scrollH;
			_hscroll.visible = true;
		} else {
			if (_hscroll != null) {
				_hscroll.visible = false;
				_hscroll.pos = 0;
			}
		}
		
		invalidate(InvalidationFlag.LAYOUT);
		#end
	}
}

@exclude
class TextInputLayout extends DefaultLayout {
	public function new() {
		super();
	}
	
	public override function resizeChildren():Void {
		super.resizeChildren();
		if (container.sprite.numChildren > 0) {
			var vscroll:VScroll = container.findChildAs(VScroll);
			
			var text:TextField = findTextField();
			if (text != null) {
				text.x = padding.left;
				if (text.multiline == true) {
					text.y = padding.top;
					text.height = usableHeight;
				} else {
					text.height = text.defaultTextFormat.size + 8;
					text.y = (container.height / 2) - (text.height / 2);
				}
				text.width = usableWidth;
				
				var placeholder:Text = container.findChild("placeholder");
				if (placeholder != null) {
					placeholder.width = text.width;
					placeholder.height = text.height;
				}
			}
		}
	}
	
	public override function repositionChildren():Void {
		super.repositionChildren();
		
		var vscroll:VScroll = container.findChildAs(VScroll);
		if (vscroll != null) {
			vscroll.x = container.width - vscroll.width - padding.right;
		}
		var hscroll:HScroll = container.findChildAs(HScroll);
		if (hscroll != null) {
			hscroll.y = container.height - hscroll.height - padding.bottom;
		}
		
		var text:TextField = findTextField();
		var placeholder:Text = container.findChild("placeholder");
		if (text != null && placeholder != null) {
			placeholder.x = text.x;
			placeholder.y = text.y + 1;
		}
	}
	
	// usable width returns the amount of available space for % size components 
	private override function get_usableWidth():Float {
		var ucx:Float = innerWidth;
		var vscroll:VScroll = container.findChildAs(VScroll);
		if (vscroll != null && vscroll.visible == true) {
			ucx -= vscroll.width + spacingX;
		}
		return ucx;
	}
	
	private override function get_usableHeight():Float {
		var ucy = innerHeight;
		var hscroll:HScroll = container.findChildAs(HScroll);
		if (hscroll != null && hscroll.visible == true) {
			ucy -= hscroll.height - spacingY;
		}
		return ucy;
	}
	
	private function findTextField():TextField {
		var tf:TextField = null;
		for (i in 0...container.sprite.numChildren) {
			var child:DisplayObject = container.sprite.getChildAt(i);
			if (Std.is(child, TextField)) {
				tf = cast(child, TextField);
				break;
			}
		}
		return tf;
	}
}
