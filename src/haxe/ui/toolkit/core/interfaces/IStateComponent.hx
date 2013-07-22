package haxe.ui.toolkit.core.interfaces;

interface IStateComponent {
	public var state(get, set):String;
	public var states(get, null):Array<String>;
}