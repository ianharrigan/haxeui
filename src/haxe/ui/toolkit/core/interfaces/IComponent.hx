package haxe.ui.toolkit.core.interfaces;

interface IComponent extends IStyleableDisplayObject {
	public var text(get, set):String;
	public var clipWidth(get, set):Float;
	public var clipHeight(get, set):Float;
	public var clipContent(get, set):Bool;
	public var disabled(get, set):Bool;
	public var userData(default, default):Dynamic;
}