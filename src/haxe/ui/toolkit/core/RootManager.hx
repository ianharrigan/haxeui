package haxe.ui.toolkit.core;

import flash.events.Event;
import flash.Lib;
import haxe.ui.toolkit.core.Root;

class RootManager {
	private static var _instance:RootManager;
	public static var instance(get_instance, null):RootManager;
	public static function get_instance():RootManager {
		if (_instance == null) {
			_instance = new RootManager();
		}
		return _instance;
	}
	
	//******************************************************************************************
	// Instance methods/props
	//******************************************************************************************
	public function new() {
		
	}
	
	public function createRoot(options:Dynamic = null, fn:Root->Void = null):Root {
		if (options == null) {
			options = { };
		}

		options.parent = (options.parent != null) ? options.parent : Lib.current.stage;

		var root:Root = new Root();
		root.addEventListener(Event.ADDED_TO_STAGE, function(e) {
			if (fn != null) {
				#if ios
					haxe.Timer.delay(fn(root), 100); // iOS 6
				#else
					fn(root);
				#end
			}
			root.removeEventListenerType(Event.ADDED_TO_STAGE);
		});
		
		root.root = root;
		root.id = (options.id != null) ? options.id : "root";
		root.x = (options.x != null) ? options.x : 0;
		root.y = (options.y != null) ? options.y : 0;
		root.width = (options.width != null) ? options.width : 0;
		root.height = (options.height != null) ? options.height : 0;
		root.percentWidth = (options.percentWidth != null) ? options.percentWidth : -1;
		root.percentHeight = (options.percentHeight != null) ? options.percentHeight : -1;
		options.parent.addChild(root.sprite);
		
		return root;
	}
	
	public function destroyRoot(root:Root):Void {
		var options:Dynamic = null;
		if (options == null) {
			options = { };
		}

		options.parent = (options.parent != null) ? options.parent : Lib.current.stage;
		options.parent.removeChild(root.sprite);
		root.dispose();
	}
}