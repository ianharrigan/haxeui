package haxe.ui.toolkit.controls;

import haxe.ui.toolkit.containers.Box;
import haxe.ui.toolkit.controls.Text;
import haxe.ui.toolkit.core.Component;
import haxe.ui.toolkit.core.ToolTipManager.ToolTipOptions;

class ToolTip extends Box {
	public var component:Component = null;
	public var options:ToolTipOptions = null;
	
	private var _textField:Text;
	public function new() {
		super();
		_autoSize = true;
		_textField = new Text();
		_textField.text = "";
		addChild(_textField);
	}
	
	public override function set_text(value:String):String {
		value = super.set_text(value);
		_textField.text = value;
		return value;
	}
}