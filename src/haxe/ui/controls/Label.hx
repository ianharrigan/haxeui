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
			if (autoSize == true) {
				sizeTextControl();
			}
		}
		return value;
	}
	
	//************************************************************
	//                  HELPERS
	//************************************************************
	private function sizeTextControl():Void {
		if (ready == false) {
			return;
		}
		
		if (wordWrap == false) {
			if (text.length == 0) {
				textControl.width = 0;
				textControl.height = 0;
			} else {
				textControl.width = textControl.textWidth + 4;
				textControl.height = textControl.textHeight + 4;
			}
		} else {
			//textControl.width = textControl.textWidth + 4;
			//textControl.height = textControl.textHeight + 4;
			if (width != 0) {
				textControl.width = width - (layout.padding.left + layout.padding.right);
			}
			/*
			if (height != 0) {
				textControl.height = height - (layout.padding.top + layout.padding.bottom);
				if (height > textControl.textHeight + 4) {
					textControl.height = textControl.textHeight;
				}
			}
			*/
			textControl.height = textControl.textHeight + 4;
		}
		
		width = textControl.width + (layout.padding.left + layout.padding.right);
		height = textControl.height + (layout.padding.top + layout.padding.bottom);
		
		textControl.x = layout.padding.left;
		textControl.y = layout.padding.top;
	}
}