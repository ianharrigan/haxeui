package haxe.ui.test;

import nme.Assets;
import nme.display.Bitmap;
import nme.display.Sprite;
import nme.events.Event;
import nme.events.MouseEvent;
import nme.events.TimerEvent;
import nme.Lib;
import nme.utils.Timer;
import haxe.ui.containers.HBox;
import haxe.ui.containers.ListView;
import haxe.ui.containers.ScrollView;
import haxe.ui.containers.TabView;
import haxe.ui.containers.VBox;
import haxe.ui.controls.Button;
import haxe.ui.controls.CheckBox;
import haxe.ui.controls.HScroll;
import haxe.ui.controls.Image;
import haxe.ui.controls.Label;
import haxe.ui.controls.ProgressBar;
import haxe.ui.controls.TextInput;
import haxe.ui.controls.ValueControl;
import haxe.ui.controls.TabBar;
import haxe.ui.controls.VScroll;
import haxe.ui.core.Component;
import haxe.ui.core.ComponentParser;
import haxe.ui.core.Controller;
import haxe.ui.core.Globals;
import haxe.ui.core.Root;
import haxe.ui.popup.ListPopup;
import haxe.ui.popup.Popup;
import haxe.ui.style.android.AndroidStyles;
import haxe.ui.style.StyleManager;
import haxe.ui.style.test.TestStyles;
import haxe.ui.style.windows.WindowsStyles;
import haxe.ui.style.ios.IosStyles;

class Main extends Sprite {
	public static var WINDOWS_SKIN:String = "WINDOWS";
	public static var ANDROID_SKIN:String = "ANDROID";
	public static var IOS_SKIN:String = "IOS";
	public static var TEST_SKIN:String = "TEST";
	
	public function new() {
		super();
		#if iphone
			Lib.current.stage.addEventListener(Event.RESIZE, initialize);
		#else
			addEventListener(Event.ADDED_TO_STAGE, initialize);
		#end
	}

	private function initialize(e) {
		#if iphone
			Lib.current.stage.removeEventListener(Event.RESIZE, initialize);
		#else
			removeEventListener(Event.ADDED_TO_STAGE, initialize);
		#end
		
		startApp(WINDOWS_SKIN);
	}

	public static function startApp(skinId:String):Void {
		if (skinId == WINDOWS_SKIN) {
			StyleManager.styles = new WindowsStyles();
		} else if (skinId == ANDROID_SKIN) {
			StyleManager.styles = new AndroidStyles();
		} else if (skinId == IOS_SKIN) {
			StyleManager.styles = new IosStyles();
		} else if (skinId == TEST_SKIN) {
			StyleManager.styles = new TestStyles();
		}
		Globals.themeName = skinId;

		var stage = Lib.current.stage;
		stage.scaleMode = nme.display.StageScaleMode.NO_SCALE;
		stage.align = nme.display.StageAlign.TOP_LEFT;

		Root.destroyAll();
		
		// static floating panel
		//var background:Bitmap = new Bitmap(Assets.getBitmapData("img/slinky_large.jpg"));
		var background:BackgroundTest = new BackgroundTest(); // just a more interactive background
		stage.addChild(background);
		
		var root:Root = Root.createRoot( { x:50, y:50, width: 500, height: 400, additionalStyles: "Root.popupBorder", useShadow: true } );
		
		// full screen, 100% size, resizes
//		var root:Root = Root.createRoot();

		/*
		var demo:ControlDemoNew = new ControlDemoNew();
		demo.percentWidth = 100;
		demo.percentHeight = 100;
		root.addChild(demo);
		*/

		/*
		var controller:Controller = new Controller(ComponentParser.fromXMLAsset("ui/test01.xml"));
		controller.getComponentAs("button5", Button).addEventListener(MouseEvent.CLICK, function (e) {
			trace("button 5 clicked");
		});
		root.addChild(controller.view);
		*/
		
		root.addChild(new ControlDemoController().view);
	}
	
	static public function main() {
		new Main().initialize(new Event(""));		
	}
	
}
