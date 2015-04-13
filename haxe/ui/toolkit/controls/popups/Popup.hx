package haxe.ui.toolkit.controls.popups;

import openfl.events.MouseEvent;
import haxe.ui.toolkit.containers.Box;
import haxe.ui.toolkit.containers.HBox;
import haxe.ui.toolkit.containers.VBox;
import haxe.ui.toolkit.controls.Button;
import haxe.ui.toolkit.controls.Text;
import haxe.ui.toolkit.core.interfaces.IDraggable;
import haxe.ui.toolkit.core.PopupManager;

/**
 Simple modal, draggable popup component
 **/
class Popup extends VBox implements IDraggable {
	private var _titleBar:Box;
	private var _title:Text;
	private var _exitButton:Button;
	private var _content:PopupContent;
	private var _buttonBar:Box;
	private var _config:Dynamic;
	private var _fn:Dynamic->Void;
	
	/**
	 Creates a new popup
	 
	 * `title` - The title of the popup

	 * `content` - The content of the popup
	 
	 * `config` - Configuration options for the popup (buttons, etc)
	 
	 * `fn` - Callback invoked when buttons are clicked
	 
	 Note - Creating the popup does not display it, use `PopupManager.showPopup` to display it.
	 **/
	public function new(title:String = null, content:PopupContent = null, config:Dynamic = null, fn:Dynamic->Void = null) {
		super();
		_autoSize = true;
		
		if (title != null) {
			_titleBar = new Box();
			_titleBar.autoSize = false;
			_titleBar.id = "titleBar";
		}
		
		_content = content;
		_content.popup = this;

		if (title != null) {
			_title = new Text();
			_title.id = "title";
			_title.text = title;
		}

		_buttonBar = new Box();
		_buttonBar.id = "buttonBar";
		//_buttonBar.percentWidth = 100;
		_buttonBar.horizontalAlign = "center";
		
		_config = config;
		if (_config == null) {
			_config = { };
			_config.buttons = new Array<PopupButtonInfo>();
		}
		if (_config.id != null) {
			this.id = _config.id;
		}
		if (_config.styleName != null) {
			this.styleName = _config.styleName;
		}
		if (_config.dismiss != null && _config.dismiss & Dismiss.CLICK_INSIDE > 0)
			addEventListener(MouseEvent.CLICK, function(e) {
				PopupManager.instance.hidePopup(this);
				callClosingCallback(PopupButton.CANCEL);
			});
		
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
			if (_config.closeButton == true) {
				_exitButton = new Button();
				_exitButton.text = "x";
				_exitButton.id = "close";
				_exitButton.styleName = "close";
				_exitButton.addEventListener(MouseEvent.CLICK, function(e) {
					PopupManager.instance.hidePopup(this);
				});
				_titleBar.addChild(_exitButton);
			}
			_titleBar.sprite.buttonMode = true;
			_titleBar.sprite.useHandCursor = true;
			addChild(_titleBar);
		}
		
		if (_content == null) {
			_content = new PopupContent();
		}
		_content.id = "popupContent";
		_content.percentWidth = 100;
		//_content.percentHeight = 100;
		addChild(_content);

		if (_config.buttons.length > 0) {
			var box:HBox = new HBox();
			box.horizontalAlign = _buttonBar.horizontalAlign;
			var buttons:Array<PopupButtonInfo> = cast _config.buttons;
			_buttonBar.addChild(box);
			for (info in buttons) {
				if (info.type & PopupButton.CUSTOM != PopupButton.CUSTOM) {
					var button:Button = createStandardButton(info.type);
					if (button != null) {
						box.addChild(button);
					}
				} else {
					var button:Button = new Button();
					button.text = info.text;
					button.addEventListener(MouseEvent.CLICK, function(e) {
						clickButton(info.type);
					});
					box.addChild(button);
				}
			}
			addChild(_buttonBar);
		}
		
		if (_config.width != null) {
			width = _config.width;
		}
		
		PopupManager.instance.centerPopup(this);
	}
	
	//******************************************************************************************
	// IDraggable
	//******************************************************************************************
	/**
	 Determines if the popup can be dragged by ensuring the mouse is in the title bar
	 or that dragging outside the title bar is allowed.
	 **/
	public function allowDrag(event:MouseEvent):Bool {
		return _config.dragAnywhere || (_titleBar == null ? false : _titleBar.hitTest(event.stageX, event.stageY));
	}

	//******************************************************************************************
	// Getters / Setters
	//******************************************************************************************
	public var content(get, null):PopupContent;
	private function get_content():PopupContent {
		return _content;
	}
	
	public var config(get, null):Dynamic;
	private function get_config():Dynamic {
		return _config;
	}
	
	//******************************************************************************************
	// Helpers
	//******************************************************************************************
	private function createStandardButton(v:Int):Button {
		var button:Button = null;
		if (v == PopupButton.OK) {
			button = new Button();
			button.text = "OK";
			button.addEventListener(MouseEvent.CLICK, function(e) {
				clickButton(PopupButton.OK);
			});
		}
		if (v == PopupButton.YES) {
			button = new Button();
			button.text = "Yes";
			button.addEventListener(MouseEvent.CLICK, function(e) {
				clickButton(PopupButton.YES);
			});
		}
		if (v == PopupButton.NO) {
			button = new Button();
			button.text = "No";
			button.addEventListener(MouseEvent.CLICK, function(e) {
				clickButton(PopupButton.NO);
			});
		}
		if (v == PopupButton.CANCEL) {
			button = new Button();
			button.text = "Cancel";
			button.addEventListener(MouseEvent.CLICK, function(e) {
				clickButton(PopupButton.CANCEL);
			});
		}
		if (v == PopupButton.CONFIRM) {
			button = new Button();
			button.text = "Confirm";
			button.addEventListener(MouseEvent.CLICK, function(e) {
				clickButton(PopupButton.CONFIRM);
			});
		}
		if (v == PopupButton.CLOSE) {
			button = new Button();
			button.text = "Close";
			button.addEventListener(MouseEvent.CLICK, function(e) {
				clickButton(PopupButton.CLOSE);
			});
		}
		
		return button;
	}
	
	@:dox(hide)
	public function clickButton(button:Int):Void {
		if (_content.onButtonClicked(button) == true) {
			PopupManager.instance.hidePopup(this);
		}
		if (_fn != null) {
			_fn(button);
		}
	}
	
	public function callClosingCallback(button:Dynamic) {
		if (_fn != null)
			_fn(button);
	}
}
