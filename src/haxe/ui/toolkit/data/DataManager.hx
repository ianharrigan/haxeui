package haxe.ui.toolkit.data;

import haxe.ui.toolkit.util.Identifier;

class DataManager {
	private static var _instance:DataManager;
	public static var instance(get_instance, null):DataManager;
	private static function get_instance():DataManager {
		if (_instance == null) {
			_instance = new DataManager();
		}
		return _instance;
	}
	
	//******************************************************************************************
	// Instance methods/props
	//******************************************************************************************
	private var _dataSourceMap:Hash<IDataSource>;
	
	/**
	 *		List of registered data sources.
	 **/
	public var dataSources(get, null):Array<IDataSource>;
	
	public function new() {
		_dataSourceMap = new Hash<IDataSource>();
	}
	
	/**
	 *		Registers a data source for global access.
	 *		@param dataSource The data source to register - if dataSource has no id one will be generated
	 **/
	public function registerDataSource(dataSource:IDataSource):Void {
		var dataSourceId:String = dataSource.id;
		if (dataSourceId == null || dataSourceId.length == 0) {
			dataSourceId = Identifier.guid();
			dataSource.id = dataSourceId;
		}
		_dataSourceMap.set(dataSourceId, dataSource);
	}
	
	private function get_dataSources():Array<IDataSource> {
		var arr:Array<IDataSource> = new Array<IDataSource>();
		for (ds in _dataSourceMap) {
			arr.push(ds);
		}
		return arr;
	}
}