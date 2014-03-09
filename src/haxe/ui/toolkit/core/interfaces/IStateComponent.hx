package haxe.ui.toolkit.core.interfaces;

interface IStateComponent extends IComponent {
	public var state(get, set):String;
	public var states(get, null):Array<String>;
	public function hasState(state:String):Bool;
}