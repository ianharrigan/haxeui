package haxe.ui.toolkit.controls.popups;

class BusyPopupContent extends SimplePopupContent {

	public function new(text:String) {
		super(text);
	}
	
	//******************************************************************************************
	// Overrides
	//******************************************************************************************
	private override function initialize():Void {
		addChild(_textControl);
	}
}