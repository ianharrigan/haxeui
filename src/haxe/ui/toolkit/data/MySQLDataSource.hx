package haxe.ui.toolkit.data;

#if (neko || cpp) // not suported on all platforms/targets
import sys.db.Connection;
import sys.db.Mysql;
import sys.db.ResultSet;
#end

class MySQLDataSource extends DataSource {
	/*
	private var _connectionDetails:Dynamic;
	private var _query:String;
	private var _currentRecord:Dynamic;
	#if (neko || cpp)
	private var _connection:Connection;
	private var _rs:ResultSet;
	#end
	
	public function new() {
		super();
		// read only
		allowAdditions = false;
		allowUpdates = false;
		allowDeletions = false;
	}
	
	//******************************************************************************************
	// Overrides
	//******************************************************************************************
	public override function create(config:Xml = null):Void {
		super.create(config);
		if (config == null) {
			return;
		}
		
		_id = config.get("id");
		
		var resource:String = config.get("resource");
		if (resource != null) {
			createFromString(resource);
		}
	}
	
	#if (neko || cpp)
	private override function _open():Bool {
		try {
			_connection = Mysql.connect(_connectionDetails);
		} catch (e:Dynamic) {
			trace("Problem connecting to MySQL database: " + _connectionDetails + " (" + e + ")");
			_connection = null;
			return false;
		}
		return true;
	}
	
	private override function _close():Bool {
		if (_connection != null) {
			_connection.close();
		}
		return true;
	}
	
	private override function _moveFirst():Bool {
		if (_connection == null) {
			return false;
		}
		_rs = _connection.request(_query);
		if (_rs == null) {
			return false;
		}
		var b:Bool = _rs.hasNext();
		if (b == true) {
			_currentRecord = _rs.next();
		} else {
			_currentRecord = null;
		}
		return b;
	}
	
	private override function _moveNext():Bool {
		if (_connection == null || _rs == null) {
			return false;
		}
		var b:Bool = _rs.hasNext();
		if (b == true) {
			_currentRecord = _rs.next();
		} else {
			_currentRecord = null;
		}
		return b;
	}
	
	private override function _get():Dynamic {
		return _currentRecord;
	}
	
	#end
	
	//******************************************************************************************
	// Helpers
	//******************************************************************************************
	public override function createFromString(data:String = null, config:Dynamic = null):Void {
		// eg: localhost:3306/haxe_db?user=root&password=root&q=SELECT FROM datasource1
		var serverDetails:String = data;
		var paramString:String = "";
		var n:Int = data.indexOf("?");
		if (n != -1) {
			serverDetails = data.substr(0, n);
			paramString = data.substr(n+1, data.length);
		}
		
		var host = serverDetails;
		var database = "";
		n = serverDetails.indexOf("/");
		if (n != -1) {
			host = serverDetails.substr(0, n);
			database = serverDetails.substr(n + 1, serverDetails.length);
		}
		var port:Int = 3306;
		n = host.indexOf(":");
		if (n != -1) {
			port = Std.parseInt(host.substr(n + 1, host.length));
			host = host.substr(0, n);
			
		}
		
		var query:String = null;
		var params:Array<String> = paramString.split("&");
		var connectionDetails:Dynamic = { };
		for (param in params) {
			n = param.indexOf("=");
			if (n != -1) {
				var paramName = param.substr(0, n);
				var paramValue = StringTools.trim(param.substr(n + 1, param.length));
				if (paramName.toLowerCase() == "query" || paramName.toLowerCase() == "q") {
					query = paramValue;
				} else {
					Reflect.setField(connectionDetails, paramName, paramValue);
				}
			}
		}
		
		Reflect.setField(connectionDetails, "host", host);
		Reflect.setField(connectionDetails, "port", port);
		Reflect.setField(connectionDetails, "database", database);
		Reflect.setField(connectionDetails, "socket", null);
		
		_connectionDetails = connectionDetails;
		_query = query;
	}
	
	public override function createFromResource(resourceId:String, config:Dynamic = null):Void {
		createFromString(resourceId, config);
	}
	*/
}