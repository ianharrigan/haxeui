package haxe.ui.toolkit.util;

class Identifier {
	private static var _objectCount:Map<String, Int> = new Map<String, Int>();
	
	public static function createObjectId(instance:Dynamic):String {
		return createClassId(Type.getClass(instance));
	}
	
	public static function createClassId(type:Class<Dynamic>):String {
		var className:String = Type.getClassName(type);
		var c:Int = _objectCount.get(className);
		if (_objectCount.exists(className) == false) {
			_objectCount.set(className, -1);
			c = -1;
		}
		c++;
		_objectCount.set(className, c);
		var id:String = className + c;
		return id;
	}
	
	public static function guid() { // not really a guid
	   return (S4()+S4()+"-"+S4()+"-"+S4()+"-"+S4()+"-"+S4()+S4()+S4()); 
	} 
	
	private static function S4() { 
		var n:Int = (((1 + Std.random(65536)) * 0x10000) | 0);
		return StringTools.hex(n, 4).substr(0, 4);
	} 
}