package haxe.ui.toolkit.controls;

import haxe.ui.toolkit.core.Component;
import haxe.ui.toolkit.core.interfaces.IClonable;
import haxe.ui.toolkit.layout.VerticalLayout;

class MenuSeparator extends Component implements IClonable<MenuSeparator> {
	private var _line:Component;
	public function new() {
		super();
		layout = new VerticalLayout();
	}
	
	private override function initialize():Void {
		super.initialize();
		
		_line = new Component();
		_line.id = "line";
		_line.percentWidth = 100;
		addChild(_line);
	}
}