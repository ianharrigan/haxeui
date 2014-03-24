package haxe.ui.toolkit.text;

import flash.display.DisplayObject;
import haxe.ui.toolkit.style.Style;

interface ITextDisplay {
	public var text(get, set):String;
	public var style(get, set):Style;
	public var display(get, null):DisplayObject;
	public var interactive(get, set):Bool;
	public var multiline(get, set):Bool;
	public var wrapLines(get, set):Bool;
	public var displayAsPassword(get, set):Bool;
	public var visible(get, set):Bool;
	public var selectable(get, set):Bool;
	public var mouseEnabled(get, set):Bool;
}