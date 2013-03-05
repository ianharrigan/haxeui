package haxe.ui.controls;

import nme.Assets;
import nme.display.Bitmap;
import nme.display.BitmapData;
import nme.display.Sprite;
import nme.events.MouseEvent;
import nme.display.DisplayObject;
import nme.geom.Point;
import nme.geom.Rectangle;
import haxe.ui.core.Component;
import haxe.ui.style.StyleHelper;
import haxe.ui.style.StyleManager;

class Button extends Component {
	private var rawText:String = "";
	public var toggle:Bool = false;
	public var selected(default, setSelected):Bool = false;
	
	private var label:Label;
	
	private var mouseDown:Bool = false;
	
	public var allowSelection:Bool = true;
	
	public function new() {
		super();
		registerState("over");
		registerState("down");
		addStyleName("Button");
	}
	
	//************************************************************
	//                  OVERRIDES
	//************************************************************
	public override function applyStyle():Void {
		super.applyStyle();
		
		label.currentStyle = currentStyle;
		label.applyStyle();

		var iconPosition:String = "left";
		if (currentStyle.iconPosition != null) {
			iconPosition = currentStyle.iconPosition;
		}
		
		repositionLabel();
		if (currentStyle.icon != null) {
			var bitmapData:BitmapData = Assets.getBitmapData(currentStyle.icon);
			if (bitmapData != null) {
				var lcx:Float = 0;
				var lcy:Float = 0;
				if (iconPosition == "left" || iconPosition == "right" || iconPosition == "farRight") {
					var requiredWidth:Float = label.width + (bitmapData.width * 2) + (spacingX * 2) + (padding.left + padding.right);
					if (innerWidth < requiredWidth && autoSize == true) {
						width = Std.int(requiredWidth);
					}
				} else if (iconPosition == "top") {
					var requiredHeight:Float = label.height + bitmapData.height + spacingY + (padding.top + padding.bottom);
					if (innerHeight < requiredHeight && autoSize == true) {
						height = Std.int(requiredHeight);
					}
				}

				
				var iconX:Float = 0;
				var iconY:Float = 0;
				if (label.text.length == 0) {
					iconX = (this.innerWidth / 2) - ((bitmapData.width) / 2) + padding.left;
					iconY = (this.innerHeight / 2) - ((bitmapData.height) / 2) + padding.top;
				} else {
					if (iconPosition == "left") {
						iconX = label.x - bitmapData.width + padding.left - spacingX;
						iconY = (this.innerHeight / 2) - ((bitmapData.height) / 2) + padding.top;
					} else if (iconPosition == "right") {
						iconX = label.x + label.width + padding.left + spacingX;
						iconY = (this.innerHeight / 2) - ((bitmapData.height) / 2) + padding.top;
					} else if (iconPosition == "farRight") {
						iconX = this.width - padding.right - bitmapData.width;
						iconY = (this.innerHeight / 2) - ((bitmapData.height) / 2) + padding.top;
					} else if (iconPosition == "top") {
						var combinedHeight:Float = label.height + bitmapData.height + spacingY;
						
						iconX = (this.innerWidth / 2) - ((bitmapData.width) / 2) + padding.left;
						iconY = (this.innerHeight / 2) - ((combinedHeight) / 2) + padding.top;
						
						label.y = iconY + bitmapData.height - padding.top;
					}
				}

				var srcRect:Rectangle = new Rectangle(0, 0, bitmapData.width, bitmapData.height);
				var dstRect:Rectangle = new Rectangle(Std.int(iconX), Std.int(iconY), bitmapData.width, bitmapData.height);
				StyleHelper.paintBitmapSection(sprite.graphics, currentStyle.icon, srcRect, dstRect);
			}
		}
	}
	
	public override function initialize():Void {
		super.initialize();

		addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
		addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
		addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		//addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		addEventListener(MouseEvent.CLICK, onClick);
		
		label = new Label();
		if (this.id != null) {
			label.id = this.id;
		}
		label.text = rawText;
		addChild(label);
		
		sprite.useHandCursor = true;
		sprite.buttonMode = true;

		if (toggle == false || selected == false) {
			showStateStyle("normal");
		} else {
			showStateStyle("down");
		}
	}

	//************************************************************
	//                  EVENT HANDLERS
	//************************************************************
	private function onMouseOver(event:MouseEvent):Void {
		if (mouseDown == false) {
			if (toggle == false || selected == false) {
				showStateStyle("over");
			}
		}
	}

	private function onMouseOut(event:MouseEvent):Void {
		if (mouseDown == true) {
			return;
		}
		
		if (toggle == false || selected == false) {
			showStateStyle("normal");
		} else {
			showStateStyle("down");
		}
	}

	private function onMouseDown(event:MouseEvent):Void {
		mouseDown = true;
		root.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		showStateStyle("down");
	}

	private function onMouseUp(event:MouseEvent):Void {
		mouseDown = false;
		root.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		if (hitTest(event.stageX, event.stageY) == true && selected == false) {
			if (hasStateSyle("over")) {
				showStateStyle("over");
			} else {
				showStateStyle("normal");
			}
		} else if (selected == false) {
			showStateStyle("normal");
		}
	}
	
	private function onClick(event:MouseEvent):Void {
		if (toggle == true && allowSelection == true) {
			selected = !selected;
		}
	}
	
	//************************************************************
	//                  GETTERS AND SETTERS
	//************************************************************
	public function setSelected(value:Bool):Bool {
		selected = value;
		if (toggle == true) {
			if (ready == true) {
				if (value == true) {
					showStateStyle("down");
				} else {
					showStateStyle("normal");
				}
			}
		}
		return value;
	}

	public override function getText():String {
		return label.text;
	}
	
	public override function setText(value:String):String {
		rawText = value;
		if (ready) {
			label.text = value;
		}
		return value;
	}
	
	//************************************************************
	//                  HELPERS
	//************************************************************
	private function repositionLabel():Void {
		var textPosition:String = "center";
		if (currentStyle.textPosition != null) {
			textPosition = currentStyle.textPosition;
		}
		if (label != null) {
			var labelX:Float = (this.innerWidth / 2) - (label.width / 2);
			var labelY:Float = (this.innerHeight / 2) - ((label.height) / 2);
			
			if (textPosition == "left") {
				labelX = 0;
			}
			
			label.x = labelX;
			label.y = labelY;
		}
	}
}