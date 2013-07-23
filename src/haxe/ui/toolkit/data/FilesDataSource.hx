package haxe.ui.toolkit.data;

#if !(flash)
import sys.FileSystem;
#end

class FilesDataSource extends ArrayDataSource {
	private var _dir:String;
	
	public function new() {
		super();
	}
	
	//******************************************************************************************
	// Overrides
	//******************************************************************************************
	public override function create(config:Xml = null):Void {
		//super.create(config);
		if (config == null) {
			return;
		}
		
		_id = config.get("id");
		
		var resource:String = config.get("resource");
		if (resource != null) {
			createFromString(resource);
		}
	}
	
	private override function _open():Bool {
		#if !(flash)
		if (isDir(_dir)) {
			var files:Array<String> = FileSystem.readDirectory(_dir);
		
			for (file in files) {
				if (FileSystem.isDirectory(_dir + "/" + file)) { // add dirs first
					var o = { text: file };
					add(o);
				}
			}
			
			for (file in files) {
				if (!FileSystem.isDirectory(_dir + "/" + file)) { // add dirs first
					var o = { text: file };
					add(o);
				}
			}
		}
		#end
		return true;
	}
	
	//******************************************************************************************
	// Helpers
	//******************************************************************************************
	public override function createFromString(data:String = null, config:Dynamic = null):Void {
		if (data != null) {
			_dir = fixDir(data);
		}
	}
	
	public override function createFromResource(resourceId:String, config:Dynamic = null):Void {
		createFromString(resourceId, config);
	}
	
	private function isDir(dir:String):Bool { // neko throws an exception on isDirectory, so move to a safer function
		var isDir:Bool = false;
		
		#if !(flash)
		try {
			if (isRoot(dir)) {
				dir += "/";
			}
			isDir = FileSystem.isDirectory(dir);
		} catch (ex:Dynamic) {
			isDir = false;
		}
		#end
		
		return isDir;
	}

	private function isRoot(dir:String):Bool {
		var isRoot:Bool = false;
		
		#if !(flash)
		isRoot = dir.split("/").length == 1;
		#end
		
		return isRoot;
	}
	
	private function fixDir(dir:String):String {
		if (dir == null) {
			return "";
		}
		
		var fixedDir:String = dir;
		fixedDir = StringTools.replace(fixedDir, "\\", "/");
		
		if (fixedDir.lastIndexOf("/") == fixedDir.length-1 || fixedDir.lastIndexOf("\\") == fixedDir.length-1) {
			fixedDir = fixedDir.substr(0, fixedDir.length - 1);
		}
		
		return fixedDir;
	}
}