package haxe.ui.toolkit.controls.extended;

import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;
import haxe.ui.toolkit.controls.TextInput;
import haxe.ui.toolkit.resources.ResourceManager;

class RTF extends TextInput {
	public function new() {
		super();
		multiline = true;
		var tf:TextField = cast(_textDisplay.display, TextField);
		#if flash
		tf.alwaysShowSelection = true;
		#end
	}
	
	//******************************************************************************************
	// Properties
	//******************************************************************************************
	public var htmlText(get, set):String;
	
	private function get_htmlText():String {
		var tf:TextField = cast(_textDisplay.display, TextField);
		return tf.htmlText;
	}
	
	private function set_htmlText(value:String):String {
		if (StringTools.startsWith(value, "asset://")) {
			var assetId:String = value.substr(8, value.length);
			value = ResourceManager.instance.getText(assetId);
			value = StringTools.replace(value, "\r", "");
		}		
		var tf:TextField = cast(_textDisplay.display, TextField);
		tf.htmlText = value;
		return value;
	}
	
	//******************************************************************************************
	// Methods
	//******************************************************************************************
	public function bold():Void {
		applyRTFStyle("bold");
	}
	
	public function italic():Void {
		applyRTFStyle("italic");
	}

	public function underline():Void {
		applyRTFStyle("underline");
	}
	
	public function fontSize(size:Int):Void {
		applyRTFStyle("fontSize", size);
	}
	
	public function fontName(name:String):Void {
		applyRTFStyle("fontName", name);
	}
	
	public function bullet():Void {
		applyRTFStyle("bullet");
	}

	public function alignLeft():Void {
		applyRTFStyle("align", "left");
	}

	public function alignCenter():Void {
		applyRTFStyle("align", "center");
	}

	public function alignRight():Void {
		applyRTFStyle("align", "right");
	}

	public function alignJustify():Void {
		applyRTFStyle("align", "justify");
	}
	
	private function applyRTFStyle(what:String, value:Dynamic = null):Void {
		if (selectionBeginIndex == 0 && selectionEndIndex == 0) {
			return;
		}

		if (selectionBeginIndex == selectionEndIndex) {
			return;
		}
		
		var tf:TextField = cast(_textDisplay.display, TextField);
		var format:TextFormat = tf.getTextFormat(selectionBeginIndex, selectionEndIndex);
		switch (what) {
			case "bold":
					format.bold = !format.bold;
			case "italic":
					format.italic = !format.italic;
			case "underline":
					format.underline = !format.underline;
			case "fontSize":
					format.size = cast(value, Int);
			case "fontName":
					format.font = cast(value, String);
			case "bullet":
					format.bullet = !format.bullet;
			case "align":
					#if flash
						var align:TextFormatAlign = TextFormatAlign.LEFT;
						var textAlign:String = cast(value, String);
						if (textAlign == "center") {
							align = TextFormatAlign.CENTER;
						} else if (textAlign == "right") {
							align = TextFormatAlign.RIGHT;
						} else if (textAlign == "justify") {
							align = TextFormatAlign.JUSTIFY;
						}
					#else
						var align:String = cast(value, String);
					#end
					format.align = align;
			default:
		}
		
		tf.setTextFormat(format, selectionBeginIndex, selectionEndIndex);
	}
}