package haxe.ui.toolkit.util;

class TypeParser {
	public static function parseInt(s:String):Int {
		var i:Int = 0;
		if (s != null) {
			s = StringTools.trim(s);
			i = Std.parseInt(s);
		}
		return i;
	}
	
	public static function parseFloat(s:String):Float {
		var f:Float = 0;
		if (s != null) {
			s = StringTools.trim(s);
			f = Std.parseFloat(s);
		}
		return f;
	}
	
	public static function parseBool(s:String):Bool {
		var b:Bool = false;
		if (s != null) {
			s = StringTools.trim(s);
			s = s.toLowerCase();
			if (s == "true" || s == "yes" || s == "1") {
				b = true;
			}
		}
		return b;
	}
	
	public static function parseColor(s:String):Int {
		var c:Int = 0;
		if (s != null) {
			s = StringTools.trim(s);
			if (StringTools.startsWith(s, "#")) {
				s = "0x" + s.substr(1, s.length - 1);
			}
			c = Std.parseInt(s);
		}
		return c;
	}
}