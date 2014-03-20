package haxe.ui.toolkit.containers;

import flash.events.Event;
import flash.events.MouseEvent;
import flash.text.Font;
import haxe.ui.toolkit.controls.Button;
import haxe.ui.toolkit.controls.extended.RTF;
import haxe.ui.toolkit.controls.selection.ListSelector;
import haxe.ui.toolkit.controls.Spacer;

/**
 Rich text editor container (contains style controls)
 **/
class RTFView extends VBox {
	private var _rtf:RTF;
	private var _fontNameList:ListSelector;
	private var _fontSizeList:ListSelector;
	
	private var _boldButton:RTFToolButton;
	private var _italicButton:RTFToolButton;
	private var _underlineButton:RTFToolButton;
	private var _bulletButton:RTFToolButton;
	private var _leftAlignButton:RTFToolButton;
	private var _centerAlignButton:RTFToolButton;
	private var _rightAlignButton:RTFToolButton;
	private var _justifyAlignButton:RTFToolButton;
	
	private var _systemFonts:Bool = false;
	
	public function new() {
		super();
		_rtf = new RTF();
		_rtf.multiline = true;
		_rtf.wrapLines = true;
		_rtf.percentWidth = 100;
		_rtf.percentHeight = 100;
	}
	
	//******************************************************************************************
	// Overrides
	//******************************************************************************************
	private override function initialize():Void {
		super.initialize();

		var hbox:HBox = new HBox();
		
		_fontNameList = new ListSelector();
		_fontNameList.width = 200;
		_fontNameList.text = "_sans";
		if (_systemFonts == true) {
			#if !html5
			var fonts:Array<Font> = Font.enumerateFonts(true);
			fonts.sort(function(f1:Font, f2:Font):Int {
				var a = f1.fontName.toLowerCase();
				var b = f2.fontName.toLowerCase();
				if (a < b) return -1;
				if (a > b) return 1;
				return 0;
			});
			
			for (font in fonts) {
				_fontNameList.dataSource.add( { text: font.fontName } );
			}
			#end
		} else {
			_fontNameList.dataSource.add( { text: "_sans" } );
			_fontNameList.dataSource.add( { text: "_serif" } );
			_fontNameList.dataSource.add( { text: "_typewriter" } );
			_fontNameList.dataSource.add( { text: "Arial" } );
			_fontNameList.dataSource.add( { text: "Courier" } );
			_fontNameList.dataSource.add( { text: "Courier New" } );
			_fontNameList.dataSource.add( { text: "Geneva" } );
			_fontNameList.dataSource.add( { text: "Georgia" } );
			_fontNameList.dataSource.add( { text: "Helvetica" } );
			_fontNameList.dataSource.add( { text: "Times New Roman" } );
			_fontNameList.dataSource.add( { text: "Times" } );
			_fontNameList.dataSource.add( { text: "Verdana" } );
		}
		_fontNameList.addEventListener(Event.CHANGE, _onFontNameChange);
		hbox.addChild(_fontNameList);
		
		_fontSizeList = new ListSelector();
		_fontSizeList.text = "13";
		_fontSizeList.dataSource.add( { text:10 } );
		_fontSizeList.dataSource.add( { text:12 } );
		_fontSizeList.dataSource.add( { text:13 } );
		_fontSizeList.dataSource.add( { text:14 } );
		_fontSizeList.dataSource.add( { text:16 } );
		_fontSizeList.dataSource.add( { text:18 } );
		_fontSizeList.dataSource.add( { text:20 } );
		_fontSizeList.dataSource.add( { text:24 } );
		_fontSizeList.dataSource.add( { text:26 } );
		_fontSizeList.dataSource.add( { text:28 } );
		_fontSizeList.dataSource.add( { text:36 } );
		_fontSizeList.dataSource.add( { text:48 } );
		_fontSizeList.dataSource.add( { text:72 } );
		_fontSizeList.addEventListener(Event.CHANGE, _onFontSizeChange);
		hbox.addChild(_fontSizeList);
		
		var spacer:Spacer = new Spacer();
		spacer.width = 10;
		hbox.addChild(spacer);
		
		_boldButton = new RTFToolButton();
		_boldButton.id = "bold";
		_boldButton.addEventListener(MouseEvent.CLICK, _onBoldClick);
		hbox.addChild(_boldButton);

		_italicButton = new RTFToolButton();
		_italicButton.id = "italic";
		_italicButton.addEventListener(MouseEvent.CLICK, _onItalicClick);
		hbox.addChild(_italicButton);

		_underlineButton = new RTFToolButton();
		_underlineButton.id = "underline";
		_underlineButton.addEventListener(MouseEvent.CLICK, _onUnderlineClick);
		hbox.addChild(_underlineButton);

		var spacer:Spacer = new Spacer();
		spacer.width = 10;
		hbox.addChild(spacer);
		
		_bulletButton = new RTFToolButton();
		_bulletButton.id = "bullet";
		_bulletButton.addEventListener(MouseEvent.CLICK, _onBulletClick);
		hbox.addChild(_bulletButton);

		var spacer:Spacer = new Spacer();
		spacer.width = 10;
		hbox.addChild(spacer);
		
		_leftAlignButton = new RTFToolButton();
		_leftAlignButton.id = "alignLeft";
		_leftAlignButton.addEventListener(MouseEvent.CLICK, _onLeftAlignClick);
		hbox.addChild(_leftAlignButton);

		_centerAlignButton = new RTFToolButton();
		_centerAlignButton.id = "alignCenter";
		_centerAlignButton.addEventListener(MouseEvent.CLICK, _onCenterAlignClick);
		hbox.addChild(_centerAlignButton);

		_rightAlignButton = new RTFToolButton();
		_rightAlignButton.id = "alignRight";
		_rightAlignButton.addEventListener(MouseEvent.CLICK, _onRightAlignClick);
		hbox.addChild(_rightAlignButton);

		_justifyAlignButton = new RTFToolButton();
		_justifyAlignButton.id = "alignJustify";
		_justifyAlignButton.addEventListener(MouseEvent.CLICK, _onJustifyAlignClick);
		hbox.addChild(_justifyAlignButton);
		
		var button:Button = new RTFToolButton();
		button.text = "";
		button.addEventListener(MouseEvent.CLICK, function(e) {
			_rtf.text = _rtf.htmlText;
		});
		hbox.addChild(button); // TODO: style issue
		
		addChild(hbox);
		addChild(_rtf);
	}
	
	//******************************************************************************************
	// Properties
	//******************************************************************************************
	/**
	 Gets or sets the rich text of the editor from a html string
	**/
	public var htmlText(get, set):String;
	
	private function get_htmlText():String {
		return _rtf.htmlText;
	}
	
	private function set_htmlText(value:String):String {
		_rtf.htmlText = value;
		return value;
	}

	private override function set_text(value:String):String {
		_rtf.text = value;
		return value;
	}
	
	//******************************************************************************************
	// Event handlers
	//******************************************************************************************
	private function _onBoldClick(event:MouseEvent):Void {
		_rtf.bold();
	}
	
	private function _onItalicClick(event:MouseEvent):Void {
		_rtf.italic();
	}
	
	private function _onUnderlineClick(event:MouseEvent):Void {
		_rtf.underline();
	}

	private function _onBulletClick(event:MouseEvent):Void {
		_rtf.bullet();
	}
	
	private function _onFontNameChange(event:Event):Void {
		/*
		var item:ListView.ListViewItem = _fontNameList.selectedItems[0];
		_rtf.fontName(item.text);
		*/
	}
	
	private function _onFontSizeChange(event:Event):Void {
		/*
		var item:ListView.ListViewItem = _fontSizeList.selectedItems[0];
		var size:Int = Std.parseInt(item.text);
		_rtf.fontSize(size);
		*/
	}
	
	private function _onLeftAlignClick(event:Event):Void {
		_rtf.alignLeft();
	}

	private function _onCenterAlignClick(event:Event):Void {
		_rtf.alignCenter();
	}

	private function _onRightAlignClick(event:Event):Void {
		_rtf.alignRight();
	}

	private function _onJustifyAlignClick(event:Event):Void {
		_rtf.alignJustify();
	}
}

@exclude
class RTFToolButton extends Button { // for styling
	
}