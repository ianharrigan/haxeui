package haxe.ui.toolkit.core.xml;

import haxe.ui.toolkit.core.ClassManager;
import haxe.ui.toolkit.data.DataManager;
import haxe.ui.toolkit.data.IDataSource;

class DataProcessor extends XMLProcessor {
	public function new() {
		super();
	}
	
	public override function process(node:Xml):Dynamic {
		var result:Dynamic = null; 
		var nodeName:String = stripNamespace(node.nodeName);
		
		var className:String = ClassManager.instance.getDataSourceClassName(nodeName);
		if (className != null) {
			result = createDataSource(className, node);
		}
		return result;
	}
	
	private static function createDataSource(className:String, config:Xml):IDataSource {
		var ds:IDataSource = Type.createInstance(Type.resolveClass(className), []);
		if (ds != null) {
			ds.create(config);
			DataManager.instance.registerDataSource(ds);
		};
		
		return ds;
	}
}