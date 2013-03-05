package haxe.ui.containers;
import nme.display.DisplayObject;
import nme.events.Event;
import haxe.ui.controls.Button;
import haxe.ui.controls.TabBar;
import haxe.ui.core.Component;

class TabView extends Component {
	private var tabs:TabBar;
	
	private var content:Component;
	
	private var pages:Array<Component>;
	
	private var currentPage:Component;
	
	public function new() {
		super();
	
		pages = new Array<Component>();
		
		tabs = new TabBar();
		tabs.percentWidth = 100;
		
		content = new Component();
		content.percentWidth = 100;
	}
	
	//************************************************************
	//                  OVERRIDES
	//************************************************************
	public override function initialize():Void {
		tabs.addEventListener(Event.CHANGE, onTabChange);
		
		content.addStyleName("TabView.content");
		
		if (width <= 0 && percentWidth <= 0) { // TODO: shouldnt need to set this
			percentWidth = 100;
		}
		if (height <= 0 && percentHeight <= 0) { // TODO: shouldnt need to set this
			percentHeight = 100;
		}
		
		super.addChild(tabs);
		super.addChild(content);
	}
	
	public override function resize():Void {
		super.resize();
		
		content.height = innerHeight - tabs.height - spacingY;
		content.y = tabs.height + padding.top + spacingY;
	}
	
	public override function dispose():Void {
		super.removeChild(tabs);
		tabs.dispose();
		super.removeChild(content);
		content.dispose();
		super.dispose();
	}
	//************************************************************
	//                  DISPLAY LIST OVERRIDES
	//************************************************************
	public override function addChild(c:Dynamic):Dynamic {
		var comp:Component = c;
		if (Std.is(c, Component) == false) {
			comp = new Component();
			comp.addChild(c);
		}
		
		var additionalStyles:String = "";
		if (id != null && comp.id != null) {
			additionalStyles += "#" + id + "." + comp.id;
		}
		var button:Button = tabs.addTab(comp.text, additionalStyles);
		if (comp.id != null) {
			button.id = comp.id + ".tab";
		}
		
		comp.percentWidth = 100;
		comp.percentHeight = 100;

		pages.push(comp);
		comp.visible = button.selected;
		if (button.selected == true) {
			currentPage = comp;
		}
		
		content.addChild(comp);
		return comp;
	}
	
	public override function removeChild(c:Dynamic):DisplayObject {
		// TODO: tab doesnt get removed 
		return content.removeChild(c);
	}
	
	public override function listChildComponents():Array<Component> {
		return content.listChildComponents();
	}
	//************************************************************
	//                  TABVIEW FUNCTIONS
	//************************************************************
	
	// DEPRICATED
	public function addPage(title:String, page:Component = null, additionalStyleNames:String = null):Component {
		if (page == null) {
			page = new Component();
		}

		var button:Button = tabs.addTab(title, additionalStyleNames);
		
		page.percentWidth = 100;
		page.percentHeight = 100;
		pages.push(page);
		page.visible = button.selected;
		if (button.selected == true) {
			currentPage = page;
		}
		
		content.addChild(page);
		
		return page;
	}
	
	//************************************************************
	//                  EVENT HANDLERS
	//************************************************************
	private function onTabChange(event:Event):Void {
		currentPage.visible = false;
		var page:Component = pages[tabs.selectedIndex];
		page.visible = true;
		currentPage = page;
	}
}