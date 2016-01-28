package haxe.ui.toolkit.controls.selection;

import haxe.ui.toolkit.containers.ListView;
import haxe.ui.toolkit.controls.Button;
import haxe.ui.toolkit.core.interfaces.IDataComponent;
import haxe.ui.toolkit.core.interfaces.IItemRenderer;
import haxe.ui.toolkit.core.PopupManager;
import haxe.ui.toolkit.core.Screen;
import haxe.ui.toolkit.core.Toolkit;
import haxe.ui.toolkit.data.ArrayDataSource;
import haxe.ui.toolkit.data.IDataSource;
import haxe.ui.toolkit.events.UIEvent;
import motion.Actuate;
import motion.easing.Linear;
import motion.easing.Quart;
import openfl.events.Event;
import openfl.events.MouseEvent;

/**
 Allows the user to select an item from a list

 The way in which the list is displayed after the user clicks the button depends on the `method` property:
 
 * `default` - The list will be displayed under the button, similar to a standard drop down box
 * `popup` - The list will be a modal popup of the choices, this is more suited to mobile applications

 <b>Events:</b>
 
 * `Event.CHANGE` - Dispatched when the user selects a list item
 
 **/

class ListSelector extends Button implements IDataComponent {
	private var _dataSource:IDataSource;
	private var _list:ListView;
	
	private var _maxListSize:Int = 4;
	private var _method:String;
	
	private var _selectedIndex:Int = -1;
	private var _selectedItems:Array<IItemRenderer>;
	
	//private var _transition:String = "slide";
	
    public var lazyLoad:Bool = true;
    
	public function new() {
		super();
		toggle = true;
		allowSelection = false;
		dispatchChangeEvents = false;
		autoSize = false;
	}
	
	//******************************************************************************************
	// Overrides
	//******************************************************************************************
	private override function preInitialize():Void {
		super.preInitialize();
		
		if (_baseStyle != null) {
			if (_baseStyle.selectionMethod != null) {
				_method = _baseStyle.selectionMethod;
			}
		}
	}
	
	private override function initialize():Void {
		super.initialize();
        if (lazyLoad == false && _list == null) {
            _list = new ListView();
            _list.styleName = "dropDown";
            _list.visible = false;
            if (this.id != null) {
                _list.id = this.id + "_dropDown";
            }
            _list.addEventListener(UIEvent.CHANGE, _onListChange);
            _list.content.addEventListener(Event.ADDED_TO_STAGE, function(e) {
                if (_dataSourceDirty == true) {
                    _list.dataSource = _dataSource;
                    _dataSourceDirty = false;
                }
            });
            root.addChild(_list);
        }
	}
	
	private override function _onMouseClick(event:MouseEvent):Void {
		//super._onMouseClick(event);
		if (_list == null || _list.visible == false) {
			showList();
		} else {
			hideList();
		}
	}
	
	public override function applyStyle():Void {
		super.applyStyle();
		
		if (_baseStyle != null) {
			if (_baseStyle.selectionMethod != null && _method == null) {
				_method = _baseStyle.selectionMethod;
			}
			
			if (_baseStyle.listSize != -1) {
				listSize = _baseStyle.listSize;
			}
		}
	}
	
	//******************************************************************************************
	// IDataComponent
	//******************************************************************************************
    private var _dataSourceDirty:Bool = true; // we'll start off as dirty so we get the first set
	/**
	 Specifies the data source where the list will get its options from
	 **/
	public var dataSource(get, set):IDataSource;
	
	private function get_dataSource():IDataSource {
		if (_dataSource == null) {
			_dataSource = new ArrayDataSource();
		}
		return _dataSource;
	}
	
	private function set_dataSource(value:IDataSource):IDataSource {
		_dataSource = value;
        _dataSourceDirty = true;
		return value;
	}
	
	//******************************************************************************************
	// Instance methods
	//******************************************************************************************
	/**
	 Displays the list to the user based on `method` (this will be called automatically when the user clicks the button)
	 **/
	public function showList():Void {
		if (_method == "popup") {
			PopupManager.instance.showList(dataSource, _selectedIndex, "Select Item", { }, function(item:IItemRenderer) {
				_selectedIndex = item.data.index;
				this.text = item.data.text;
				_selectedItems = new Array<IItemRenderer>();
				_selectedItems.push(item);
				this.selected = false;
				var event:UIEvent = new UIEvent(UIEvent.CHANGE);
				dispatchEvent(event);
			});
		} else {
			if (_list == null) {
				_list = new ListView();
				_list.styleName = "dropDown";
				if (this.id != null) {
					_list.id = this.id + "_dropDown";
				}
				_list.addEventListener(UIEvent.CHANGE, _onListChange);
				_list.content.addEventListener(Event.ADDED_TO_STAGE, function(e) {
					showList();
				});
				root.addChild(_list);
				return;
			}

            if (_dataSourceDirty == true) {
                _list.dataSource = _dataSource;
                _dataSourceDirty = false;
            }
			root.addEventListener(MouseEvent.MOUSE_DOWN, _onRootMouseDown);
			root.addEventListener(MouseEvent.MOUSE_WHEEL, _onRootMouseDown);
			
			_list.x = this.stageX - root.stageX;
			_list.y = this.stageY + this.height - root.stageY;
			//if (_list.width == 0) {
				_list.width = this.width;
			//}
			
			var n:Int = _maxListSize;
			if (n > _list.listSize) {
				n = _list.listSize;
			}
			
			var listHeight:Float = n * _list.itemHeight + (_list.layout.padding.top + _list.layout.padding.bottom);
			_list.height = listHeight;
			_list.setSelectedIndexNoEvent(_selectedIndex);
			if (_list.stageY + listHeight > Screen.instance.height/Toolkit.scaleFactor) {
				_list.y = this.stageY - _list.height;
				this.styleName = "dropUp";
			} else {
				this.styleName = null;
			}
			
			var transition:String = Toolkit.getTransitionForClass(ListSelector);
			var transitionTime:Float = Toolkit.getTransitionTimeForClass(ListSelector);
			if (transition == "slide") {
				_list.clipHeight = 0;
				_list.sprite.alpha = 1;
				_list.visible = true;
				Actuate.tween(_list, transitionTime, { clipHeight: listHeight }, true).ease(Quart.easeOut).onComplete(function() {
					_list.clearClip();
				});
			} else if (transition == "fade") {
				_list.sprite.alpha = 0;
				_list.visible = true;
				Actuate.tween(_list.sprite, transitionTime, { alpha: 1 }, true).ease(Linear.easeNone).onComplete(function() {
				});
			} else {
				_list.sprite.alpha = 1;
				_list.visible = true;
			}
			
			this.selected = true;
		}
	}
	
	/**
	 Hides the list from the user
	 **/
	public function hideList():Void {
		if (_list != null) {
			var transition:String = Toolkit.getTransitionForClass(ListSelector);
			var transitionTime:Float = Toolkit.getTransitionTimeForClass(ListSelector);
			if (transition == "slide") {
				_list.sprite.alpha = 1;
				Actuate.tween(_list, transitionTime, { clipHeight: 0 }, true).ease(Quart.easeOut).onComplete(function() {
					_list.visible = false;
					_list.clearClip();
				});
			} else if (transition == "fade") {
				Actuate.tween(_list.sprite, transitionTime, { alpha: 0 }, true).ease(Linear.easeNone).onComplete(function() {
					_list.visible = false;
				});
			} else {
				_list.sprite.alpha = 1;
				_list.visible = false;
			}
			
			this.selected = false;
		}
	}

	//******************************************************************************************
	// Propreties
	//******************************************************************************************
	/**
	 Specifies the method to display the list, valid values are:
		 
	 * `default` - The list will be displayed under the button, similar to a standard drop down box

	 * `popup` - The list will be a modal popup of the choices, this is more suited to mobile applications
	 **/
	public var method(get, set):String;
	
	private function get_method():String {
		return _method;
	}
	
	private function set_method(value:String):String {
		_method = value;
		return value;
	}
	
	public var listSize(get, set):Int;
	
	private function get_listSize():Int {
		return _maxListSize;
	}
	
	private function set_listSize(value:Int):Int {
		_maxListSize = value;
		return value;
	}
	
	//******************************************************************************************
	// ListView props
	//******************************************************************************************
	/**
	 Returns an array of the selected list items
	 **/
	public var selectedItems(get, null):Array<IItemRenderer>;
	
	private function get_selectedItems():Array<IItemRenderer> {
		return _selectedItems;
	}
	
	public var selectedIndex(get, set):Int;
	private function get_selectedIndex():Int {
		return _selectedIndex;
	}
	
	private function set_selectedIndex(value:Int):Int {
		_selectedIndex = value;
		if (_list != null) {
			_list.selectedIndex = value;
			_selectedItems = _list.selectedItems;
		}
		if (_selectedIndex < 0) {
			this.text = '';
		}else {
			if (_dataSource != null) {
				var n:Int = 0;
				if (dataSource.moveFirst()) {
					do {
						if (n == _selectedIndex) {
							this.text = _dataSource.get().text;
							break;
						}
						n++;
					} while (dataSource.moveNext()); 
				}
			}
		}
		return value;
	}
	
	//******************************************************************************************
	// Event handlers
	//******************************************************************************************
	private function _onRootMouseDown(event:MouseEvent):Void {
		var mouseInList:Bool = false;
		if (_list != null) {
			mouseInList = _list.hitTest(event.stageX, event.stageY);
		}

		var mouseIn:Bool = hitTest(event.stageX, event.stageY);
		if (mouseInList == false && _list != null && mouseIn == false) {
			root.removeEventListener(MouseEvent.MOUSE_DOWN, _onRootMouseDown);
			root.removeEventListener(MouseEvent.MOUSE_WHEEL, _onRootMouseDown);
			hideList();
		}
	}
	
	private function _onListChange(event:UIEvent):Void {
		if (_list.selectedItems != null && _list.selectedItems.length > 0) {
			this.text = _list.selectedItems[0].data.text;
			_selectedIndex = _list.selectedIndex;
			_selectedItems = _list.selectedItems;
			hideList();
			
			var event:UIEvent = new UIEvent(UIEvent.CHANGE);
			dispatchEvent(event);
		}
	}
}

class DropDownList extends ListView {
	public function new() {
		super();
	}
}