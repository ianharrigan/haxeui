package haxe.ui.toolkit.controls.extended;

import flash.text.TextField;
import flash.text.TextFormat;
import haxe.ui.toolkit.controls.TextInput;

class RTF extends TextInput {
	public function new() {
		super();
		multiline = true;
		var tf:TextField = cast(_textDisplay.display, TextField);
		#if flash
		tf.alwaysShowSelection = true;
		#end
	}
	
	public function bold():Void {
		var tf:TextField = cast(_textDisplay.display, TextField);
		#if flash
		var s1:Int = tf.selectionBeginIndex;
		var s2:Int = tf.selectionEndIndex;
		#else
		var s1:Int = 0;
		var s2:Int = 0;
		#end 
		var format:TextFormat = tf.getTextFormat(s1, s2);
		format.bold = true;
		tf.setTextFormat(format, s1, s2);
	}
	
	public function italic():Void {
		var tf:TextField = cast(_textDisplay.display, TextField);
		#if flash
		var s1:Int = tf.selectionBeginIndex;
		var s2:Int = tf.selectionEndIndex;
		#else
		var s1:Int = 0;
		var s2:Int = 0;
		#end 
		var format:TextFormat = tf.getTextFormat(s1, s2);
		format.italic = true;
		tf.setTextFormat(format, s1, s2);
	}
	
	public function fontSize(size:Int):Void {
		var tf:TextField = cast(_textDisplay.display, TextField);
		#if flash
		var s1:Int = tf.selectionBeginIndex;
		var s2:Int = tf.selectionEndIndex;
		#else
		var s1:Int = 0;
		var s2:Int = 0;
		#end 
		var format:TextFormat = tf.getTextFormat(s1, s2);
		format.size = size;
		tf.setTextFormat(format, s1, s2);
	}
	
	public function fontName(name:String):Void {
		var tf:TextField = cast(_textDisplay.display, TextField);
		#if flash
		var s1:Int = tf.selectionBeginIndex;
		var s2:Int = tf.selectionEndIndex;
		#else
		var s1:Int = 0;
		var s2:Int = 0;
		#end 
		var format:TextFormat = tf.getTextFormat(s1, s2);
		format.font = name;
		tf.setTextFormat(format, s1, s2);
	}
}