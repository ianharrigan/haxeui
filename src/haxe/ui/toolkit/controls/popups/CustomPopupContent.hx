package haxe.ui.toolkit.controls.popups;

import haxe.ui.toolkit.core.interfaces.IDisplayObject;

class CustomPopupContent extends PopupContent {
	private var _display:IDisplayObject;
	
	public function new(display:IDisplayObject) {
		super();
		
		_display = display;
	}
	
	//******************************************************************************************
	// Overrides
	//******************************************************************************************
	private override function initialize():Void {
		super.initialize();
		addChild(_display);
		height = _display.height;
	}
}