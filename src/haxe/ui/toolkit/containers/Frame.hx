package haxe.ui.toolkit.containers;

import haxe.ui.toolkit.controls.Text;
import haxe.ui.toolkit.core.Component;
import haxe.ui.toolkit.core.interfaces.IDisplayObject;
import haxe.ui.toolkit.core.interfaces.ILayout;
import haxe.ui.toolkit.layout.VerticalLayout;
import haxe.ui.toolkit.layout.DefaultLayout;

class Frame extends Component {
	private var _content:Box;
	private var _title:Text;
	
	public function new() {
		super();
		autoSize = true;
		_layout = new FrameLayout();
		_content = new Box();
		_content.layout = new VerticalLayout();
		_content.id = id + "_content";
		_content.percentWidth = _content.percentHeight = 100;
		addChild(_content);
		
		_title = new Text();
		_title.text = this.text;
		_title.id = id + "_title";
		_title.styleName = "frame";
		_title.style.backgroundColor = 0xFFFFFF;
		addChild(_title);
	}
	
	//******************************************************************************************
	// Overrides
	//******************************************************************************************
	public override function addChild(child:IDisplayObject):IDisplayObject {
		var r = null;
		if (child.id == id + "_content" || child.id == id + "_title") {
			r = super.addChild(child);
		} else {
			r = _content.addChild(child);
		}
		return r;
	}
	
	private override function set_layout(value:ILayout):ILayout {
		_content.layout = value;
		return value;
	}
	
	private override function set_text(value:String):String {
		super.set_text(value);
		_title.text = value;
		return value;
	}
}

@exclude
class FrameLayout extends DefaultLayout {
	public function new() {
		super();
	}
	
	public override function repositionChildren():Void {
		super.repositionChildren();
		var title:Text = container.findChildAs(Text);
		if (title != null) {
			title.x = 10;
			title.y = -(title.height / 2);
		}
		
	}
}