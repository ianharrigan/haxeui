package haxe.ui.toolkit;

import flash.display.Sprite;
import haxe.ui.toolkit.containers.Accordion;
import haxe.ui.toolkit.containers.Stack;
import haxe.ui.toolkit.core.Macros;
import haxe.ui.toolkit.core.Root;
import haxe.ui.toolkit.core.Toolkit;
import haxe.ui.toolkit.core.XMLController;
import haxe.ui.toolkit.events.UIEvent;
import haxe.ui.toolkit.themes.DefaultTheme;
import haxe.ui.toolkit.themes.GradientTheme;
import haxe.ui.toolkit.themes.WindowsTheme;

class Main /* extends Sprite */ {
	/*
	public function new () {
		super();
		trace("bob");
		Toolkit.init();
		Toolkit.openFullscreen(function(root:Root) {
			var t2:TestController = new TestController();
			root.addChild(t2.view);
		});
	}
	*/
	
	public static function main() {
		Toolkit.defaultTransition = "none";
		Toolkit.setTransitionForClass(Accordion, "slide");
		Toolkit.setTransitionForClass(Stack, "fade");
		Toolkit.theme = new DefaultTheme();
		//Toolkit.theme = new GradientTheme();
		//Toolkit.theme = new WindowsTheme();
		Macros.addStyleSheet("assets/test.css");
		Toolkit.setTransitionForClass(Stack, "none");
		Toolkit.init();
		Toolkit.openFullscreen(function(root:Root) {
			var t2:TestController2 = new TestController2();
			root.addChild(t2.view);
		});
	}
}

/*
@:build( haxe.ui.toolkit.core.Macros.buildController( "assets/test.xml" ) )
class TestController extends XMLController {
  public function new():Void {
    myButton.addEventListener( UIEvent.CLICK, myButtonClicked );
  }

  private function myButtonClicked( e:UIEvent ):Void {
    myButton.text = "You clicked me!";
  }
}

*/