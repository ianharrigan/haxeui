package haxe.ui.toolkit.core.xml;

import flash.xml.XML;
import haxe.ui.toolkit.core.ClassManager;
import haxe.ui.toolkit.core.Component;
import haxe.ui.toolkit.core.interfaces.IDataComponent;
import haxe.ui.toolkit.core.interfaces.IDisplayObject;
import haxe.ui.toolkit.core.StyleableDisplayObject;
import haxe.ui.toolkit.data.DataManager;
import haxe.ui.toolkit.data.IDataSource;
import haxe.ui.toolkit.hscript.ScriptManager;
import haxe.ui.toolkit.hscript.ScriptUtils;
import haxe.ui.toolkit.style.Style;
import haxe.ui.toolkit.style.StyleParser;
import haxe.ui.toolkit.style.Styles;
import haxe.ui.toolkit.util.TypeParser;

class UIProcessor extends XMLProcessor {
	public function new() {
		super();
	}

	public override function process(node:Xml):Dynamic {
		var result:Dynamic = null;
		var nodeName:String = node.nodeName;
		var nodeNS:String = null;
		var n:Int = nodeName.indexOf(":");
		if (n != -1) {
			nodeNS = nodeName.substr(0, n);
			nodeName = nodeName.substr(n + 1, nodeName.length);
		}
		
		var className:String = ClassManager.instance.getComponentClassName(nodeName, nodeNS);
		var direction:String = node.get("direction");
		if (direction != null) {
			var directionalPrefix:String = direction.substr(0, 1);
			var directionalName:String = directionalPrefix + nodeName;
			var directionalClassName:String = ClassManager.instance.getComponentClassName(directionalName, nodeNS);
			if (directionalClassName != null) {
				className = directionalClassName;
			}
		}
		if (className != null) {
			result = createComponent(className, node);
		}
		return result;
	}
	
	private static function createComponent(className, config:Xml):IDisplayObject {
		var c:Component = Type.createInstance(Type.resolveClass(className), []);

		for (attr in config.attributes()) {
			if (StringTools.startsWith(attr, "xmlns:")) {
				continue;
			}
			
			var value:String = config.get(attr);
			if (ScriptUtils.isScript(value) && attr != "text" && attr != "id" && attr != "dataSource" && attr != "resource" && attr != "htmlText") {
				value = ScriptManager.instance.executeScript(value);
			}
			
			if (attr == "width") { // special case for width, want to be able to specify % values
				var width:Float = 0;
				var percentWidth:Int = -1;
				var widthString:String = value;
				if (widthString != null) {
					width = Std.parseInt(widthString);
					if (widthString.indexOf("%") != -1) {
						width = 0;
						percentWidth = Std.parseInt(widthString.substr(0, widthString.length - 1));
					}
				}
				
				if (width != 0) {
					c.width = width;
				}
				if (percentWidth != -1) {
					c.percentWidth = percentWidth;
				}
			} else if (attr == "height") { // special case for height, want to be able to specify % values
				var height:Float = 0;
				var percentHeight:Int = -1;
				var heightString:String = value;
				if (heightString != null) {
					height = Std.parseInt(heightString);
					if (heightString.indexOf("%") != -1) {
						height = 0;
						percentHeight = Std.parseInt(heightString.substr(0, heightString.length - 1));
					}
				}
				
				if (height != 0) {
					c.height = height;
				}
				if (percentHeight != -1) {
					c.percentHeight = percentHeight;
				}
			} else if (attr == "style") { // ignore condition attr
				if (Std.is(c, StyleableDisplayObject)) {
					var inlineStyles:Styles = StyleParser.fromString("_temp {" + value + "}");
					if (inlineStyles != null) {
						var style:Style = inlineStyles.getStyle("_temp");
						if (style != null) {
							cast(c, StyleableDisplayObject).inlineStyle = style;
						}
					}
				}
			} else if (attr == "condition") { // ignore condition attr
			} else if (attr == "dataSource") { // special handling
				if (Std.is(c, IDataComponent)) {
					var dataComponent:IDataComponent = cast(c, IDataComponent);
					var registeredDataSource:IDataSource = DataManager.instance.getRegisteredDataSource(value);
					if (registeredDataSource != null) {
						dataComponent.dataSource = registeredDataSource;
					} else {
						var n:Int = value.indexOf("://");
						if (n != -1) {
							var proto:String = value.substr(0, n);
							value = value.substr(n + 3, value.length);
							var className:String = ClassManager.instance.getDataSourceClassName(proto);
							var ds:IDataSource = Type.createInstance(Type.resolveClass(className), []);
							if (ds != null) {
								ds.createFromResource(value);
								DataManager.instance.registerDataSource(ds);
								dataComponent.dataSource = ds;
							}
						}
					}
				}
			} else if (attr == "text") {
				c.text = value;
			} else {
				try {
					if (Std.parseInt(value) != null) {
						Reflect.setProperty(c, attr, Std.parseInt(value));
					} else if (value == "true" || value == "yes" || value == "false" || value == "no") {
						Reflect.setProperty(c, attr, TypeParser.parseBool(value));
					} else {
						Reflect.setProperty(c, attr, value);
					}
				} catch (e:Dynamic) {
					trace("Exception setting component property: " + attr + " (" + e + ")");
				}
			}
		}
		
		return c;
	}
}