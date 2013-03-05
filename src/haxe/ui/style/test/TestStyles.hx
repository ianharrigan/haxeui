package haxe.ui.style.test;
import haxe.ui.style.Styles;

class TestStyles extends Styles{
	public function new() {
		super();
		
		addStyle("Root", {
			fontSize: 14,
			fontName: "_sans",
			backgroundColor: 0xFFFFFF,
		});
		
		addStyle("Root.simpleBorder", {
			backgroundColor: 0xFFFFFF,
			borderColor: 0x64AEBC,
			cornerRadius: 5,
		});

		addStyle("Root.popupBorder", {
			backgroundColor: 0xFFFFFF,
			borderColor: 0x64AEBC,
			cornerRadius: 5,
		});
		
		addStyle("#screen", {
			paddingLeft: 0,
			paddingRight: 0,
			paddingBottom: 0,
			paddingTop: 0,
			backgroundColor: 0xFFFFFF,
		});

		addStyle("favIcon", {
			icon: "icons/fav_16.png",
		});
		addStyle("userIcon", {
			icon: "icons/fav_16.png",
		});
		
		addStyle("#disabledOverlay", {
			backgroundColor: 0xA5D2DC,
			alpha: 0.2,
		});
		
		
		addStyle("Component", {
			fontSize: 14,
			fontName: "_sans",
			borderSize: 1,
		});

		addStyle("HBox", {
			spacingX: 5,
		});

		addStyle("VBox", {
			spacingY: 5,
		});
		
		addStyle("TextInput", {
			width: 200,
			height: 23,
			paddingLeft: 2,
			paddingTop: 2,
			paddingRight: 2,
			paddingBottom: 2,
			borderColor: 0x64AEBC,
			backgroundColor: 0xD9ECF0,
			cornerRadius: 2,
		});
		
		addStyle("Button", {
			paddingLeft: 8,
			paddingTop: 8,
			paddingBottom: 8,
			paddingRight: 8,
			backgroundColor: 0xD9ECF0,
			backgroundColorGradientEnd: 0xA5D2DC,
			color: 0x64AEBC,
			borderColor: 0x64AEBC,
			cornerRadius: 5,
			borderSize: 1,
		});
		
		addStyle("Button:over", {
			backgroundColor: 0xFFFFFF,
			color: 0x64AEBC,
		});
		
		addStyle("Button:down", {
			backgroundColor: 0x64AEBC,
			color: 0xFFFFFF,
		});
		
		addStyle("DropDownList", {
			icon: "skins/windows/vscroll/vscroll_down_arrow.png",
			paddingLeft: 8,
			paddingTop: 8,
			paddingBottom: 8,
			paddingRight: 8,
			iconPosition: "farRight",
			textPosition: "left",
			backgroundColor: 0xD9ECF0,
			backgroundColorGradientEnd: 0xA5D2DC,
			color: 0x64AEBC,
			borderColor: 0x64AEBC,
		});
		
		addStyle("TabView.content", {
			paddingLeft: 5,
			paddingTop: 5,
			paddingBottom: 5,
			paddingRight: 5,
		});
		
		addStyle("TabBar", {
			paddingTop: 10,
			paddingLeft: 5,
			paddingBottom: 0,
			paddingRight: 5,
			height: 45,
			backgroundColor: 0xFFFFFF,
			borderColor: 0x64AEBC,
		});
		
		addStyle("TabBar.content", {
			spacingX: 5,
		});
		
		addStyle("TabBar.tab", {
			backgroundColor: 0xD9ECF0,
			backgroundColorGradientEnd: 0xA5D2DC,
			color: 0x64AEBC,
			paddingLeft: 8,
			paddingTop: 8,
			paddingBottom: 8,
			paddingRight: 8,
			height: 30,
			borderColor: 0x64AEBC,
			cornerRadius: 5,
			cornerRadiusBottomLeft: 0,
			cornerRadiusBottomRight: 0,
			borderSize: 1,
		});
		
		addStyle("TabBar.tab:over", {
			backgroundColor: 0xFFFFFF,
			color: 0xFFFFFF,
		});

		addStyle("TabBar.tab:down", {
			backgroundColor: 0xD9ECF0,
			backgroundColorGradientEnd: 0xFFFFFF,
			color: 0x64AEBC,
		});
		
		addStyle("VScroll", {
			backgroundColor: 0xD9ECF0,
			//borderColor: 0x888888,
			width: 8,
			height: 100,
			paddingLeft: 1,
			paddingTop: 1,
			paddingBottom: 1,
			paddingRight: 1,
			spacingY: 1,
			hasButtons: true,
			cornerRadius: 2,
		});

		addStyle("VScroll.thumb", {
			backgroundColor: 0x64AEBC,
			backgroundColorGradientEnd: 0x64AEBC,
			cornerRadius: 0,
			borderSize: 0,
		});

		addStyle("VScroll.thumb:over", {
			backgroundColor: 0x64AEBC,
			backgroundColorGradientEnd: 0x64AEBC,
			cornerRadius: 0,
			borderSize: 0,
		});

		addStyle("VScroll.thumb:down", {
			backgroundColor: 0x64AEBC,
			backgroundColorGradientEnd: 0x64AEBC,
			cornerRadius: 0,
			borderSize: 0,
		});
		
		addStyle("VScroll.upButton", {
			backgroundColor: 0x64AEBC,
			backgroundColorGradientEnd: 0x64AEBC,
			cornerRadiusBottomLeft: 0,
			cornerRadiusBottomRight: 0,
			borderSize: 0,
			cornerRadius: 2,
		});

		addStyle("VScroll.upButton:over", {
			backgroundColor: 0x64AEBC,
			backgroundColorGradientEnd: 0x64AEBC,
			cornerRadiusBottomLeft: 0,
			cornerRadiusBottomRight: 0,
			borderSize: 0,
			cornerRadius: 2,
		});

		addStyle("VScroll.upButton:down", {
			backgroundColor: 0x64AEBC,
			backgroundColorGradientEnd: 0x64AEBC,
			cornerRadiusBottomLeft: 0,
			cornerRadiusBottomRight: 0,
			borderSize: 0,
			cornerRadius: 2,
		});
		
		addStyle("VScroll.downButton", {
			backgroundColor: 0x64AEBC,
			backgroundColorGradientEnd: 0x64AEBC,
			cornerRadiusTopLeft: 0,
			cornerRadiusTopRight: 0,
			borderSize: 0,
			cornerRadius: 2,
		});
	
		addStyle("HScroll", {
			backgroundColor: 0xD9ECF0,
			width: 100,
			height: 8,
			paddingLeft: 1,
			paddingTop: 1,
			paddingBottom: 1,
			paddingRight: 1,
			spacingX: 1,
			hasButtons: true,
			cornerRadius: 2,
		});
		
		addStyle("HScroll.thumb", {
			backgroundColor: 0x64AEBC,
			backgroundColorGradientEnd: 0x64AEBC,
			cornerRadius: 0,
			borderSize: 0,
		});

		addStyle("HScroll.thumb:over", {
			backgroundColor: 0x64AEBC,
			backgroundColorGradientEnd: 0x64AEBC,
			cornerRadius: 0,
			borderSize: 0,
		});

		addStyle("HScroll.thumb:down", {
			backgroundColor: 0x64AEBC,
			backgroundColorGradientEnd: 0x64AEBC,
			cornerRadius: 0,
			borderSize: 0,
		});
		
		addStyle("HScroll.leftButton", {
			cornerRadiusTopRight: 0,
			cornerRadiusBottomRight: 0,
			backgroundColor: 0x64AEBC,
			backgroundColorGradientEnd: 0x64AEBC,
			borderSize: 0,
			cornerRadius: 2,
		});
		
		addStyle("HScroll.rightButton", {
			cornerRadiusTopLeft: 0,
			cornerRadiusBottomLeft: 0,
			backgroundColor: 0x64AEBC,
			backgroundColorGradientEnd: 0x64AEBC,
			borderSize: 0,
			cornerRadius: 2,
		});
		
		addStyle("ListView", {
			borderColor: 0x64AEBC,
			backgroundColor: 0xFFFFFF,
			paddingLeft: 3,
			paddingRight: 3,
			paddingBottom: 3,
			paddingTop: 3,
			cornerRadius: 5,
			spacingX: 2,
		});
		
		addStyle("ListView.content", {
			spacingY: 0,
		});
		
		addStyle("ListView.item", {
			backgroundColor: 0xFFFFFF,
			paddingLeft: 4,
			paddingTop: 4,
			paddingRight: 4,
			paddingBottom: 4,
		});

		addStyle("ListView.item.text", {
			color: 0x000000,
		});

		addStyle("ListView.item.subtext", {
			color: 0xA5D2DC,
		});
		
		addStyle("ListView.item:over", {
			cornerRadius: 3,
			backgroundColor: 0xFFFFFF,
			backgroundColorGradientEnd: 0xD9ECF0,
			color: 0x64AEBC,
			borderColor: 0x64AEBC,
		});
		
		addStyle("ListView.item.text:over", {
			color: 0x64AEBC,
		});
		

		addStyle("ListView.item:selected", {
			cornerRadius: 3,
			backgroundColor: 0xD9ECF0,
			backgroundColorGradientEnd: 0xA5D2DC,
			color: 0x64AEBC,
			borderColor: 0x64AEBC,
		});

		addStyle("ListView.item.text:selected", {
			color: 0xFFFFFF,
		});
		
		addStyle("CheckBox.value", {
			xxxxbackgroundColor: 0xFFFFFF,
			paddingLeft: 0,
			paddingRight: 0,
			paddingBottom: 0,
			paddingTop: 0,
			width: 15,
			height: 15,
		});

		addStyle("CheckBox.value.unselected", {
			backgroundColor: 0xFFFFFF,
			color: 0x64AEBC,
			borderColor: 0x64AEBC,
			cornerRadius: 5,
		});

		addStyle("CheckBox.value.selected", {
			backgroundColor: 0xD9ECF0,
			backgroundColorGradientEnd: 0xA5D2DC,
			color: 0x64AEBC,
			borderColor: 0x64AEBC,
			cornerRadius: 5,
			borderSize: 1,
		});

		addStyle("OptionBox.value", {
			xxxxbackgroundColor: 0xFFFFFF,
			paddingLeft: 0,
			paddingRight: 0,
			paddingBottom: 0,
			paddingTop: 0,
			width: 15,
			height: 15,
		});

		addStyle("OptionBox.value.unselected", {
			backgroundColor: 0xFFFFFF,
			color: 0x64AEBC,
			borderColor: 0x64AEBC,
			cornerRadius: 10,
		});

		addStyle("OptionBox.value.selected", {
			backgroundColor: 0xD9ECF0,
			backgroundColorGradientEnd: 0xA5D2DC,
			color: 0x64AEBC,
			borderColor: 0x64AEBC,
			cornerRadius: 10,
			borderSize: 1,
		});
		
		addStyle("Popup", {
			backgroundColor: 0x64AEBC,
			borderColor: 0x64AEBC,
			cornerRadius: 5,
			width: 230,
		});

		addStyle("Popup.title", {
			paddingLeft: 15,
			paddingTop: 5,
			paddingRight: 0,
			paddingBottom: 0,
		});
		
		addStyle("Popup.content", {
			backgroundColor: 0xFFFFFF,
			borderColor: 0x64AEBC,
			cornerRadius: 5,
			paddingLeft: 8,
			paddingTop: 30,
			paddingRight: 8,
			paddingBottom: 8,
		});
		
		addStyle("ProgressBar", {
			width: 100,
			height: 20,
			paddingLeft: 2,
			paddingTop: 2,
			paddingBottom: 2,
			paddingRight: 2,
			backgroundColor: 0xFFFFFF,
			color: 0x64AEBC,
			borderColor: 0x64AEBC,
			cornerRadius: 5,
		});

		addStyle("ProgressBar.value", {
			backgroundColor: 0xD9ECF0,
			backgroundColorGradientEnd: 0xA5D2DC,
			color: 0x64AEBC,
			borderColor: 0x64AEBC,
			cornerRadius: 5,
			borderSize: 1,
		});
		
		addStyle("RatingControl", {
			paddingLeft: 5,
			paddingTop: 5,
			paddingBottom: 5,
			paddingRight: 5,
			backgroundColor: 0xFFFFFF,
			color: 0x64AEBC,
			borderColor: 0x64AEBC,
			cornerRadius: 5,
			spacingX: 5,
		});

		addStyle("RatingControl.value", {
			width: 15,
			height: 15,
		});
		
		addStyle("RatingControl.value.unselected", {
			backgroundColor: 0xFFFFFF,
			color: 0x64AEBC,
			borderColor: 0x64AEBC,
			cornerRadius: 10,
		});

		addStyle("RatingControl.value.unselected:over", {
			backgroundColor: 0xD9ECF0,
			backgroundColorGradientEnd: 0xA5D2DC,
			color: 0x64AEBC,
			borderColor: 0x64AEBC,
			cornerRadius: 10,
			borderSize: 1,
		});

		addStyle("RatingControl.value.unselected:down", {
			backgroundColor: 0xD9ECF0,
			backgroundColorGradientEnd: 0xA5D2DC,
			color: 0x64AEBC,
			borderColor: 0x64AEBC,
			cornerRadius: 10,
			borderSize: 1,
		});
		
		addStyle("RatingControl.value.selected", {
			backgroundColor: 0xD9ECF0,
			backgroundColorGradientEnd: 0xA5D2DC,
			color: 0x64AEBC,
			borderColor: 0x64AEBC,
			cornerRadius: 10,
			borderSize: 1,
		});
	}
	
}