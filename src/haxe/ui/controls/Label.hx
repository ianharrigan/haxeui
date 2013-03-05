package haxe.ui.controls;

import nme.text.TextField;
import nme.text.TextFormat;
import nme.text.TextFormatAlign;

import haxe.ui.core.Component;

class Label extends Component {
	private var rawText:String = ""; // cache the text as if you set it before the control is ready you lose font settings
	
	private var textControl:TextField;
	
	public var wordWrap:Bool = false;
	public var textCol(default, setTextCol):Int = 0x000000;
	
	public function new() {
		super();
		addStyleName("Label");
		
		textControl = new TextField();
	}
	
	//************************************************************
	//                  OVERRIDES
	//************************************************************
	public override function initialize():Void {
		super.initialize();
		var format:TextFormat = new TextFormat(currentStyle.fontName, currentStyle.fontSize, currentStyle.color);
		textControl.defaultTextFormat = format;
		textControl.selectable = false;
		textControl.mouseEnabled = false;
		textControl.wordWrap = wordWrap;
		textControl.text = rawText;
		addChild(textControl);
		sizeTextControl();
	}

	public override function applyStyle():Void {
		//super.applyStyle();
		
		if (currentStyle.color != null) {
			textCol = currentStyle.color;	
		}
		
		if (currentStyle.fontSize != null) {
			textControl.setTextFormat(new TextFormat(currentStyle.fontName, currentStyle.fontSize, currentStyle.color));
		}
		
		sizeTextControl();
	}
	
	//************************************************************
	//                  GETTERS AND SETTERS
	//************************************************************
	public function setTextCol(value:Int):Int {
		textCol = value;
		currentStyle.color = value;
		var format:TextFormat = new TextFormat(currentStyle.fontName, currentStyle.fontSize, currentStyle.color);
		textControl.setTextFormat(format);
		return value;
	}
	
	public override function getText():String {
		return textControl.text;
	}
	
	public override function setText(value:String):String {
		rawText = value;
		if (ready == true) {
			textControl.text = value;
		}
		return value;
	}
	
	//************************************************************
	//                  HELPERS
	//************************************************************
	private function sizeTextControl():Void {
		if (wordWrap == false) {
			if (text.length == 0) {
				textControl.width = 0;
				textControl.height = 0;
			} else {
				textControl.width = textControl.textWidth + 4;
				textControl.height = textControl.textHeight + 4;
			}
		} else {
			if (width != 0) {
				textControl.width = width - (padding.left + padding.right);
			}
			if (height != 0) {
				textControl.height = height - (padding.top + padding.bottom);
			}
		}
		
		if (width == 0) {
			width = textControl.width + (padding.left + padding.right);
		}
		if (height == 0) {
			height = textControl.height + (padding.top + padding.bottom);
		}
		textControl.x = padding.left;
		textControl.y = padding.top;
	}
}