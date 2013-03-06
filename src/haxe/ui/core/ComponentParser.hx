package haxe.ui.core;

import haxe.ui.containers.HBox;
import haxe.ui.containers.VBox;
import haxe.ui.controls.DropDownList;
import haxe.ui.controls.Image;
import haxe.ui.controls.TextInput;
import haxe.ui.style.StyleManager;
import haxe.ui.style.StyleParser;
import haxe.ui.style.Styles;

// TODO: have to include all the controls? (Dont think so)
import haxe.ui.controls.Button;
import haxe.ui.controls.CheckBox;
import haxe.ui.controls.OptionBox;


class ComponentParser {
	public function new() {
		
	}

	private static function getXMLAssetString(xmlStringId:String):String {
		#if embeddedXML
			//trace("Using xml skin as resource");
			var xmlString:String = haxe.Resource.getString(xmlStringId);
		#else
			//trace("Using xml skin as asset");
			var xmlString:String = Assets.getText(xmlStringId);
		#end
		return xmlString;
	}
	
	public static function fromXMLAsset(xmlStringId:String):Component {
		return fromXMLString(getXMLAssetString(xmlStringId));
	}
	
	public static function fromXMLString(xmlString:String):Component {
		var xml:Xml = Xml.parse(xmlString);
		for (child in xml) {
			if (Std.string(child.nodeType) == "element") {
				return fromXML(child);
			}
		}
		return null;
	}
	
	public static function fromXML(xml:Xml):Component {
		if (xml.get("if") != null && xml.get("if").length > 0) { // make sure it satisfies the criteria
			var ifValue = xml.get("if");
			if (Globals.has(ifValue) == false) {
				return null;
			}
		}
		
		if (hasComponentClass(xml.nodeName) == false) {
			if (xml.nodeName == "style") {
				processInlineStyle(xml);
			} else if (xml.nodeName == "import") {
				var importResId:String = xml.get("resource");
				return fromXMLAsset(importResId);
			}
		}
		
		var width:Float = 0;
		var percentWidth:Int = -1;
		var widthString:String = xml.get("width");
		if (widthString != null) {
			width = Std.parseInt(widthString);
			if (widthString.indexOf("%") != -1) {
				width = 0;
				percentWidth = Std.parseInt(widthString.substr(0, widthString.length - 1));
			}
		}

		var height:Float = 0;
		var percentHeight:Int = -1;
		var heightString:String = xml.get("height");
		if (heightString != null) {
			height = Std.parseInt(heightString);
			if (heightString.indexOf("%") != -1) {
				height = 0;
				percentHeight = Std.parseInt(heightString.substr(0, heightString.length - 1));
			}
		}
		
		var c:Component = createComponent(xml);
		if (c != null) {
			if (xml.get("id") != null && xml.get("id").length != 0) {
				c.id = xml.get("id");
			}
			// dont overwrite, might have been set in component constructor
			if (width != 0) {
				c.width = width;
			}
			if (height != 0) {
				c.height = height;
			}
			if (percentWidth != -1) {
				c.percentWidth = percentWidth;
			}
			if (percentHeight != -1) {
				c.percentHeight = percentHeight;
			}
			if (xml.get("text") != null) {
				c.text = xml.get("text");
			}
			if (xml.get("styles") != null) {
				c.addStyleName(xml.get("styles"));
			}
			
			for (child in xml) {
				if (Std.string(child.nodeType) == "element") {
					var childComponent:Component = fromXML(child);
					if (childComponent != null) {
						c.addChild(childComponent);
					}
				}
			}
		}
		
		
		return c;
	}
	
	private static function createComponent(xml:Xml):Component {
		var c:Component = null;
		var nodeName:String = xml.nodeName;
		var className:String = getComponentClass(xml.nodeName);
		if (className != null) {
			try {
				c = Type.createInstance(Type.resolveClass(className), []);
				
				if (Std.is(c, Button)) { // TODO: Ugly
					if (xml.get("toggle") != null) {
						cast(c, Button).toggle = (xml.get("toggle") == "true");
					}
					if (xml.get("selected") != null) {
						cast(c, Button).selected = (xml.get("selected") == "true");
					}
				}
				
				if (Std.is(c, CheckBox)) { // TODO: Ugly
					if (xml.get("selected") != null) {
						cast(c, CheckBox).selected = (xml.get("selected") == "true");
					}
				}
				
				if (Std.is(c, OptionBox)) { // TODO: Ugly
					if (xml.get("selected") != null) {
						cast(c, OptionBox).selected = (xml.get("selected") == "true");
					}
					if (xml.get("group") != null) {
						cast(c, OptionBox).group = xml.get("group");
					}
				}
				
				if (Std.is(c, TextInput)) { // TODO: Ugly
					if (xml.get("multiline") != null) {
						cast(c, TextInput).multiline = (xml.get("multiline") == "true");
					}
				}
				
				if (Std.is(c, Image)) { // TODO: Ugly
					if (xml.get("asset") != null) {
						cast(c, Image).bitmapAssetPath = xml.get("asset");
					}
				}
			} catch (e:Dynamic) {
				trace("Problem creating class '" + className + "': " + Std.string(e));
			}
		}
		return c;
	}
	
	private static var registeredComponents = {
		component: "haxe.ui.core.Component",
		button: "haxe.ui.controls.Button",
		vbox: "haxe.ui.containers.VBox",
		hbox: "haxe.ui.containers.HBox",
		tabview: "haxe.ui.containers.TabView",
		rating: "haxe.ui.controls.RatingControl",
		progress: "haxe.ui.controls.ProgressBar",
		optionbox: "haxe.ui.controls.OptionBox",
		checkbox: "haxe.ui.controls.CheckBox",
		textfield: "haxe.ui.controls.TextInput",
		vscroll: "haxe.ui.controls.VScroll",
		hscroll: "haxe.ui.controls.HScroll",
		scrollview: "haxe.ui.containers.ScrollView",
		image: "haxe.ui.controls.Image",
		dropdown: "haxe.ui.controls.DropDownList",
		label: "haxe.ui.controls.Label",
		listview: "haxe.ui.containers.ListView",
	}
	
	private static function getComponentClass(name:String):String {
		var className:String = null;
		if (Reflect.hasField(registeredComponents, name)) {
			className = Reflect.field(registeredComponents, name);
		}
		return className;
	}
	
	private static function hasComponentClass(name:String):Bool {
		return Reflect.hasField(registeredComponents, name);
	}
	
	private static function processInlineStyle(xml:Xml):Bool {
		if (xml.nodeName == "style") {
			for (child in xml) {
				if (Std.string(child.nodeType) == "pcdata") {
					var inlineStyles:Styles = StyleParser.fromString(child.nodeValue);
					if (inlineStyles != null) {
						for (styleName in inlineStyles.styleNames) {
							StyleManager.styles.addStyle(styleName, inlineStyles.getStyle(styleName));
						}
					}
				}
			}
			return true;
		}
		return false;
	}
}