package haxe.ui.toolkit.controls.popups;

import haxe.ui.toolkit.controls.Text;

class SimplePopupContent extends PopupContent {
	private var _textControl:Text;
	
	public function new(text:String) {
		super();
		_autoSize = false;
		_textControl = new Text();
		_textControl.text = text;
	}
	
	//******************************************************************************************
	// Overrides
	//******************************************************************************************
	private override function initialize():Void {
		super.initialize();
		addChild(_textControl);
		height = _textControl.height;
	}
}