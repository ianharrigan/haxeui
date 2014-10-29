package haxe.ui.toolkit.core.interfaces;

import openfl.events.MouseEvent;

interface IDraggable {
	public function allowDrag(event:MouseEvent):Bool;
}