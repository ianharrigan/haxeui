package haxe.ui.data;

#if (neko || cpp) // not suported on all platforms/targets
import sys.db.Connection;
import sys.db.Mysql;
import sys.db.ResultSet;
#end

class MySQLDataSource extends DataSource {
	private var connectionDetails:Dynamic;
	private var query:String;
	private var currentRecord:Dynamic;
	#if (neko || cpp)
	private var connection:Connection;
	private var rs:ResultSet;
	#end
	
	public function new(connectionDetails:Dynamic, query:String) {
		super();
		// TODO: for now data source is read only
		allowAdditions = false;
		allowUpdates = false;
		allowDeletions = false;
		this.connectionDetails = connectionDetails;
		this.query = query;
	}
	
	#if (neko || cpp)
	public override function open():Bool {
		try {
			connection = Mysql.connect(connectionDetails);
		} catch (e:Dynamic) {
			trace("Problem connecting to MySQL database: " + connectionDetails);
			connection = null;
			return false;
		}
		return true;
	}
	
	public override function close():Bool {
		if (connection != null) {
			connection.close();
		}
		return true;
	}
	
	private override function internalMoveFirst():Bool {
		if (connection == null) {
			return false;
		}
		rs = connection.request(query);
		if (rs == null) {
			return false;
		}
		var b:Bool = rs.hasNext();
		if (b == true) {
			currentRecord = rs.next();
		} else {
			currentRecord = null;
		}
		return b;
	}

	private override function internalMoveNext():Bool {
		if (connection == null || rs == null) {
			return false;
		}
		var b:Bool = rs.hasNext();
		if (b == true) {
			currentRecord = rs.next();
		} else {
			currentRecord = null;
		}
		return b;
	}	
	
	private override function internalGet():Dynamic {
		return currentRecord;
	}
	#end
	
	//************************************************************
	//                  HELPERS
	//************************************************************
	public static function fromConnectionString(connectionString:String):MySQLDataSource {
		// eg: localhost:3306/haxe_db?user=root&password=root&q=SELECT FROM datasource1
		var serverDetails:String = connectionString;
		var paramString:String = "";
		var n:Int = connectionString.indexOf("?");
		if (n != -1) {
			serverDetails = connectionString.substr(0, n);
			paramString = connectionString.substr(n+1, connectionString.length);
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
		
		var ds:MySQLDataSource = new MySQLDataSource(connectionDetails, query);
		return ds;
	}
}