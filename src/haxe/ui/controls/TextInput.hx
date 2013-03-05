package haxe.ui.controls;

import nme.events.Event;
import nme.events.MouseEvent;
import nme.text.TextField;
import nme.text.TextFieldType;
import nme.text.TextFormat;
import haxe.ui.core.Component;
import haxe.ui.style.StyleManager;

class TextInput extends Component {
	private var vscroll:VScroll;
	
	private var rawText:String = ""; // cache the text as if you set it before the control is ready you lost font settings
	public var multiline:Bool = false;
	
	private var textControl:TextField;
	
	private var upStyle:Dynamic;
	private var overStyle:Dynamic;
	
	public function new() {
		super();
		registerState("over");
		addStyleName("TextInput");
		textControl = new TextField();
	}
	
	//************************************************************
	//                  OVERRIDES
	//************************************************************
	public override function initialize():Void {
		super.initialize();
		
		var format:TextFormat = new TextFormat(currentStyle.fontName, currentStyle.fontSize, currentStyle.color);
		textControl.defaultTextFormat = format;
		textControl.type = TextFieldType.INPUT;
		textControl.selectable = true;
		textControl.wordWrap = multiline;
		textControl.multiline = multiline;
		textControl.text = rawText;
		addChild(textControl);
		
		addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
		addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
		textControl.addEventListener(Event.CHANGE, onTextControlChange);
		textControl.addEventListener(Event.SCROLL, onTextControlScroll);

		
		//upStyle = StyleManager.mergeStyles(upStyle, StyleManager.getCascadedStyleFromId(styleName));
		//overStyle = StyleManager.mergeStyles(overStyle, StyleManager.getCascadedStyleFromId(styleName + ".over"));
		
		showStateStyle("normal");
		
		/*
		if (style.width != null && width == 0) {
			width = style.width;
		}
		if (style.height != null && height == 0) {
			height = style.height;
		}
		*/
	}

	public override function resize():Void {
		super.resize();
		sizeTextControl();
	}
	
	//************************************************************
	//                  EVENT HANDLERS
	//************************************************************
	private function onMouseOver(event:MouseEvent):Void {
		showStateStyle("over");
	}
	
	private function onMouseOut(event:MouseEvent):Void {
		showStateStyle("normal");
	}
	
	private function onVScrollChange(event:Event):Void {
		#if !html5
			textControl.scrollV = Std.int(vscroll.value);
		#end
	}
	
	private function onTextControlChange(event:Event):Void {
		sizeTextControl();
	}
	
	private function onTextControlScroll(event:Event):Void {
		sizeTextControl();
	}
	
	//************************************************************
	//                  GETTERS AND SETTERS
	//************************************************************
	public override function getText():String {
		return textControl.text;
	}
	
	public override function setText(value:String):String {
		rawText = value;
		if (ready == true) {
			textControl.text = value;
		}
		return value;
	}
	
	//************************************************************
	//                  HELPERS
	//************************************************************
	private function sizeTextControl():Void {
		textControl.x = padding.left;
		textControl.y = padding.top;
		if (width != 0) {
			textControl.width = width - (padding.left + padding.right);
		}
		if (height != 0) {
			textControl.height = height - (padding.top + padding.bottom);
		}
		
		if (multiline == true && textControl.textHeight > innerHeight) {
			if (vscroll == null) {
				vscroll = new VScroll();
				vscroll.percentHeight = 100;
				vscroll.horizontalAlign = "right";
				vscroll.addEventListener(Event.CHANGE, onVScrollChange);
				vscroll.incrementSize = 1;
				addChild(vscroll);
			}

			#if !html5
				vscroll.min = 1;
				vscroll.max = textControl.maxScrollV;
				vscroll.pageSize = (textControl.numLines - textControl.maxScrollV) / textControl.maxScrollV * textControl.maxScrollV;  //TODO: page size is wrong
				vscroll.value = textControl.scrollV;
				vscroll.visible = true;
				textControl.width -= vscroll.width;
			#end
		}
		
	}
	
	/*
	private function showState(state:String):Void {
		if (state == "up") {
			style = upStyle;
			var format:TextFormat = new TextFormat(style.fontName, style.fontSize, style.color);
			textControl.setTextFormat(format);
		} else if (state == "over") {
			style = overStyle;
			var format:TextFormat = new TextFormat(style.fontName, style.fontSize, style.color);
			textControl.setTextFormat(format);
		}
	}
	*/
}