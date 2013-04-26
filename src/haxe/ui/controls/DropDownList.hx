package haxe.ui.controls;

import haxe.ui.data.ArrayDataSource;
import haxe.ui.data.DataSource;
import nme.events.Event;
import nme.events.MouseEvent;
import nme.filters.DropShadowFilter;
import haxe.ui.containers.ListView;
import haxe.ui.core.Component;
import haxe.ui.popup.Popup;

class DropDownList extends Selector {
	private var list:ListView;
	
	public var dataSource:DataSource;
	
	public var maxSize:Int = 5;
	
	// how the list is displayed. Values = "popup"
	public var method:String;
	public var selectedIndex:Int = -1;
	
	public function new() {
		super();
		
		toggle = true;
		
		addEventListener(MouseEvent.CLICK, onDropDownClick);
		if (dataSource == null) {
			dataSource = new ArrayDataSource();
		}
	}
	
	//************************************************************
	//                  OVERRIDES
	//************************************************************
	public override function initialize():Void {
		super.initialize();
		method = currentStyle.method;
	}
	
	//************************************************************
	//                  EVENT HANDLERS
	//************************************************************
	private function onDropDownClick(event:MouseEvent):Void {
		if (list == null || list.visible == false) {
			showList();
		} else {
			hideList();
		}
	}
	
	private function onListChange(event:Event):Void {
		hideList();
		this.selected = false;
		
		this.text = list.getListItem(list.selectedIndex).text;
		
		dispatchEvent(event);
	}

	private function onScreenMouseDown(event:MouseEvent):Void {
		var mouseInList:Bool = false;
		if (list != null) {
			mouseInList = list.hitTest(event.stageX, event.stageY);
		}
		var mouseIn:Bool = hitTest(event.stageX, event.stageY);
		if (mouseInList == false && list != null && mouseIn == false) {
			root.removeEventListener(MouseEvent.MOUSE_DOWN, onScreenMouseDown);
			root.removeEventListener(MouseEvent.MOUSE_WHEEL, onScreenMouseDown);
			hideList();
			this.selected = false;
		}
	}

	private function onComponentEvent(event:ListViewEvent):Void {
		dispatchEvent(new ListViewEvent(event.type, event.item, event.typeComponent)); // TODO: not sure why i have to recreate the event, just dispatching the old event causes rte
	}
	//************************************************************
	//                  LIST FUNCTIONS
	//************************************************************
	public function showList():Void {
		if (method == "popup") {
			Popup.showList(root, dataSource, "Select", selectedIndex, function(item) {
				this.text = item.text;
				this.selected = false;
				this.selectedIndex = item.index;
			});
		} else {
			if (list == null) {
				list = new ListView();
				list.dataSource = dataSource;
				list.sprite.filters = [ new DropShadowFilter (4, 45, 0x808080, .7, 4, 4, 1, 3) ];
				
				list.addEventListener(Event.CHANGE, onListChange);
				list.addEventListener(ListViewEvent.COMPONENT_EVENT, onComponentEvent);
				root.addChild(list);
			}

			root.addEventListener(MouseEvent.MOUSE_DOWN, onScreenMouseDown);
			root.addEventListener(MouseEvent.MOUSE_WHEEL, onScreenMouseDown);
			
			var n:Int = maxSize;
			if (n > list.listSize) {
				n = list.listSize;
			}
			var listHeight:Float = n * list.itemHeight + (list.layout.padding.top + list.layout.padding.bottom);
			
			list.height = listHeight;
			list.width = this.width;
			list.x = this.stageX - (root.component.x + root.component.layout.padding.left);
			list.y = this.stageY + this.height - (root.component.y + root.component.layout.padding.top);
			list.visible = true;
		}
	}
	
	public function hideList():Void {
		if (list != null) {
			//this.selected = false;
			list.visible = false;
		}
	}
}