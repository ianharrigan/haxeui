package haxe.ui.toolkit.text;

import flash.display.DisplayObject;

interface ITextDisplay {
	public var text(get, set):String;
	public var style(get, set):Dynamic;
	public var display(get, null):DisplayObject;
	public var interactive(get, set):Bool;
	public var multiline(get, set):Bool;
}