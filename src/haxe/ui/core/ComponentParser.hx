package haxe.ui.core;

import haxe.ui.data.DataSource;
import haxe.ui.data.JSONDataSource;
import haxe.ui.data.MySQLDataSource;
import haxe.ui.resources.ResourceManager;
import haxe.ui.style.StyleManager;
import haxe.ui.style.StyleParser;
import haxe.ui.style.Styles;

// TODO: all components must be expicitliy included if you want to use the at runtime from xml
import haxe.ui.containers.HBox;
import haxe.ui.containers.ListView;
import haxe.ui.containers.ScrollView;
import haxe.ui.containers.TabView;
import haxe.ui.containers.VBox;

import haxe.ui.controls.Button;
import haxe.ui.controls.CheckBox;
import haxe.ui.controls.DropDownList;
import haxe.ui.controls.HScroll;
import haxe.ui.controls.HSlider;
import haxe.ui.controls.Image;
import haxe.ui.controls.Label;
import haxe.ui.controls.OptionBox;
import haxe.ui.controls.ProgressBar;
import haxe.ui.controls.RatingControl;
import haxe.ui.controls.Selector;
import haxe.ui.controls.TabBar;
import haxe.ui.controls.TextInput;
import haxe.ui.controls.ValueControl;
import haxe.ui.controls.VScroll;
import haxe.ui.containers.GridBox;
import haxe.ui.controls.VSlider;


class ComponentParser {
	public static function fromXMLResource(resourceId:String):Component {
		return fromXMLString(ResourceManager.getText(resourceId));
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
		
		if (xml.get("unless") != null && xml.get("unless").length > 0) { // make sure it satisfies the criteria
			var unlessValue = xml.get("unless");
			if (!Globals.has(unlessValue) == false) {
				return null;
			}
		}
		
		if (hasComponentClass(xml.nodeName) == false) {
			if (xml.nodeName == "style") {
				processInlineStyle(xml);
			} else if (xml.nodeName == "import") {
				var importResId:String = xml.get("resource");
				return fromXMLResource(importResId);
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
				//c.addStyleName(xml.get("styles"));
				c.styles = xml.get("styles");
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
				#if !html5
				c = Type.createInstance(Type.resolveClass(className), []);
				#else // TODO: no idea why, but new() is never called if createInstance method is used, visible here: http://try.haxe.org/#db121 (add trace to constructors)
				if (nodeName == "component") {
					c = new Component();
				} else if (nodeName == "button") {
					c = new Button();
				} else if (nodeName == "vbox") {
					c = new VBox();
				} else if (nodeName == "hbox") {
					c = new HBox();
				} else if (nodeName == "tabview") {
					c = new TabView();
				} else if (nodeName == "rating") {
					c = new RatingControl();
				} else if (nodeName == "progress") {
					c = new ProgressBar();
				} else if (nodeName == "optionbox") {
					c = new OptionBox();
				} else if (nodeName == "checkbox") {
					c = new CheckBox(); 
				} else if (nodeName == "textinput") {
					c = new TextInput();
				} else if (nodeName == "vscroll") {
					c = new VScroll();
				} else if (nodeName == "hscroll") {
					c = new HScroll();
				} else if (nodeName == "scrollview") {
					c = new ScrollView();
				} else if (nodeName == "image") {
					c = new Image();
				} else if (nodeName == "dropdown") {
					c = new DropDownList();
				} else if (nodeName == "label") {
					c = new Label();
				} else if (nodeName == "valuecontrol") {
					c = new ValueControl();
				} else if (nodeName == "listview") {
					c = new ListView();
				} else if (nodeName == "hslider") {
					c = new HSlider();
				} else if (nodeName == "vslider") {
					c = new VSlider();
				} else if (nodeName == "grid") {
					c = new GridBox()
				} else if (nodeName == "gridbox") {
					c = new GridBox();
				}
				#end
				
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
					if (xml.get("resource") != null) {
						cast(c, Image).resourceId = xml.get("resource");
					}
				}
				
				if (Std.is(c, ListView)) { // TODO: Ugly
					if (xml.get("dataSource") != null) {
						var dsString:String = xml.get("dataSource");
						cast(c, ListView).dataSource = createDataSource(dsString);
					}
				}
				
				if (Std.is(c, DropDownList)) { // TODO: Ugly
					if (xml.get("dataSource") != null) {
						var dsString:String = xml.get("dataSource");
						cast(c, DropDownList).dataSource = createDataSource(dsString);
					}
				}
				
				if (Std.is(c, GridBox)) { // TODO: Ugly
					if (xml.get("columns") != null) {
						var columnsString:String = xml.get("columns");
						cast(c, GridBox).columns = Std.parseInt(columnsString);
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
		textinput: "haxe.ui.controls.TextInput",
		vscroll: "haxe.ui.controls.VScroll",
		hscroll: "haxe.ui.controls.HScroll",
		scrollview: "haxe.ui.containers.ScrollView",
		image: "haxe.ui.controls.Image",
		dropdown: "haxe.ui.controls.DropDownList",
		label: "haxe.ui.controls.Label",
		valuecontrol: "haxe.ui.controls.ValueControl",
		listview: "haxe.ui.containers.ListView",
		hslider: "haxe.ui.controls.HSlider",
		vslider: "haxe.ui.controls.VSlider",
		grid: "haxe.ui.containers.GridBox",
		gridbox: "haxe.ui.containers.GridBox",
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
			if (xml.get("resource") != null) {
				var styleRes:String = xml.get("resource");
				StyleManager.loadFromResource(styleRes);
			}
			
			for (child in xml) {
				if (Std.string(child.nodeType) == "pcdata") {
					var styles:Styles = StyleParser.fromString(child.nodeValue);
					if (styles != null) {
						for (rule in styles.rules) {
							StyleManager.addStyle(rule, styles.getStyle(rule));
						}
					}
				}
			}
			return true;
		}
		return false;
	}
	
	private static function createDataSource(dsString:String):DataSource {
		var ds:DataSource = null;
		var n:Int = dsString.indexOf("://");
		if (n == -1) {
			return null;
		}

		var dsType:String = dsString.substr(0, n);
		dsString = dsString.substr(n + 3, dsString.length);
		if (dsType == "json") {
			var sourceType:String = "resource";
			n = dsString.indexOf("://");
			if (n != -1) {
				sourceType = dsString.substr(0, n);
				dsString = dsString.substr(n + 3, dsString.length);
			}
			if (sourceType == "resource") {
				ds = JSONDataSource.fromResource(dsString);
			}
		} else if (dsType == "mysql") {
			ds = MySQLDataSource.fromConnectionString(dsString);
		}
		
		return ds;
	}
}