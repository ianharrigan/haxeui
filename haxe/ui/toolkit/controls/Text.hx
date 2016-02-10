package haxe.ui.toolkit.controls;

import haxe.ui.toolkit.core.interfaces.IClonable;
import haxe.ui.toolkit.core.interfaces.InvalidationFlag;
import haxe.ui.toolkit.core.StateComponent;
import haxe.ui.toolkit.layout.BoxLayout;
import haxe.ui.toolkit.text.ITextDisplay;
import haxe.ui.toolkit.text.TextDisplay;

/**
 Generic non-editable text component (supports multiline text)
 **/
class Text extends StateComponent implements IClonable<Text> {
	private var _textDisplay:ITextDisplay;

    /*
	#if (html5 && dom)
    private static inline var HEIGHT_FIX:Int = 2;
	#elseif (html5 && !dom)
    private static inline var HEIGHT_FIX:Int = 2;
    #else
    private static inline var HEIGHT_FIX:Int = 0;
    #end
    */
    
	public function new() {
		super();
		_valign = "center";
		autoSize = true;
		_textDisplay = new TextDisplay();
		_textDisplay.text = "";
	}
	
	//******************************************************************************************
	// Overrides
	//******************************************************************************************
	private override function initialize():Void {
		super.initialize();
		
		sprite.addChild(_textDisplay.display);
		_textDisplay.autoSize = autoSize;
		_textDisplay.text = text;

		if (autoSize == true) {
			if (width == 0) {
				width = _textDisplay.display.width;
			}
			if (height == 0) {
				height = _textDisplay.display.height;
			}
		}
	}
	
	public override function dispose() {
		if (sprite.contains(_textDisplay.display)) {
			sprite.removeChild(_textDisplay.display);
		}
		super.dispose();
	}
	
	public override function invalidate(type:Int = InvalidationFlag.ALL, recursive:Bool = false):Void {
		if (!_ready || _invalidating) {
			return;
		}

		super.invalidate(type, recursive);
		_invalidating = true;
		if (type & InvalidationFlag.SIZE == InvalidationFlag.SIZE && _autoSize == false) {
			_textDisplay.display.width = layout.innerWidth;
			_textDisplay.display.height = layout.innerHeight;
		}
		_invalidating = false;
	}
	
	//******************************************************************************************
	// Component overrides
	//******************************************************************************************
	private override function get_text():String {
		return _textDisplay.text;
	}
	
	private override function set_text(value:String):String {
		value = super.set_text(value);
		//_textDisplay.multiline = true;
		_textDisplay.text = value;
		if (autoSize == true) {
			width = _textDisplay.display.width;
			height = _textDisplay.display.height + heightFix();
		} 
		return value;
	}
	
	private override function set_autoSize(value:Bool):Bool {
		value = super.set_autoSize(value);
		if (_textDisplay != null) {
			_textDisplay.autoSize = value;
		}
		return value;
	}
	
	private override function set_width(value:Float):Float {
		super.set_width(value);
		_textDisplay.display.width = value;
		_textDisplay.text = text;
		height = _textDisplay.display.height + heightFix();
		//trace(height);
		return value;
	}
	
	//******************************************************************************************
	// IStyleable
	//******************************************************************************************
	public override function applyStyle():Void {
		super.applyStyle();

		// apply style to TextDisplay
		if (_textDisplay != null) {
			_textDisplay.style = _baseStyle;
			if (autoSize == true) {
				width = _textDisplay.display.width;
				height = _textDisplay.display.height + heightFix();
			}
		}
	}
	
    private function heightFix():Float {
        var fs:Float = -1;
        if (_baseStyle != null) {
            fs = _baseStyle.fontSize;
        }
        var fix:Float = 0;

        #if (html5 && dom)
        
        fix = 2;
        
        #elseif (html5 && !dom)
        
        if (fs <= 14) {
            fix = 6;
        } else if (fs > 14 && fs <= 18) {
            fix = 6;
        } else if (fs > 18) {
            fix = 6;
        }
        
        fix -= 4;
        
        #end
        
        return fix;
    }
    
	//******************************************************************************************
	// Getters/setters
	//******************************************************************************************
	/**
	 Defines whether or not the text can span more than a single line
	 **/
	@:clonable
	public var multiline(get, set):Bool;
	@:clonable
	public var wrapLines(get, set):Bool;
	@:clonable
	public var selectable(get, set):Bool;
	@:clonable
	public var textAlign(get, set):String;
	
	private function get_multiline():Bool {
		return _textDisplay.multiline;
	}
	
	private function set_multiline(value:Bool):Bool {
		_textDisplay.multiline = value;
		return value;
	}
	
	private function get_wrapLines():Bool {
		return _textDisplay.wrapLines;
	}
	
	private function set_wrapLines(value:Bool):Bool {
		_textDisplay.wrapLines = value;
		return value;
	}
	
	private function get_selectable():Bool {
		return _textDisplay.selectable;
	}
	
	private function set_selectable(value:Bool):Bool {
		return _textDisplay.selectable = value;
	}
	
	private function get_textAlign():String {
		if (_textDisplay == null) {
			return null;
		}
		return _textDisplay.textAlign;
	}
	
	private function set_textAlign(value:String):String {
		if (_textDisplay != null) {
			_textDisplay.textAlign = value;
		}
		return value;
	}
}
