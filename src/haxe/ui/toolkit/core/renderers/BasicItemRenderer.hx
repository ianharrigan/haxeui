package haxe.ui.toolkit.core.renderers;

import haxe.ui.toolkit.controls.Image;
import haxe.ui.toolkit.core.base.VerticalAlign;
import haxe.ui.toolkit.layout.HorizontalLayout;
import haxe.ui.toolkit.controls.Text;

class BasicItemRenderer extends ItemRenderer {
	public function new() {
		super();
		_layout = new HorizontalLayout();
		
		var text:Text = new Text();
		text.text = "Text";
		text.id = "text";
		text.percentWidth = 100;
		addChild(text);
	}
	
	private override function set_data(value:Dynamic):Dynamic {
		if (value.icon != null) {
			if (findChild("icon") == null) {
				var icon:Image = new Image();
				icon.id = "icon";
				icon.verticalAlign = VerticalAlign.CENTER;
				addChildAt(icon, 0);
			}
		}
		return super.set_data(value);
	}
}
