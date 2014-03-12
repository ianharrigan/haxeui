package haxe.ui.toolkit.core;

import haxe.Timer;
import haxe.ui.toolkit.controls.popups.BusyPopupContent;
import haxe.ui.toolkit.controls.popups.CalendarPopupContent;
import haxe.ui.toolkit.controls.popups.CustomPopupContent;
import haxe.ui.toolkit.controls.popups.ListPopupContent;
import haxe.ui.toolkit.controls.popups.Popup;
import haxe.ui.toolkit.controls.popups.PopupContent;
import haxe.ui.toolkit.controls.popups.SimplePopupContent;
import haxe.ui.toolkit.core.interfaces.IDisplayObject;
import haxe.ui.toolkit.core.PopupManager.PopupButtonInfo;
import haxe.ui.toolkit.data.ArrayDataSource;
import haxe.ui.toolkit.data.IDataSource;
import haxe.ui.toolkit.events.UIEvent;
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
	public var defaultTitle(default, default):String = "HaxeUI";
	public var defaultWidth(default, default):Int = 300;
	
	public function new() {
		
	}
	
	public function showSimple(text:String, title:String = null, config:Dynamic = PopupButton.OK, fn:Dynamic->Void = null):Popup {
		var p:Popup = buildPopup(new SimplePopupContent(text), title, config, fn);
		showPopup(p);
		return p;
	}
	
	public function showCustom(display:IDisplayObject, title:String = null, config:Dynamic = PopupButton.OK, fn:Dynamic->Void = null):Popup {
		var p:Popup = buildPopup(new CustomPopupContent(display), title, config, fn);
		showPopup(p);
		return p;
	}
	
	public function showList(items:Dynamic, selectedIndex:Int = -1, title:String = null, config:Dynamic = null, fn:Dynamic->Void = null):Popup {
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
		
		var p:Popup = buildPopup(new ListPopupContent(ds, selectedIndex, fn), title, config, fn);
		showPopup(p);
		return p;
	}
	
	public function showCalendar(title:String = null, fn:Dynamic->Date-> Void = null):Popup {
		var config:Dynamic = { modal: true, buttons: PopupButton.CONFIRM | PopupButton.CANCEL };
		var content:CalendarPopupContent = new CalendarPopupContent();
		var tempFn = function(button:Dynamic) {
			if (fn != null) {
				if (button == PopupButton.CONFIRM) {
					fn(button, content.selectedDate);
				} else {
					fn(button, null);
				}
			}
		}
		
		var p:Popup = buildPopup(content, title, config, tempFn);
		showPopup(p);
		return p;
	}
	
	public function showBusy(text:String, delay:Int = -1, title:String = null, config:Dynamic = null, fn:Dynamic->Void = null):Popup {
		if (config == null) {
			config = { };
		}
		config.useDefaultTitle = false;
		var p:Popup = buildPopup(new BusyPopupContent(text), title, config, fn);
		showPopup(p);
		
		if (delay > 0) {
			var timer:Timer = new Timer(delay);
			timer.run = function():Void {
				timer.stop();
				hidePopup(p);
			}
		}
		
		return p;
	}
	
	public function showPopup(p:Popup):Void {
		var modal:Bool = true;
		if (p.config.modal != null) {
			modal = p.config.modal;
		}
		if (modal == true) {
			p.root.showModalOverlay();
		}
		p.root.addChild(p);
		centerPopup(p);

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
	
	public function hidePopup(p:Popup, dispose:Bool = true):Void {
		var transition:String = Toolkit.getTransitionForClass(Popup);
		if (transition == "slide") {
			Actuate.tween(p, .2, { y: p.root.height }, true).ease(Linear.easeNone).onComplete(function() {
				p.root.removeChild(p, dispose);
				p.root.hideModalOverlay();
			});
		} else if (transition == "fade") {
			Actuate.tween(p.sprite, .2, { alpha: 0 }, true).ease(Linear.easeNone).onComplete(function() {
				p.root.removeChild(p, dispose);
				p.root.hideModalOverlay();
			});
		} else {
			p.root.removeChild(p, dispose);
			p.root.hideModalOverlay();
		}
	}
	
	public function centerPopup(p:Popup):Void {
		p.x = Std.int((p.root.width / 2) - (p.width / 2));
		p.y = Std.int((p.root.height / 2) - (p.height / 2));
	}
	
	private function buildPopup(content:PopupContent, title:String = null, config:Dynamic = null, fn:Dynamic->Void = null):Popup {
		config = buildConfig(config);
		if (title == null && config.useDefaultTitle == true) {
			title = PopupManager.instance.defaultTitle;
		}
		var p:Popup = new Popup(title, content, config, fn);
		p.root = config.root;
		p.visible = false;
		
		return p;
	}
	
	private function buildConfig(config:Dynamic):Dynamic {
		var c:Dynamic = { };
		c.id = null;
		c.styleName = null;
		c.modal = true;
		c.width = PopupManager.instance.defaultWidth;
		c.useDefaultTitle = true;
		c.root = RootManager.instance.currentRoot;

		if (config != null && Std.is(config, Int) == false) {
			c.id = (config.id != null) ? config.id : null;
			c.styleName = (config.styleName != null) ? config.styleName : null;
			c.modal = (config.modal != null) ? config.modal : true;
			c.width = (config.width != null) ? config.width : PopupManager.instance.defaultWidth;
			c.useDefaultTitle = (config.useDefaultTitle != null) ? config.useDefaultTitle : true;
			c.root = (config.root != null) ? config.root : RootManager.instance.currentRoot;
		}

		c.buttons = new Array<PopupButtonInfo>();
		if (config != null) {
			if (Std.is(config, Int)) {
				c.buttons = buildButtonArray(config);
			} else if (Std.is(config, Array)) {
				c.buttons = buildButtonArray(config);
			} else {
				if (config.buttons != null) {
					c.buttons = buildButtonArray(config.buttons);
				}
			}
		}
		
		return c;
	}
	
	private function buildButtonArray(data:Dynamic):Array<PopupButtonInfo> {
		var buttons:Array<PopupButtonInfo> = new Array<PopupButtonInfo>();
		if (Std.is(data, Int)) {
			var n:Int = cast(data, Int);
			if (n & PopupButton.OK == PopupButton.OK) {
				buttons.push(new PopupButtonInfo(PopupButton.OK));
			}
			if (n & PopupButton.YES == PopupButton.YES) {
				buttons.push(new PopupButtonInfo(PopupButton.YES));
			}
			if (n & PopupButton.NO == PopupButton.NO) {
				buttons.push(new PopupButtonInfo(PopupButton.NO));
			}
			if (n & PopupButton.CANCEL == PopupButton.CANCEL) {
				buttons.push(new PopupButtonInfo(PopupButton.CANCEL));
			}
			if (n & PopupButton.CONFIRM == PopupButton.CONFIRM) {
				buttons.push(new PopupButtonInfo(PopupButton.CONFIRM));
			}
		} else if (Std.is(data, Array)) {
			var arr:Array<Dynamic> = cast data;
			for (item in arr) {
				if (Std.is(item, Int)) {
					buttons.push(new PopupButtonInfo(cast(item, Int)));
				} else {
					var type:Int = PopupButton.CUSTOM;
					if (item.type != null) {
						type = item.type;
					}
					var text = item.text;
					var fn = item.fn;
					buttons.push(new PopupButtonInfo(type, text, fn));
				}
			}
		}	
		return buttons;
	}
}

class PopupButton {
	public static inline var OK:Int =      0x00000001;
	public static inline var YES:Int =     0x00000010;
	public static inline var NO:Int =      0x00000100;
	public static inline var CANCEL:Int =  0x00001000;
	public static inline var CONFIRM:Int = 0x00010000;
	public static inline var CUSTOM:Int =  0x00100000;
}

class PopupButtonInfo {
	public var type:Int = -1;
	public var text:String;
	public var fn:Dynamic->Void;
	
	public function new(type:Int = PopupButton.OK, text:String = null, fn:Dynamic->Void = null) {
		this.type = type;
		this.text = text;
		this.fn = fn;
	}
}
