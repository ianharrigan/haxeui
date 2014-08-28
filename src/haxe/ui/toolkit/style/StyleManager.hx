package haxe.ui.toolkit.style;

import haxe.ds.StringMap;
import haxe.ui.toolkit.core.Component;
import haxe.ui.toolkit.core.DisplayObject;
import haxe.ui.toolkit.core.DisplayObjectContainer;
import haxe.ui.toolkit.core.interfaces.IDisplayObjectContainer;
import haxe.ui.toolkit.core.interfaces.IStyleableDisplayObject;
import haxe.ui.toolkit.core.Macros;
import haxe.ui.toolkit.core.StateComponent;
import haxe.ui.toolkit.core.StyleableDisplayObject;

class StyleManager {
	private static var _instance:StyleManager;
	public static var instance(get, null):StyleManager;
	private static function get_instance():StyleManager {
		if (_instance == null) {
			_instance = new StyleManager();
		}
		return _instance;
	}
	
	//******************************************************************************************
	// Instance methods/props
	//******************************************************************************************
	private var _styles:StringMap<StyleRule>;
	private var _rules:Array<String>; // the order the rules are added is important, hence an array to hold them
	
	private var stylesBuilt:Int = 0; //debug helper
	private var stylesBuiltFor:Map<String, Int>;
	
	public var hasStyles(get, null):Bool;

	private var _cacheStyles:Bool = true;
	private var _cachedStyles:Map<String, Style>;
	
	public function new() {
		_styles = new StringMap<StyleRule>();
		_rules = new Array<String>();
		stylesBuiltFor = new Map<String, Int>();
	}
	
	public function getRules():Array<String> {
		return _rules;
	}
	
	public function removeStyle(rule:String):Void {
		_styles.remove(rule);
		_rules.remove(rule);
	}
	
	public function addStyle(rule:String, style:Style):Void {
		_cachedStyles = null;
		var arr:Array<String> = rule.split(",");
		for (a in arr) {
			a = StringTools.trim(a);
			var existingStyleRule:StyleRule = _styles.get(a);
			var existingStyle:Style = null;
			if (existingStyleRule != null) {
				var existingStyle:Style = existingStyleRule.style;
				existingStyle.merge(style);
				var styleRule:StyleRule = new StyleRule(a, existingStyle);
				_styles.set(a, styleRule);
			} else {
				var styleRule:StyleRule = new StyleRule(a, style);
				_styles.set(a, styleRule);
				_rules.push(a);
			}
		}
	}
	
	public function addStyles(styles:Styles):Void {
		for (rule in styles.rules) {
			addStyle(rule, styles.getStyle(rule));
		}
	}
	
	public function findStyle(rule:String):Style {
		var existingStyleRule:StyleRule = _styles.get(rule);
		if (existingStyleRule != null) {
			return existingStyleRule.style;
		}
		return null;
	}
	
	public function clear():Void {
		_styles = new StringMap<StyleRule>();
		_rules = new Array<String>();
		StyleHelper.clearCache();
	}
	
	private function findAncestor(c:IDisplayObjectContainer, rulePart:StyleRulePart):IDisplayObjectContainer {
		var a:IDisplayObjectContainer = null;
		var t:IDisplayObjectContainer = c;
		
		while (a == null) {
			if (rulePartMatch(t, rulePart, null) == true) {
				a = t;
			} else {
				t = t.parent;
				if (t == null) {
					break;
				}
			}
		}
		
		return a;
	}
	
	private function rulePartMatch(c:IDisplayObjectContainer, rulePart:StyleRulePart, state:String, overriddenClassName:String = null):Bool {
		var match:Bool = false;

		if (state == "normal") {
			state = null;
		}
		
		var className:String = Type.getClassName(Type.getClass(c));
		var n:Int = className.lastIndexOf(".");
		className = className.substr(n + 1, className.length);
		if (overriddenClassName != null) {
			className = overriddenClassName;
		}
		var id:String = c.id;
		var styleName:String = null;
		if (Std.is(c, IStyleableDisplayObject)) {
			styleName = cast(c, IStyleableDisplayObject).styleName;
		}
		
		var rulePartId:String = rulePart.id;
		var rulePartClassName:String = rulePart.className;
		var rulePartState:String = rulePart.state;
		var rulePartStyleName:String = rulePart.styleName;
		
		if (rulePartStyleName != null && rulePartStyleName.length == 0) {
			rulePartStyleName = null;
		}
		
		var s:Style = new Style();
		if (rulePartId != null) {
			match = (rulePartId == id);
			if (rulePartStyleName != null && match == true) {
				match = (rulePartStyleName == styleName);
			}
		} else if (rulePartClassName != null) {
			match = (rulePartClassName == className);
			if (rulePartStyleName != null && match == true) {
				match = (rulePartStyleName == styleName);
			}
		} else if (rulePartStyleName != null) {
			match = (rulePartStyleName == styleName);
		}
		
		if (rulePartState != null && match == true) {
			match = (rulePartState == state);
		}
		
		return match;
	}
	
	private function ruleMatch(c:IDisplayObjectContainer, rule:String, state:String, overriddenClassName:String = null):Bool {
		var match:Bool = true;
		
		if (state == "normal") {
			state = null;
		}
		
		var className:String = Type.getClassName(Type.getClass(c));
		var n:Int = className.lastIndexOf(".");
		className = className.substr(n + 1, className.length);
		if (overriddenClassName != null) {
			className = overriddenClassName;
		}
		var id:String = c.id;
		var styleName:String = null;
		if (Std.is(c, IStyleableDisplayObject)) {
			styleName = cast(c, IStyleableDisplayObject).styleName;
		}
		
		var styleRule:StyleRule = _styles.get(rule);
		// skip rules if not relevant
		var skipRule:Bool = true;

		if (styleRule.isRelevant(id, className, state, styleName) == true) {
			skipRule = false;
		}
		
		if (styleName != null && rule.indexOf("." + styleName) != -1) {
			skipRule = false;
		}
		
		if (skipRule == true) {
			return false;
		}
		
		var t:IDisplayObjectContainer = c;
		
		for (rulePart in styleRule.ruleParts) {
			var partMatch:Bool = rulePartMatch(t, rulePart, state, overriddenClassName);
			if (partMatch == false) {
				t = findAncestor(t, rulePart);
				if (t == null) {
					match = false;
					break;
				} else {
					state = null;
				}
			}
		}
		
		return match;
	}
	
	public function buildStyleFor(c:IDisplayObjectContainer, state:String = null):Style {
		Macros.beginProfile();
		if (state == "normal") {
			state = null;
		}
		
		var cacheKey:String = null;
		if (_cacheStyles == true) {
			cacheKey = buildFullCacheKey(c, state);
			if (_cachedStyles == null) {
				_cachedStyles = new Map<String, Style>();
			}
			if (_cachedStyles.get(cacheKey) != null) {
				Macros.endProfile();
				return _cachedStyles.get(cacheKey);
			}
		}
		
		var style:Style = new Style();
		style.autoApply = false;
		
		var superClass:Class<Dynamic> = Type.getSuperClass(Type.getClass(c));
		while (superClass != Component
			&& superClass != StateComponent
			&& superClass != StyleableDisplayObject
			&& superClass != DisplayObjectContainer
			&& superClass != DisplayObject
			&& superClass != null) {
			var superClassName:String = Type.getClassName(superClass);
			var n:Int = superClassName.lastIndexOf(".");
			superClassName = superClassName.substr(n + 1, superClassName.length);
			
			for (rule in _rules) {
				if (ruleMatch(c, rule, state, superClassName) == true) {
					var matchedStyle:Style = _styles.get(rule).style;
					style.merge(matchedStyle);
				}
			}
			
			superClass = Type.getSuperClass(superClass);
		}
		
		for (rule in _rules) {
			if (ruleMatch(c, rule, state) == true) {
				var matchedStyle:Style = _styles.get(rule).style;
				style.merge(matchedStyle);
			}
		}

		stylesBuilt++;
		var className:String = Type.getClassName(Type.getClass(c));
		if (stylesBuiltFor.get(className) == null) {
			stylesBuiltFor.set(className, 0);
		}
		var n:Int = stylesBuiltFor.get(className);
		n++;
		stylesBuiltFor.set(className, n);
		
		if (_cacheStyles == true && cacheKey != null) {
			_cachedStyles.set(cacheKey, style);
		}
		
		style.target = c;
		style.autoApply = true;
		Macros.endProfile();
		return style;
	}
	
	private function buildCacheKey(c:IDisplayObjectContainer, state:String = null):String {
		if (state == "normal") {
			state = null;
		}
		
		var className:String = Type.getClassName(Type.getClass(c));
		var n:Int = className.lastIndexOf(".");
		className = className.substr(n + 1, className.length);

		var id:String = c.id;
		var styleName:String = null;
		if (Std.is(c, IStyleableDisplayObject)) {
			styleName = cast(c, IStyleableDisplayObject).styleName;
		}
		
		var s:String = className;
		if (id != null) {
			s += "#" + id;
		}
		if (styleName != null) {
			s += "." + styleName;
		}
		if (state != null) {
			s += ":" + state;
		}
		return s;
	}
	
	private function buildFullCacheKey(c:IDisplayObjectContainer, state:String = null):String {
		if (state == "normal") {
			state = null;
		}
		
		var key:String = buildCacheKey(c, state);
		var p:IDisplayObjectContainer = c.parent;
		while (p != null) {
			key += ">" + buildCacheKey(p, null);
			p = p.parent;
		}
		return key;
	}
	
	public function dump():Void {
		for (key in stylesBuiltFor.keys()) {
			trace("> " + key + " = " + stylesBuiltFor.get(key));
		}
		trace(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
	}
	
	private function get_hasStyles():Bool {
		if (_styles == null) {
			return false;
		}
		return _styles.keys().hasNext();
	}
}

private class StyleRule {
	public var ruleParts(default, default):Array<StyleRulePart>;
	public var style(default, default):Style;
	
	public function new(rule:String, style:Style) {
		this.style = style;
		ruleParts = new Array<StyleRulePart>();
		var ruleArr:Array<String> = rule.split(" ");
		ruleArr.reverse();
		for (rulePart in ruleArr) {
			ruleParts.push(new StyleRulePart(rulePart));
		}
	}
	
	public function containsClassName(className:String):Bool {
		var found:Bool = false;
		for (rulePart in ruleParts) {
			if (rulePart.className != null && rulePart.className == className) {
				found = true;
				break;
			}
		}
		return found;
	}
	
	public function isRelevant(id:String, className:String, state:String, styleName:String):Bool {
		var relevant:Bool = false;
		for (rulePart in ruleParts) {
			if (rulePart.id != null && rulePart.id == id) {
				relevant = true;
				break;
			}
			if (rulePart.className != null && rulePart.className == className) {
				relevant = true;
				break;
			}
			if (rulePart.state != null && rulePart.state == state) {
				relevant = true;
				break;
			}
			if (rulePart.styleName != null && rulePart.styleName == styleName) {
				relevant = true;
				break;
			}
		}
		return relevant;
	}
}
private class StyleRulePart {
	public var id(default, default):String;
	public var className(default, default):String;
	public var state(default, default):String;
	public var styleName(default, default):String;
	
	public function new(rulePart:String):Void {
		var n:Int = rulePart.indexOf(":");
		if (n != -1) {
			state = rulePart.substr(n + 1, rulePart.length);
			rulePart = rulePart.substr(0, n);
		}
		
		if (StringTools.startsWith(rulePart, "#")) {
			id = rulePart.substr(1, rulePart.length);
			n = id.indexOf(".");
			if (n != -1) {
				styleName = id.substr(n + 1, id.length);
				id = id.substr(0, n);
			}
		} else {
			className = rulePart;
			n = className.indexOf(".");
			if (n != -1) {
				styleName = className.substr(n + 1, className.length);
				className = className.substr(0, n);
				if (className.length == 0) {
					className = null;
				}
			}
		}
		
		if (styleName != null && styleName.length == 0) {
			styleName = null;
		}
	}
}