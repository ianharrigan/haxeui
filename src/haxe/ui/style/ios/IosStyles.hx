package haxe.ui.style.ios;
import haxe.ui.style.Styles;

class IosStyles extends Styles {
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
			backgroundImage: "skins/ios/popup/popup_border_no_title.png",
			backgroundImageScale9: "2,2,4,4",
		//	textPosition: "center",

		});

		styles.addStyle("Root.popupBorder", {
			backgroundImage: "skins/ios/popup/popup_border_no_title.png",
			backgroundImageScale9: "4,50,258,86",
			backgroundColor: -1,
			
			paddingLeft: 2,
			paddingTop: 2,
			paddingRight: 2,
			paddingBottom: 2,
			//textPosition: "center",

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
			//textPosition: "center",
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
			backgroundImage: "skins/ios/button/button_up2.png",
			backgroundImageScale9: "5,5,139,43",
			color: 0xFFFFFF,
			method: "popup",
			iconPosition: "farRight",
			//textPosition: "left",
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
			icon: "skins/ios/icons/fav_32.png",
		});
		styles.addStyle("userIcon", {
			icon: "skins/ios/icons/user_32.png",
		});

		addStyle("TextInput", {
			backgroundImage: "skins/ios/textinput/textinput_normal.png",
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