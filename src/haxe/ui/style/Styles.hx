package haxe.ui.style;

class Styles {
	var styles:Hash<Dynamic>;
	var styleRules:Array<String>;
	
	public var rules(getStyleRules, null):Iterator<String>;
	
	public function new() {
		styles = new Hash<Dynamic>();
		styleRules = new Array<String>();
	}
	
	public function addStyle(rule:String, style:Dynamic):Dynamic {
		var currentStyle:Dynamic = getStyle(rule);
		if (currentStyle != null) {
			style = StyleManager.mergeStyle(currentStyle, style);
		} else {
			styleRules.push(rule);
		}
		styles.set(rule, style);
		return style;
	}
	
	public function getStyle(rule:String):Dynamic {
		return styles.get(rule);
	}
	
	public function getStyleRules():Iterator<String> {
		return styleRules.iterator();
	}
}