package haxe.ui.toolkit.style;

import openfl.filters.DropShadowFilter;
import openfl.Assets;

class DefaultStyles extends Styles {
	public function new() {
		super();

		var f = Assets.getFont("fonts/Oxygen.ttf");
		var fb = Assets.getFont("fonts/Oxygen-Bold.ttf");
		
		addStyle("Component", new Style( {
			padding: 0,
			backgroundColor: 0x888888,
		} ));
		
		addStyle("#modalOverlay", new Style( {
			backgroundColor: 0x888888,
			alpha: .7
		} ));
		
		addStyle("Text", new Style( {
			fontSize: 14,
			fontName: f.fontName,
			fontEmbedded: true,
			color: 0x444444
		} ));

		addStyle("Code", new Style( {
			fontSize: 14,
			fontName: "_sans",
			fontEmbedded: false,
			color: 0x444444,
		} ));
		
		addStyle("Container", new Style( {
			spacing: 5,
			backgroundColor: 0x888888,
		} ));
		
		addStyle("Accordion", new Style( {
			spacing: 0,
		} ));
		
		addStyle(".page", new Style( {
			padding: 5,
			backgroundColor: -2,
		} ));

		addStyle("Button", new Style( {
			fontSize: 14,
			fontName: f.fontName,
			fontEmbedded: true,
			
			backgroundColor: 0xffa84c,
			backgroundColorGradientEnd: 0xff7b0d,
			color: 0x222222,
			padding: 10,
			borderColor: 0x444444,
			borderSize: 1,
			cornerRadius: 2,
			filter: new DropShadowFilter(2, 45, 0x444444, 1, 2, 2, 1, 3),
			spacing: 5
		} ));
		
		
		addStyle("Button:over", new Style( {
			backgroundColor: 0xffb76b,
			backgroundColorGradientEnd: 0xff7f04,
			color: 0x222222,
		} ));
		
		addStyle("Button:down", new Style( {
			backgroundColor: 0xffa84c,
			backgroundColorGradientEnd: 0xff7b0d,
			color: 0x444444,
		} ));

		
		addStyle("Button.expandable", new Style( {
			icon: "styles/default/expand.png",
		} ));
		
		addStyle("Button.expandable:down", new Style( {
			icon: "styles/default/collapse.png",
		} ));
		
		addStyle("CheckBox, OptionBox", new Style( {
			spacingX: 2,
			fontSize: 14,
			fontName: f.fontName,
			fontEmbedded: true,
			color: 0x444444
		} ));

		addStyle("CheckBoxValue, OptionBoxValue", new Style( {
			width: 32,
			height: 32,
		} ));
		
		addStyle("CheckBoxValue #unselected", new Style( {
			iconPosition: "center",
		} ));

		addStyle("CheckBoxValue #unselected:disabled", new Style( {
		} ));

		addStyle("CheckBoxValue #selected", new Style( {
			icon: "styles/default/cross.png",
			iconPosition: "center",
		} ));

		addStyle("CheckBoxValue #selected:disabled", new Style( {
		} ));

		addStyle("OptionBoxValue #unselected", new Style( {
			iconPosition: "center",
		} ));

		addStyle("OptionBoxValue #unselected:disabled", new Style( {
		} ));

		addStyle("OptionBoxValue #selected", new Style( {
			icon: "styles/default/circle.png",
			iconPosition: "center",
		} ));

		addStyle("OptionBoxValue #selected:disabled", new Style( {
		} ));
		
		addStyle("TextInput", new Style( {
			backgroundColor: 0xFFFFFF,
			color: 0x222222,
			width: 150,
			height: 42,
			borderColor: 0x222222,
			borderSize: 1,
			padding: 2,
			cornerRadius: 2,
			filter: new DropShadowFilter(2, 45, 0xBFBFBF, 1, 2, 2, 1, 3, true),
			fontSize: 14,
			fontName: f.fontName,
			fontEmbedded: true,
		} ));

		addStyle("TextInput #placeholder", new Style( {
			color: 0xAAAAAA,
		} ));
		
		addStyle("ListSelector, DateSelector", new Style( {
			icon: "styles/default/up_down.png",
			iconPosition: "right",
			selectionMethod: "popup",
			textAlign: "left"
		} ));

		addStyle("CalendarView, Calendar", new Style( {
			width: 310,
			height: 310,
			spacing: 3,
			padding: 2,
			//autoSize: false,
		} ));

		addStyle("CalendarView", new Style( {
			backgroundColor: 0x888888,
			filter: new DropShadowFilter(1, 45, 0x222222, 1, 2, 2, 1, 3),
			borderColor: 0x444444,
			borderSize: 1,
			cornerRadius: 2,
			padding: 5,
			spacing: 5,
		} ));
		
		addStyle("CalendarView Calendar", new Style( {
			borderSize: 0,
		} ));
		
		addStyle("CalendarPopupContent", new Style( {
			padding: 50,
		} ));
		
		addStyle("CalendarDay", new Style( {
			padding: 0,
			backgroundColor: 0xcccccc,
			//borderSize: 0,
			//cornerRadius: 0,
			//filter: null,
		} ));
		
		addStyle("CalendarView #currentMonthYear", new Style( {
			textAlign: "center",
		} ));
		
		addStyle("Calendar #selectedDay", new Style( {
			fontSize: 14,
			fontName: f.fontName,
			fontEmbedded: true,
			
			backgroundColor: 0xffa84c,
			backgroundColorGradientEnd: 0xff7b0d,
			color: 0x222222,
			padding: 10,
			borderColor: 0x444444,
			borderSize: 1,
			cornerRadius: 2,
			filter: new DropShadowFilter(2, 45, 0x444444, 1, 2, 2, 1, 3),
			spacing: 5
		} ));
		
		
		addStyle("CalendarDay:over, Calendar #selectedDay:over", new Style( {
			backgroundColor: 0xffb76b,
			backgroundColorGradientEnd: 0xff7f04,
			color: 0x222222,
		} ));
		
		addStyle("CalendarDay:down, Calendar #selectedDay:down", new Style( {
			backgroundColor: 0xffa84c,
			backgroundColorGradientEnd: 0xff7b0d,
			color: 0x444444,
		} ));
		
		addStyle("TabView", new Style( {
			backgroundColor: 0xcccccc,
			borderColor: -1,
			filter: null,
			spacing: 0,
		} ));
		addStyle("TabView Container", new Style( {
			backgroundColor: 0xcccccc,
		} ));
		
		addStyle("TabBar", new Style( {
			backgroundColor: 0x888888,
			height: 41,
			paddingTop: 0,
			paddingLeft: 0,
			paddingRight: 0,
			paddingBottom: 0,
			cornerRadius: 0,
			filter: null,
			borderColor: -1,
			borderSize: 0,
			spacing:0,
		} ));
		addStyle("TabBar #content", new Style( {
			spacing: 1,
			borderColor: -1,
			backgroundColor: 0x888888,
		} ));
		addStyle("TabBar #container", new Style( {
			backgroundColor: 0x888888,
		} ));
		addStyle("TabBar Button", new Style( {
			height: 42,
			iconPosition: "left",
			cornerRadius: 0,
			autoSize: true,
			
			backgroundColor: 0xffa84c,
			backgroundColorGradientEnd: 0xff7b0d,
			color: 0x222222,
			
			borderSize: 0,
			borderColor: -1,
			paddingLeft: 20,
			paddingRight: 20
		} ));
		addStyle("TabBar Button:down", new Style( {
			backgroundColor: 0xeeeeee,
			backgroundColorGradientEnd: 0xcccccc,
			color: 0x444444,
		} ));
		
		addStyle("HProgress", new Style( {
			width: 150,
			height: 30,
			backgroundColor: 0x666666,
			borderColor: -1,
			padding: 2,
			cornerRadius: 2,
			borderSize: 0,
			filter: new DropShadowFilter(1, 45, 0x444444, 1, 2, 2, 1, 3, true),
		} ));
		
		addStyle("HProgress #background", new Style( {
			percentWidth: 100,
			percentHeight: 100,
			backgroundColor: -1,
			borderSize: 0,
			borderColor: -1,
		} ));
		
		addStyle("HProgress #value", new Style( {
			percentHeight: 100,
			backgroundColor: 0xffa84c,
			backgroundColorGradientEnd: 0xff7b0d,
			borderColor: -1,
			cornerRadius: 2,
		} ));

		addStyle("VProgress", new Style( {
			width: 30,
			height: 150,
			backgroundColor: 0x666666,
			borderColor: -1,
			padding: 2,
			cornerRadius: 2,
			borderSize: 0,
			filter: new DropShadowFilter(1, 45, 0x444444, 1, 2, 2, 1, 3, true),
		} ));
		
		addStyle("VProgress #background", new Style( {
			percentWidth: 100,
			percentHeight: 100,
			backgroundColor: -1,
			borderSize: 0,
			borderColor: -1,
		} ));
		
		addStyle("VProgress #value", new Style( {
			percentWidth: 100,
			backgroundColor: 0xffa84c,
			backgroundColorGradientEnd: 0xff7b0d,
			borderColor: -1,
			cornerRadius: 2,
			gradientType: "horizontal",
		} ));
		
		addStyle("HSlider", new Style( {
			width: 150,
			height: 30,
			backgroundColor: 0x666666,
			borderColor: -1,
			padding: 2,
			paddingLeft: 0,
			paddingRight: 0,
			cornerRadius: 2,
			borderSize: 0,
			filter: new DropShadowFilter(1, 45, 0x444444, 1, 2, 2, 1, 3, true),
		} ));
		
		addStyle("HSlider #background", new Style( {
			percentWidth: 100,
			percentHeight: 100,
			backgroundColor: -1,
			borderSize: 0,
			borderColor: -1,
		} ));
		
		addStyle("HSlider #value", new Style( {
			percentHeight: 0,
			backgroundColor: 0xffa84c,
			backgroundColorGradientEnd: 0xff7b0d,
			borderColor: -1,
			cornerRadius: 2,
		} ));
		
		addStyle("HSlider Button", new Style( {
			width: 26,
			height: 26,
			gradientType: "vertical",
			filter: new DropShadowFilter(2, 45, 0x666666, 1, 2, 2, 1, 3, false),
		} ));

		addStyle("VSlider", new Style( {
			width: 30,
			height: 150,
			backgroundColor: 0x666666,
			borderColor: -1,
			padding: 2,
			paddingLeft: 0,
			paddingRight: 0,
			cornerRadius: 2,
			borderSize: 0,
			filter: new DropShadowFilter(1, 45, 0x444444, 1, 2, 2, 1, 3, true),
		} ));
		
		addStyle("VSlider #background", new Style( {
			percentWidth: 100,
			percentHeight: 100,
			backgroundColor: -1,
			borderSize: 0,
			borderColor: -1,
		} ));
		
		addStyle("VSlider #value", new Style( {
			percentWidth: 0,
			backgroundColor: 0xffa84c,
			backgroundColorGradientEnd: 0xff7b0d,
			borderColor: -1,
			cornerRadius: 2,
		} ));
		
		addStyle("VSlider Button", new Style( {
			width: 26,
			height: 26,
			gradientType: "horizontal",
			filter: new DropShadowFilter(2, 45, 0x666666, 1, 2, 2, 1, 3, false),
		} ));
		
		addStyle("ScrollView", new Style( {
			backgroundColor: 0x444444 ,
			borderColor: -1,
			padding: 1,
			cornerRadius: 2,
			borderSize: 0,
			filter: new DropShadowFilter(1, 45, 0x444444, 1, 2, 2, 1, 3, true),
			inlineScrolls: true,
			autoHideScrolls: true,
			spacing: 0
		} ));
		
		
		addStyle("ListView", new Style( {
			//cornerRadius: 0,
		} ));

		addStyle("ListView #content", new Style( {
			backgroundColor: 0x444444,
			borderColor: -1,
			padding: 0,
			spacing: 1,
		} ));
		
		addStyle(".even, .odd", new Style( {
			padding: 10,
			backgroundColor: 0x666666,
		} ));

		addStyle(".even:over, .odd:over", new Style( {
			backgroundColor: 0xffb76b,
			backgroundColorGradientEnd: 0xff7f04,
			color: 0x222222,
		} ));
		
		addStyle(".even:selected, .odd:selected", new Style( {
			backgroundColor: 0xffa84c,
			backgroundColorGradientEnd: 0xff7b0d,
			color: 0x444444,
		} ));
		
		addStyle(".even #text, .odd #text", new Style( {
			color: 0xffa84c,
		} ));
		addStyle(".even #text:over, .odd #text:over", new Style( {
			color: 0x222222,
		} ));
		addStyle(".even #text:selected, .odd #text:selected", new Style( {
			color: 0x444444,
		} ));
		
		addStyle("VScroll", new Style( {
			width: 10,
			height: 100,
			hasButtons: false,
		} ));
		addStyle("VScroll Button", new Style( {
			cornerRadius: 2,
			gradientType: "horizontal",
			filter: null,
		} ));

		addStyle("HScroll", new Style( {
			width: 100,
			height: 10,
			hasButtons: false,
		} ));
		addStyle("HScroll Button", new Style( {
			cornerRadius: 2,
			gradientType: "vertical",
			filter: null,
		} ));
		
		addStyle("MenuBar", new Style( {
			backgroundColor: 0xdfdddd,
			percentWidth: 100,
			height: 10,
			padding: 5,
			borderColor: -1,
			cornerRadius: 0,
			filter: new DropShadowFilter(2, 45, 0x444444, 1, 2, 2, 1, 3),
			autoSize:true,
		} ));
		
		addStyle("MenuBar Container", new Style( {
			backgroundColor: 0xdfdddd,
		} ));
		
		addStyle("Popup", new Style( {
			backgroundColor: 0x888888,
			filter: new DropShadowFilter(2, 45, 0x444444, 1, 2, 2, 1, 3),
			borderColor: 0x888888,
			borderSize: 1,
			cornerRadius: 2,
			padding: 1,
			spacing: 1,
			width: 400,
		} ));

		addStyle("Popup Container", new Style( {
			backgroundColor: -2,
		} ));
		
		
		addStyle("Popup #titleBar", new Style( {
			backgroundColor: 0xcccccc,
			height: 45,
			paddingTop: 5,
			paddingBottom: 5,
			paddingLeft: 5,
			paddingRight: 5,
		} ));
		
		addStyle("Popup #popupContent", new Style( {
			padding: 5,
			backgroundColor: 0xcccccc,
		} ));

		addStyle("Popup #buttonBar", new Style( {
			paddingTop: 5,
			paddingBottom: 5,
			height: 55,
			backgroundColor: 0xcccccc,
		} ));
		
		addStyle("Popup #titleBar #title", new Style( {
			fontName: fb.fontName,
			fontEmbedded: true,
			fontSize: 24,
			color: 0x888888,
			horizontalAlignment: "right",
		} ));

		addStyle("ListPopupContent ListView, ListPopupContent #popupContent", new Style( {
			padding: 2,
			borderSize: 0,
		} ));

		addStyle("Menu", new Style( {
			backgroundColor: 0x888888,
			filter: new DropShadowFilter(2, 45, 0x444444, 1, 2, 2, 1, 3),
			borderColor: 0x444444,
			borderSize: 1,
			cornerRadius: 1,
			padding: 1,
			width: 175,
			spacing: 1,
		} ));

		addStyle("MenuButton", new Style( {
			backgroundColor: 0xdfdddd,
			backgroundColorGradientEnd: 0xdfdddd,
			color: 0x222222,
			padding: 10,
			borderColor: -1,
			borderSize: 0,
			cornerRadius: 2,
			filter: null,
		} ));
		
		
		addStyle("MenuButton:over", new Style( {
			backgroundColor: 0xffb76b,
			backgroundColorGradientEnd: 0xff7f04,
			color: 0x222222,
			filter: new DropShadowFilter(2, 45, 0x444444, 1, 2, 2, 1, 3),
			borderSize: 1,
		} ));
		addStyle("MenuButton:down", new Style( {
			backgroundColor: 0xffa84c,
			backgroundColorGradientEnd: 0xff7b0d,
			color: 0x444444,
			filter: new DropShadowFilter(2, 45, 0x444444, 1, 2, 2, 1, 3),
			borderSize: 1,
		} ));
		
		
		addStyle("MenuItem", new Style( {
			percentWidth: 100,
			iconPosition: "right",
			filter: null,
			borderSize: 0,
			cornerRadius: 0,
			backgroundColor: 0xcccccc,
			color: 0x222222,
		} ));

		addStyle("MenuItem:over", new Style( {
			backgroundColor: 0xffb76b,
			backgroundColorGradientEnd: 0xff7f04,
			color: 0x222222,
		} ));
		
		addStyle("MenuItem:down", new Style( {
			backgroundColor: 0xffa84c,
			backgroundColorGradientEnd: 0xff7b0d,
			color: 0x444444,
		} ));

		addStyle("MenuItem.expandable", new Style( {
			icon: "styles/default/expand.png",
		} ));
	}
}