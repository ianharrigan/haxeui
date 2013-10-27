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
	
	//private var _transition:String = "slide";
	
	public function new() {
		super();
		_autoSize = false;
		_panels = new Array<IDisplayObject>();
		_buttons = new Array<AccordionButton>();
	}
	
	//******************************************************************************************
	// Overrides
	//******************************************************************************************
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
			child.percentHeight = 100;
			child.percentWidth = 100;
			_panels.push(child);
			
			var button:AccordionButton = new AccordionButton();
			if (Std.is(child, Component)) {
				button.text = cast(child, Component).text;
			}
			button.percentWidth = 100;
			button.toggle = true;
			button.allowSelection = false;
			button.addEventListener(MouseEvent.CLICK, buildMouseClickFunction(_panels.length - 1));
			
			addChild(button);
			_buttons.push(button);
		}
		return r;
	}

	//******************************************************************************************
	// Helpers
	//******************************************************************************************
	private function buildMouseClickFunction(index:Int) {
		return function(event:MouseEvent) { mouseClickButton(index); };
	}
	
	private function mouseClickButton(index:Int):Void {
		var button:AccordionButton = _buttons[index];
		for (b in _buttons) {
			if (b == button) {
				if (b.selected == false) {
					showPanel(index);
				} else {
					hidePanel(index);
				}
			}
		}
	}
	
	private function showPanel(index:Int):Void {
		var button:AccordionButton = _buttons[index];
		var buttonChildIndex:Int = indexOfChild(button);
		var panel:IDisplayObject = _panels[index];
		
		if (panel != null) {
			panel.visible = false;
			if (panel.ready == false) {
				cast(panel, IEventDispatcher).addEventListener(UIEvent.INIT, _onPanelAdded);
			} else {
				cast(panel, IEventDispatcher).addEventListener(UIEvent.ADDED_TO_STAGE, _onPanelAdded);
			}
			super.addChildAt(panel, buttonChildIndex + 1);
			button.selected = true;
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
					invalidate(InvalidationFlag.SIZE);
					button.selected = false;
					removeChild(panel, false);
				});
			} else if (transition == "fade") {
				removeChild(panel, false);
				button.selected = false;
			} else {
				removeChild(panel, false);
				button.selected = false;
			}
		}
	}
	
	private function _onPanelAdded(event:Event):Void {
		var panel:IDisplayObject = findPanelFromSprite(event.target);
		cast(panel, IEventDispatcher).removeEventListener(UIEvent.ADDED_TO_STAGE, _onPanelAdded);
		cast(panel, IEventDispatcher).removeEventListener(UIEvent.INIT, _onPanelAdded);
		var panelIndex:Int = Lambda.indexOf(_panels, panel);
		var button:Button = _buttons[panelIndex];
	
		var panelToHide:Component = null;
		var buttonToHide:AccordionButton = null;
		for (b in _buttons) {
			if (b != button && b.selected == true) {
				buttonToHide = b;
				var tempIndex:Int = Lambda.indexOf(_buttons, b);
				panelToHide = cast(_panels[tempIndex], Component);
				break;
			}
		}
		
		var transition:String = Toolkit.getTransitionForClass(Accordion);
		if (transition == "slide") {
			var c:Component = cast(panel, Component);
			invalidate(InvalidationFlag.SIZE);
			c.percentHeight = -1;
			var ucy:Float = c.height;
			c.width = _layout.usableWidth;
			c.height = 0;
			c.clipHeight = 0;
			c.visible = true;
			
			Actuate.tween(c, .2, { height: ucy, clipHeight: ucy }, true).ease(Linear.easeNone).onComplete(function() {
				c.clearClip();
				c.percentHeight = 100;
				invalidate(InvalidationFlag.SIZE);
				if (buttonToHide != null) {
					buttonToHide.selected = false;
					removeChild(panelToHide, false);
				}
			}).onUpdate(function() {
				if (panelToHide != null) {
					panelToHide.height = ucy - c.height;
					panelToHide.clipHeight = panelToHide.height;
				}
			});
		} else if (transition == "fade") {
			panel.sprite.alpha = 0;
			panel.visible = true;
			Actuate.tween(panel.sprite, .2, { alpha: 1 }, true).ease(Linear.easeNone).onComplete(function() {
			});
			if (panelToHide != null) {
				removeChild(panelToHide, false);
				buttonToHide.selected = false;
			}
		} else {
			panel.visible = true;
			if (panelToHide != null) {
				removeChild(panelToHide, false);
				buttonToHide.selected = false;
			}
		}
	}
	
	private function findPanelFromSprite(s:Sprite):IDisplayObject {
		var panel:IDisplayObject = null;
		for (p in _panels) {
			if (p.sprite == s) {
				panel = p;
				break;
			}
		}
		return panel;
	}
}

private class AccordionButton extends Button {
	public function new() {
		super();
	}
}