package haxe.ui.toolkit.controls.popups;

import flash.events.MouseEvent;
import haxe.ui.toolkit.containers.HBox;
import haxe.ui.toolkit.containers.VBox;
import haxe.ui.toolkit.controls.Button;
import haxe.ui.toolkit.controls.Spacer;
import haxe.ui.toolkit.controls.Text;
import haxe.ui.toolkit.core.interfaces.IDraggable;
import haxe.ui.toolkit.core.PopupManager;

class Popup extends VBox implements IDraggable {
	private var _titleBar:HBox;
	private var _title:Text;
	private var _content:PopupContent;
	private var _buttonBar:HBox;
	private var _config:PopupConfig;
	private var _fn:Dynamic->Void;
	
	public function new(title:String = null, content:PopupContent = null, config:PopupConfig = null, fn:Dynamic->Void = null) {
		super();
		_autoSize = true;
		
		if (title != null) {
			_titleBar = new HBox();
			_titleBar.autoSize = false;
			_titleBar.id = "titleBar";
		}
		
		_content = content;
		
		if (title != null) {
			_title = new Text();
			_title.id = "title";
			//_title.width = 1000;
			//_title.autoSize = false;
			_title.text = title;
		}
		
		_buttonBar = new HBox();
		_buttonBar.autoSize = false;
		_buttonBar.id = "buttonBar";
		
		_config = config;
		if (_config == null) {
			_config = new PopupConfig();
			_config.addButton(PopupButtonType.OK);
		}
		
		_fn = fn;
	}
	
	//******************************************************************************************
	// Overrides
	//******************************************************************************************
	private override function initialize():Void {
		super.initialize();
		
		if (_titleBar != null) {
			_titleBar.percentWidth = 100;
			_titleBar.addChild(_title);
			_titleBar.sprite.buttonMode = true;
			_titleBar.sprite.useHandCursor = true;
			addChild(_titleBar);
		}
		
		if (_content == null) {
			_content = new PopupContent();
		}
		_content.id = "content";
		_content.percentWidth = 100;
		//_content.percentHeight = 100;
		addChild(_content);
		
		if (_config.buttons.length > 0) {
			_buttonBar.percentWidth = 100;
			var spacer:Spacer = new Spacer();
			spacer.percentWidth = 50;
			_buttonBar.addChild(spacer);
			
			for (but in _config.buttons) {
				if (but.type != PopupButtonType.CUSTOM) {
					addStandardButton(but.type);
				}
			}

			var spacer:Spacer = new Spacer();
			spacer.percentWidth = 50;
			_buttonBar.addChild(spacer);
			
			addChild(_buttonBar);
		}
		
		PopupManager.instance.centerPopup(this);
	}
	
	//******************************************************************************************
	// IDraggable
	//******************************************************************************************
	public function allowDrag(event:MouseEvent):Bool {
		return _titleBar.hitTest(event.stageX, event.stageY);
	}

	//******************************************************************************************
	// Helpers
	//******************************************************************************************
	private function addStandardButton(v:Int):Void {
		if (v == PopupButtonType.OK) {
			var button:Button = new Button();
			button.text = "OK";
			button.addEventListener(MouseEvent.CLICK, function(e) {
				PopupManager.instance.hidePopup(this);
				if (_fn != null) {
					_fn(PopupButtonType.OK);
				}
			});
			_buttonBar.addChild(button);
		}
		if (v == PopupButtonType.YES) {
			var button:Button = new Button();
			button.text = "Yes";
			button.addEventListener(MouseEvent.CLICK, function(e) {
				PopupManager.instance.hidePopup(this);
				if (_fn != null) {
					_fn(PopupButtonType.YES);
				}
			});
			_buttonBar.addChild(button);
		}
		if (v == PopupButtonType.NO) {
			var button:Button = new Button();
			button.text = "No";
			button.addEventListener(MouseEvent.CLICK, function(e) {
				PopupManager.instance.hidePopup(this);
				if (_fn != null) {
					_fn(PopupButtonType.NO);
				}
			});
			_buttonBar.addChild(button);
		}
		if (v == PopupButtonType.CANCEL) {
			var button:Button = new Button();
			button.text = "Cancel";
			button.addEventListener(MouseEvent.CLICK, function(e) {
				PopupManager.instance.hidePopup(this);
				if (_fn != null) {
					_fn(PopupButtonType.CANCEL);
				}
			});
			_buttonBar.addChild(button);
		}
		if (v == PopupButtonType.CONFIRM) {
			var button:Button = new Button();
			button.text = "Confirm";
			button.addEventListener(MouseEvent.CLICK, function(e) {
				PopupManager.instance.hidePopup(this);
				if (_fn != null) {
					_fn(PopupButtonType.CONFIRM);
				}
			});
			_buttonBar.addChild(button);
		}
	}
	
}