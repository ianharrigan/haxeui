package haxe.ui.toolkit.core.interfaces;

interface IItemRenderer extends IStateComponent {
	public var hash(default, default):String;
	public var eventDispatcher(default, default):IEventDispatcher;
	public var data(get, set):Dynamic;
	public function allowSelection(stageX:Float, stageY:Float):Bool;
	public function update():Void;
}