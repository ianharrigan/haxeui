package haxe.ui.toolkit.controls.popups;

import haxe.ui.toolkit.containers.VBox;

/**
 Empty popup content
 **/
class PopupContent extends VBox {
	public var popup(default, default):Popup;
	
	public function new() {
		super();
	}
	
	public function onButtonClicked(button:Int):Bool {
		return true;
	}
}