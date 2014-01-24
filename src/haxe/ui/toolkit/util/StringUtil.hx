package haxe.ui.toolkit.util;

class StringUtil {
	public static function capitalizeFirstLetter(s:String):String {
		s = s.substr(0, 1).toUpperCase() + s.substr(1, s.length);
		return s;
	}
}