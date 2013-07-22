package haxe.ui.toolkit.core.interfaces;

import flash.display.Graphics;

interface IDrawable { // Component has a redrawable device context
	public var graphics(get, null):Graphics;
	private function paint():Void;
}