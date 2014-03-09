package haxe.ui.toolkit.core.renderers;

import haxe.ui.toolkit.layout.HorizontalLayout;
import haxe.ui.toolkit.controls.Text;

class TextItemRenderer extends ItemRenderer {
	public function new() {
		super();
		_layout = new HorizontalLayout();
		
		var text:Text = new Text();
		text.text = "Text";
		text.id = "text";
		text.percentWidth = 100;
		addChild(text);
	}
}
