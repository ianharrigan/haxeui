package haxe.ui.toolkit.core.interfaces;

interface IClonable<T> {
	function clone():T;
	private function self():T;
}