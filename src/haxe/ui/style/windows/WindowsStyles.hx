package haxe.ui.style.windows;

class WindowsStyles extends Styles {
	public function new() {
		super();

		addStyle("Root", {
			fontSize: 13,
			fontName: "_sans",
			backgroundColor: 0xFFFFFF,
		});
		
		addStyle("Root.simpleBorder", {
			backgroundImage: "skins/windows/container/container_bg.png",
			backgroundImageScale9: "2,2,4,4",
		});

		addStyle("Root.popupBorder", {
			backgroundImage: "skins/windows/popup/popup_border.png",
			backgroundImageScale9: "8,30,341,50",
			
			paddingLeft: 8,
			paddingTop: 30,
			paddingRight: 8,
			paddingBottom: 8,
			backgroundColor: -1,
		});
		
		addStyle("Component", {
			fontSize: 13,
			fontName: "_sans",
			
			xxxbackgroundColor: 0xFF0000,
		});

		addStyle("HBox", {
			spacingX: 5,
		});

		addStyle("VBox", {
			spacingY: 5,
		});
		
		addStyle("Label", {
			paddingLeft: 0,
			paddingRight: 0,
			paddingBottom: 0,
			paddingTop: 0,
		});
		
		addStyle("ValueControl", {
			XXXbackgroundColor: 0xFFFFFF,
		});

		addStyle("DropDownList", {
			icon: "skins/windows/vscroll/vscroll_down_arrow.png",
			paddingLeft: 5,
			paddingTop: 2,
			paddingBottom: 2,
			paddingRight: 5,
			backgroundImage: "skins/windows/button/button_up.png",
			backgroundImageScale9: "5,5,15,15",
			iconPosition: "farRight",
			textPosition: "left",
		});

		addStyle("DropDownList:over", {
			backgroundImage: "skins/windows/button/button_over.png",
			backgroundImageScale9: "5,5,15,15",
		});

		addStyle("DropDownList:down", {
			backgroundImage: "skins/windows/button/button_down.png",
			backgroundImageScale9: "5,5,15,15",
		});
		
		addStyle("favIcon", {
			icon: "icons/fav_16.png",
		});
		
		addStyle("userIcon", {
			icon: "icons/user_16.png",
		});

		addStyle("TextInput", {
			backgroundImage: "skins/windows/textinput/textinput_normal.png",
			backgroundImageScale9: "5,5,10,10",
			width: 200,
			height: 23,
			paddingLeft: 2,
			paddingTop: 2,
			paddingRight: 2,
			paddingBottom: 2,
		});

		addStyle("TextInput:over", {
			backgroundImage: "skins/windows/textinput/textinput_over.png",
			backgroundImageScale9: "5,5,10,10",
		});
		
		new ButtonStyles(this);
		new CheckBoxStyles(this);
		new VScrollStyles(this);
		new HScrollStyles(this);
		new ListViewStyles(this);
		new TabBarStyles(this);
		new PopupStyles(this);
		new OptionBoxStyles(this);
		new ProgressBarStyles(this);
		new RatingsStyles(this);
	}
	
}