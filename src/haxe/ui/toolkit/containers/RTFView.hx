package haxe.ui.toolkit.containers;

import flash.events.Event;
import flash.events.MouseEvent;
import flash.text.Font;
import haxe.ui.toolkit.controls.Button;
import haxe.ui.toolkit.controls.extended.RTF;
import haxe.ui.toolkit.controls.selection.List;
import haxe.ui.toolkit.data.ArrayDataSource;

class RTFView extends VBox {
	private var _rtf:RTF;
	private var _fontNameList:List;
	private var _fontSizeList:List;
	
	public function new() {
		super();
		_rtf = new RTF();
		_rtf.percentWidth = 100;
		_rtf.percentHeight = 100;
	}
	
	//******************************************************************************************
	// Overrides
	//******************************************************************************************
	private override function initialize():Void {
		super.initialize();

		
		var hbox:HBox = new HBox();
		
		_fontNameList = new List();
		_fontNameList.width = 200;
		_fontNameList.text = " ";
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
		_fontNameList.addEventListener(Event.CHANGE, _onFontNameChange);
		hbox.addChild(_fontNameList);
		
		_fontSizeList = new List();
		_fontSizeList.text = "13";
		_fontSizeList.dataSource.add( { text:10 } );
		_fontSizeList.dataSource.add( { text:12 } );
		_fontSizeList.dataSource.add( { text:13 } );
		_fontSizeList.dataSource.add( { text:14 } );
		_fontSizeList.dataSource.add( { text:15 } );
		_fontSizeList.dataSource.add( { text:16 } );
		_fontSizeList.dataSource.add( { text:18 } );
		_fontSizeList.dataSource.add( { text:20 } );
		_fontSizeList.dataSource.add( { text:22 } );
		_fontSizeList.dataSource.add( { text:24 } );
		_fontSizeList.dataSource.add( { text:26 } );
		_fontSizeList.dataSource.add( { text:30 } );
		_fontSizeList.dataSource.add( { text:34 } );
		_fontSizeList.addEventListener(Event.CHANGE, _onFontSizeChange);
		hbox.addChild(_fontSizeList);
		
		var button:Button = new Button();
		button.text = "B";
		button.addEventListener(MouseEvent.CLICK, _onBoldClick);
		hbox.addChild(button);

		button = new Button();
		button.text = "I";
		button.addEventListener(MouseEvent.CLICK, _onItalicClick);
		hbox.addChild(button);

		button = new Button();
		button.text = "U";
		hbox.addChild(button);
		
		addChild(hbox);
		addChild(_rtf);
	}
	
	public override function set_text(value:String):String {
		value = super.set_text(value);
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
		_rtf.bold();
	}

	private function _onFontNameChange(event:Event):Void {
		var item:ListView.ListViewItem = _fontNameList.selectedItems[0];
		_rtf.fontName(item.text);
	}
	
	private function _onFontSizeChange(event:Event):Void {
		var item:ListView.ListViewItem = _fontSizeList.selectedItems[0];
		var size:Int = Std.parseInt(item.text);
		_rtf.fontSize(size);
	}
}