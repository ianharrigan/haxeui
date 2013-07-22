package haxe.ui.toolkit.core;

import haxe.ui.toolkit.core.interfaces.IDisplayObjectContainer;

class Controller {
	private var _view:IDisplayObjectContainer;
	private var _namedComponents:Hash<IDisplayObjectContainer>;
	
	public var view(get, null):IDisplayObjectContainer;
	public var root(get, null):Root;
	
	public function new(view:IDisplayObjectContainer) {
		_view = view;
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
		var c:IDisplayObjectContainer = _namedComponents.get(id);
		if (c == null) {
			return null;
		}

		return cast c;
	}
	
	private function refereshNamedComponents():Void {
		_namedComponents = new Hash<IDisplayObjectContainer>();
		addNamedComponentsFrom(_view);
	}

	private function addNamedComponentsFrom(parent:IDisplayObjectContainer):Void {
		if (parent == null) {
			return;
		}
		
		if (parent != null && parent.id != null) {
			_namedComponents.set(parent.id, parent);
		}
		
		for (child in parent.children) {
			addNamedComponentsFrom(cast(child, IDisplayObjectContainer));
		}
	}
	
	private function get_view():IDisplayObjectContainer {
		return _view;
	}
	
	private function get_root():Root {
		if (_view == null) {
			return null;
		}
		return _view.root;
	}
}