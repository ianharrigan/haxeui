package haxe.ui.toolkit.controls.extended;

import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;
import haxe.ui.toolkit.controls.TextInput;
import haxe.ui.toolkit.resources.ResourceManager;

/**
 Basic rich text editor
 
 Note - The `RTF` class does not contain the controls to apply styles to the text, merely the functions. For a full rich text editor (including controls) see `RTFView`.
 **/
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
	/**
	 Gets or sets the rich text of the editor from a html string
	**/
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
	/**
	 Sets the currently selected text to bold
	 **/
	public function bold():Void {
		applyRTFStyle("bold");
	}
	
	/**
	 Sets the currently selected text to italic
	 **/
	public function italic():Void {
		applyRTFStyle("italic");
	}

	/**
	 Sets the currently selected text to underlined
	 **/
	public function underline():Void {
		applyRTFStyle("underline");
	}
	
	/**
	 Sets the currently selected text to the specified font size
	 **/
	public function fontSize(size:Int):Void {
		applyRTFStyle("fontSize", size);
	}
	
	/**
	 Sets the currently selected text to the specified font name
	 **/
	public function fontName(name:String):Void {
		applyRTFStyle("fontName", name);
	}
	
	/**
	 Formats the currently selected text as bullet points
	 **/
	public function bullet():Void {
		applyRTFStyle("bullet");
	}

	/**
	 Horizontally aligns the currently selected text to the left
	 **/
	public function alignLeft():Void {
		applyRTFStyle("align", "left");
	}

	/**
	 Horizontally aligns the currently selected text to the center
	 **/
	public function alignCenter():Void {
		applyRTFStyle("align", "center");
	}

	/**
	 Horizontally aligns the currently selected text to the right
	 **/
	public function alignRight():Void {
		applyRTFStyle("align", "right");
	}

	/**
	 Horizontally justifies the currently selected text
	 **/
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