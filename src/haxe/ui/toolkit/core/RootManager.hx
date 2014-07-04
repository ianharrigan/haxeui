package haxe.ui.toolkit.core;

import openfl.events.Event;
import openfl.Lib;
import haxe.ui.toolkit.core.Root;

class RootManager {
	private static var _instance:RootManager;
	public static var instance(get_instance, null):RootManager;
	private static function get_instance():RootManager {
		if (_instance == null) {
			_instance = new RootManager();
		}
		return _instance;
	}
	
	//******************************************************************************************
	// Instance methods/props
	//******************************************************************************************
	private var _roots:Array<Root>;
	
	public function new() {
		_roots = new Array<Root>();
	}
	
	public function createRoot(options:Dynamic = null, fn:Root->Void = null):Root {
		if (options == null) {
			options = { };
		}

		options.parent = (options.parent != null) ? options.parent : Lib.current.stage;

		var root:Root = new Root();
		_roots.push(root);
		root.addEventListener(Event.ADDED_TO_STAGE, function(e) {
			if (fn != null) {
				#if ios
					haxe.Timer.delay(function() fn(root), 100); // iOS 6
				#else
					fn(root);
				#end
			}
			root.removeEventListenerType(Event.ADDED_TO_STAGE);
		});
		
		root.root = root;
		root.id = (options.id != null) ? options.id : "root";
		root.styleName = (options.styleName != null) ? options.styleName : null;
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
		if (root.sprite.parent != null)
			root.sprite.parent.removeChild(root.sprite);
		root.dispose();
		
		_roots.remove(root);
	}
	
	public function destroyAllRoots():Void {
		for (root in _roots) {
			destroyRoot(root);
		}
	}
	
	public var roots(get, null):Array<Root>;
	public function get_roots():Array<Root> {
		return _roots;
	}
	
	public var currentRoot(get, null):Root;
	public function get_currentRoot():Root {
		if (_roots.length == 0) {
			return null;
		}
		return _roots[_roots.length - 1];
	}
}