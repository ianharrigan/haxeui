package haxe.ui.toolkit.core.interfaces;

import haxe.ui.toolkit.style.Style;

interface IStyleableDisplayObject extends IDisplayObjectContainer {
	public var id(get, set):String;
	public var style(get, set):Style;
	public var styleName(get, set):String;

	private function storeStyle(id:String, value:Style):Void; // hold onto a style
	private function retrieveStyle(id:String):Style; // get style back
	
	public function applyStyle():Void;
	private function buildStyles():Void;
}