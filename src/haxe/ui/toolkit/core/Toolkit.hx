package haxe.ui.toolkit.core;

import flash.Lib;
import haxe.ds.StringMap;
import haxe.ui.toolkit.controls.Menu;
import haxe.ui.toolkit.core.interfaces.IDataComponent;
import haxe.ui.toolkit.core.interfaces.IDisplayObject;
import haxe.ui.toolkit.core.interfaces.IDisplayObjectContainer;
import haxe.ui.toolkit.core.xml.DataProcessor;
import haxe.ui.toolkit.core.xml.IXMLProcessor;
import haxe.ui.toolkit.core.xml.StyleProcessor;
import haxe.ui.toolkit.core.xml.UIProcessor;
import haxe.ui.toolkit.data.DataManager;
import haxe.ui.toolkit.data.IDataSource;
import haxe.ui.toolkit.hscript.ClientWrapper;
import haxe.ui.toolkit.hscript.ScriptManager;
import haxe.ui.toolkit.resources.ResourceManager;
import haxe.ui.toolkit.style.DefaultStyles;
import haxe.ui.toolkit.style.StyleManager;
import haxe.ui.toolkit.style.StyleParser;
import haxe.ui.toolkit.style.Styles;
import haxe.ui.toolkit.util.TypeParser;

class Toolkit {
	private static var _instance:Toolkit;
	public static var instance(get, null):Toolkit;
	private static function get_instance():Toolkit {
		if (_instance == null) {
			Lib.current.stage.align = flash.display.StageAlign.TOP_LEFT;
			Lib.current.stage.scaleMode = flash.display.StageScaleMode.NO_SCALE;
			_instance = new Toolkit();
		}
		return _instance;
	}
	
	public static function init():Void {
		get_instance();
		registerXMLProcessor(UIProcessor, "ui");
		registerXMLProcessor(UIProcessor, "selection");
		registerXMLProcessor(StyleProcessor, "style");
		registerXMLProcessor(DataProcessor, "data");

		if (_defaultTransition != "none" && _transitionRegister.get(Type.getClassName(Menu)) == null) {
			setTransitionForClass(Menu, "fade"); // fade looks nicer
		}
		
		if (StyleManager.instance.hasStyles == false && _useDefaultStyles == true) {
			StyleManager.instance.addStyles(new DefaultStyles());
		}
	}

	private static var _registeredProcessors:StringMap<String>;
	public static function registerXMLProcessor(cls:Class<IXMLProcessor>, prefix:String):Void {
		if (_registeredProcessors == null) {
			_registeredProcessors = new StringMap<String>();
		}
		_registeredProcessors.set(prefix, Type.getClassName(cls));
	}
	
	//******************************************************************************************
	// Processes a chunk of xml, return values depend on what comes in, could return IDisplayObject, IDataSource
	// processing means constructing ui, registering data sources
	//******************************************************************************************
	public static function processXmlResource<T>(resourceId:String):Null<T> {
		return processXml(ResourceManager.instance.getXML(resourceId));
	}
	
	public static function processXml<T>(xml:Xml):Null<T> {
		var result:Dynamic = null;
		
		result = processXmlNode(xml.firstElement());
		
		return cast result;
	}
	
	private static function processXmlNode<T>(node:Xml):Null<T> {
		if (node == null) {
			return null;
		}
		
		var result:Dynamic = null; 
		var nodeName:String = node.nodeName;
		var n:Int = nodeName.indexOf(":");
		if (n != -1) {
			nodeName = nodeName.substr(n + 1, nodeName.length);
		}
		nodeName = nodeName.toLowerCase();

		var condition:String = node.get("condition");
		if (condition != null) {
			var parser = new hscript.Parser();
			var program = parser.parseString(condition);
			var interp = new hscript.Interp();
			var clientWrapper:ClientWrapper = new ClientWrapper();
			interp.variables.set("Client", clientWrapper);
			var conditionResult:Bool = interp.execute(program);
			if (conditionResult == false) {
				return null;
			}
		}
		
		if (nodeName == "import") {
			var importResource = node.get("resource");
			if (importResource != null) {
				var importData:String = ResourceManager.instance.getText(importResource);
				if (importData != null) {
					var importXml:Xml = Xml.parse(importData);
					return processXml(importXml);
				}
			}
		} else if (nodeName == "script") {
			var scriptResource = node.get("resource");
			var scriptData:String = "";
			if (scriptResource != null) {
				scriptData += ResourceManager.instance.getText(scriptResource);
			}
			var scriptNodeData:String = node.firstChild().nodeValue;
			if (scriptNodeData != null) {
				scriptNodeData = StringTools.trim(scriptNodeData);
				scriptData += "\n\n" + scriptNodeData;
			}
			ScriptManager.instance.addScript(scriptData);
		} else if (nodeName == "style") {
			var p:IXMLProcessor = new StyleProcessor();
			result = p.process(node);
		} else {
			if (ClassManager.instance.hasDataSourceClass(nodeName)) {
				var p:IXMLProcessor = new DataProcessor();
				result = p.process(node);
			} else {
				var p:IXMLProcessor = new UIProcessor();
				result = p.process(node);
			}
		}
		
		for (child in node.elements()) {
			var childResult = processXmlNode(child);
			
			if (Std.is(childResult, IDataSource) && Std.is(result, IDataComponent)) {
				cast(result, IDataComponent).dataSource = cast(childResult, IDataSource);
			}
			
			if (Std.is(childResult, IDisplayObject) && Std.is(result, IDisplayObjectContainer)) {
				cast(result, IDisplayObjectContainer).addChild(cast(childResult, IDisplayObject));
			}
		}
		
		return cast result;
	}
	
	//******************************************************************************************
	// Animation defaults
	//******************************************************************************************
	private static var _useDefaultStyles:Bool = true;
	private static var _defaultTransition:String = "slide";
	private static var _transitionRegister:StringMap<String>;
	
	public static var defaultTransition(get, set):String;
	public static var useDefaultStyles(get, set):Bool;	
	
	private static function get_defaultTransition():String {
		return _defaultTransition;
	}
	
	private static function set_defaultTransition(value:String):String {
		_defaultTransition = value;
		return value;
	}

	private static function get_useDefaultStyles():Bool {
		return _useDefaultStyles;
	}
	
	private static function set_useDefaultStyles(value:Bool):Bool {
		_useDefaultStyles = value;
		return value;
	}
	
	public static function getTransitionForClass(cls:Class<IDisplayObject>):String {
		var s = _defaultTransition;
		var className:String = Type.getClassName(cls);
		if (_transitionRegister != null && _transitionRegister.get(className) != null) {
			s = _transitionRegister.get(className);
		}
		return s;
	}
	
	public static function setTransitionForClass(cls:Class<IDisplayObject>, transition:String):Void {
		if (_transitionRegister == null) {
			_transitionRegister = new StringMap<String>();
		}
		var className:String = Type.getClassName(cls);
		_transitionRegister.set(className, transition);
	}
	
	//******************************************************************************************
	// Instance methods/props
	//******************************************************************************************
	public function new() {
		initInstance();
	}
	
	private function initInstance() {
		_transitionRegister = new StringMap<String>();
		ClassManager.instance;
	}
	
	public static function openFullscreen(fn:Root->Void = null):Root {
		var root:Root = RootManager.instance.createRoot({x: 0, y: 0, percentWidth: 100, percentHeight: 100}, fn);
		return root;
	}
	
	public static function openPopup(options:Dynamic = null, fn:Root->Void = null):Root {
		if (options == null) {
			options = { };
		}
		
		options.x = (options.x != null) ? options.x : 20;
		options.y = (options.y != null) ? options.y : 20;
		options.styleName = (options.styleName != null) ? options.styleName : "popup";
		
		var root:Root = RootManager.instance.createRoot(options, fn);
		return root;
	}
}