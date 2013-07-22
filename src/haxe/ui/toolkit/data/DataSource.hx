package haxe.ui.toolkit.data;

import flash.events.Event;
import flash.events.EventDispatcher;
import haxe.ui.toolkit.core.interfaces.IEventDispatcher;

class DataSource extends EventDispatcher implements IDataSource implements IEventDispatcher {
	public var config(get, null):Xml;
	private var _config:Xml; // hold onto the config incase we want to make a clone
	private var _id:String;
	private var allowAdditions:Bool = true;
	private var allowUpdates:Bool = true;
	private var allowDeletions:Bool = true;
	private var allowEvents:Bool = true;
	
	public function new() {
		super();
	}
	
	//******************************************************************************************
	// DataSource functions/helpers
	//******************************************************************************************
	private function get_config():Xml {
		return _config;
	}
	
	public function clone():DataSource {
		var newDS = null;
		return newDS;
	}
	
	//******************************************************************************************
	// IDataSource
	//******************************************************************************************
	public var id(get, set):String;

	private function get_id():String {
		return _id;
	}
	
	private function set_id(value:String):String {
		_id = value;
		return value;
	}
	
	public function create(config:Xml):Void {
		_config = config;
		
		_id = config.get("id");
	}
	
	public function open():Bool {
		return true;
	}
	
	public function close():Bool {
		return true;
	}
	
	public function moveFirst():Bool {
		return _moveFirst();
	}
	
	public function moveNext():Bool {
		return _moveNext();
	}
	
	public function get():Dynamic {
		return _get();
	}

	public function add(o:Dynamic):Bool {
		var b:Bool = false;
		if (allowAdditions) {
			b = _add(o);
			if (b == true) {
				dispatchChanged();
			}
		}
		return b;
	}
	
	public function update(o:Dynamic):Bool {
		var b:Bool = false;
		if (allowUpdates) {
			b = _update(o);
			if (b) {
				dispatchChanged();
			}
		}
		return b;
	}
	
	public function remove():Bool {
		var b:Bool = false;
		if (allowDeletions) {
			b = _remove();
			if (b) {
				dispatchChanged();
			}
		}
		return b;
	}
	
	public function hash():String {
		var o:Dynamic = get();
		if (o == null) {
			return null;
		}
		return "" + getObjectId(o);
	}
	
	//******************************************************************************************
	// Overridables
	//******************************************************************************************
	private function _moveFirst():Bool {
		return false;
	}
	
	private function _moveNext():Bool {
		return false;
	}
	
	private function _get():Dynamic {
		return null;
	}
	
	private function _add(o:Dynamic):Bool {
		return false;
	}
	
	private function _update(o:Dynamic):Bool {
		return false;
	}
	
	private function _remove():Bool {
		return false;
	}
	
	//******************************************************************************************
	// Helpers
	//******************************************************************************************
	private function dispatchChanged():Void {
		if (allowEvents == true) {
			dispatchEvent(new Event(Event.CHANGE));
		}
	}
	
	// extracted from: https://code.google.com/p/fermmmtools/source/browse/Haxe/com/fermmmtools/utils/ObjectHash.hx
	private static inline var SAFE_NUM = #if neko 1073741823 #else 2147483647 #end;
	private static var clsId:Int = 0;
	private #if (cpp || php || java || cs) inline #end function getObjectId(obj:Dynamic):#if !php Int #else String #end untyped
	{
#if cpp
		return __global__.__hxcpp_obj_id(obj);
#elseif (neko || js || flash)
		if (Std.is(obj, Class))
		{
			if (obj.__cls_id__ == null)
				obj.__cls_id__ = clsId++;
			return obj.__cls_id__;
		} else {
#if neko
			if (__dollar__typeof(obj) == __dollar__tfunction)
				return 0;
#end
			if (obj.__get_id__ == null)
			{
				var cls:Dynamic = Type.getClass(obj);
				if (cls == null)
				{
					var id = Std.random(SAFE_NUM);
					obj.__get_id__ = function() return id;
					return id;
				}
				
				var fstid = Std.random(SAFE_NUM);
				var _this = this;
				cls.prototype.__get_id__ = function()
				{
					if (_this.___id___ == null)
					{
						return _this.___id___ = Std.random(SAFE_NUM);
					}
					return _this.___id___;
					
				}
			}
			return obj.__get_id__();
		}

	
#elseif php
		if (Reflect.isFunction(obj))
			return "fun";
		else
			return __call__('spl_object_hash', obj);
#elseif java
		return obj.hashCode();
#elseif cs
		return obj.GetHashCode();
#else
		UnsupportedPlatform
#end
	}
}