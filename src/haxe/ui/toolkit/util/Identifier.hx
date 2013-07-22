package haxe.ui.toolkit.util;

class Identifier {
	public static function guid() { // not really a guid
	   return (S4()+S4()+"-"+S4()+"-"+S4()+"-"+S4()+"-"+S4()+S4()+S4()); 
	} 
	
	private static function S4() { 
		var n:Int = (((1 + Std.random(65536)) * 0x10000) | 0);
		return StringTools.hex(n, 4).substr(0, 4);
	} 
}