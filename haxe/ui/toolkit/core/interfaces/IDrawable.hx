package haxe.ui.toolkit.core.interfaces;

import openfl.display.Graphics;

interface IDrawable { // Component has a redrawable device context
	public var graphics(get, null):Graphics;
	private function paint():Void;
}