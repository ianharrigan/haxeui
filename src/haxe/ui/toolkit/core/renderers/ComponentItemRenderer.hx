package haxe.ui.toolkit.core.renderers;

import haxe.ui.toolkit.controls.Button;
import haxe.ui.toolkit.controls.HSlider;
import haxe.ui.toolkit.controls.Image;
import haxe.ui.toolkit.core.base.VerticalAlign;
import haxe.ui.toolkit.core.Component;

class ComponentItemRenderer extends BasicItemRenderer {
	private var _component:Component;
	
	public function new() {
		super();
	}
	
	private override function set_data(value:Dynamic):Dynamic {
		var type:String = value.componentType;
		if (type != null) {
			var cls:Class<Component> = getClassFromType(type);
			if (cls != null && Std.is(_component, cls) == false) {
				if (_component != null) {
					removeChild(_component);
				}
				_component = Type.createInstance(cls, []);
				_component.verticalAlign = VerticalAlign.CENTER;
				_component.id = "componentValue";
				_component.styleName = value.controlId;
				if (value.componentSize != null) {
					var cx:Int = value.componentSize;
					_component.autoSize = false;
					_component.width = cx;
				}
				addChildAt(_component, numChildren);
			}
		}
		return super.set_data(value);
	}
	
	private function getClassFromType(type:String):Class<Component> {
		type = type.toLowerCase();
		if (type == "button") {
			return Button;
		} else if (type == "slider") {
			return HSlider;
		} else if (type == "image") {
			return Image;
		}
		return null;
	}
}
