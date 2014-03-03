package haxe.ui.toolkit.containers;

import flash.events.Event;
import flash.geom.Rectangle;
import haxe.ui.toolkit.core.Component;
import haxe.ui.toolkit.core.interfaces.IDisplayObject;
import haxe.ui.toolkit.core.interfaces.InvalidationFlag;
import haxe.ui.toolkit.core.Toolkit;
import motion.Actuate;
import motion.easing.Linear;

class Stack extends Component {
	#if !html5
	private var _selectedIndex:Int = 0;
	#else
	private var _selectedIndex:Int = -1;
	#end
	
	//private var _transition:String = "slide";
	
	public function new() {
		super();
		_clipContent = true;
	}
	
	//******************************************************************************************
	// Overrides
	//******************************************************************************************
	public override function addChild(child:IDisplayObject):IDisplayObject {
		var r = super.addChild(child);
		r.visible = (children.length - 1 == _selectedIndex);
		r.sprite.alpha = 1;
		return r;
	}
	
	//******************************************************************************************
	// Getters/setters
	//******************************************************************************************
	public var selectedIndex(get, set):Int;
	
	private function get_selectedIndex():Int {
		return _selectedIndex;
	}
	
	private function set_selectedIndex(value:Int):Int {
		if (value != _selectedIndex) {
			var transition:String = Toolkit.getTransitionForClass(Stack);
			transition = "none";
			for (n in 0...children.length) {
				var item:IDisplayObject = children[n];
				if (n == value) {
					if (transition == "slide") {
						if (value > _selectedIndex) {
							item.x = -item.width;
							item.sprite.alpha = 1;
							item.visible = true;
							Actuate.tween(item, .2, { x: this.layout.padding.left }, true).ease(Linear.easeNone).onComplete(function() {
							});
						} else {
							item.x = this.width;
							item.sprite.alpha = 1;
							item.visible = true;
							Actuate.tween(item, .2, { x: this.layout.padding.left }, true).ease(Linear.easeNone).onComplete(function() {
							});
						}
					} else if (transition == "fade") {
						item.x = this.layout.padding.left;
						item.sprite.alpha = 0;
						item.visible = true;
						Actuate.tween(item.sprite, .2, { alpha: 1 }, true).ease(Linear.easeNone).onComplete(function() {
						});
					} else {
						item.x = this.layout.padding.left;
						item.sprite.alpha = 1;
						item.visible = true;
					}
				} else {
					if (n == _selectedIndex) {
						if (transition == "slide") {
							item.sprite.alpha = 1;
							if (value > _selectedIndex) {
								Actuate.tween(item, .2, { x: this.width }, true).ease(Linear.easeNone).onComplete(function() {
									item.visible = false;
								});
							} else {
								Actuate.tween(item, .2, { x: -item.width }, true).ease(Linear.easeNone).onComplete(function() {
									item.visible = false;
								});
							}
						} else if (transition == "fade") {
							item.x = this.layout.padding.left;
							Actuate.tween(item.sprite, .2, { alpha: 0 }, true).ease(Linear.easeNone).onComplete(function() {
								item.visible = false;
							});
						} else {
							item.x = this.layout.padding.left;
							item.sprite.alpha = 1;
							item.visible = false;
						}
					}
				}
			}
			_selectedIndex = value;
			
			var event:Event = new Event(Event.CHANGE);
			dispatchEvent(event);
		}
		return value;
	}
}