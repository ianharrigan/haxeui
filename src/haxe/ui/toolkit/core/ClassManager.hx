package haxe.ui.toolkit.core;

import haxe.ui.toolkit.core.interfaces.IDisplayObject;
import haxe.ui.toolkit.data.IDataSource;

class ClassManager {
	private static var _instance:ClassManager;
	public static var instance(get, null):ClassManager;
	private static function get_instance():ClassManager {
		if (_instance == null) {
			_instance = new ClassManager();
		}
		return _instance;
	}
	
	//******************************************************************************************
	// Instance methods/props
	//******************************************************************************************
	public function new() {
		registerDefaults();
	}

	private function registerDefaults():Void {
		Macros.registerComponentPackage("haxe.ui.toolkit.containers", "ui");
		Macros.registerComponentPackage("haxe.ui.toolkit.controls", "ui");
		Macros.registerComponentPackage("haxe.ui.toolkit.controls.selection", "selection");
		Macros.registerDataSourcePackage("haxe.ui.toolkit.data");
	}

	//******************************************************************************************
	// Component class registry
	//******************************************************************************************
	private var componentClassPrefixMap:Hash<String>;
	private var componentClassMap:Hash<ComponentRegistryEntry>;
	
	public function getComponentClassName(simpleName:String, prefix:String):String {
		if (componentClassMap == null) {
			return null;
		}
		
		var key:String = simpleName;
		if (prefix != null) {
			key = prefix + ":" + simpleName;
		}
		
		var entry:ComponentRegistryEntry = componentClassMap.get(key);
		if (entry == null) {
			return null;
		}
		return entry.className;
	}
	
	public function registerComponentClass(cls:Class<IDisplayObject>, simpleName:String, prefix:String):Void {
		var className:String = Type.getClassName(cls);
		registerComponentClassName(className, simpleName, prefix);
	}
	
	private function registerComponentClassName(className:String, simpleName:String, prefix:String):Void {
		if (componentClassPrefixMap == null) {
			componentClassPrefixMap = new Hash<String>();
		}
		if (componentClassMap == null) {
			componentClassMap = new Hash<ComponentRegistryEntry>();
		}
		
		var entry:ComponentRegistryEntry = new ComponentRegistryEntry();
		entry.simpleName = simpleName;
		entry.prefix = prefix;
		entry.className = className;
		componentClassPrefixMap.set(prefix, prefix);
		componentClassMap.set(prefix + ":" + simpleName, entry);
	}
	
	//******************************************************************************************
	// Data source class registry
	//******************************************************************************************
	private var dataSourceClassMap:Hash<DataSourceRegistryEntry>;
	
	public function getDataSourceClassName(simpleName:String):String {
		if (dataSourceClassMap == null) {
			return null;
		}
		
		var entry:DataSourceRegistryEntry = dataSourceClassMap.get(simpleName);
		if (entry == null) {
			return null;
		}
		
		return entry.className;
	}
	
	public function registerDataSourceClass(cls:Class<IDataSource>, simpleName:String):Void {
		var className:String = Type.getClassName(cls);
		registerDataSourceClassName(className, simpleName);
	}
	
	private function registerDataSourceClassName(className:String, simpleName:String):Void {
		if (dataSourceClassMap == null) {
			dataSourceClassMap = new Hash<DataSourceRegistryEntry>();
		}
		
		var entry:DataSourceRegistryEntry = new DataSourceRegistryEntry();
		entry.simpleName = simpleName;
		entry.className = className;
		dataSourceClassMap.set(simpleName, entry);
	}
}

private class ClassRegistryEntry {
	public function new() {
		
	}
	
	public var simpleName:String;
	public var className:String;
}

private class ComponentRegistryEntry extends ClassRegistryEntry {
	public var prefix:String;
}

private class DataSourceRegistryEntry extends ClassRegistryEntry {
	
}