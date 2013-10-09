package haxe.ui.toolkit.core.interfaces;

import haxe.ui.toolkit.style.Style;

interface IStyleable {
	public var id(get, set):String;
	public var style(get, set):Style;

	private function storeStyle(id:String, value:Style):Void; // hold onto a style
	private function retrieveStyle(id:String):Style; // get style back
	
	private function applyStyle():Void;
	private function buildStyles():Void;
}