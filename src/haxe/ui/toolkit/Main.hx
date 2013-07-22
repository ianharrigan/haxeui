package haxe.ui.toolkit;

import flash.Lib;
import haxe.ui.samples.accordion.AccordionSample;
import haxe.ui.samples.buttons.ButtonsSample;
import haxe.ui.samples.hello_world.HelloWorldControllerSample;
import haxe.ui.samples.hello_world.HelloWorldCSSSample;
import haxe.ui.samples.hello_world.HelloWorldSample;
import haxe.ui.samples.hello_world.HelloWorldXMLSample;
import haxe.ui.samples.layouts.LayoutsSample;
import haxe.ui.samples.lists.ListsSample;
import haxe.ui.samples.scrolls.ScrollsSample;
import haxe.ui.samples.stacks.StacksSample;
import haxe.ui.samples.tabs.TabsSample;
import haxe.ui.samples.test.TestSample;
import haxe.ui.toolkit.core.Macros;
import haxe.ui.toolkit.core.RootManager;
import haxe.ui.toolkit.core.Toolkit;
import haxe.ui.samples.InteractiveBackground;
import haxe.ui.toolkit.core.Root;
import haxe.ui.toolkit.resources.ResourceManager;
import haxe.ui.toolkit.style.StyleManager;

class Main {
	private static var STYLE_WINDOWS:String = "windows";
	private static var STYLE_GRADIENT:String = "gradient";
	private static var STYLE_GRADIENT_MOBILE:String = "gradient mobile";
	
	private static var currentRoot:Root;
	
	public function new() {
		if (currentRoot != null) {
			RootManager.instance.destroyRoot(currentRoot);
		}
		
		openFullscreen(function(root:Root) {
			currentRoot = root;
			//new HelloWorldSample().run(root);
			//new HelloWorldXMLSample().run(root);
			//new HelloWorldControllerSample().run(root);
			//new HelloWorldCSSSample().run(root);
			//new ButtonsSample().run(root);
			//new LayoutsSample().run(root);
			//new ScrollsSample().run(root);
			//new TabsSample().run(root);
			//new ListsSample().run(root);
			//new StacksSample().run(root);
			//new AccordionSample().run(root);
			
			new TestSample().run(root);
		});
	}

	private function openFullscreen(fn:Root->Void = null):Root {
		var root:Root = RootManager.instance.createRoot({x: 0, y: 0, percentWidth: 100, percentHeight: 100}, fn);
		return root;
	}
	
	private function openPopup(fn:Root->Void = null):Root {
		var stage = Lib.current.stage;
		var background:InteractiveBackground = new InteractiveBackground(); // just a more interactive background
		stage.addChild(background);
		
		var root:Root = RootManager.instance.createRoot( { x: 20, y: 20, id: "popupRoot" }, fn);
		return root;
	}

	public static function openApp(style:String):Void {
		StyleManager.instance.clear();
		ResourceManager.instance.reset();
		
		if (style == STYLE_GRADIENT) {
			Macros.addStyleSheet("styles/gradient/gradient.css");
		} else if (style == STYLE_GRADIENT_MOBILE) {
			Macros.addStyleSheet("styles/gradient/gradient_mobile.css");
		} else if (style == STYLE_WINDOWS) {
			Macros.addStyleSheet("styles/windows/windows.css");
			Macros.addStyleSheet("styles/windows/buttons.css");
			Macros.addStyleSheet("styles/windows/tabs.css");
			Macros.addStyleSheet("styles/windows/listview.css");
			Macros.addStyleSheet("styles/windows/scrolls.css");
			Macros.addStyleSheet("styles/windows/sliders.css");
			Macros.addStyleSheet("styles/windows/accordion.css");
		}
		
		var main = new Main();
	}
	
	public static function main() {
		Toolkit.init();
		Toolkit.defaultTransition = "slide";

		#if android
			openApp(STYLE_GRADIENT_MOBILE);
		#else
			openApp(STYLE_GRADIENT);
		#end
	}
}
