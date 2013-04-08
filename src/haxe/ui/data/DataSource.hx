package haxe.ui.data;
import nme.events.Event;
import nme.events.EventDispatcher;

// TODO: because i cant get proper object ids all items in the data source must be objects, ie, String/Int/etc will cause errors
class DataSource extends EventDispatcher {
	
	public var allowAdditions:Bool = true;
	public var allowUpdates:Bool = true;
	public var allowDeletions:Bool = true;
	public var allowEvents:Bool = true;
	
	public function new() {
		super();
	}

	public function moveFirst():Bool {
		return internalMoveFirst();
	}
	
	public function moveNext():Bool {
		return internalMoveNext();
	}
	
	public function get():Dynamic {
		return internalGet();
	}

	public function add(o:Dynamic):Bool {
		var b:Bool = false;
		if (allowAdditions) {
			b = internalAdd(o);
			if (b) {
				dispatchChanged();
			}
		}
		return b;
	}
	
	public function update(o:Dynamic):Bool {
		var b:Bool = false;
		if (allowUpdates) {
			b = internalUpdate(o);
			if (b) {
				dispatchChanged();
			}
		}
		return b;
	}
	
	public function remove():Bool {
		var b:Bool = false;
		if (allowDeletions) {
			b = internalRemove();
			if (b) {
				dispatchChanged();
			}
		}
		return b;
	}
	
	public function open():Bool {
		return true;
	}
	
	public function close():Bool {
		return true;
	}
	
	public function hash():String {
		var o:Dynamic = get();
		if (o == null) {
			return null;
		}
		return "" + getObjectId(o);
	}
	
	public function addAll(ds:DataSource):Void {
		if (ds.moveFirst()) {
			var originalFlag:Bool = allowEvents;
			allowEvents = false;
			do {
				add(ds.get());
			} while (ds.moveNext());
			allowEvents = originalFlag;
			dispatchChanged();
		}
	}
	
	// OVERRIDES
	private function internalMoveFirst():Bool {
		return false;
	}
	
	private function internalMoveNext():Bool {
		return false;
	}
	
	private function internalGet():Dynamic {
		return null;
	}
	
	private function internalAdd(o:Dynamic):Bool {
		return false;
	}
	
	private function internalUpdate(o:Dynamic):Bool {
		return false;
	}
	
	private function internalRemove():Bool {
		return false;
	}
	
	// HELPERS
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