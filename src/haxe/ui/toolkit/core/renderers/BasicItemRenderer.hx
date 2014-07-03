package haxe.ui.toolkit.core.renderers;

import haxe.ui.toolkit.containers.VBox;
import haxe.ui.toolkit.controls.Image;
import haxe.ui.toolkit.controls.Text;
import haxe.ui.toolkit.core.base.VerticalAlign;
import haxe.ui.toolkit.layout.HorizontalLayout;

class BasicItemRenderer extends ItemRenderer {
	private var _vbox:VBox;
	private var _maintext:Text;
	private var _subtext:Text;
	private var _icon:Image;
	
	public function new() {
		super();
		_layout = new HorizontalLayout();
		
		_maintext = new Text();
		_maintext.text = "Text";
		_maintext.id = "text";
		_maintext.verticalAlign = VerticalAlign.CENTER;
		_maintext.percentWidth = 100;
		addChild(_maintext);
	}
	
	private override function set_data(value:Dynamic):Dynamic {
		var n:Int = 0;
		if (value.icon != null) {
			if (_icon == null) {
				_icon = new Image();
				_icon.id = "icon";
				_icon.verticalAlign = VerticalAlign.CENTER;
				addChildAt(_icon, n);
				n++;
			}
		}
		if (value.subtext != null) {
			if (_vbox == null) {
				_vbox = new VBox();
				_vbox.percentWidth = 100;
				addChildAt(_vbox, n);
			}
			if (_subtext == null) {
				_subtext = new Text();
				_subtext.id = "subtext";
				_subtext.percentWidth = 100;
				_subtext.multiline = true;
				_subtext.wrapLines = true;
				removeChild(_maintext, false);
				_vbox.addChild(_maintext);
				_vbox.addChild(_subtext);
			}
		}
		return super.set_data(value);
	}
}
