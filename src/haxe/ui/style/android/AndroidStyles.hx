package haxe.ui.style.android;

import haxe.ui.style.Styles;

class AndroidStyles extends Styles {
	public function new() {
		super();
		
		addAll(this);
	}
	
	public function addAll(styles:Styles) {
		styles.addStyle("Root", {
			fontSize: 14,
			fontName: "_sans",
			backgroundColor: 0x181818,
		});
		
		styles.addStyle("Root.simpleBorder", {
			backgroundImage: "skins/android/popup/popup_border_no_title.png",
			backgroundImageScale9: "2,2,4,4",
		});

		styles.addStyle("Root.popupBorder", {
			backgroundImage: "skins/android/popup/popup_border_no_title.png",
			backgroundImageScale9: "4,50,258,86",
			backgroundColor: -1,
			
			paddingLeft: 2,
			paddingTop: 2,
			paddingRight: 2,
			paddingBottom: 2,
		});

		styles.addStyle("Component", {
			fontSize: 14,
			fontName: "_sans",
		});

		styles.addStyle("HBox", {
			spacingX: 5,
		});

		styles.addStyle("VBox", {
			spacingY: 5,
		});

		styles.addStyle("ScrollView", {
			autoHideScrolls: true,
		});
		
		styles.addStyle("Label", {
			paddingLeft: 0,
			paddingRight: 0,
			paddingBottom: 0,
			paddingTop: 0,
			color: 0xFFFFFF,
			fontSize: 14,
		});
		
		styles.addStyle("ValueControl", {
			XXXbackgroundColor: 0xFFFFFF,
		});

		styles.addStyle("DropDownList", {
			icon: "skins/windows/vscroll/vscroll_down_arrow.png",
			paddingLeft: 12,
			paddingTop: 12,
			paddingBottom: 12,
			paddingRight: 12,
			backgroundImage: "skins/android/button/button_up.png",
			backgroundImageScale9: "5,5,146,38",
			color: 0x000000,
			method: "popup",
			iconPosition: "farRight",
			textPosition: "left",
		});
		
		styles.addStyle("#screen", {
			paddingLeft: 0,
			paddingRight: 0,
			paddingBottom: 0,
			paddingTop: 0,
			backgroundColor: 0x161616,
		});
		
		styles.addStyle("#disabledOverlay", {
			backgroundColor: 0x181818,
			alpha: 0.5,
		});
		
		styles.addStyle("favIcon", {
			icon: "skins/android/icons/fav_32.png",
		});
		styles.addStyle("userIcon", {
			icon: "skins/android/icons/user_32.png",
		});

		addStyle("TextInput", {
			backgroundImage: "skins/android/textinput/textinput_normal.png",
			backgroundImageScale9: "5,5,10,10",
			color: 0x000000,
			width: 200,
			height: 42,
			paddingLeft: 0,
			paddingTop: 10,
			paddingRight: 0,
			paddingBottom: 0,
			fontSize: 16,
		});
		
		new ButtonStyles(styles);
		new TabBarStyles(styles);
		new CheckBoxStyles(styles);
		new HScrollStyles(styles);
		new VScrollStyles(styles);
		new ListViewStyles(styles);
		new PopupStyles(styles);
		new OptionBoxStyles(styles);
		new ProgressBarStyles(styles);
		new RatingsStyles(styles);
	}
	
}