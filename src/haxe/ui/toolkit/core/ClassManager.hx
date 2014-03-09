package haxe.ui.toolkit.core;

import haxe.ds.StringMap;
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
		Macros.registerComponentPackage("haxe.ui.toolkit.containers");
		Macros.registerComponentPackage("haxe.ui.toolkit.controls");
		Macros.registerComponentPackage("haxe.ui.toolkit.controls.selection");
		Macros.registerComponentPackage("haxe.ui.toolkit.controls.extended");
		Macros.registerComponentPackage("haxe.ui.toolkit.core");
		Macros.registerComponentPackage("haxe.ui.toolkit.core.renderers");
		Macros.registerDataSourcePackage("haxe.ui.toolkit.data");
	}

	//******************************************************************************************
	// Component class registry
	//******************************************************************************************
	private var componentClassMap:StringMap<ComponentRegistryEntry>;
	
	public function getComponentClassName(simpleName:String):String {
		if (componentClassMap == null) {
			return null;
		}
		
		var key:String = simpleName;
		
		var entry:ComponentRegistryEntry = componentClassMap.get(key);
		if (entry == null) {
			return null;
		}
		return entry.className;
	}
	
	public function registerComponentClass(cls:Class<IDisplayObject>, simpleName:String):Void {
		var className:String = Type.getClassName(cls);
		registerComponentClassName(className, simpleName);
	}
	
	private function registerComponentClassName(className:String, simpleName:String):Void {
		if (componentClassMap == null) {
			componentClassMap = new StringMap<ComponentRegistryEntry>();
		}
		
		var entry:ComponentRegistryEntry = new ComponentRegistryEntry();
		entry.simpleName = simpleName;
		entry.className = className;
		componentClassMap.set(simpleName, entry);
	}
	
	//******************************************************************************************
	// Data source class registry
	//******************************************************************************************
	private var dataSourceClassMap:StringMap<DataSourceRegistryEntry>;
	
	public function hasDataSourceClass(simpleName:String):Bool {
		if (dataSourceClassMap == null) {
			return false;
		}
		
		return dataSourceClassMap.exists(simpleName);
	}
	
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
			dataSourceClassMap = new StringMap<DataSourceRegistryEntry>();
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