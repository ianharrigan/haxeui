package haxe.ui.toolkit.controls.popups;

import haxe.ui.toolkit.controls.Text;

/**
 Basic text popup (resizes based on content)
 **/
class SimplePopupContent extends PopupContent {
	private var _textControl:Text;
	
	public function new(text:String = "") {
		super();
		_autoSize = true;
		_textControl = new Text();
		_textControl.multiline = true;
		_textControl.wrapLines = true;
		_textControl.percentWidth = 100;
		_textControl.text = text;
		_textControl.autoSize = true;
	}
	
	//******************************************************************************************
	// Overrides
	//******************************************************************************************
	private override function initialize():Void {
		super.initialize();
		addChild(_textControl);
		//height = _textControl.height + 10;
	}
}