package haxe.ui.toolkit.containers;

import openfl.events.Event;
import openfl.events.IEventDispatcher;
import openfl.events.MouseEvent;
import haxe.ui.toolkit.controls.Button;
import haxe.ui.toolkit.controls.HProgress;
import haxe.ui.toolkit.controls.HSlider;
import haxe.ui.toolkit.controls.selection.ListSelector;
import haxe.ui.toolkit.controls.Spacer;
import haxe.ui.toolkit.controls.Text;
import haxe.ui.toolkit.core.Component;
import haxe.ui.toolkit.core.interfaces.IDataComponent;
import haxe.ui.toolkit.core.interfaces.InvalidationFlag;
import haxe.ui.toolkit.core.interfaces.IStateComponent;
import haxe.ui.toolkit.data.ArrayDataSource;
import haxe.ui.toolkit.data.IDataSource;
import haxe.ui.toolkit.style.Style;
import haxe.ui.toolkit.style.StyleManager;

class TableView extends Component implements IDataComponent {
	private var _scrollView:ScrollView;
	private var _scrollContent:VBox;
	private var _dataSource:IDataSource;
	
	private var _selectedItems:Array<TableViewRow>;
	private var _lastSelection:Int = -1;
	
	public function new() {
		super();
		_columnDefs = new TableViewColumnDefs();
		dataSource = new ArrayDataSource();
		_scrollView = new ScrollView();
		_scrollView.style.borderSize = 0;
		
		_selectedItems = new Array<TableViewRow>();
		
		_scrollView.percentWidth = 100;
		_scrollView.percentHeight = 100;
		_scrollContent = new VBox();
		_scrollContent.id = "tableContent";
		_scrollContent.autoSize = true;
		_scrollView.addChild(_scrollContent);
	}
	
	//******************************************************************************************
	// Overrides
	//******************************************************************************************
	private override function initialize():Void {
		super.initialize(); 
		
		addChild(_scrollView);
		
		if (_dataSource == null) { // create a default data source
			dataSource = new ArrayDataSource();
		}
		
		_dataSource.open();
		
		syncUI();
	}
	
	public override function invalidate(type:Int = InvalidationFlag.ALL, recursive:Bool = false):Void {
		super.invalidate(type, recursive);
		if (_ready && type & InvalidationFlag.SIZE == InvalidationFlag.SIZE) {
			if (_scrollView.layout.usableWidth > 0) {
				resizeColumns();
			}
		}
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
	// Instance properties
	//******************************************************************************************
	private var _columnDefs:TableViewColumnDefs;
	public var columns(get, set):TableViewColumnDefs;
	private function get_columns():TableViewColumnDefs {
		return _columnDefs;
	}
	private function set_columns(value:TableViewColumnDefs):TableViewColumnDefs {
		_columnDefs = value;
		return value;
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
					var item:TableViewRow = null;
					if (_scrollContent.getChildAt(pos) != null) {
						item = cast(_scrollContent.getChildAt(pos), TableViewRow);
					}
					
					if (item == null) { // add item
						addTableRow(dataHash, data, pos);	
						pos++;
					} else {
						if (item.hash == dataHash) { // item is in the right position
							pos++;
						} else {
							while (item != null && item.hash != dataHash) { // keep on removing until we find a match
								//removeListViewItem(pos);
								item = cast(_scrollContent.getChildAt(pos), TableViewRow);
							}
							pos++;
						}
					}
					
				} while (dataSource.moveNext()); 
			}
		}
	}
	
	private function addTableRow(dataHash:String, data:Dynamic, index:Int = -1):Void {
		if (data == null) {
			return;
		}
		
		for (f in Reflect.fields(data)) {
			if (f != "__get_id__") {
				if (_columnDefs.has(f) == false) {
					_columnDefs.add(f);
					trace(f);
				}
			}
		}
		
		var item:TableViewRow = new TableViewRow(this);
		item.autoSize = true;
		item.data = data;
		item.hash = dataHash;
		var id:String = (_scrollContent.numChildren % 2 == 0) ? "even" : "odd";
		item.id = id;
		if (index == -1) {
			_scrollContent.addChild(item);
		} else {
			_scrollContent.addChildAt(item, index);
		}
	
		_scrollView.invalidate(InvalidationFlag.SIZE);
	}
	
	private function resizeColumns():Void {
		
		if (_scrollContent.numChildren == 0) {
			return;
		}
		var sx:Int = cast(_scrollContent.getChildAt(0), TableViewRow).layout.spacingX;		
		
		var cols:Array<TableViewColumnDef> = _columnDefs.iterator();
		var totalWidth:Float = 0;
		for (c in cols) {
			totalWidth += c.calculatedWidth + sx;
		}
		
		if (totalWidth < _scrollView.layout.usableWidth) {
			var diff:Float = _scrollView.layout.usableWidth - totalWidth;
			var newWidth:Float = cols[cols.length - 1].calculatedWidth + diff;
			for (child in _scrollContent.children) {
				var temp:TableViewRow = cast(child, TableViewRow);
				temp.getChildAt(temp.numChildren - 1).width = newWidth;
			}
		}
	}
	
	public function handleListSelection(item:TableViewRow, event:Event, raiseEvent:Bool = true):Void {
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
					selectedItem.state = TableViewRow.STATE_NORMAL;
				}
			}
			_selectedItems = new Array<TableViewRow>();
		}
		
		if (isSelected(item)) {
			_selectedItems.remove(item);
			item.state = TableViewRow.STATE_OVER;
		} else {
			_selectedItems.push(item);
			item.state = TableViewRow.STATE_SELECTED;
		}

		//_scrollView.ensureVisible(item);
		
		if (raiseEvent == true) {
			var event:Event = new Event(Event.CHANGE);
			dispatchEvent(event);
		}
	}
	
	public function handleClick(item:TableViewRow, event:MouseEvent):Void {
		var index:Int = Lambda.indexOf(_scrollContent.children, item);
		if (_lastSelection == index) {
			var event:MouseEvent = new MouseEvent(MouseEvent.DOUBLE_CLICK);
			dispatchEvent(event);
			_lastSelection = -1;
		} else {
			_lastSelection = index;
		}
	}
	
	public function isSelected(item:TableViewRow):Bool {
		return Lambda.indexOf(_selectedItems, item) != -1;
	}
}

class TableViewColumnDefs {
	private var _columns:Array<TableViewColumnDef>;
	public function new() {
		_columns = new Array<TableViewColumnDef>();
	}
	
	public function add(id:String, width:Float = 0, title:String = ""):Void {
		if (has(id) == false) {
			var c:TableViewColumnDef = new TableViewColumnDef();
			c.id = id;
			c.width = width;
			_columns.push(c);
		}
	}
	
	public function has(id:String):Bool {
		var b:Bool = false;
		for (c in _columns) {
			if (c.id == id) {
				b = true;
			}
		}
		return b;
	}
	
	public function iterator():Array<TableViewColumnDef> {
		return _columns;
	}
	
	public function findColumn(id:String):TableViewColumnDef {
		var c:TableViewColumnDef = null;
		for (test in _columns) {
			if (test.id == id) {
				c = test;
				break;
			}
		}
		return c;
	}
}

class TableViewColumnDef {
	public var id:String;
	public var type:String = "text";
	public var width:Float = 0;
	public var calculatedWidth:Float = 0;
	
	public function new() {
		
	}
}

class TableViewRow extends HBox implements IStateComponent {
	public static inline var STATE_NORMAL = "normal";
	public static inline var STATE_OVER = "over";
	public static inline var STATE_SELECTED = "selected";
	
	private var _state:String;
	private var _states:Array<String>;
	private var _parentTable:TableView;
	
	public function new(parentTable:TableView = null) {
		super();
		_states = new Array<String>();
		sprite.buttonMode = true;
		sprite.useHandCursor = true;
		state = STATE_NORMAL;
		_parentTable = parentTable;
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
		if (_parentTable.isSelected(this)) {
			state = STATE_SELECTED;
		} else {
			state = STATE_NORMAL;
		}
	}
	
	private function _onMouseClick(event:MouseEvent):Void {
		/*
		if (_subControl != null && _subControl.hitTest(event.stageX, event.stageY) == true) {
			return;
		}
		*/
		
		_parentTable.handleListSelection(this, event);
		_parentTable.handleClick(this, event);
	}
	
	//******************************************************************************************
	// Instance properties
	//******************************************************************************************
	public var hash(default, default):String;
	
	private var _data:Dynamic;
	public var data(get, set):Dynamic;
	private function get_data():Dynamic {
		return _data;
	}
	private function set_data(value:Dynamic):Dynamic {
		_data = value;
		for (colDef in _parentTable.columns.iterator()) {
			if (Reflect.hasField(value, colDef.id)) {
				var c:Component = null;
				var colValue:Dynamic = Reflect.field(value, colDef.id);
				var type:String = "text";
				if (Std.is(colValue, String)) {
					c = createColumnComponent(colValue, "text");
				} else {
					if (Reflect.hasField(colValue, "type")) {
						type = cast(Reflect.field(colValue, "type"), String);
					}
					var componentValue:Dynamic = null;
					if (Reflect.hasField(colValue, "value")) {
						componentValue = Reflect.field(colValue, "value");
					}
					c = createColumnComponent(componentValue, type);
				}
				
				if (c != null) {
					if (type == "list") {
						if (Reflect.hasField(colValue, "dataSource")) {
							var controlDataSource:Dynamic = Reflect.field(colValue, "dataSource");
							var ds:IDataSource = null;
							if (Std.is(controlDataSource, Array)) {
								ds = new ArrayDataSource();
								for (o in cast(controlDataSource, Array<Dynamic>)) {
									ds.add(o);
								}
							}
							cast(c, ListSelector).dataSource = ds;
						}
					}
					
					c.autoSize = true;
					addChild(c);
					c.addEventListener(Event.ADDED_TO_STAGE, function(e) {
						if (colDef.width <= 0) {
							if (c.width > colDef.calculatedWidth) {
								colDef.calculatedWidth = c.width;
							} else {
								c.width = colDef.calculatedWidth;
							}
						} else {
							c.width = colDef.width;
							colDef.calculatedWidth = colDef.width;
						}
					});
				}
			}
		}
		return value;
	}
	
	//******************************************************************************************
	// Helpers
	//******************************************************************************************
	private function createColumnComponent(value:Dynamic, type:String):Component {
		var c:Component = null;
		if (value == null) {
			c = new Spacer();
			return c;
		}
		switch (type) {
			case "text":
				c = new Text();
				c.autoSize = false;
				cast(c, Text).text = cast(value, String);
				cast(c, Text).addStates(this.states);
			case "button":
				c = new Button();
				cast(c, Button).text = cast(value, String);
			case "slider":
				c = new HSlider();
				cast(c, HSlider).pos = Std.parseInt(value);
			case "progress":
				c = new HProgress();
				cast(c, HProgress).pos = Std.parseInt(value);
			case "list":
				c = new ListSelector();
				cast(c, ListSelector).text = cast(value, String);
			default:
				c = new Spacer();
		}
		return c;
	}
	
	//******************************************************************************************
	// IStyleable
	//******************************************************************************************
	private override function buildStyles():Void {
		for (s in states) {
			var stateStyle:Style = StyleManager.instance.buildStyleFor(this, s);
			if (stateStyle != null) {
				//stateStyle.merge(_setStyle);
				storeStyle(s, stateStyle);
			}
		}
	}

	public function addStates(stateNames:Array<String>):Void {
		for (stateName in stateNames) {
			_states.push(stateName);
		}
		if (_ready) {
			buildStyles();
		}
	}
	
	//******************************************************************************************
	// IState
	//******************************************************************************************
	public var state(get, set):String;
	public var states(get, null):Array<String>;
	
	private function get_state():String {
		return _state;
	}

	private function set_state(value:String):String {
		if (_state != value) {
			_state = value;
			if (retrieveStyle(_state) != null) {
				style = retrieveStyle(_state);
			} else {
				invalidate(InvalidationFlag.STATE);
			}
			
			for (c in children) {
				if (Std.is(c, Text)) {
					var cx:Float = cast(c, Text).width; // This shouldnt be needed
					cast(c, Text).state = value;
					cast(c, Text).width = cx;
				}
			}
		}
		return value;
	}
	
	private function get_states():Array<String> {
		return [STATE_NORMAL, STATE_OVER, STATE_SELECTED];
	}
	
	public function hasState(state:String):Bool {
		if (states == null) {
			return false;
		}
		return Lambda.indexOf(states, state) != -1;
	}
}
