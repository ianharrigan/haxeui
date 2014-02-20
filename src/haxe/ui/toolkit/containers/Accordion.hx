package haxe.ui.toolkit.containers;

import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import haxe.ui.toolkit.core.Component;
import haxe.ui.toolkit.controls.Button;
import haxe.ui.toolkit.core.interfaces.IDisplayObject;
import haxe.ui.toolkit.core.interfaces.IDisplayObjectContainer;
import haxe.ui.toolkit.core.interfaces.IEventDispatcher;
import haxe.ui.toolkit.core.interfaces.InvalidationFlag;
import haxe.ui.toolkit.core.StyleableDisplayObject;
import haxe.ui.toolkit.core.Toolkit;
import haxe.ui.toolkit.events.UIEvent;
import motion.Actuate;
import motion.easing.Linear;

/**
 Basic, animated accordion container
 **/
class Accordion extends VBox {
	private var _panels:Array<IDisplayObject>;
	private var _buttons:Array<AccordionButton>;
	private var _selectedIndex:Int = -1;
	
	public function new() {
		super();
		_autoSize = false;
		_panels = new Array<IDisplayObject>();
		_buttons = new Array<AccordionButton>();
	}
	
	//******************************************************************************************
	// Overrides
	//******************************************************************************************
	public override function initialize():Void {
		super.initialize();
		
		if (_selectedIndex != -1) {
			var cachedIndex:Int = _selectedIndex;
			_selectedIndex = -1;
			showPage(cachedIndex);
		}
	}
	
	/**
	 Adds a panel to the accordion, the childs `text` property will be used as the title
	 **/
	public override function addChild(child:IDisplayObject):IDisplayObject {
		var r = null;
		if (Std.is(child, AccordionButton)) {
			r = super.addChild(child);
		} else {
			if (Std.is(child, IDisplayObjectContainer)) {
				cast(child, IDisplayObjectContainer).autoSize = false;
			}
			if (Std.is(child, StyleableDisplayObject)) {
				cast(child, StyleableDisplayObject).styleName = "page";
			}
			child.percentHeight = 100;
			child.percentWidth = 100;
			_panels.push(child);
			
			var button:AccordionButton = new AccordionButton();
			button.styleName = "expandable";
			if (Std.is(child, Component)) {
				button.text = cast(child, Component).text;
			}
			button.percentWidth = 100;
			button.toggle = true;
			button.selected = false;
			button.addEventListener(UIEvent.CHANGE, buildMouseClickFunction(_panels.length - 1));
			
			addChild(button);
			_buttons.push(button);
			child.visible = false;
			super.addChild(child);
		}
		return r;
	}

	//******************************************************************************************
	// Properties
	//******************************************************************************************
	public var selectedIndex(get, set):Int;
	
	private function get_selectedIndex():Int {
		return _selectedIndex;
	}
	
	private function set_selectedIndex(value:Int):Int {
		if (_ready == true) {
			_buttons[value].selected = true;
		} else {
			_selectedIndex = value;
		}
		return value;
	}
	
	//******************************************************************************************
	// Helpers
	//******************************************************************************************
	public var selectedButton(get, null):Button;
	private function get_selectedButton():Button {
		
		if (_selectedIndex == -1) {
			return null;
		}
		
		return getButton(_selectedIndex);
	}

	public function getButton(index:Int):Button {
		return _buttons[index];
	}
	
	public function showPage(index:Int):Void {
		var button:AccordionButton = _buttons[index];
		button.selected = true;
	}
	
	private function buildMouseClickFunction(index:Int) {
		return function(event:UIEvent) { mouseClickButton(index); };
	}
	
	private function mouseClickButton(index:Int):Void {
		var button:AccordionButton = _buttons[index];
		for (b in _buttons) {
			if (b == button) {
				if (b.selected == true) {
					showPanel(index);
				} else {
					hidePanel(index);
				}
			}
		}
		
		dispatchEvent(new UIEvent(UIEvent.CHANGE));
	}
	
	private function showPanel(index:Int):Void {
		var button:AccordionButton = _buttons[index];
		var panel:IDisplayObject = _panels[index];
		
		if (panel != null) {
			panel.visible = true;
			//panel.percentHeight = 100;
			
			var transition:String = Toolkit.getTransitionForClass(Accordion);
			
			var c = cast(panel, Component);
			
			if (transition == "fade") { // fade in panel.
				c.sprite.alpha = 0;
				Actuate.tween(c.sprite, .2, { alpha: 1 }, true).ease(Linear.easeNone);
			}
			
			if (selectedButton != null) {
				selectedButton.selected = false; // hides current panel.
			} else if (transition == "slide") { // slide in panel.
				panel.percentHeight = -1;
				c.clipHeight = 0;
				c.height = 0;
				Actuate.tween(c, .2, { height: layout.usableHeight, clipHeight: layout.usableHeight }, true).ease(Linear.easeNone)
					   .onComplete(function () {
						   c.clearClip();
						   c.percentHeight = 100;
					   });
			}
			
			_selectedIndex = index;
		}
	}
	
	private function hidePanel(index:Int):Void {
		var button:AccordionButton = _buttons[index];
		var buttonChildIndex:Int = indexOfChild(button);
		var panel:IDisplayObject = _panels[index];
		
		if (panel != null) {
			var transition:String = Toolkit.getTransitionForClass(Accordion);
			if (transition == "slide") {
				var c:Component = cast(panel, Component);
				c.percentHeight = -1;
				c.clipHeight = c.height;
				Actuate.tween(c, .2, { height: 0, clipHeight: 0 }, true).ease(Linear.easeNone).onComplete(function() {
					c.clearClip();
					panel.percentHeight = 100;
					unselectButton(button);
					panel.visible = false;
				});
			} else if (transition == "fade") {
				unselectButton(button);
				panel.visible = false;
			} else {
				unselectButton(button);
				panel.visible = false;
			}
			
			if (selectedIndex == index) {
				// selected index is none.
				_selectedIndex = -1;
			}
		}
	}
	
	/** Unselects button without triggering hidePanel() */
	private function unselectButton(button:Button) {
		button.allowSelection = false;
		button.selected = false;
		button.allowSelection = true;
	}
	
}

private class AccordionButton extends Button {
	public function new() {
		super();
	}
}