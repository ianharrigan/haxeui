package haxe.ui.controls;

import nme.events.Event;
import nme.events.MouseEvent;
import haxe.ui.containers.HBox;
import haxe.ui.core.Component;

class RatingControl extends HBox {
	private var valueControls:Array<ValueControl>;
	
	public var rating(getRating, setRating):Int;
	
	public var max:Int = 5;
	
	public function new() {
		super();
		
		valueControls = new Array<ValueControl>();
	}
	
	//************************************************************
	//                  OVERRIDES
	//************************************************************
	public override function initialize():Void {
		super.initialize();
		
		for (n in 0...max) {
			var vc:ValueControl = new ValueControl();
			
			vc.verticalAlign = "center";
			vc.addValue("unselected");
			vc.addValue("selected");
			vc.value = "unselected";
			vc.interactive = false;
			vc.sprite.useHandCursor = true;
			vc.sprite.buttonMode = true;
		
			vc.addEventListener(MouseEvent.MOUSE_OVER, buildMouseOverFunction(n));
			vc.addEventListener(MouseEvent.MOUSE_OUT, onMouseOutItem);
			vc.addEventListener(MouseEvent.CLICK, buildMouseClickFunction(n));
			
			valueControls.push(vc);
			addChild(vc);
		}
		
		rating = rating;
	}	

	private function onMouseOutItem(event:MouseEvent):Void {
		for (vc in valueControls) {
			vc.state = "normal";
		}
	}
	
	private function buildMouseOverFunction(index:Int) {
		return function(event:MouseEvent) { mouseOverItem(index); };
	}

	private function buildMouseClickFunction(index:Int) {
		return function(event:MouseEvent) { mouseClickItem(index); };
	}

	private function mouseOverItem(index:Int):Void {
		for (n in 0...valueControls.length) {
			var vc:ValueControl = valueControls[n];
			if (n < index) {
				vc.state = "over";
			} else {
				vc.state = "normal";
			}
		}
	}

	private function mouseClickItem(index:Int):Void {
		rating = index + 1;
	}
	//************************************************************
	//                  GETTERS/SETTERS
	//************************************************************
	public function getRating():Int {
		return rating;
	}
	
	public function setRating(value:Int):Int {
		rating = value;
		for (n in 0...valueControls.length) {
			var vc:ValueControl = valueControls[n];
			if (n < value) {
				vc.value = "selected";
			} else {
				vc.value = "unselected";
			}
		}
		if (ready) {
			dispatchEvent(new Event(Event.CHANGE));
		}
		return value;
	}
}