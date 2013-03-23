package haxe.ui.style;

import haxe.ui.core.Component;
import haxe.ui.resources.ResourceManager;
import nme.display.BitmapData;
import nme.display.Graphics;
import nme.geom.Rectangle;

class StyleManager {
	private static var styles:Hash<Dynamic>;
	private static var rules:Array<String>;

	private static function init():Void {
		if (styles == null) {
			styles = new Hash<Dynamic>();
		}
		if (rules == null) {
			rules = new Array<String>();
		}
	}
	
	public static function clear() {
		styles = new Hash<Dynamic>();
		rules = new Array<String>();
	}
	
	public static function addStyle(rule:String, style:Dynamic):Void {
		init();
		styles.set(rule, style);
		rules.push(rule);
	}

	public static function loadFromResource(resourceId:String):Void {
		var styleString:String = ResourceManager.getText(resourceId);
		if (styleString != null) {
			var styles:Styles = StyleParser.fromString(styleString);
			for (rule in styles.rules) {
				addStyle(rule, styles.getStyle(rule));
			}
		}
	}
	
	public static function buildStyle(c:Component, state:String = null):Dynamic {
		init();
		if (state == "normal") {
			state = null;
		}
		var style:Dynamic = { };
		
		for (rule in rules) {
			var test:Component = c;
			var isMatch:Bool = false;
			var selectorArr:Array<String> = rule.split(" ");
			selectorArr.reverse();

			var n:Int = 0;
			for (selector in selectorArr) {
				
				var selectorMatch:Bool = isSelectorMatch(test, selector, state);
				
				if (selectorMatch) {
					if (n == selectorArr.length - 1) {
						isMatch = true;
					} else {
						test = findAncestor(selectorArr[n+1], test);
						if (test == null) {
							break;
						}
					}
				} else {
					break;
				}
				
				n++;
			}
			
			if (isMatch == true) {
				var ruleStyle = styles.get(rule);
				if (ruleStyle != null) {
					style = StyleManager.mergeStyle(style, ruleStyle);
				}
			}
		}
		
		return style;
	}

	private static function isSelectorMatch(c:Component, selector:String, state:String = null):Bool {
		if (state == "normal") {
			state = null;
		}
		var className:String = getSimpleClassName(c);
		var selectorState:String = null;
		if (selector.indexOf(":") != -1) {
			selectorState = selector.substr(selector.indexOf(":") + 1, selector.length);
			selector = selector.substr(0, selector.indexOf(":"));
		}
		var selectorStyleName = null;
		if (selector.indexOf(".") != -1) {
			selectorStyleName = selector.substr(selector.indexOf(".") + 1, selector.length);
			selector = selector.substr(0, selector.indexOf("."));
		}
		
		var selectorId = null;
		var selectorClassName = null;
		if (selector.indexOf("#") == 0) {
			selectorId = selector.substr(1, selector.length);
		} else if (selector.length > 0) {
			selectorClassName = selector;
		}
		
		if (selectorState != null && selectorState != state) {
			return false;
		}
		
		var selectorMatch:Bool = false;
		if (selectorClassName != null && selectorClassName == className) {
			selectorMatch = true;
			if (selectorStyleName != null && selectorStyleName != c.styles) {
				selectorMatch = false;
			}
		}
		if (selectorStyleName != null && selectorStyleName == c.styles) {
			selectorMatch = true;
			if (selectorId != null && selectorId != c.id) {
				selectorMatch = false;
			}
			if (selectorClassName != null && selectorClassName != className) {
				selectorMatch = false;
			}
		}
		if (selectorId != null && selectorId == c.id) {
			selectorMatch = true;
			if (selectorStyleName != null && selectorStyleName != c.styles) {
				selectorMatch = false;
			}
		}
		
		return selectorMatch;
	}
	
	private static function findAncestor(selector:String, c:Component):Component {
		var p:Component = c.parent;
		var a:Component = null;
		while (p != null) { 
			var selectorMatch:Bool = isSelectorMatch(p, selector);
			if (selectorMatch) {
				a = p;
				break;
			}
			p = p.parent;
		}
		return a;
	}
	
	public static function getSimpleClassName(c:Component):String {
		var className:String = Type.getClassName(Type.getClass(c));
		var x:Int = className.lastIndexOf(".") + 1;
		className = className.substr(x, className.length);
		return className;
	}
	
	public static function mergeStyle(originalStyle:Dynamic, newStyle:Dynamic):Dynamic {
		var mergedStyle = { };
		if (originalStyle != null) {
			for (field in Reflect.fields(originalStyle)) {
				var value:Dynamic = Reflect.field(originalStyle, field);
				Reflect.setField(mergedStyle, field, value);
			}
		}
		if (newStyle != null) {
			if (Reflect.hasField(newStyle, "backgroundImage")) { // TODO: doesnt feel right
				Reflect.deleteField(mergedStyle, "backgroundImageScale9");
				Reflect.deleteField(mergedStyle, "backgroundImageRect");
			}

			if (Reflect.hasField(newStyle, "backgroundColor")) { // TODO: doesnt feel right
				Reflect.deleteField(mergedStyle, "backgroundColorGradientEnd");
			}
			
			for (field in Reflect.fields(newStyle)) {
				var value:Dynamic = Reflect.field(newStyle, field);
				if (value == "null") {
					Reflect.deleteField(mergedStyle, field);
				} else {
					Reflect.setField(mergedStyle, field, value);
				}
			}
		}
		return mergedStyle;
	}
}