package haxe.ui.toolkit.hscript;

class ScriptUtils {
	public static function isScript(data:String):Bool {
		if (data.indexOf("+") != -1
			|| data.indexOf("-") != -1
			|| data.indexOf("*") != -1
			|| data.indexOf("/") != -1
			|| data.indexOf("(") != -1
			|| data.indexOf(")") != -1
			|| data.indexOf("[") != -1
			|| data.indexOf("]") != -1) {
			return true;
		}
		return false;
	}
	
	public static function isCssException(name:String):Bool {
		if (name == "filter"
			|| name == "icon"
			|| name == "backgroundImage"
			|| name == "fontName111") {
				return true;
			}
		return false;
	}
}