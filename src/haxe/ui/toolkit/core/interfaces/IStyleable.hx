package haxe.ui.toolkit.core.interfaces;

interface IStyleable {
	public var id(get, set):String;
	public var style(get, set):Dynamic;

	private function storeStyle(id:String, value:Dynamic):Void; // hold onto a style
	private function retrieveStyle(id:String):Dynamic; // get style back
	
	private function applyStyle():Void;
	private function buildStyles():Void;
}