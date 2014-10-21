package haxe.ui.toolkit.controls;

import haxe.ui.toolkit.core.Component;
import haxe.ui.toolkit.core.DisplayObject;
import haxe.ui.toolkit.core.interfaces.IClonable;
import haxe.ui.toolkit.core.interfaces.IItemRenderer;
import haxe.ui.toolkit.core.interfaces.IEventDispatcher;
import haxe.ui.toolkit.core.StateComponent;
import haxe.ui.toolkit.layout.VerticalLayout;

class Divider extends StateComponent implements IItemRenderer implements IClonable<Divider> {
	private var _label:Text;
	private var _line:Component;
	
	public function new() {
		super();
		autoSize = true;
		layout = new VerticalLayout();
	}
	
	private override function initialize():Void {
		super.initialize();
		
		_line = new Component();
		_line.id = "line";
		_line.percentWidth = 100;
		addChild(_line);
	}
	
	private override function get_text():String {
		if (_label == null) {
			return null;
		}
		return _label.text;
	}
	
	private override function set_text(value:String):String {
		if (_label == null) {
			_label = new Text();
			_label.id = "text";
			addChildAt(_label, 0);
		}
		return _label.set_text(value);
	}
	
	//******************************************************************************************
	// IItemRenderer
	//******************************************************************************************
	public var hash(default, default):String;
	public var eventDispatcher(default, default):IEventDispatcher;
	
	private var _data:Dynamic;
	public var data(get, set):Dynamic;
	private function get_data():Dynamic {
		return _data;
	}
	private function set_data(value:Dynamic):Dynamic {
		_data = value;
		if (data.text != null) {
			text = data.text;
		}
		return value;
	}
	
	public function allowSelection(stageX:Float, stageY:Float):Bool {
		return false;
	}
	
	public function update():Void {
		
	}
}