package haxe.ui.core;

import nme.events.Event;

class Controller {
	public var view:Component;
	
	private var namedComponents:Hash<Component>;
	
	public function new(view:Component) {
		this.view = view;
		refereshNamedComponents();
	}

	public function attachEvent(id:String, type:String, listener:Dynamic->Void):Void {
		var c:Component = getComponent(id);
		if (c != null) {
			c.addEventListener(type, listener);
		}
	}
	
	public function getComponent(id:String):Component {
		return getComponentAs(id, Component);
	}
	
	public function getComponentAs<T>(id:String, type:Class<T>):Null<T> {
		var c:Component = namedComponents.get(id);
		if (c == null) {
			return null;
		}

		return cast c;
	}
	
	private function refereshNamedComponents():Void {
		namedComponents = new Hash<Component>();
		addNamedComponentsFrom(view);
	}

	private function addNamedComponentsFrom(parent:Component):Void {
		if (parent.id != null) {
			namedComponents.set(parent.id, parent);
		}
		
		for (child in parent.listChildComponents()) {
			addNamedComponentsFrom(child);
		}
	}
}