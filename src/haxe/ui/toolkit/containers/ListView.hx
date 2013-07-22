package haxe.ui.toolkit.containers;

import flash.events.Event;
import flash.events.MouseEvent;
import flash.Lib;
import haxe.ui.toolkit.controls.Button;
import haxe.ui.toolkit.controls.HProgress;
import haxe.ui.toolkit.controls.HSlider;
import haxe.ui.toolkit.controls.Image;
import haxe.ui.toolkit.controls.selection.List;
import haxe.ui.toolkit.controls.Text;
import haxe.ui.toolkit.core.Component;
import haxe.ui.toolkit.core.interfaces.IDataComponent;
import haxe.ui.toolkit.core.interfaces.IDisplayObject;
import haxe.ui.toolkit.core.interfaces.IEventDispatcher;
import haxe.ui.toolkit.core.interfaces.InvalidationFlag;
import haxe.ui.toolkit.core.StateComponent;
import haxe.ui.toolkit.data.ArrayDataSource;
import haxe.ui.toolkit.data.IDataSource;
import haxe.ui.toolkit.layout.DefaultLayout;

class ListView extends ScrollView implements IDataComponent {
	private var _dataSource:IDataSource;
	
	private var _content:VBox;
	
	private var _selectedItems:Array<ListViewItem>;
	
	public function new() {
		super();
		autoSize = false;
		dataSource = new ArrayDataSource();
		_selectedItems = new Array<ListViewItem>();
		_content = new VBox();
		_content.percentWidth = 100;
		addChild(_content);
	}

	//******************************************************************************************
	// Overrides
	//******************************************************************************************
	private override function initialize():Void {
		super.initialize();

		if (_dataSource == null) { // create a default data source
			dataSource = new ArrayDataSource();
		}
		
		syncUI();
	}

	//******************************************************************************************
	// Instance properties
	//******************************************************************************************
	public var listSize(get, null):Int;
	public var itemHeight(get, null):Float;
	public var selectedItems(get, null):Array<ListViewItem>;
	
	private function get_listSize():Int {
		return _content.children.length;
	}
	
	private function get_itemHeight():Float {
		if (_content.children.length == 0) {
			return 0;
		}
		var n:Int = 0;
		var cy:Float = 0;
		for (child in _content.children) {
			cy += child.height;
			n++;
			if (n > 100) {
				break;
			}
		}
		return (cy / n);
	}
	
	public function getItem(index:Int):ListViewItem {
		return cast(_content.children[index], ListViewItem);
	}
	
	private function get_selectedItems():Array<ListViewItem> {
		return _selectedItems;
	}

	//******************************************************************************************
	// IDataComponent
	//******************************************************************************************
	public var dataSource(get, set):IDataSource;
	
	private function get_dataSource():IDataSource {
		return _dataSource;
	}
	
	private function set_dataSource(value:IDataSource):IDataSource {
		if (_dataSource != null) { // clean up if has ds
			if (Std.is(_dataSource, IEventDispatcher)) {
				cast(_dataSource, IEventDispatcher).removeEventListener(Event.CHANGE, _onDataSourceChanged);
			}
		}
		
		_dataSource = value;
		
		if (Std.is(_dataSource, IEventDispatcher)) {
			cast(_dataSource, IEventDispatcher).addEventListener(Event.CHANGE, _onDataSourceChanged);
		}
		
		if (_ready == true) {
			syncUI();
		}
		return value;
	}
	
	private function _onDataSourceChanged(event:Event):Void {
		syncUI();
	}
	
	//******************************************************************************************
	// Add/removes/updates ui items in the underlying scrollview based on the datasource
	//******************************************************************************************
	private function syncUI():Void {
		var pos:Int = 0;
		if (_dataSource != null) {
			if (dataSource.moveFirst()) {
				do {
					var dataHash:String = dataSource.hash();
					var data:Dynamic = dataSource.get();
					var item:ListViewItem = null;
					if (_content.getChildAt(pos) != null) {
						item = cast(_content.getChildAt(pos), ListViewItem);
					}
					
					if (item == null) { // add item
						addListViewItem(dataHash, data, pos);
						pos++;
					} else {
						if (item.hash == dataHash) { // item is in the right position
							pos++;
						} else {
							while (item != null && item.hash != dataHash) { // keep on removing until we find a match
								removeListViewItem(pos);
								item = cast(_content.getChildAt(pos), ListViewItem);
							}
							pos++;
						}
					}
				} while (dataSource.moveNext()); 
			}
		}
		
		for (n in pos..._content.children.length) { // remove anything left over
			removeListViewItem(n);
		}
		
		var n:Int = 0; // set id's for styling
		for (child in _content.children) {
			var item:ListViewItem = cast(child, ListViewItem);
			var id:String = (n % 2 == 0) ? "even" : "odd";
			item.id = id;
			n++;
		}
	}
	
	private function addListViewItem(dataHash:String, data:Dynamic, index:Int = -1):Void {
		if (data == null) {
			return;
		}
		
		var itemData:Dynamic = data;
		if (Std.is(data, String)) {
			itemData = { };
			itemData.text = cast(data, String);
		}
		itemData.text = (itemData.text != null) ? itemData.text : "";
		itemData.subtext = (itemData.subtext != null) ? itemData.subtext : "";
		itemData.icon = (itemData.icon != null) ? itemData.icon : null;
		itemData.type = (itemData.type != null) ? itemData.type : null;
		itemData.controlId = (itemData.controlId != null) ? itemData.controlId : null;
		itemData.value = (itemData.value != null) ? itemData.value : null;
		itemData.dataSource = (itemData.dataSource != null) ? itemData.dataSource : null;
		
		var item:ListViewItem = new ListViewItem(this);
		item.text = itemData.text;
		item.subtext = itemData.subtext;
		item.icon = itemData.icon;
		item.hash = dataHash;
		item.controlId = itemData.controlId;
		item.controlDataSource = itemData.dataSource;
		item.type = itemData.type;
		item.value = itemData.value;
		item.percentWidth = 100;
		if (index == -1) {
			_content.addChild(item);
		} else {
			_content.addChildAt(item, index);
		}
		
		invalidate(InvalidationFlag.SIZE);
	}
	
	private function removeListViewItem(index:Int):Void {
		trace("remove item index = " + index);
	}
	
	public function handleListSelection(item:ListViewItem, event:Event):Void {
		var shiftPressed:Bool = false;
		var ctrlPressed:Bool = false;
		
		if (Std.is(event, MouseEvent)) {
			var mouseEvent:MouseEvent = cast(event, MouseEvent);
			shiftPressed = mouseEvent.shiftKey;
			ctrlPressed = mouseEvent.ctrlKey;
		}
		
		if (ctrlPressed == true) {
			// do nothing
		} else if (shiftPressed == true) {
			
		} else {
			for (selectedItem in _selectedItems) {
				if (selectedItem != item) {
					selectedItem.state = ListViewItem.STATE_NORMAL;
				}
			}
			_selectedItems = new Array<ListViewItem>();
		}
		
		if (isSelected(item)) {
			_selectedItems.remove(item);
			item.state = ListViewItem.STATE_OVER;
		} else {
			_selectedItems.push(item);
			item.state = ListViewItem.STATE_SELECTED;
		}
		
		var event:Event = new Event(Event.CHANGE);
		dispatchEvent(event);
	}
	
	public function isSelected(item:ListViewItem):Bool {
		return Lambda.indexOf(_selectedItems, item) != -1;
	}
}

class ListViewItem extends StateComponent {
	public static inline var STATE_NORMAL = "normal";
	public static inline var STATE_OVER = "over";
	public static inline var STATE_SELECTED = "selected";
	
	private var _hash:String;
	private var _controlId:String;
	private var _controlDataSource:Dynamic;
	
	private var _textControl:Text;
	private var _subtextControl:Text;
	private var _iconControl:Image;
	private var _subControl:Component;
	
	private var _parentList:ListView;
	
	public function new(parentList:ListView) {
		super();
		_parentList = parentList;
		sprite.buttonMode = true;
		sprite.useHandCursor = true;
		state = STATE_NORMAL;
		_layout = new ListViewItemLayout();
	}
	
	private override function initialize():Void {
		super.initialize();

		addEventListener(MouseEvent.MOUSE_OVER, _onMouseOver);
		addEventListener(MouseEvent.MOUSE_OUT, _onMouseOut);
		addEventListener(MouseEvent.CLICK, _onMouseClick);
	}
	
	//******************************************************************************************
	// Event handlers
	//******************************************************************************************
	private function _onMouseOver(event:MouseEvent):Void {
		state = STATE_OVER;
	}

	private function _onMouseOut(event:MouseEvent):Void {
		if (_parentList.isSelected(this)) {
			state = STATE_SELECTED;
		} else {
			state = STATE_NORMAL;
		}
	}
	
	private function _onMouseClick(event:MouseEvent):Void {
		if (_subControl != null && _subControl.hitTest(event.stageX, event.stageY) == true) {
			return;
		}

		_parentList.handleListSelection(this, event);
	}
	
	//******************************************************************************************
	// IState
	//******************************************************************************************
	private override function get_states():Array<String> {
		return [STATE_NORMAL, STATE_OVER, STATE_SELECTED];
	}
	
	private override function set_state(value:String):String {
		var v:String = super.set_state(value);
		if (_textControl != null) {
			_textControl.state = value;
		}
		if (_subtextControl != null) {
			_subtextControl.state = value;
		}
		return v;
	}
	
	//******************************************************************************************
	// Component overrides
	//******************************************************************************************
	private override function get_text():String {
		if (_textControl == null) {
			return null;
		}
		return _textControl.text;
	}
	
	private override function set_text(value:String):String {
		if (value.length == 0) {
			return value;
		}
		
		if (_textControl == null) {
			_textControl = new Text();
			_textControl.id = "text";
			_textControl.addStates(this.states);
			addChild(_textControl);
		}
		_textControl.text = value;
		return value;
	}
	
	//******************************************************************************************
	// Getters/setters
	//******************************************************************************************
	public var hash(get, set):String;
	public var subtext(get, set):String;
	public var icon(get, set):String;
	public var controlId(get, set):String;
	public var type(null, set):String;
	public var value(get, set):Dynamic;
	public var controlDataSource(get, set):Dynamic;
	
	private function get_hash():String {
		return _hash;
	}
	
	private function set_hash(value:String):String {
		_hash = value;
		return _hash;
	}
	
	private function get_subtext():String {
		if (_subtextControl == null) {
			return null;
		}
		return _subtextControl.text;
	}
	
	private function set_subtext(value:String):String {
		if (value.length == 0) {
			return value;
		}
		
		if (_subtextControl == null) {
			_subtextControl = new Text();
			_subtextControl.id = "subtext";
			_subtextControl.multiline = true;
			_subtextControl.autoSize = false;
			_subtextControl.addStates(this.states);
			addChild(_subtextControl);
			_subtextControl.state = state;
		}
		_subtextControl.text = value;
		return value;
	}
	
	private function get_icon():String {
		if (_iconControl == null) {
			return null;
		}
		
		return _iconControl.resource;
	}
	
	private function set_icon(value:String):String {
		if (value == null || value.length == 0) {
			return value;
		}
		
		if (_iconControl == null) {
			_iconControl = new Image();
			_iconControl.id = "icon";
			addChild(_iconControl);
		}
		
		_iconControl.resource = value;
		return value;
	}
	
	private function get_controlId():String {
		return _controlId;
	}
	
	private function set_controlId(value:String):String {
		_controlId = value;
		return value;
	}
	
	private function set_type(value:String):String {
		if (_subControl != null) {
			removeChild(_subControl);
		}
		
		if (value == "button") {
			_subControl = new Button();
			_subControl.addEventListener(MouseEvent.CLICK, function(e) {
				var event:ListViewEvent = new ListViewEvent(ListViewEvent.COMPONENT_EVENT, this, _subControl);
				_parentList.dispatchEvent(event);
			});
		} else if (value == "slider") {
			_subControl = new HSlider();
			_subControl.addEventListener(Event.CHANGE, function(e) {
				var event:ListViewEvent = new ListViewEvent(ListViewEvent.COMPONENT_EVENT, this, _subControl);
				_parentList.dispatchEvent(event);
			});
		} else if (value == "progress") {
			_subControl = new HProgress();
		} else if (value == "list") {
			_subControl = new List();
			_subControl.text = "Select Option";
			var ds:IDataSource = null;
			if (Std.is(_controlDataSource, Array)) {
				ds = new ArrayDataSource();
				for (o in cast(_controlDataSource, Array<Dynamic>)) {
					ds.add(o);
				}
			}
			cast(_subControl, List).dataSource = ds;
		}
		
		if (_subControl != null) {
			_subControl.id = controlId;
			addChild(_subControl);
		}
		
		return value;
	}
	
	private function get_value():Dynamic {
		if (_subControl == null) {
			return null;
		}
		
		var value:Dynamic = null;
		if (Std.is(_subControl, Button)) {
			value = _subControl.text;
		} else if (Std.is(_subControl, HSlider)) {
			value = cast(_subControl, HSlider).pos;
		} else if (Std.is(_subControl, HProgress)) {
			value = cast(_subControl, HProgress).pos;
		}
		
		return value;
	}
	
	private function set_value(value:Dynamic):Dynamic {
		if (_subControl == null) {
			return value;
		}
		
		if (Std.is(_subControl, List)) {
		} else if (Std.is(_subControl, Button)) {
			_subControl.text = cast(value, String);
		} else if (Std.is(_subControl, HSlider)) {
			cast(_subControl, HSlider).pos = Std.parseInt(value);
		} else if (Std.is(_subControl, HProgress)) {
			cast(_subControl, HProgress).pos = Std.parseInt(value);
		}
		
		return value;
	}
	
	private function get_controlDataSource():Dynamic {
		return _controlDataSource;
	}
	
	private function set_controlDataSource(value:Dynamic):Dynamic {
		_controlDataSource = value;
		return value;
	}
}

private class ListViewItemLayout extends DefaultLayout {
	public function new() {
		super();
	}
	
	private override function resizeChildren():Void {
		//super.resizeChildren();
		
		var text:IDisplayObject = container.findChild("text");
		var subtext:IDisplayObject = container.findChild("subtext");
		var icon:IDisplayObject = container.findChild("icon");
		
		var cy:Float = padding.top + padding.bottom;
		if (text != null) {
			cy += text.height;
			if (subtext != null) {
				cy += spacingY;
			}
		}
		if (subtext != null) {
			subtext.width = usableWidth;
			cy += subtext.height;
		}
		if (icon != null) {
			if (icon.height + padding.top + padding.bottom > cy) {
				cy = icon.height + padding.top + padding.bottom;
			}
		}
		
		// sub controls
		var button:Button = container.findChildAs(Button);
		var hslider:HSlider = container.findChildAs(HSlider);
		var hprogress:HProgress = container.findChildAs(HProgress);
		var component:Component = null;
		if (button != null) {
			component = button;
		}
		if (hslider != null) {
			component = hslider;
		}
		if (hprogress != null) {
			component = hprogress;
		}
		if (component != null) {
			if (component.height + padding.top + padding.bottom > cy) {
				cy = component.height + padding.top + padding.bottom;
			}
		}
		
		container.height = cy;
	}
	
	private override function repositionChildren():Void {
		//super.repositionChildren();
		
		var text:IDisplayObject = container.findChild("text");
		var subtext:IDisplayObject = container.findChild("subtext");
		var icon:IDisplayObject = container.findChild("icon");
		var xpos:Float = padding.left;
		var ypos:Float = padding.top;
		
		if (icon != null) {
			icon.x = xpos;
			icon.y = (container.height / 2) - (icon.height / 2);
			xpos += icon.width + spacingX;
		}
		
		if (text != null) {
			if (subtext == null) {
				ypos = (container.height / 2) - (text.height / 2);
			}
			text.x = xpos;
			text.y = ypos;
			ypos += text.height;
			if (subtext != null) {
				ypos += spacingY;
			}
		}
		if (subtext != null) {
			subtext.x = xpos;
			subtext.y = ypos;
		}
		
		// sub controls
		var button:Button = container.findChildAs(Button);
		var hslider:HSlider = container.findChildAs(HSlider);
		var hprogress:HProgress = container.findChildAs(HProgress);
		var component:Component = null;
		if (button != null) {
			component = button;
		}
		if (hslider != null) {
			component = hslider;
		}
		if (hprogress != null) {
			component = hprogress;
		}
		if (component != null) {
			component.x = container.width - padding.right - component.width;
			component.y = (container.height / 2) - (component.height / 2);
		}
	}
}

class ListViewEvent extends Event {
	public static var COMPONENT_EVENT:String = "ComponentEvent";
	
	private var li:ListViewItem;
	private var c:Component;
	
	public var item(get, null):ListViewItem;
	public var component(get, null):Component;
	
	public function new(type:String, listItem:ListViewItem, component:Component) {
		super(type);
		li = listItem;
		c = component;
	}
	
	public function get_item():ListViewItem {
		return li;
	}
	
	public function get_component():Component {
		return c;
	}
}
