package haxe.ui.popup;

import nme.filters.DropShadowFilter;
import haxe.ui.controls.Label;
import haxe.ui.core.Component;
import haxe.ui.core.Root;

class Popup extends Component {
	private var content:Component;
	public var title:String = "HaxeUI";
	private var titleComponent:Label;
	
	public function new() {
		super();
		addStyleName("Popup");
		
		content = new Component();
		content.addStyleName("Popup.content");

		titleComponent = new Label();
		titleComponent.addStyleName("Popup.title");
	}
	
	//************************************************************
	//                  OVERRIDES
	//************************************************************
	public override function initialize():Void {
		super.initialize();
		
		content.percentWidth = 100;
		content.percentHeight = 100;
		if (this.id != null) {
			content.id = id + ".content";
		}
		addChild(content);
		
		titleComponent.text = title;
		addChild(titleComponent);
		height = content.padding.top + content.padding.bottom + 10;
	}
	
	//************************************************************
	//                  HELPERS
	//************************************************************
	public static function showSimple(root:Root, text:String, title:String = null, modal:Bool = true):Popup {
		var p:SimplePopup = new SimplePopup();
		p.root = root;
		if (title != null) {
			p.title = title;
		}
		p.text = text;
		
		centerPopup(p);
		showPopup(p, modal);
		
		return p;
	}
	
	public static function showList(root:Root, items:Array<Dynamic>, title:String = null, selectedIndex:Int = -1, fnCallback:Dynamic->Void = null, modal:Bool = true):Popup {
		var p:ListPopup = new ListPopup();
		p.root = root;
		if (title != null) {
			p.title = title;
		}
		p.selectedIndex = selectedIndex;
		p.items = items;
		p.fnCallback = fnCallback;
		
		centerPopup(p);
		showPopup(p, modal);
		
		return p;
	}
	
	public static function showBusy(root:Root, text:String, delay:Float = -1, modal:Bool = true):Popup {
		var p:BusyPopup = new BusyPopup();
		p.root = root;
		p.text = text;
		p.title = "";
		p.delay = delay;
		
		centerPopup(p);
		showPopup(p, modal);
		
		return p;
	}
	
	public static function showCustom(root:Root, content:Component, title:String = null, modal:Bool = true):Popup {
		var p:CustomPopup = new CustomPopup();
		p.root = root;
		p.customContent = content;
		if (title != null) {
			p.title = title;
		}
		
		centerPopup(p);
		showPopup(p, modal);
		
		return p;
	}
	
	public static function showPopup(p:Popup, modal:Bool = true):Void {
		#if !android // performace goes down significantly
		p.sprite.filters = [ new DropShadowFilter (5, 45, 0, 1, 20, 20, 1, 3) ];
		#end
		
		p.root.addChild(p);
		if (modal == true) {
			p.root.enabled = false;
		}
		p.root.bringToFront(p);
	}
	
	public static function hidePopup(p:Popup):Void {
		p.root.removeChild(p);
		p.dispose();
		p.root.enabled = true;
	}
	
	public static function centerPopup(p:Popup):Void {
		p.x = Std.int((p.root.width / 2) - (p.width / 2));
		p.y = Std.int((p.root.height / 2) - (p.height / 2));
	}
}