package haxe.ui;

#if !doc

import motion.Actuate;
import motion.easing.Linear;
import openfl.display.Sprite;
import openfl.events.Event;

class HaxeUIPreloader extends NMEPreloader {
	private var _outline:Sprite;
	private var _bar:Sprite;
	
	public function new() {
		super();
		this.removeChild(progress);
		this.removeChild(outline);
		
		_outline = new Sprite();
		_outline.graphics.lineStyle (1, getOutlineColor(), 1, true);
		_outline.graphics.drawRoundRect (.5, .5, getPreloaderWidth() - .5, getPreloaderHeight() - .5, getCornerRadius(), getCornerRadius());
		_outline.x = (getWidth() / 2) - (getPreloaderWidth() / 2);
		_outline.y = (getHeight() / 2) - (getPreloaderHeight() / 2);
		addChild (_outline);
		
		_bar = new Sprite();
		_bar.x = _outline.x + 2;
		_bar.y = _outline.y + 2;
		addChild (_bar);
	}
	
	private function getOutlineColor():Int {
		return 0x999999;
	}

	private function getBarColor():Int {
		return 0x999999;
	}
	
	private function getPreloaderWidth():Float {
		return 100;
	}
	
	private function getPreloaderHeight():Float {
		return 11;
	}
	
	public override function getHeight():Float {
		return flash.Lib.current.stage.stageHeight;
	}
	
	public override function getWidth():Float {
		return flash.Lib.current.stage.stageWidth;
	}
	
	private function getCornerRadius():Float {
		return 0;
	}

	private function getAllowFade():Bool {
		return false;
	}
	
	/*
	public override function onInit() {
		trace("onInit");
	}
	*/
	
	public override function onLoaded() {
		if (getAllowFade() == true) {
			Actuate.tween(this, .5, { alpha: 0 } ).ease(Linear.easeNone).onComplete(function() {
				dispatchEvent(new Event(Event.COMPLETE));
			});
		} else {
			dispatchEvent(new Event(Event.COMPLETE));
		}
	}
	
	public override function onUpdate(bytesLoaded:Int, bytesTotal:Int) {
		var percentLoaded = (bytesLoaded / bytesTotal) * 100;
		drawBarPercent(percentLoaded);
	}
	
	private function drawBarPercent(percent:Float):Void {
		//percent = 100;
		var cx = ((getPreloaderWidth() - 4) * percent) / 100;
		_bar.graphics.clear();
		_bar.graphics.beginFill(getBarColor());
		_bar.graphics.drawRect(0, 0, cx, getPreloaderHeight() - 4);
		_bar.graphics.endFill();
	}
}

#end