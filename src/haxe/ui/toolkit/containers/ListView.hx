package haxe.ui.toolkit.containers;

import flash.events.Event;
import flash.events.MouseEvent;
import haxe.ui.toolkit.core.Component;
import haxe.ui.toolkit.core.interfaces.IDataComponent;
import haxe.ui.toolkit.core.interfaces.IDisplayObject;
import haxe.ui.toolkit.core.interfaces.IEventDispatcher;
import haxe.ui.toolkit.core.interfaces.IItemRenderer;
import haxe.ui.toolkit.core.interfaces.InvalidationFlag;
import haxe.ui.toolkit.core.interfaces.IStateComponent;
import haxe.ui.toolkit.core.renderers.BasicItemRenderer;
import haxe.ui.toolkit.core.renderers.ItemRenderer;
import haxe.ui.toolkit.core.StyleableDisplayObject;
import haxe.ui.toolkit.data.ArrayDataSource;
import haxe.ui.toolkit.data.IDataSource;
import haxe.ui.toolkit.events.UIEvent;

@:build(haxe.ui.toolkit.core.Macros.addEvents([
	"componentEvent"
]))
class ListView extends ScrollView implements IDataComponent {
	private var _dataSource:IDataSource;
	
	private var _content:VBox;
	
	private var _selectedItems:Array<IItemRenderer>;
	private var _lastSelection:Int = -1;
	
	private var _itemRenderer:Dynamic;
	
	public function new() {
		super();
		autoSize = false;
		dataSource = new ArrayDataSource();
		_selectedItems = new Array<IItemRenderer>();
		_content = new VBox();
		_content.id = "content";
		_content.percentWidth = 100;
		addChild(_content);

		_itemRenderer = BasicItemRenderer;
	}

	//******************************************************************************************
	// Overrides
	//******************************************************************************************
	private override function initialize():Void {
		super.initialize();

		if (_dataSource == null) { // create a default data source
			dataSource = new ArrayDataSource();
		}
		
		_dataSource.open();
		
		syncUI();
		checkScrolls();
	}

	public override function dispose():Void {
		if (_dataSource != null) {
			_dataSource.close();
		}
		super.dispose();
	}
	
	public override function addChild(child:IDisplayObject):IDisplayObject {
		if (Std.is(child, IItemRenderer)) {
			_itemRenderer = child;
			return child;
		}
		return super.addChild(child);
	}

	public override function addChildAt(child:IDisplayObject, index:Int):IDisplayObject {
		return super.addChildAt(child, index);
	}
	
	//******************************************************************************************
	// Instance properties
	//******************************************************************************************
	public var listSize(get, null):Int;
	public var itemHeight(get, null):Float;
	public var selectedItems(get, null):Array<IItemRenderer>;
	public var selectedIndex(get, set):Int;
	public var content(get, null):Component;
	public var itemRenderer(get, set):Dynamic;
	
	private function get_listSize():Int {
		return _content.children.length;
	}
	
	private function get_itemHeight():Float {
		if (_content.children.length == 0) {
			return 0;
		}
		var n:Int = 0;
		var cy:Float = _content.layout.padding.top + _content.layout.padding.bottom;
		var scy:Int = _content.layout.spacingY;
		for (child in _content.children) {
			cy += child.height + scy;
			n++;
			if (n > 100) {
				break;
			}
		}
		if (n > 0) {
			cy -= scy;
		}
		return (cy / n);
	}
	
	public function getItem(index:Int):IItemRenderer {
		return cast(_content.children[index], IItemRenderer);
	}
	
	private function get_selectedItems():Array<IItemRenderer> {
		return _selectedItems;
	}

	private function get_selectedIndex():Int {
		var index:Int = -1;
		if (_selectedItems != null && _selectedItems.length > 0) {
			index = Lambda.indexOf(_content.children, _selectedItems[0]);
		}
		return index;
	}
	
	private function set_selectedIndex(value:Int):Int {
		if (_ready == false) {
			return value;
		}

		if (value < 0) {
			for (selectedItem in _selectedItems) {
				selectedItem.state = ItemRenderer.STATE_NORMAL;
			}
			_selectedItems = new Array<IItemRenderer>();
		} else {
			if (_content.getChildAt(value) != null) {
				var item:IItemRenderer = cast(_content.getChildAt(value), IItemRenderer);
				if (item != null) {
					handleListSelection(item, null);
				}
			}
		}
		
		return value;
	}
	
	private function get_content():Component {
		var c:Component = null;
		if (numChildren > 0) {
			c = cast(getChildAt(0), Component);
		}
		return c;
	}
	
	private function get_itemRenderer():Dynamic {
		return _itemRenderer;
	}
	
	private function set_itemRenderer(value:Dynamic):Dynamic {
		_itemRenderer = value;
		return value;
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
		_lastSelection = -1;
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
					var item:IItemRenderer = null;
					if (_content.getChildAt(pos) != null) {
						item = cast(_content.getChildAt(pos), IItemRenderer);
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
								item = cast(_content.getChildAt(pos), IItemRenderer);
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
		
		/*
		var n:Int = 0; // set id's for styling
		for (child in _content.children) {
			var item:IItemRenderer = cast(child, IItemRenderer);
			if (Std.is(item, StyleableDisplayObject)) {
				var styleName:String = (n % 2 == 0) ? "even" : "odd";
				cast(item, StyleableDisplayObject).styleName = styleName;
			}
			n++;
		}
		*/
	}
	
	private function addListViewItem(dataHash:String, data:Dynamic, index:Int = -1):Void {
		if (data == null) {
			return;
		}

		var item:IItemRenderer = createRendererInstance();
		item.autoSize = true;
		item.hash = dataHash;
		item.percentWidth = 100;
		//item.height = 100;
		item.data = data;
		if (Std.is(item, StyleableDisplayObject)) {
			var styleName:String = (_content.numChildren % 2 == 0) ? "even" : "odd";
			cast(item, StyleableDisplayObject).styleName = styleName;
		}
		
		if (index == -1) {
			_content.addChild(item);
		} else {
			_content.addChildAt(item, index);
		}
		
		invalidate(InvalidationFlag.SIZE);
		
		cast(item, IDisplayObject).addEventListener(UIEvent.MOUSE_OVER, _onListItemMouseOver);
		cast(item, IDisplayObject).addEventListener(UIEvent.MOUSE_OUT, _onListItemMouseOut);
		cast(item, IDisplayObject).addEventListener(UIEvent.CLICK, _onListItemClick);
	}
	
	private function removeListViewItem(index:Int):Void {
		var item:IItemRenderer = cast(_content.getChildAt(index), IItemRenderer);
		var sIndex:Int = Lambda.indexOf(_selectedItems, item);
		if (sIndex != -1) {
			_selectedItems.remove(item);
		}
		if (item != null) {
			_content.removeChild(item);
			invalidate(InvalidationFlag.SIZE);
		}
	}
	
	private function _onListItemMouseOver(event:UIEvent):Void {
		if (Std.is(event.component, IStateComponent)) {
			cast(event.component, IStateComponent).state = ItemRenderer.STATE_OVER;
		}
	}

	private function _onListItemMouseOut(event:UIEvent):Void {
		if (Std.is(event.component, IStateComponent)) {
			var item:IItemRenderer = cast event.component;
			if (isSelected(item)) {
				cast(item, IStateComponent).state = ItemRenderer.STATE_SELECTED;
			} else {
				cast(item, IStateComponent).state = ItemRenderer.STATE_NORMAL;
			}
		}
	}
	
	private function _onListItemClick(event:UIEvent):Void {
		if (Std.is(event.component, IItemRenderer)) {
			var item:IItemRenderer = cast event.component;
			if (item.allowSelection(event.stageX, event.stageY)) {
				handleListSelection(item, event);
				handleClick(item);
			}
		}
	}
	
	private function handleListSelection(item:IItemRenderer, event:UIEvent, raiseEvent:Bool = true):Void {
		var shiftPressed:Bool = false;
		var ctrlPressed:Bool = false;
		
		if (event != null && Std.is(event, MouseEvent)) {
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
					selectedItem.state = ItemRenderer.STATE_NORMAL;
				}
			}
			_selectedItems = new Array<IItemRenderer>();
		}
		
		if (isSelected(item)) {
			_selectedItems.remove(item);
			item.state = ItemRenderer.STATE_OVER;
		} else {
			_selectedItems.push(item);
			item.state = ItemRenderer.STATE_SELECTED;
		}

		ensureVisible(item);
		
		if (raiseEvent == true) {
			if (selectedIndex != -1) {
				var item:ItemRenderer = cast _content.getChildAt(selectedIndex);
				if (item != null) {
					item.dispatchProxyEvent(UIEvent.CHANGE, event);
				}
				//var event:UIEvent = new UIEvent(UIEvent.CHANGE);
				//dispatchEvent(event);
			}
		}
	}
	
	private function handleClick(item:IItemRenderer):Void {
		var index:Int = Lambda.indexOf(_content.children, item);
		if (_lastSelection == index) {
			var event:UIEvent = new UIEvent(UIEvent.DOUBLE_CLICK);
			dispatchEvent(event);
			_lastSelection = -1;
		} else {
			_lastSelection = index;
		}
	}
	
	public function isSelected(item:IItemRenderer):Bool {
		return Lambda.indexOf(_selectedItems, item) != -1;
	}
	
	//******************************************************************************************
	// Helpers
	//******************************************************************************************
	public function getItemIndex(item:IItemRenderer):Int {
		var index:Int = -1;
		if (item != null) {
			index = Lambda.indexOf(_content.children, item);
		}
		return index;
	}
	
	public function setSelectedIndexNoEvent(value:Int):Int {
		if (_ready == false) {
			return value;
		}
		if (_content.getChildAt(value) != null) {
			var item:IItemRenderer = cast(_content.getChildAt(value), IItemRenderer);
			if (item != null) {
				handleListSelection(item, null, false);
			}
		}
		return value;
	}
	
	public function ensureVisible(item:IItemRenderer):Void {
		if (item == null) {
			return;
		}
		var vpos:Float = 0;
		if (_vscroll != null) {
			vpos = _vscroll.pos;
		}
		if (item.y + item.height > vpos + _content.clipHeight) {
			_vscroll.pos = ((item.y + item.height) - _content.clipHeight);
		} else if (item.y < vpos) {
			_vscroll.pos = item.y;
		}
	}
	
	private function createRendererInstance():IItemRenderer {
		var r:IItemRenderer = null;
		if (_itemRenderer == null) {
			return null;
		}
		
		if (Std.is(_itemRenderer, IItemRenderer)) {
			r = cast(_itemRenderer, IItemRenderer).clone();
		} else if (Std.is(_itemRenderer, Class)) {
			var cls:Class<Dynamic> = cast(_itemRenderer, Class<Dynamic>);
			r = Type.createInstance(cls, []);
		} else if (Std.is(_itemRenderer, String)) {
			var classString = cast(_itemRenderer, String);
			var cls:Class<Dynamic> = Type.resolveClass(classString);
			r = Type.createInstance(cls, []);
		}
		
		if (r != null) {
			r.eventDispatcher = this;
		}
		
		return r;
	}
}
