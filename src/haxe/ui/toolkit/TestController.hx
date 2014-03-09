package haxe.ui.toolkit;

import haxe.ui.toolkit.core.interfaces.IItemRenderer;
import haxe.ui.toolkit.core.XMLController;
import haxe.ui.toolkit.events.UIEvent;

@:build(haxe.ui.toolkit.core.Macros.buildController("assets/test.xml"))
class TestController extends XMLController {
	public function new() {
		list1.onChange = function(e:UIEvent) {
			logData("list1.onChange: text = " + list1.selectedItems[0].data.text);
		};
		list2.onChange = function(e:UIEvent) {
			logData("list2.onChange: text = " + list2.selectedItems[0].data.text);
		};
		list3.onChange = function(e:UIEvent) {
			logData("list3.onChange: text = " + list3.selectedItems[0].data.text + ", componentValue = " + list3.selectedItems[0].data.componentValue);
		};
		list4.onChange = function(e:UIEvent) {
			logData("list4.onChange: text = " + list4.selectedItems[0].data.text + ", componentValue = " + list4.selectedItems[0].data.componentValue);
		};
		
		list3.onComponentEvent = function(e:UIEvent) {
			logData("list3.onComponentEvent: value = " + e.component.value);
			e.data.text = e.component.value;
			e.data.update();
		};

		list4.onComponentEvent = function(e:UIEvent) {
			logData("list4.onComponentEvent: value = " + e.component.value);
			e.data.text = e.component.value;
			e.data.update();
		};
		
		logData("ready...");	
	}
	
	private function logData(data:String):Void {
		log.text += data + "\n";
		log.vscrollPos = log.vscrollMax;
	}
	
}