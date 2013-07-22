package haxe.ui.toolkit.style;

class Styles {
	private var _styles:Hash<Dynamic>;
	private var _styleRules:Array<String>;
	
	public var rules(get, null):Iterator<String>;
	
	public function new() {
		_styles = new Hash<Dynamic>();
		_styleRules = new Array<String>();
	}
	
	public function addStyle(rule:String, style:Dynamic):Dynamic {
		var currentStyle:Dynamic = getStyle(rule);
		if (currentStyle != null) {
			style = StyleManager.instance.mergeStyle(currentStyle, style);
		} else {
			_styleRules.push(rule);
		}
		
		_styles.set(rule, style);
		return style;
	}
	
	public function getStyle(rule:String):Dynamic {
		return _styles.get(rule);
	}
	
	private function get_rules():Iterator<String> {
		return _styleRules.iterator();
	}
	
	public function dump():Void {
		for (rule in _styleRules) {
			trace(rule + ":" + _styles.get(rule));
		}
	}
}