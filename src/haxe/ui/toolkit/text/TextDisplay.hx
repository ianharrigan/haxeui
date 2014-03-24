package haxe.ui.toolkit.text;

import flash.display.DisplayObject;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFieldType;
import flash.text.TextFormat;
import haxe.ui.toolkit.style.Style;

class TextDisplay implements ITextDisplay {
	#if html5
	private static inline var X_PADDING:Int = 0;
	private static inline var Y_PADDING:Int = 2;
	#else
	private static inline var X_PADDING:Int = 4;
	private static inline var Y_PADDING:Int = 4;
	#end
	
	private var _style:Style;
	private var _tf:TextField; 
	
	public function new() {
		_tf = new TextField();
		_tf.type = TextFieldType.DYNAMIC;
		_tf.selectable = false;
		_tf.multiline = false;
		_tf.mouseEnabled = false;
		_tf.wordWrap = false;
		_tf.autoSize = TextFieldAutoSize.NONE;
		_tf.text = "";
	}
	
	//******************************************************************************************
	// ITextDisplay
	//******************************************************************************************
	public var text(get, set):String;
	public var style(get, set):Style;
	public var display(get, null):DisplayObject;
	public var interactive(get, set):Bool;
	public var multiline(get, set):Bool;
	public var wrapLines(get, set):Bool;
	public var displayAsPassword(get, set):Bool;
	public var visible(get, set):Bool;
	public var selectable(get, set):Bool;
	public var mouseEnabled(get, set):Bool;

	private function get_text():String {
		return _tf.text;
	}
	
	private function set_text(value:String):String {
		if (value != null) {
			if (_tf.multiline == false) {
				_tf.text = StringTools.replace(value, "\\n", "\n");
			} else {
				_tf.text = StringTools.replace(value, "\\n", "\n");
			}
		}
		
		style = _style;
		if (value != null && value.length > 0) {
			if (_tf.type == TextFieldType.DYNAMIC && _tf.multiline == false) {
				_tf.width = _tf.textWidth + X_PADDING;
				_tf.height = _tf.textHeight + Y_PADDING;
			} else if (_tf.type == TextFieldType.DYNAMIC && _tf.multiline == true) {
				_tf.height = _tf.textHeight + Y_PADDING;
			} else if (_tf.type == TextFieldType.INPUT && _tf.multiline == false) {
				//_tf.width = _tf.textWidth + 4;
				//_tf.height = _tf.textHeight + 4;
			}
		} else {
			if (_tf.type == TextFieldType.DYNAMIC) {
				_tf.width = 0;
				_tf.height = 0;
			} else if (_tf.type == TextFieldType.INPUT && _tf.multiline == false) {
			}
		}
		return value;
	}
	
	private function get_style():Style {
		return _style;
	}
	
	private function set_style(value:Style):Style {
		if (value == null) {
			return value;
		}
		_style = value;
		var format:TextFormat = _tf.getTextFormat();
		if (_style.fontName != null) {
			_tf.embedFonts = _style.fontEmbedded;
			format.font = _style.fontName;
		}
		if (_style.fontSize != -1) {
			format.size = _style.fontSize;
		}
		if (_style.color != -1) {
			format.color = _style.color;
		}

		_tf.defaultTextFormat = format;
		_tf.setTextFormat(format);
		
		if (text.length > 0) {
			if (_tf.type == TextFieldType.DYNAMIC && _tf.multiline == false) {
				_tf.width = _tf.textWidth + X_PADDING;
				_tf.height = _tf.textHeight + Y_PADDING;
			} else if (_tf.type == TextFieldType.DYNAMIC && _tf.multiline == true) {
				_tf.height = _tf.textHeight + Y_PADDING;
			} else if (_tf.type == TextFieldType.INPUT && _tf.multiline == false) {
				//_tf.width = _tf.textWidth + 4;
				//_tf.height = _tf.textHeight + 4;
			}
		}
		
		return value;
	}
	
	private function get_display():DisplayObject {
		return _tf;
	}
	
	private function get_interactive():Bool {
		return _tf.type == TextFieldType.INPUT;
	}
	
	private function set_interactive(value:Bool):Bool {
		if (value == true) {
			_tf.type = TextFieldType.INPUT;
			_tf.selectable = true;
			_tf.mouseEnabled = true;
		} else {
			_tf.type = TextFieldType.DYNAMIC;
			_tf.selectable = false;
			_tf.mouseEnabled = false;
		}
		return value;
	}
	
	private function get_multiline():Bool {
		return _tf.multiline;
	}
	
	private function set_multiline(value:Bool):Bool {
		_tf.multiline = value;
		return value;
	}
	
	private function get_wrapLines():Bool {
		return _tf.wordWrap;
	}
	
	private function set_wrapLines(value:Bool):Bool {
		_tf.wordWrap = value;
		return value;
	}
	
	private function get_displayAsPassword():Bool {
		return _tf.displayAsPassword;
	}
	
	private function set_displayAsPassword(value:Bool):Bool {
		_tf.displayAsPassword = value;
		return value;
	}

	private function get_visible():Bool {
		return _tf.visible;
	}
	
	private function set_visible(value:Bool):Bool {
		_tf.visible = value;
		return value;
	}
	
	private function get_selectable():Bool {
		return _tf.selectable;
	}
	
	private function set_selectable(value:Bool):Bool {
		return _tf.selectable = value;
	}
	
	private function get_mouseEnabled():Bool {
		return _tf.mouseEnabled;
	}
	
	private function set_mouseEnabled(value:Bool):Bool {
		return _tf.mouseEnabled = value;
	}
}
