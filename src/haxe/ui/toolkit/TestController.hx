package haxe.ui.toolkit;

import flash.events.MouseEvent;
import haxe.ui.toolkit.containers.VBox;
import haxe.ui.toolkit.controls.Button;
import haxe.ui.toolkit.core.Component;
import haxe.ui.toolkit.core.DisplayObjectContainer;
import haxe.ui.toolkit.core.interfaces.InvalidationFlag;
import haxe.ui.toolkit.core.PopupManager;
import haxe.ui.toolkit.core.Toolkit;
import haxe.ui.toolkit.core.XMLController;
import haxe.ui.toolkit.events.UIEvent;
import haxe.ui.toolkit.util.StringUtil;

@:build(haxe.ui.toolkit.core.Macros.buildController("assets/test.xml"))
class TestController extends XMLController {
	public function new() {
		/*
		virtualScrollview.onScroll = function(e) {
			hpos.text = "" + virtualScrollview.hscrollPos;
			vpos.text = "" + virtualScrollview.vscrollPos;
			theButton.x =  virtualScrollview.hscrollPos;
			theButton.y =  virtualScrollview.vscrollPos;
		};
		*/
		
		//theAccordion.selectedIndex = 0;
	}
	
}