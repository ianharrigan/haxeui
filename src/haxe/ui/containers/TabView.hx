package haxe.ui.containers;
import haxe.ui.style.StyleManager;
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
	
	public var selectedIndex(getSelectedIndex, setSelectedIndex):Int;
	public var pageCount(getPageCount, null):Int;
	
	public function new() {
		super();
	
		pages = new Array<Component>();
		
		tabs = new TabBar();
		tabs.percentWidth = 100;
		
		content = new TabViewContent();
		content.percentWidth = 100;
	}
	
	//************************************************************
	//                  OVERRIDES
	//************************************************************
	public override function initialize():Void {
		tabs.addEventListener(Event.CHANGE, onTabChange);
		content.id = "tabViewContent";
		
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
		
		content.height = innerHeight - tabs.height - layout.spacingY;
		content.y = tabs.height + layout.padding.top + layout.spacingY;
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
		
		var button:Button = tabs.addTab(comp.text, comp.id);
		
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
	//                  EVENT HANDLERS
	//************************************************************
	private function onTabChange(event:Event):Void {
		currentPage.visible = false;
		var page:Component = pages[tabs.selectedIndex];
		if (page != null) {
			page.visible = true;
			currentPage = page;
		}
	}
	
	private function getSelectedIndex():Int {
		return tabs.selectedIndex;
	}
	
	public function setSelectedIndex(value:Int):Int {
		tabs.selectedIndex = value;
		var page:Component = pages[tabs.selectedIndex];
		if (page != null) {
			page.visible = true;
			currentPage = page;
		}
		return value;
	}
	
	private function getPageCount():Int {
		return pages.length;
	}
}

//************************************************************
//                  CHILD CLASSES
//************************************************************
class TabViewContent extends Component { // makes content easier to style
	public function new() {
		super();
	}
}