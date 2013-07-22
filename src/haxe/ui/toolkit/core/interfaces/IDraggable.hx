package haxe.ui.toolkit.core.interfaces;

import flash.events.MouseEvent;

interface IDraggable {
	public function allowDrag(event:MouseEvent):Bool;
}