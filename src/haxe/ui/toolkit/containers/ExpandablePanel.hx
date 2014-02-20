package haxe.ui.toolkit.containers;
import flash.events.Event;
import flash.events.MouseEvent;
import haxe.ui.toolkit.containers.ExpandablePanel;
import haxe.ui.toolkit.containers.VBox;
import haxe.ui.toolkit.controls.Button;
import haxe.ui.toolkit.core.Component;
import haxe.ui.toolkit.core.interfaces.IDisplayObject;
import haxe.ui.toolkit.core.interfaces.InvalidationFlag;
import haxe.ui.toolkit.core.Toolkit;
import haxe.ui.toolkit.events.UIEvent;
import motion.Actuate;
import motion.easing.Linear;

/**
 * @author TiagoLr
 * @link https://github.com/ProG4mr
 */
class ExpandablePanel extends VBox {

	var _button:ExpandableButton;
	var _panel:VBox;
	
	var startExpanded:Bool = true;
	
	public function new() {
		super();
	}
	
	override private function initialize():Void {
		super.initialize();
	}
	
	public override function addChild(child:IDisplayObject):IDisplayObject {
		
		if (_button == null) {
			_button = new ExpandableButton();
			_button.percentWidth = 100;
			_button.text = this.text;
			_button.toggle = true;
			_button.selected = startExpanded ? true : false;
			_button.addEventListener(UIEvent.CHANGE, onClickButton);
			_button.styleName = "expandable";
			super.addChild(_button);
		} 
		
		if (_panel == null) {
			_panel = new VBox();
			_panel.id = "content";
			_panel.percentWidth = 100; 
			super.addChild(_panel);
			_panel.addEventListener(Event.ADDED_TO_STAGE, panelAdded);
		}
		
		
		
		return _panel.addChild(child);
	}
	
	private function onClickButton(e:UIEvent):Void {
		if (_button.selected) {
			showPanel();
		} else {
			hidePanel();
		}
	}
	
	private function panelAdded(e:Event):Void {
		removeEventListener(Event.ADDED_TO_STAGE, panelAdded);
		
		if (!startExpanded) {
			_panel.visible = false;
		}
	}
	
	public function showPanel() {
		
		var transition:String = Toolkit.getTransitionForClass(ExpandablePanel);
		if (transition == "slide") {
			
			var startH = _panel.height; 
			_panel.invalidate(InvalidationFlag.SIZE); // reset panel height.
			var finalH = _panel.height; // final height.
			
			_panel.visible = true;
			
			Reflect.setField(_panel, "_height", startH);
			_panel.clipHeight = startH;
			Actuate.tween(_panel, .2, { _height:finalH, clipHeight:finalH }, true).ease(Linear.easeNone)
							.onUpdate(function() { invalidate(InvalidationFlag.SIZE); } );
							
		} else {
			_panel.visible = true;
		}
		
	}
	
	public function hidePanel() {
		
		var transition:String = Toolkit.getTransitionForClass(ExpandablePanel);
		if (transition == "slide") {
			Actuate.tween(_panel, .2, { _height: 0, clipHeight:0 }, true).ease(Linear.easeNone)
							.onUpdate(function() { invalidate(InvalidationFlag.SIZE); } )
							.onComplete(function() { _panel.visible = false; } );
		} else {
			_panel.visible = false;
		}
	}
}

private class ExpandableButton extends Button {
	public function new () {
		super();
	}
}