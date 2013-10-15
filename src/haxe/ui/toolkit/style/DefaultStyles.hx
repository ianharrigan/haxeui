package haxe.ui.toolkit.style;

import flash.filters.BitmapFilter;
import flash.filters.DropShadowFilter;

class DefaultStyles extends Styles {
	public function new() {
		super();

		addStyle("Root", new Style( {
			padding: 0
		} ));
		
		addStyle("Text", new Style( {
			fontSize: 13,
			fontName: "_sans"
		} ));
		
		addStyle("ScrollView, ScrollView VBox", new Style( {
			backgroundColor: 0xFFFFFF,
			borderColor: 0xDDDDDD,
			color: 0x000000,
			padding: 0,
			borderSize: 0,
			spacing: 5,
		} ));
		addStyle("VBox, HBox, Grid, ListView", new Style( {
			spacing: 5,
			
		} ));
		addStyle("Stack", new Style( {
			padding: 5,
		} ));
		
		addStyle("Button", new Style( {
			backgroundColor: 0xFFFFFF,
			backgroundColorGradientEnd: 0xEEEEEE,
			padding: 10,
			borderColor: 0xCCCCCC,
			borderSize: 1,
			cornerRadius: 3,
			filter: new DropShadowFilter(1, 45, 0xBFBFBF, 1, 2, 2, 1, 1)
		} ));
		addStyle("Button:over", new Style( {
			backgroundColor: 0xFFFFFF,
			backgroundColorGradientEnd: 0xDDDDDD,
		} ));
		addStyle("Button:down", new Style( {
			backgroundColor: 0xFFFFFF,
			backgroundColorGradientEnd: 0xCCCCCC,
		} ));

		addStyle("TextInput", new Style( {
			backgroundColor: 0xFFFFFF,
			width: 150,
			height: 30,
			borderColor: 0xCCCCCC,
			padding: 2,
			cornerRadius: 2,
			filter: new DropShadowFilter(2, 45, 0xBFBFBF, 1, 2, 2, 1, 1, true),
			fontSize: 13,
			fontName: "_sans"
		} ));

		addStyle("HProgress", new Style( {
			backgroundColor: 0xFFFFFF,
			width: 100,
			height: 20,
			borderColor: 0xEFEFEF,
			padding: 0,
			cornerRadius: 2,
			borderSize: 0,
			filter: new DropShadowFilter(1, 45, 0xBFBFBF, 1, 2, 2, 1, 1, true),
		} ));

		addStyle("HProgress #background", new Style( {
			percentWidth: 100,
			percentHeight: 100,
			backgroundColor: 0xFFFFFF,
			borderSize: 0,
		} ));

		addStyle("HProgress #value", new Style( {
			percentHeight: 100,
			backgroundColor: 0xFFFFFF,
			backgroundColorGradientEnd: 0xEEEEEE,
			borderColor: 0xDFDFDF,
			cornerRadius: 2,
		} ));

		
		
		
		
		addStyle("HSlider", new Style( {
			width: 100,
			height: 26,
			borderColor: 0xEFEFEF,
			padding: 3,
			cornerRadius: 2,
			borderSize: 0,
		} ));

		addStyle("HSlider #background", new Style( {
			percentWidth: 100,
			height: 10,
			borderSize: 1,
			backgroundColor: 0xEFEFEF,
			cornerRadius: 2,
		} ));

		addStyle("HSlider #value", new Style( {
			height: 10,
			backgroundColor: 0xFFFFFF,
			backgroundColorGradientEnd: 0xEEEEEE,
			borderColor: 0xDFDFDF,
			cornerRadius: 2,
		} ));

		addStyle("HSlider Button", new Style( {
			width: 10,
			percentHeight: 100,
			backgroundColor: 0xFFFFFF,
			backgroundColorGradientEnd: 0xEEEEEE,
			borderColor: 0xDFDFDF,
			cornerRadius: 2,
		} ));
		
		
		
		addStyle("VScroll", new Style( {
			width: 10,
			height: 100,
			hasButtons: false,
		} ));
		addStyle("VScroll Button", new Style( {
			cornerRadius: 2,
			gradientType: "horizontal"
		} ));
		addStyle("HScroll", new Style( {
			width: 100,
			height: 10,
			hasButtons: false,
		} ));
		addStyle("HScroll Button", new Style( {
			cornerRadius: 2,
		} ));
		
		addStyle("ListView", new Style( {
			color: 0x000000,
			padding: 2,
			borderSize: 1,
			spacing: 2,
			cornerRadius: 2,
		} ));

		addStyle("ListViewItem", new Style( {
			padding: 5,
			cornerRadius: 3,
			backgroundColor: 0xFFFFFF
		} ));
		
		addStyle("ListView #even", new Style( {
			backgroundColor: 0xF9F9F9
		} ));

		addStyle("ListView #even:over, ListView #odd:over, ListViewItem:selected", new Style( {
			backgroundColor: 0xCCCCCC,
		} ));

		addStyle("MenuBar", new Style( {
			height: 45
		} ));
		
		addStyle("TabBar", new Style( {
			backgroundColor: 0xFFFFFF,
			height: 45,
			paddingTop: 15,
			paddingLeft: 5,
			paddingRight: 5,
		} ));
		addStyle("TabBar HBox", new Style( {
			spacingX: 3,
		} ));
		addStyle("TabBar Button", new Style( {
			height: 30,
			iconPosition: "left",
			cornerRadiusBottomLeft: 0,
			cornerRadiusBottomRight: 0,
			backgroundColor: 0xEEEEEE,
			backgroundColorGradientEnd: 0xCCCCCC,
			borderColor: 0xE0E0E0,
			color: 0x888888
		} ));
		addStyle("TabBar Button:down", new Style( {
			backgroundColor: 0xFFFFFF,
			backgroundColorGradientEnd: 0xEEEEEE,
			color: 0x000000,
		} ));
		addStyle("TabView", new Style( {
			backgroundColor: 0xEEEEEE,
		} ));

		addStyle("MenuBar", new Style( {
			backgroundColor: 0xdfdddd,
			percentWidth: 100,
			height: 50,
			padding: 5,
			cornerRadius: 0,
			filter: new DropShadowFilter(2, 45, 0xBFBFBF, 1, 2, 2, 1, 1)
		} ));
		
		addStyle("Calendar, CalendarView", new Style( {
			width: 250,
			height: 250,
		} ));

		addStyle("Popup", new Style( {
			backgroundColor: 0xFFFFFF,
			filter: new DropShadowFilter(2, 45, 0xBFBFBF, 1, 2, 2, 1, 1),
			borderColor: 0xAAAAAA,
			borderSize: 1,
			cornerRadius: 3,
			padding: 2,
			width: 350,
		} ));
		
		addStyle("Popup #titleBar", new Style( {
			backgroundColor: 0xCCCCCC,
			height: 30,
			paddingTop: 4,
			paddingLeft: 5,
		} ));
		
		addStyle("Popup #content", new Style( {
			padding: 5,
		} ));

		addStyle("Popup #buttonBar", new Style( {
			paddingTop: 10,
			paddingBottom: 5,
			height: 55,
		} ));
		
		addStyle("Popup #titleBar #text", new Style( {
			color: 0x666666,
		} ));
		
		addStyle("Menu", new Style( {
			spacing: 0,
			backgroundColor: 0xFFFFFF,
			filter: new DropShadowFilter(2, 45, 0xBFBFBF, 1, 2, 2, 1, 1),
			borderColor: 0xAAAAAA,
			borderSize: 1,
			cornerRadius: 3,
			padding: 2,
			width: 150,
		} ));
		
		addStyle("MenuItem", new Style( {
			percentWidth: 100,
			backgroundColor: 0xFFFFFF,
			borderSize: 0,
			labelPosition: "left",
			iconPosition: "farRight",
			cornerRadius: 0,
		} ));
		
		addStyle("MenuItem:over, MenuItem:down", new Style( {
			backgroundColor: 0xAAAAAA,
		} ));
	}
}