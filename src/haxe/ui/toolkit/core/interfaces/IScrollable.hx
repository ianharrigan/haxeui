package haxe.ui.toolkit.core.interfaces;

interface IScrollable { // x values are hscroll values, y values are vscroll values
	public var pos(get, set):Float;
	public var min(get, set):Float;
	public var max(get, set):Float;
	public var pageSize(get, set):Float;
	public var incrementSize(get, set):Float;
}