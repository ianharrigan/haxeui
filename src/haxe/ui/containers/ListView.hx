package haxe.ui.containers;

import nme.Assets;
import nme.display.Bitmap;
import nme.display.DisplayObject;
import nme.events.Event;
import nme.events.MouseEvent;
import nme.media.Sound;
import nme.media.SoundChannel;
import haxe.ui.controls.Button;
import haxe.ui.controls.Label;
import haxe.ui.controls.ProgressBar;
import haxe.ui.controls.RatingControl;
import haxe.ui.core.Component;
import haxe.ui.style.StyleManager;

class ListView extends ScrollView {
	private var items:Array<ListViewItem>;
	public var selectedIndex(default, setSelectedIndex):Int = -1;

	public var listSize(getListSize, null):Int;
	public var itemHeight(getItemHeight, null):Float;

	public function new() {
		super();
		addStyleName("ListView");
		
		items = new Array<ListViewItem>();
		
		viewContent = new VBox();
		viewContent.percentWidth = 100;
		viewContent.addStyleName("ListView.content");
	}

	public override function initialize():Void {
		super.initialize();
		
		if (id != null) {
			viewContent.id = id + ".content";
		}
	}
	
	//************************************************************
	//                  LIST FUNCTIONS
	//************************************************************
	private function mouseOverItem(index:Int):Void {
		var listItem:ListViewItem = items[index];
		if (index != selectedIndex) {
			listItem.showStateStyle("over");
		}
	}
	
	private function mouseOutItem(index:Int):Void {
		var listItem:ListViewItem = items[index];
		if (index == selectedIndex) {
			listItem.showStateStyle("selected");
		} else {
			listItem.showStateStyle("normal");
		}
	}

	private function mouseClickItem(index:Int, e:MouseEvent):Void {
		var item:ListViewItem = items[index];
		var allowSelection:Bool = true;
		var testX:Float = e.stageX;
		var testY:Float = e.stageY;
		if (hscroll != null) {
			testX += hscroll.value;
		}
		if (vscroll != null) {
			testY += vscroll.value;
		}
		if (item.typeComponent != null && item.typeComponent.hitTest(testX, testY) == true) {
			allowSelection = false;
		}
		
		if (allowSelection) {
			selectedIndex = index;
			var changeEvent:Event = new Event(Event.CHANGE);
			dispatchEvent(changeEvent);
		}
	}
	
	public function removeItem(index:Int):Void {
		var listItem:ListViewItem = items[index];
		if (listItem != null) {
			if (index == selectedIndex) {
				selectedIndex = -1;
			}
			items.remove(listItem);
			viewContent.removeChild(listItem);
			if (ready) {
				invalidate(false); // TODO: this should probably happen automatically
			}
			
			// reset mouse events
			for (n in 0...items.length) {
				items[n].removeEventListenerType(MouseEvent.MOUSE_OVER);
				items[n].removeEventListenerType(MouseEvent.MOUSE_OUT);
				items[n].removeEventListenerType(MouseEvent.CLICK);
				items[n].addEventListener(MouseEvent.MOUSE_OVER, buildMouseOverFunction(n));
				items[n].addEventListener(MouseEvent.MOUSE_OUT, buildMouseOutFunction(n));
				items[n].addEventListener(MouseEvent.CLICK, buildMouseClickFunction(n));
			}
		}
	}
	
	public function addItem(item:Dynamic, additionalStyleNames:String = null):Component {
		var itemData:Dynamic = { };
		if (Std.is(item, String)) {
			var itemString:String = cast(item, String);
			item = { };
			item.text = itemString;
		}
		itemData.text = (item.text != null) ? item.text : "";
		itemData.subtext = (item.subtext != null) ? item.subtext : null;
		itemData.enabled = (item.enabled != null) ? item.enabled : true;
		itemData.type = (item.type != null) ? item.type : null;
		itemData.value = (item.value != null) ? item.value : null;
		itemData.fn = (item.fn != null) ? item.fn : null;
		
		var c:ListViewItem = new ListViewItem(this);
		if (additionalStyleNames != null) {
			c.addStyleName(additionalStyleNames);
		}
		c.percentWidth = 100;
		c.itemData = itemData;
		c.enabled = itemData.enabled;
		viewContent.addChild(c);
		items.push(c);
		if (ready) {
			invalidate(false); // TODO: this should probably happen automatically
		}
		
		c.addEventListener(MouseEvent.MOUSE_OVER, buildMouseOverFunction(items.length-1));
		c.addEventListener(MouseEvent.MOUSE_OUT, buildMouseOutFunction(items.length-1));
		c.addEventListener(MouseEvent.CLICK, buildMouseClickFunction(items.length-1));
		
		return c;
	}

	public function getListItem(index:Int):ListViewItem {
		return items[index];
	}
	
	public function buildMouseOverFunction(index:Int) {
		return function(event:MouseEvent) { mouseOverItem(index); };
	}

	public function buildMouseOutFunction(index:Int) {
		return function(event:MouseEvent) { mouseOutItem(index); };
	}

	public function buildMouseClickFunction(index:Int) {
		return function(event:MouseEvent) { mouseClickItem(index, event); };
	}
	
	//************************************************************
	//                  GETTERS AND SETTERS
	//************************************************************
	public function getListSize():Int {
		return items.length;
	}
	
	public function getItemHeight():Float {
		if (items.length == 0) {
			return 0;
		}
		
		return items[0].height;
	}
	
	public function setSelectedIndex(value:Int):Int {
		if (selectedIndex != -1) {
			items[selectedIndex].showStateStyle("normal");
		}
		selectedIndex = value;
		if (selectedIndex > -1) {
			var listItem:ListViewItem = items[value];
			listItem.showStateStyle("selected");
		}
		return value;
	}
}

//************************************************************
//                  CHILD CLASSES
//************************************************************
class ListViewItem extends Component {
	public var itemData:Dynamic;
	
	private var textComponent:Label;
	private var subTextComponent:Label;
	private var iconComponent:DisplayObject;
	
	private var parentList:ListView;
	
	public var subtext(getSubText, setSubText):String;
	
	private var currentIconAsset:String;
	
	public var typeComponent:Component;
	
	public function new(parentList:ListView) {
		this.parentList = parentList;
		super();
		inheritStylesFrom = "ListView";
		
		registerState("over");
		registerState("selected");
		for (s in parentList.styleString.split(" ")) {
			if (s != " " && s != "") {
				addStyleName(s + ".item");
			}
		}
	}

	public override function initialize():Void {
		super.initialize();
		
		if (itemData.text != null) {
			textComponent = new Label();
			textComponent.registerState("over");
			textComponent.registerState("selected");
			for (s in parentList.styleString.split(" ")) {
				if (s != " ") {
					textComponent.addStyleName(s + ".item.text");
				}
			}
			if (parentList.id != null) {
				textComponent.id = id + ".item.text";
			}
			textComponent.text = itemData.text;
			textComponent.percentWidth = 100;
			addChild(textComponent);
		}

		if (itemData.subtext != null) {
			subTextComponent = new Label();
			subTextComponent.registerState("over");
			subTextComponent.registerState("selected");
			for (s in parentList.styleString.split(" ")) {
				if (s != " ") {
					subTextComponent.addStyleName(s + ".item.subtext");
				}
			}
			if (parentList.id != null) {
				textComponent.id = id + ".subtext";
			}
			subTextComponent.text = itemData.subtext;
			subTextComponent.percentWidth = 100;
			addChild(subTextComponent);
		}
		
		var icon:String = currentStyle.icon;
		if (icon != null) {
			iconComponent = new Bitmap(Assets.getBitmapData(icon));
			if (iconComponent != null) {
				currentIconAsset = icon;
				addChild(iconComponent);
			}
		}

		if (itemData.type != null) {
			if (itemData.type == "button") {
				var button:Button = new Button();
				button.text = itemData.value;
				button.addEventListener(MouseEvent.CLICK, itemData.fn);
				typeComponent = button;
			} else if (itemData.type == "progress") {
				var progress:ProgressBar = new ProgressBar();
				progress.value = itemData.value;
				typeComponent = progress;
			} else if (itemData.type == "rating") {
				var rating:RatingControl = new RatingControl();
				rating.rating = itemData.value;
				typeComponent = rating;
			}
			
			if (typeComponent != null) {
				typeComponent.verticalAlign = "center";
				typeComponent.horizontalAlign = "farRight";
				addChild(typeComponent);
			}
		}
		
		// calculate new height
		var totalHeight:Float = 0;
		if (textComponent != null) {
			totalHeight += textComponent.height;
		}
		if (subTextComponent != null) {
			totalHeight += subTextComponent.height;
		}
		if (typeComponent != null) {
			totalHeight = Math.max(totalHeight, typeComponent.height);
		}

		var newHeight = height;
		if (totalHeight > innerHeight) {
			newHeight = totalHeight + padding.top + padding.bottom;
		}
		
		this.height = newHeight;
	}
	
	public override function showStateStyle(stateName:String):Void {
		super.showStateStyle(stateName);
		
		if (textComponent != null) {
			textComponent.showStateStyle(stateName);
		}
		if (subTextComponent != null) {
			subTextComponent.showStateStyle(stateName);
		}
		
		if (currentStyle.icon != null && currentStyle.icon != currentIconAsset) {
			if (iconComponent != null) {
				removeChild(iconComponent);
			}
			iconComponent = new Bitmap(Assets.getBitmapData(currentStyle.icon));
			if (iconComponent != null) {
				currentIconAsset = currentStyle.icon;
				addChild(iconComponent);
			}
		}
	}
	
	public override function getText():String {
		return textComponent.text;
	}
	
	public override function setText(value:String):String {
		textComponent.text = value;
		return value;
	}

	public function getSubText():String {
		if (subTextComponent == null) {
			return "";
		}
		return subTextComponent.text;
	}
	
	public function setSubText(value:String):String {
		subTextComponent.text = value;
		return value;
	}
	
	private override function repositionChildren():Void {
		var iconPosition:String = "left";
		if (currentStyle.iconPosition != null) {
			iconPosition = currentStyle.iconPosition;
		}

		var contentHeight:Float = 0;
		if (textComponent != null) {
			contentHeight += textComponent.height;
		}
		if (subTextComponent != null) {
			contentHeight += subTextComponent.height;
		}
		
		
		var ypos = Std.int((innerHeight / 2) - (contentHeight / 2));
		if (textComponent != null) {
			textComponent.y = ypos;
			if (iconComponent != null && iconPosition == "left") {
				textComponent.x = iconComponent.width;
			}
		}
		if (subTextComponent != null) {
			subTextComponent.x = textComponent.x;
			subTextComponent.y = ypos + textComponent.height;
		}
		
		if (iconComponent != null) {
			if (iconPosition == "farRight") {
				iconComponent.x = width - iconComponent.width - padding.right;
			} else {
				iconComponent.x = padding.right;
			}
			
			if (subTextComponent == null) {
				iconComponent.y = Std.int((height / 2) - (iconComponent.height / 2));
			} else {
				iconComponent.y = padding.top;
			}
			
		}
		
		if (typeComponent != null) {
			if (typeComponent.horizontalAlign == "farRight") {
				typeComponent.x = innerWidth - typeComponent.width;
			}
			
			if (typeComponent.verticalAlign == "top") {
				typeComponent.y = textComponent.y;
			}else if (typeComponent.verticalAlign == "center") {
				typeComponent.y = Std.int((innerHeight / 2) - (typeComponent.height / 2));
			}
		}
	}
}
