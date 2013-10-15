package haxe.ui.toolkit.core;

import haxe.ui.toolkit.controls.popups.BusyPopupContent;
import haxe.ui.toolkit.controls.popups.CalendarPopupContent;
import haxe.ui.toolkit.controls.popups.CustomPopupContent;
import haxe.ui.toolkit.controls.popups.ListPopupContent;
import haxe.ui.toolkit.controls.popups.Popup;
import haxe.ui.toolkit.controls.popups.SimplePopupContent;
import haxe.ui.toolkit.core.interfaces.IDisplayObject;
import haxe.ui.toolkit.data.ArrayDataSource;
import haxe.ui.toolkit.data.IDataSource;
import motion.Actuate;
import motion.easing.Linear;

class PopupManager {
	private static var _instance:PopupManager;
	public static var instance(get_instance, null):PopupManager;
	private static function get_instance():PopupManager {
		if (_instance == null) {
			_instance = new PopupManager();
		}
		return _instance;
	}
	
	//******************************************************************************************
	// Instance methods/props
	//******************************************************************************************
	//private var _transition:String = "slide";
	
	public function new() {
		
	}
	
	public function showSimple(root:Root, text:String, title:String = null, config:Dynamic = PopupButtonType.OK, fn:Dynamic->Void = null):Popup {
		var popupConfig:PopupConfig = getPopupConfig(config);
		var p:Popup = new Popup(title, new SimplePopupContent(text), popupConfig, fn);
		
		p.root = root;
		p.visible = false;
		centerPopup(p);
		if (popupConfig.modal == true) {
			root.showModalOverlay();
		}
		root.addChild(p);
		showPopup(p);
		
		return p;
	}
	
	public function showCustom(root:Root, display:IDisplayObject, title:String = null, config:Dynamic = PopupButtonType.CONFIRM, fn:Dynamic->Void = null):Popup {
		var popupConfig:PopupConfig = getPopupConfig(config);
		var p:Popup = new Popup(title, new CustomPopupContent(display), popupConfig, fn);

		p.root = root;
		p.visible = false;
		centerPopup(p);
		if (popupConfig.modal == true) {
			root.showModalOverlay();
		}
		root.addChild(p);
		showPopup(p);
		
		return p;
	}
	
	public function showList(root:Root, items:Dynamic, title:String = null, selectedIndex:Int = -1, fn:Dynamic->Void):Popup {
		var ds:IDataSource = null;
		if (Std.is(items, Array)) { // we need to convert items into a proper data source for the list
			var arr:Array<Dynamic> = cast(items, Array<Dynamic>);
			ds = new ArrayDataSource();
			for (item in arr) { // TODO: have to use objects in data sources else cant get proper object ids, means you cant just add an array of strings
				if (Std.is(item, String)) {
					var o:Dynamic = { };
					o.text = cast(item, String);
					ds.add(o);
				} else { // assume its an object
					ds.add(item);
				}
			}
		} else if (Std.is(items, IDataSource)) {
			ds = cast(items, IDataSource);
		}

		var p:Popup = new Popup(title, new ListPopupContent(ds, selectedIndex, fn), new PopupConfig());
		
		p.root = root;
		p.visible = false;
		centerPopup(p);
		root.showModalOverlay();
		root.addChild(p);
		showPopup(p);
		
		return p;
	}
	
	public function showBusy(root:Root, text:String, delay:Int = -1, title:String = null):Popup {
		var p:Popup = new Popup(title, new BusyPopupContent(text), new PopupConfig());
		
		p.root = root;
		p.visible = false;
		centerPopup(p);
		root.showModalOverlay();
		root.addChild(p);
		showPopup(p);
		
		return p;
	}

	public function showCalendar(root:Root, title:String = null, fn:Dynamic->Date->Void = null):Popup {
		var content:CalendarPopupContent = new CalendarPopupContent();
		var tempFn = function(button:Dynamic) {
			if (fn != null) {
				if (button == PopupButtonType.CONFIRM) {
					fn(button, content.selectedDate);
				} else {
					fn(button, null);
				}
			}
		}
		var p:Popup = new Popup(title, content, getPopupConfig(PopupButtonType.CONFIRM |PopupButtonType.CANCEL), tempFn);
		
		p.root = root;
		p.visible = false;
		centerPopup(p);
		root.showModalOverlay();
		root.addChild(p);
		showPopup(p);
		
		return p;
	}
	
	public function showPopup(p:Popup):Void {
		var transition:String = Toolkit.getTransitionForClass(Popup);
		if (transition == "slide") {
			var ypos:Float = p.y;
			p.y = -p.height;
			p.visible = true;
			Actuate.tween(p, .2, { y: ypos }, true).ease(Linear.easeNone).onComplete(function() {
			});
		} else if (transition == "fade") {
			p.sprite.alpha = 0;
			p.visible = true;
			Actuate.tween(p.sprite, .2, { alpha: 1 }, true).ease(Linear.easeNone).onComplete(function() {
			});
		} else {
			p.visible = true;
		}
	}
	
	public function hidePopup(p:Popup):Void {
		var transition:String = Toolkit.getTransitionForClass(Popup);
		if (transition == "slide") {
			Actuate.tween(p, .2, { y: p.root.height }, true).ease(Linear.easeNone).onComplete(function() {
				p.root.removeChild(p);
				p.root.hideModalOverlay();
			});
		} else if (transition == "fade") {
			Actuate.tween(p.sprite, .2, { alpha: 0 }, true).ease(Linear.easeNone).onComplete(function() {
				p.root.removeChild(p);
				p.root.hideModalOverlay();
			});
		} else {
			p.root.removeChild(p);
			p.root.hideModalOverlay();
		}
	}
	
	public function centerPopup(p:Popup):Void {
		p.x = Std.int((p.root.width / 2) - (p.width / 2));
		p.y = Std.int((p.root.height / 2) - (p.height / 2));
	}
	
	private function getPopupConfig(config:Dynamic):PopupConfig {
		var conf:PopupConfig = new PopupConfig();
		if (Std.is(config, Int)) {
			var n:Int = cast(config, Int);
			if (n & PopupButtonType.OK == PopupButtonType.OK) {
				conf.addButton(PopupButtonType.OK);
			}
			if (n & PopupButtonType.YES == PopupButtonType.YES) {
				conf.addButton(PopupButtonType.YES);
			}
			if (n & PopupButtonType.NO == PopupButtonType.NO) {
				conf.addButton(PopupButtonType.NO);
			}
			if (n & PopupButtonType.CANCEL == PopupButtonType.CANCEL) {
				conf.addButton(PopupButtonType.CANCEL);
			}
			if (n & PopupButtonType.CONFIRM == PopupButtonType.CONFIRM) {
				conf.addButton(PopupButtonType.CONFIRM);
			}
		} else if (Std.is(config, PopupConfig)) {
			conf = cast(config, PopupConfig);
		}
		return conf;
	}
}

class PopupConfig {
	public var buttons:Array<PopupButtonConfig>;
	public var id:String;
	public var styleName:String;
	public var modal:Bool = true;
	
	public function new() {
		buttons = new Array<PopupButtonConfig>();
	}
	
	public function addButton(type:Int):Void {
		var butConfig:PopupButtonConfig = new PopupButtonConfig();
		butConfig.type = type;
		buttons.push(butConfig);
	}
}

class PopupButtonConfig {
	public var type:Int;
	
	public function new() {
		
	}
}

class PopupButtonType {
	public static inline var OK:Int =      0x00000001;
	public static inline var YES:Int =     0x00000010;
	public static inline var NO:Int =      0x00000100;
	public static inline var CANCEL:Int =  0x00001000;
	public static inline var CONFIRM:Int = 0x00010000;
	public static inline var CUSTOM:Int =  0x00100000;
}