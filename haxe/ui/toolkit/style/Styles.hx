package haxe.ui.toolkit.style;

import haxe.ds.StringMap;

class Styles {
	private var _styles:StringMap<Style>;
	private var _styleRules:Array<String>;
	
	public var rules(get, null):Iterator<String>;
	
	public function new() {
		_styles = new StringMap<Style>();
		_styleRules = new Array<String>();
	}

	public function addStyle(rule:String, style:Style):Style {
		if (rule.indexOf(",") != -1) {
			var rules:Array<String> = rule.split(",");
			for (r in rules) {
				r = StringTools.trim(r);
				addStyle(r, style);
			}
			return null;
		}
		
		var currentStyle:Style = getStyle(rule);
		if (currentStyle != null) {
			currentStyle.merge(style);
			style = currentStyle;
		} else {
			_styleRules.push(rule);
		}
		
		_styles.set(rule, style);
		return style;
	}
	
	public function getStyle(rule:String):Style {
		return _styles.get(rule);
	}
	
	private function get_rules():Iterator<String> {
		return _styleRules.iterator();
	}
}