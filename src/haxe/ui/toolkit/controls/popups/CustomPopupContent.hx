package haxe.ui.toolkit.controls.popups;

import haxe.ui.toolkit.core.interfaces.IDisplayObject;

/**
 Custom popup content that resizes based on size
 **/
class CustomPopupContent extends PopupContent {
	private var _display:IDisplayObject;
	
	public function new(display:IDisplayObject = null) {
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