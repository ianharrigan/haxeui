package haxe.ui.core.interfaces;
import nme.events.MouseEvent;

interface IDraggable {
	function allowDrag(event:MouseEvent):Bool;
}