package haxe.ui.toolkit.core;

import haxe.ds.StringMap.StringMap;
import haxe.ui.toolkit.core.base.State;
import haxe.ui.toolkit.core.Client;
import haxe.ui.toolkit.core.interfaces.IClonable;
import haxe.ui.toolkit.core.interfaces.IComponent;
import haxe.ui.toolkit.core.interfaces.IDraggable;
import haxe.ui.toolkit.core.interfaces.InvalidationFlag;
import haxe.ui.toolkit.core.ToolTipManager.ToolTipPosition;
import haxe.ui.toolkit.core.ToolTipManager.ToolTipRelativeTo;
import haxe.ui.toolkit.events.UIEvent;
import haxe.ui.toolkit.hscript.ScriptInterp;
import haxe.ui.toolkit.resources.ResourceManager;
import haxe.ui.toolkit.util.StringUtil;
import openfl.events.MouseEvent;
import openfl.geom.Point;
import openfl.geom.Rectangle;

class Component extends StyleableDisplayObject implements IComponent implements IClonable<StyleableDisplayObject> {
	private var _text:String;
	private var _clipContent:Bool = false;
	private var _disabled:Bool = false;
	
	public function new() {
		super();
	}

	//******************************************************************************************
	// Overrides
	//******************************************************************************************
	private override function initialize():Void {
		super.initialize();
		if (Std.is(this, IDraggable)) {
			addEventListener(MouseEvent.MOUSE_DOWN, _onComponentMouseDown);
		}
		initScriplet();
	}
	
	private override function postInitialize():Void { 
		if (_disabled == true) {
			disabled = true;
		}
	}
	
	public override function invalidate(type:Int = InvalidationFlag.ALL, recursive:Bool = false):Void {
		if (!_ready || _invalidating) {
			return;
		}
		
		super.invalidate(type, recursive);
		_invalidating = true;
		if (type & InvalidationFlag.SIZE == InvalidationFlag.SIZE && _clipContent == true) {
			sprite.scrollRect = new Rectangle(0, 0, width, height);
		}
		_invalidating = false;
	}
	
	//******************************************************************************************
	// Component methods/properties
	//******************************************************************************************
	@:clonable
	public var text(get, set):String;
	public var clipWidth(get, set):Float;
	public var clipHeight(get, set):Float;
	public var clipContent(get, set):Bool;
	@:clonable
	public var disabled(get, set):Bool;
	@:clonable
	public var userData(default, default):Dynamic;
	@:clonable
	public var value(get, set):Dynamic;
	
	private function get_text():String {
		return _text;
	}
	
	private function set_text(value:String):String {
		if (value != null) {
			if (StringTools.startsWith(value, "@#")) {
				value = value.substr(2, value.length) + "_" + Client.instance.language;
			} else if (StringTools.startsWith(value, "asset://")) {
				var assetId:String = value.substr(8, value.length);
				value = ResourceManager.instance.getText(assetId);
				value = StringTools.replace(value, "\r", "");
			}
			_text = value;
		}
		return value;
	}
	
	
	private function get_clipWidth():Float {
		if (sprite.scrollRect == null) {
			return width;
		}
		return sprite.scrollRect.width;
	}
	
	private function set_clipWidth(value:Float):Float {
		sprite.scrollRect = new Rectangle(0, 0, value, clipHeight);
		return value;
	}
	
	private function get_clipHeight():Float {
		if (sprite.scrollRect == null) {
			return height;
		}
		return sprite.scrollRect.height;
	}
	
	private function set_clipHeight(value:Float):Float {
		sprite.scrollRect = new Rectangle(0, 0, clipWidth, value);
		return value;
	}
	
	private function get_clipContent():Bool {
		return _clipContent;
	}
	
	private function set_clipContent(value:Bool):Bool {
		_clipContent = value;
		if (_clipContent == false) {
			clearClip();
		}
		invalidate(InvalidationFlag.SIZE);
		return value;
	}
	
	public function clearClip():Void {
		sprite.scrollRect = null;
	}
	
	private function get_disabled():Bool {
		return _disabled;
	}
	
	private function set_disabled(value:Bool):Bool {
		if (value == true) {
			if (_cachedListeners == null) {
				_cachedListeners = new StringMap < Array < Dynamic->Void >> ();
			}
			
			for (type in _eventListeners.keys()) {
				if (disablableEventType(type) == true) {
					var list:Array < Dynamic->Void > = _eventListeners.get(type);
					var cachedList:Array < Dynamic->Void > = _cachedListeners.get(type);
					if (cachedList == null) {
						cachedList = new Array < Dynamic->Void > ();
						_cachedListeners.set(type, cachedList);
					}
					for (listener in list) {
						cachedList.push(listener);
						removeEventListener(type, listener);
					}
				}
			}
		}
		
		_disabled = value;
		for (child in children) {
			if (Std.is(child, Component)) {
				cast(child, Component).disabled = value;
			}
		}
		
		if (value == false) { // add event listeners
			if (_cachedListeners != null) {
				for (type in _cachedListeners.keys()) {
					var list:Array < Dynamic->Void > = _cachedListeners.get(type);
					for (listener in list) {
						addEventListener(type, listener);
					}
					list = new Array < Dynamic->Void > ();
				}
				_cachedListeners = null;
			}
		}
		
		if (Std.is(this, StateComponent)) {
			var stateComponent:StateComponent = cast(this, StateComponent);
			if (value == true) {
				if (stateComponent.hasState(State.DISABLED)) {
					stateComponent.state = State.DISABLED;
				}
			} else {
				if (stateComponent.hasState(State.NORMAL)) {
					stateComponent.state = State.NORMAL;
				}
			}
		}
		
		return value;
	}
	
	private function get_value():Dynamic {
		return text;
	}
	
	private function set_value(newValue:Dynamic):Dynamic {
		text = "" + newValue;
		return newValue;
	}
	
	//******************************************************************************************
	// Tooltip methods/properties
	//******************************************************************************************
	private var _toolTip:Dynamic;
	
	@:clonable
	public var toolTip(get, set):Dynamic;
	public var toolTipPosition(default, default):ToolTipPosition;
	public var toolTipRelativeTo(default, default):ToolTipRelativeTo;
	public var toolTipOffsetX(default, default):Null<Float>;
	public var toolTipOffsetY(default, default):Null<Float>;
	public var toolTipCenter(default, default):Null<Bool>;
	public var toolTipFollow(default, default):Null<Bool>;
	
	private function get_toolTip():Dynamic {
		return _toolTip;
	}
	
	private function set_toolTip(value:Dynamic):Dynamic {
		_toolTip = value;
		removeEventListener(UIEvent.MOUSE_OVER, _onComponentMouseOver);
		removeEventListener(UIEvent.MOUSE_OUT, _onComponentMouseOut);
		removeEventListener(UIEvent.CLICK, _onComponentClick);
		removeEventListener(UIEvent.CHANGE, _onComponentClick);
		if (_toolTip != null) {
			addEventListener(UIEvent.MOUSE_OVER, _onComponentMouseOver);
			addEventListener(UIEvent.MOUSE_OUT, _onComponentMouseOut);
			addEventListener(UIEvent.CLICK, _onComponentClick);
			addEventListener(UIEvent.CHANGE, _onComponentClick);
		}
		return value;
	}

	private var _toolTipTimer:Timer = null;
	private function _onComponentMouseOver(event:UIEvent) {
		if (_toolTipTimer != null) {
			_toolTipTimer.stop();
			_toolTipTimer = null;
		}
		if (_toolTipTimer == null) {
			_toolTipTimer = Timer.delay(function() {
				ToolTipManager.instance.showToolTip(this, null, event);
			}, ToolTipManager.instance.defaults.delay);
		}
	}
	
	private function _onComponentMouseOut(event:UIEvent) {
		if (_toolTipTimer != null) {
			_toolTipTimer.stop();
			_toolTipTimer = null;
		}
		if (ToolTipManager.instance.toolTipVisible(this) == true && hitTest(event.stageX, event.stageY) == false) {
			ToolTipManager.instance.hideCurrentToolTip();
		}
	}
	
	private function _onComponentClick(event:UIEvent) {
		if (_toolTipTimer != null) {
			_toolTipTimer.stop();
			_toolTipTimer = null;
		}
		if (ToolTipManager.instance.toolTipVisible(this) == true) {
			ToolTipManager.instance.hideCurrentToolTip();
		}
	}
	
	//******************************************************************************************
	// Event dispatcher overrides
	//******************************************************************************************
	private var _cachedListeners:StringMap < Array < Dynamic->Void >> ; // for disabling
	public override function addEventListener(type:String, listener:Dynamic->Void, useCapture:Bool = false, priority:Int = 0, useWeakReference:Bool = false):Void {
		if (_disabled == true && disablableEventType(type) == true) {
			if (_cachedListeners == null) {
				_cachedListeners = new StringMap < Array < Dynamic->Void >> ();
			}
			var list:Array < Dynamic->Void > = _cachedListeners.get(type);
			if (list == null) {
				list = new Array < Dynamic->Void > ();
				_cachedListeners.set(type, list);
			}
			list.push(listener);
			return;
		}
		super.addEventListener(type, listener, useCapture, priority, useWeakReference);
	}
	
	public override function removeEventListener(type:String, listener:Dynamic->Void, useCapture:Bool = false):Void {
		if (_disabled == true && disablableEventType(type) == true) {
			if (_cachedListeners != null && _cachedListeners.exists(type)) {
				var list:Array < Dynamic->Void > = _cachedListeners.get(type);
				if (list != null) {
					//list.remove(listener);
					removeEventFunction(list, listener);
					if (list.length == 0) {
						_cachedListeners.remove(type);
					}
				}
			}
			//return;
		}
		super.removeEventListener(type, listener, useCapture);
	}
	
	private function disablableEventType(type:String):Bool {
		return (type == MouseEvent.MOUSE_DOWN
				|| type == MouseEvent.MOUSE_MOVE
				|| type == MouseEvent.MOUSE_OVER
				|| type == MouseEvent.MOUSE_OUT
				|| type == MouseEvent.MOUSE_UP
				|| type == MouseEvent.MOUSE_WHEEL
				|| type == MouseEvent.CLICK
		);
	}
	
	//******************************************************************************************
	// Drag functions
	//******************************************************************************************
	private var mouseDownPos:Point;
	private function _onComponentMouseDown(event:MouseEvent):Void {
		if (Std.is(this, IDraggable)) {
			if (cast(this, IDraggable).allowDrag(event) == false) {
				return;
			}
		}
		
		mouseDownPos = new Point(event.stageX - stageX, event.stageY - stageY);
		root.addEventListener(MouseEvent.MOUSE_MOVE, _onComponentMouseMove);
		root.addEventListener(MouseEvent.MOUSE_UP, _onComponentMouseUp);
	}
	
	private function _onComponentMouseUp(event:MouseEvent):Void {
		root.removeEventListener(MouseEvent.MOUSE_MOVE, _onComponentMouseMove);
		root.removeEventListener(MouseEvent.MOUSE_UP, _onComponentMouseUp);
	}
	
	private function _onComponentMouseMove(event:MouseEvent):Void {
		this.x = event.stageX - mouseDownPos.x;
		this.y = event.stageY - mouseDownPos.y;
	}
	
	//******************************************************************************************
	// Scriptlet functions
	//******************************************************************************************
	public function addScriptlet(scriptlet:String):Void {
		var found = false;
		var item:Component = this;
		while (item != null) {
			if (item.scriptletSource != null) {
				found = true;
				break;
			}
			item = cast item.parent;
		}
		if (found == false) {
			item = this;
		}
		if (item != null) {
			if (item.scriptletSource == null) {
				item.scriptletSource = "";
			}
			item.scriptletSource += scriptlet;
		}
	}
	
	private function findInterp():ScriptInterp {
		var found = false;
		var item:Component = this;
		while (item != null) {
			if (item._interp != null) {
				found = true;
				break;
			}
			item = cast item.parent;
		}
		if (found == false) {
			return null;
		}
		return item._interp;
	}
	
	public function executeScriptletExpr(expr:String) {
		try {
			var parser = new hscript.Parser();
			var line = parser.parseString(expr);
			findInterp().expr(line);
		} catch (e:Dynamic) {
			trace("Problem executing scriptlet: " + e);
		}
	}
	
	public function addScriptletEventHandler(event:String, scriptlet:String):Void {
		event = UIEvent.PREFIX + event;
		addEventListener(event, function(e) {
			executeScriptletExpr(scriptlet);
		});
	}
	
	private var _scriptletSource:String;
	public var scriptletSource(get, set):String;
	private function get_scriptletSource():String {
		return _scriptletSource;
	}
	private function set_scriptletSource(value:String):String {
		_scriptletSource = value;
		return value;
	}
	
	private var _interp:ScriptInterp;
	private function initScriplet():Void {
		if (_scriptletSource != null) { 
			try {
				var parser = new hscript.Parser();
				var program = parser.parseString(_scriptletSource);
				_interp = new ScriptInterp();
				
				var comps:Array<IComponent> = namedComponents;
				for (comp in comps) {
					var safeId = StringUtil.capitalizeHyphens(comp.id);
					_interp.variables.set(safeId, comp);
				}

				_interp.execute(program);
			} catch (e:Dynamic) {
				trace("Problem running script: " + e);
			}
		}
	}
	
	public var namedComponents(get, null):Array<IComponent>;
	private function get_namedComponents():Array<IComponent> {
		var list:Array<IComponent> = new Array<IComponent>();
		addNamedComponentsFrom(this, list);
		return list;
	}
	
	private static function addNamedComponentsFrom(parent:IComponent, list:Array<IComponent>):Void {
		if (parent == null) { 
			return;
		}
		
		if (parent.id != null) {
			list.push(parent);
		}
		
		for (child in parent.children) {
			addNamedComponentsFrom(cast(child, IComponent), list);
		}
	}
}