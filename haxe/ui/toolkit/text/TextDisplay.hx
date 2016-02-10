package haxe.ui.toolkit.text;

import haxe.ui.toolkit.util.CallStackHelper;
import openfl.display.DisplayObject;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFieldType;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;
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
	private var _autoSize:Bool = true;
	
	public function new() {
		_tf = new TextField();
		_tf.type = TextFieldType.DYNAMIC;
		_tf.selectable = false;
		_tf.multiline = false;
		_tf.mouseEnabled = false;
		_tf.wordWrap = false;
		_tf.autoSize = TextFieldAutoSize.LEFT;
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
	public var autoSize(get, set):Bool;
	public var textAlign(get, set):String;
	public var maxChars(get, set):Int;
	public var restrictChars(get, set):String;
	
	private function get_text():String {
		return _tf.text;
	}
	
	private function set_text(value:String):String {
		if (value != null) {
            #if (html5 && dom)
			value = StringTools.replace(value, "\\n", "\n");
            if (multiline == true) {
			    value = StringTools.replace(value, "\n", "<br/>");
            }
			_tf.text = value;
            #else
			_tf.text = StringTools.replace(value, "\\n", "\n");
            #end
		}
		
		style = _style;
		
		#if (html5 && !dom)
		if (_tf.height != _tf.textHeight) {
			_tf.height = _tf.textHeight + 2;
		}
		#end

		#if (html5 && dom)
		if (Std.int(_tf.height) != Std.int(_tf.textHeight)) {
			_tf.height = Std.int(_tf.textHeight);
		}
		#end
		
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
		var fontName:String = _style.fontName;
		if (fontName != null) {
			#if html5
			if (fontName == "_sans") {
				fontName = "Tahoma";
			}
			#end
			_tf.embedFonts = _style.fontEmbedded;
			format.font = fontName;
		}
		if (_style.fontSize != -1) {
			format.size = cast _style.fontSize;
		}
		if (_style.color != -1) {
			format.color = _style.color;
		}
		format.bold = _style.fontBold;
		format.italic = _style.fontItalic;
		format.underline = _style.fontUnderline;
		_tf.defaultTextFormat = format;
		_tf.setTextFormat(format);
		if (_style.textAlign != null) {
			textAlign = _style.textAlign;
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
		_tf.mouseEnabled = value;
		return _tf.selectable = value;
	}
	
	private function get_autoSize():Bool {
		return _tf.autoSize != TextFieldAutoSize.NONE;
	}
	
	private function set_autoSize(value:Bool):Bool {
		if (value == true) {
			_tf.autoSize = TextFieldAutoSize.LEFT;
		} else {
			_tf.autoSize = TextFieldAutoSize.NONE;
		}
		return value;
	}
	
	private function get_textAlign():String {
		var format:TextFormat = _tf.getTextFormat();
		var align:String = "left";
		switch (format.align) {
			case TextFormatAlign.LEFT:
				align = "left";
			case TextFormatAlign.CENTER:
				align = "center";
			case TextFormatAlign.RIGHT:
				align = "right";
			default:
				align = "left";
		}
		return align;
	}
	
	private function set_textAlign(value:String):String {
		var format:TextFormat = _tf.getTextFormat();
		switch (value) {
			case "left":
				format.align = TextFormatAlign.LEFT;
			case "center":
				format.align = TextFormatAlign.CENTER;
			case "right":
				format.align = TextFormatAlign.RIGHT;
			default:
				format.align = TextFormatAlign.LEFT;
		}
		_tf.defaultTextFormat = format;
		_tf.setTextFormat(format);
		return value;
	}
	
	private function get_maxChars():Int {
		return _tf.maxChars;
	}
	
	private function set_maxChars(value:Int):Int {
		return _tf.maxChars = value;
	}

	
	private function get_restrictChars():String {
		#if flash
		return _tf.restrict;
		#else
		return null;
		#end
	}
	
	private function set_restrictChars(value:String):String {
		#if flash
		return _tf.restrict = value;
		#else
		return value;
		#end
	}
}
