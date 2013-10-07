package haxe.ui.toolkit.style;

import flash.display.DisplayObjectContainer;
import haxe.ds.StringMap;
import haxe.ui.toolkit.core.interfaces.IDisplayObjectContainer;
import haxe.ui.toolkit.core.interfaces.IStyleable;
import haxe.ui.toolkit.core.Macros;
import haxe.ui.toolkit.resources.ResourceManager;
import haxe.ui.toolkit.util.PerfTimer;

class StyleManager {
	public static var STYLE_WINDOWS:String = "windows";
	public static var STYLE_GRADIENT:String = "gradient";
	public static var STYLE_GRADIENT_MOBILE:String = "gradient mobile";
	
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
	private var _styleAssets:StringMap<Array<String>>;
	private var _styles:StringMap<Dynamic>;
	private var _rules:Array<Dynamic>; // the order the rules are added is important, hence an array to hold them
	
	private var stylesBuilt:Int = 0; //debug helper
	private var stylesBuiltFor:Map<String, Int>;
	
	public function new() {
		_styles = new StringMap<Dynamic>();
		_rules = new Array<Dynamic>();
		stylesBuiltFor = new Map<String, Int>();
		addStyleAsset(STYLE_GRADIENT, "styles/gradient/gradient.css");
		addStyleAsset(STYLE_GRADIENT_MOBILE, "styles/gradient/gradient_mobile.css");
		addStyleAsset(STYLE_WINDOWS, "styles/windows/windows.css");
		addStyleAsset(STYLE_WINDOWS, "styles/windows/buttons.css");
		addStyleAsset(STYLE_WINDOWS, "styles/windows/tabs.css");
		addStyleAsset(STYLE_WINDOWS, "styles/windows/listview.css");
		addStyleAsset(STYLE_WINDOWS, "styles/windows/scrolls.css");
		addStyleAsset(STYLE_WINDOWS, "styles/windows/sliders.css");
		addStyleAsset(STYLE_WINDOWS, "styles/windows/accordion.css");
		addStyleAsset(STYLE_WINDOWS, "styles/windows/rtf.css");
	}
	
	public function addStyleAsset(style:String, assetId:String):Void {
		if (_styleAssets == null) {
			_styleAssets = new StringMap<Array<String>>();
		}
		var list:Array<String> = _styleAssets.get(style);
		if (list == null) {
			list = new Array<String>();
			_styleAssets.set(style, list);
		}
		list.push(assetId);
	}
	
	public function loadStyle(style:String):Void {
		if (_styleAssets == null) {
			return;
		}
		var list:Array<String> = _styleAssets.get(style);
		if (list == null) {
			return;
		}
		clear();
		ResourceManager.instance.reset();
		var assetId:String;
		for (assetId in list) {
			addStyles(StyleParser.fromString(ResourceManager.instance.getText(assetId)));
		}
	}
	
	public function addStyle(rule:String, style:Dynamic):Void {
		_styles.set(rule, style);
		_rules.push(rule);
	}
	
	public function addStyles(styles:Styles):Void {
		for (rule in styles.rules) {
			addStyle(rule, styles.getStyle(rule));
		}
	}
	
	public function clear():Void {
		_styles = new StringMap<Dynamic>();
		_rules = new Array<Dynamic>();
		StyleHelper.clearCache();
	}
	
	private function findAncestor(c:IDisplayObjectContainer, rulePart:String):IDisplayObjectContainer {
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
	
	private function rulePartMatch(c:IDisplayObjectContainer, rulePart:String, state:String):Bool {
		var match:Bool = false;

		if (state == "normal") {
			state = null;
		}
		
		var className:String = Type.getClassName(Type.getClass(c));
		var n:Int = className.lastIndexOf(".");
		className = className.substr(n + 1, className.length);
		var id:String = c.id;
		
		var rulePartId:String = null;
		var rulePartClassName:String = null;
		var rulePartState:String = null;
		
		n = rulePart.indexOf(":");
		if (n != -1) {
			rulePartState = rulePart.substr(n + 1, rulePart.length);
			rulePart = rulePart.substr(0, n);
		}
		
		if (StringTools.startsWith(rulePart, "#")) {
			rulePartId = rulePart.substr(1, rulePart.length);
		} else {
			rulePartClassName = rulePart;
		}
		
		if (rulePartId != null) {
			match = (rulePartId == id);
		} else if (rulePartClassName != null) {
			match = (rulePartClassName == className);
		}
		
		if (rulePartState != null && match == true) {
			match = (rulePartState == state);
		}
		
		return match;
	}
	
	private function ruleMatch(c:IDisplayObjectContainer, rule:String, state:String):Bool {
		var match:Bool = true;
		
		if (state == "normal") {
			state = null;
		}
		
		var className:String = Type.getClassName(Type.getClass(c));
		var n:Int = className.lastIndexOf(".");
		className = className.substr(n + 1, className.length);
		var id:String = c.id;
		
		// skip rules if not relevant
		var skipRule:Bool = true;
		if (id != null && rule.indexOf("#" + id) != -1) {
			skipRule = false;
		}
		if (rule.indexOf(className) != -1) {
			skipRule = false;
		}
		if (state != null && rule.indexOf(":" + state) != -1) {
			skipRule = false;
		}
		
		if (skipRule == true) {
			return false;
		}
		
		var ruleArr:Array<String> = rule.split(" ");
		ruleArr.reverse();
		
		var t:IDisplayObjectContainer = c;
		
		for (rulePart in ruleArr) {
			var partMatch:Bool = rulePartMatch(t, rulePart, state);
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
	
	public function mergeStyle(oldStyle:Dynamic, newStyle:Dynamic):Dynamic {
		var mergedStyle:Dynamic = { };
		
		for (fieldName in Reflect.fields(oldStyle)) {
			Reflect.setField(mergedStyle, fieldName, Reflect.field(oldStyle, fieldName));
		}

		for (fieldName in Reflect.fields(newStyle)) {
			if (Reflect.hasField(newStyle, "backgroundImage")) {
				Reflect.deleteField(mergedStyle, "backgroundImageScale9");
				Reflect.deleteField(mergedStyle, "backgroundImageRect");
			}

			if (Reflect.hasField(newStyle, "backgroundColor")) {
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
	
	public function buildStyleFor(c:IDisplayObjectContainer, state:String = null):Dynamic {
		if (state == "normal") {
			state = null;
		}
		
		//var pt:PerfTimer = new PerfTimer("buildStyleFor - " + Type.getClassName(Type.getClass(c)));
		
		var style:Dynamic = { };
		for (rule in _rules) {
			if (ruleMatch(c, rule, state) == true) {
				var matchedStyle:Dynamic = _styles.get(rule);
				style = mergeStyle(style, matchedStyle);
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
		//trace(stylesBuilt);
		//pt.end();
		//dump();
		
		return style;
	}
	
	public function dump():Void {
		for (key in stylesBuiltFor.keys()) {
			trace("> " + key + " = " + stylesBuiltFor.get(key));
		}
		trace(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
	}
}