package haxe.ui.toolkit.containers;

import haxe.ui.toolkit.controls.Button;
import haxe.ui.toolkit.core.Component;
import haxe.ui.toolkit.core.interfaces.IClonable;
import haxe.ui.toolkit.core.interfaces.IDisplayObject;
import haxe.ui.toolkit.core.interfaces.IDisplayObjectContainer;
import haxe.ui.toolkit.core.StyleableDisplayObject;
import haxe.ui.toolkit.core.Toolkit;
import haxe.ui.toolkit.events.UIEvent;
import motion.Actuate;
import motion.easing.Linear;

/**
 Basic, animated accordion container
 **/
class Accordion extends VBox implements IClonable<Accordion> {
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
			button.userData = _panels.length - 1;
			button.addEventListener(UIEvent.CLICK, _onButtonClick);
			_buttons.push(button);
			
			addChild(button);
			child.visible = false;
			r = super.addChild(child);
		}
		return r;
	}

	public override function removeChild(child:IDisplayObject, dispose:Bool = true):IDisplayObject {
		if (Std.is(child, AccordionButton)) {
			_buttons.remove(cast child);
		} else {
			_panels.remove(child);
		}
		return super.removeChild(child, dispose);
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
	
	private function _onButtonClick(event:UIEvent):Void {
		var index:Int = event.component.userData;
		showPanel(index);
		dispatchEvent(new UIEvent(UIEvent.CHANGE));
	}
	
	private function showPanel(index:Int):Void {
		var button:AccordionButton = _buttons[index];
		var panel:Component = cast _panels[index];

		var buttonOld:AccordionButton = null;
		var panelOld:Component = null;
		var ucy:Float = layout.usableHeight;
		if (_selectedIndex > -1) {
			buttonOld = _buttons[_selectedIndex];
			panelOld = cast _panels[_selectedIndex];
			unselectButton(buttonOld);
		}
		
		var transition:String = Toolkit.getTransitionForClass(Accordion);
		if (transition == "slide") {
			panel.percentHeight = -1;
			panel.height = 0;
			panel.visible = true;
			Actuate.tween(panel, .2, { height: ucy, clipHeight: ucy }, true).ease(Linear.easeNone)
				.onComplete(function () {
					panel.clearClip();
					panel.percentHeight = 100;
					if (panelOld != null) {
						panelOld.visible = false;
						unselectButton(buttonOld);
					}
				}).onUpdate(function() {
					if (panelOld != null) {
						panelOld.height = ucy - panel.height;
						panelOld.clipHeight = panelOld.height;
					}
				});
		} else if (transition == "fade") {
			panel.sprite.alpha = 0;
			panel.visible = true;
			if (panelOld != null) {
				panelOld.visible = false;
			}
			Actuate.tween(panel.sprite, .2, { alpha: 1 }, true).ease(Linear.easeNone);
		} else {
			panel.visible = true;
			if (panelOld != null) {
				panelOld.visible = false;
			}
		}
		
		if (panelOld == panel) {
			_selectedIndex = -1;
		} else {
			_selectedIndex = index;
		}
	}
	
	/** Unselects button without triggering hidePanel() */
	private function unselectButton(button:Button) {
		button.allowSelection = false;
		button.selected = false;
		button.allowSelection = true;
	}
	
	//******************************************************************************************
	// Clone
	//******************************************************************************************
	public override function clone():Accordion {
		c.removeAllChildren();
		for (child in this.children) {
			if (Std.is(child, AccordionButton) == false) {
				c.addChild(child.clone());
			}
		}
	}
}

@exclude
class AccordionButton extends Button implements IClonable<AccordionButton> {
	public function new() {
		super();
	}
}