package haxe.ui.toolkit.core.interfaces;

import flash.geom.Rectangle;

interface ILayout {
	public var container(get, set):IDisplayObjectContainer;
	public var padding(get, set):Rectangle;
	public var spacingX(get, set):Int;
	public var spacingY(get, set):Int;
	
	public var innerWidth(get, null):Float;
	public var innerHeight(get, null):Float;
	public var usableWidth(get, null):Float;
	public var usableHeight(get, null):Float;
	
	public function refresh():Void;
	private function resizeChildren():Void;
	private function repositionChildren():Void;
}