package haxe.ui.toolkit.core;

import haxe.ds.StringMap;
import haxe.ui.toolkit.controls.popups.Popup;
import haxe.ui.toolkit.controls.popups.PopupContent;
import haxe.ui.toolkit.core.interfaces.IDisplayObject;
import haxe.ui.toolkit.core.interfaces.IDisplayObjectContainer;
import haxe.ui.toolkit.core.PopupManager.PopupButton;
import haxe.ui.toolkit.events.UIEvent;

class Controller {
	private var _view:IDisplayObjectContainer;
	private var _namedComponents:StringMap<IDisplayObjectContainer>;
	
	public var view(get, null):IDisplayObjectContainer;
	public var root(get, null):Root;
	public var popup(get, null):Popup;
	
	public function new(view:Dynamic = null, options:Dynamic = null) {
		if (Std.is(view, IDisplayObjectContainer)) {
			_view = cast(view, IDisplayObjectContainer);
		} else if (Std.is(view, Class)) {
			var cls:Class<Dynamic> = cast(view, Class<Dynamic>);
			_view = Type.createInstance(cls, []);
		} else if (view != null) {
			options = view;
		}
		
		if (_view == null) {
			_view = new Component();
		}
		
		if (options != null) {
			for (f in Reflect.fields(options)) {
				if (Reflect.getProperty(_view, "set_" + f) != null) {
					Reflect.setProperty(_view, f, Reflect.field(options, f));
				}
			}
		}
		
		refereshNamedComponents();
		
        _view.addEventListener(UIEvent.READY, function(e) {
            if (_view.width != 0 && _view.height != 0) {
                onReady();
            } else {
                _view.addEventListener(UIEvent.RESIZE, onFirstResize);
            }
        });
	}
	
    private function onFirstResize(event:UIEvent):Void {
        if (_view.width != 0 && _view.height != 0) {
            _view.removeEventListener(UIEvent.RESIZE, onFirstResize);
            onReady();
        }
    }
    
	private function onReady():Void {
		
	}
	
	public function addChild<T>(child:Dynamic = null, options:Dynamic = null):Null<T> {
		var childObject:IDisplayObject = null;
		if (Std.is(child, IDisplayObject)) {
			childObject = cast(child, IDisplayObject);
		} else if (Std.is(child, Class)) {
			var cls:Class<Dynamic> = cast(child, Class<Dynamic>);
			childObject = Type.createInstance(cls, []);
		} else if (child != null) {
			options = child;
		}
		
		if (childObject == null) {
			childObject = new Component();
		}

		if (options != null) {
			for (f in Reflect.fields(options)) {
				if (Reflect.getProperty(childObject, "set_" + f) != null) {
					Reflect.setProperty(childObject, f, Reflect.field(options, f));
				}
			}
		}
		
		var retVal:IDisplayObject = _view.addChild(childObject);
		refereshNamedComponents();
		return cast retVal;
	}
	
	public function attachView(newView:IDisplayObjectContainer):Void {
		_view = newView;
		refereshNamedComponents();
	}
	
	public function attachEvent(id:String, type:String, listener:Dynamic->Void):Void {
		var c:Component = getComponent(id);
		if (c != null) {
			c.addEventListener(type, listener);
		}
	}
	
	public function detachEvent(id:String, type:String, listener:Dynamic->Void):Void {
		var c:Component = getComponent(id);
		if (c != null) {
			c.removeEventListener(type, listener);
		}
	}

	public function detachEvents(id:String, type:String):Void {
		var c:Component = getComponent(id);
		if (c != null) {
			c.removeEventListenerType(type);
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
		_namedComponents = new StringMap<IDisplayObjectContainer>();
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
	
	private function get_popup():Popup {
		var popup:Popup = null;
		if (Std.is(view.parent, PopupContent)) {
			popup = cast(view.parent, PopupContent).popup;
		}
		return popup;
	}
	
	public var namedComponents(get, null):StringMap<IDisplayObjectContainer>;
	private function get_namedComponents():StringMap<IDisplayObjectContainer> {
		return _namedComponents;
	}

	private function showPopup(text:String, title:String = null, config:Dynamic = PopupButton.OK, fn:Dynamic->Void = null):Popup {
		return showSimplePopup(text, title, config, fn);
	}
	
	private function showSimplePopup(text:String, title:String = null, config:Dynamic = PopupButton.OK, fn:Dynamic->Void = null):Popup {
		return PopupManager.instance.showSimple(text, title, config, fn);
	}
	
	private function showCustomPopup(content:Dynamic, title:String = null, config:Dynamic = PopupButton.OK, fn:Dynamic->Void = null):Popup {
		var display:IDisplayObject = null;
		if (Std.is(content, IDisplayObject)) {
			display = cast(content, IDisplayObject);
		} else if (Std.is(content, String)) {
			display = Toolkit.processXmlResource(cast(content, String));
		}
		if (display == null) {
			return null;
		}
		return PopupManager.instance.showCustom(display, title, config, fn);
	}
	
	private function showListPopup(items:Dynamic, selectedIndex:Int = -1, title:String = null, fn:Dynamic->Void = null):Popup {
		return PopupManager.instance.showList(items, selectedIndex, title, fn);
	}
	
	private var _currentBusyPopup:Popup;
	private function showBusyPopup(text:String, delay:Int = -1, title:String = null, config:Dynamic = null, fn:Dynamic->Void = null):Popup {
		hideBusy();
		return _currentBusyPopup = PopupManager.instance.showBusy(text, delay, title, config, fn);
	}
	
	private function showBusy(text:String, delay:Int = -1, title:String = null, config:Dynamic = null, fn:Dynamic->Void = null):Popup {
		return showBusyPopup(text, delay, title, config, fn);
	}
	
	private function hideBusy() {
		if (_currentBusyPopup != null) {
			PopupManager.instance.hidePopup(_currentBusyPopup);
			_currentBusyPopup = null;
		}
	}
	
	public function showCalendarPopup(title:String = null, fn:Dynamic->Date->Void = null):Popup {
		return PopupManager.instance.showCalendar(title, fn);
	}
}