package haxe.ui.style.windows;
import haxe.ui.style.Styles;

class PopupStyles {
	public function new(styles:Styles) {
		styles.addStyle("Popup", {
			backgroundImage: "skins/windows/popup/popup_border.png",
			backgroundImageScale9: "8,30,341,50",
			width: 230,
		});

		styles.addStyle("Popup.title", {
			paddingLeft: 5,
			paddingTop: 5,
			paddingRight: 0,
			paddingBottom: 0,
		});
		
		styles.addStyle("Popup.content", {
			paddingLeft: 8,
			paddingTop: 30,
			paddingRight: 8,
			paddingBottom: 8,
		});
		
		styles.addStyle("Popup.list", {
			xxbackgroundImage: null,
		});
		
		styles.addStyle("Popup.list.item", {
			xxbackgroundColor: 0xFFFFFF,
			xxcolor: 0x000000,
			xxpaddingLeft: 2,
			xxpaddingTop: 0,
			xxpaddingRight: 2,
			xxpaddingBottom: 2,
			xxicon: "icons/home_16.png",
		});
		
		styles.addStyle("Popup.list.item.text", {
			xxbackgroundColor: 0xFFFFFF,
			xxcolor: 0x000000,
		});
		
		styles.addStyle("Popup.list.item.text:over", {
			xxbackgroundColor: 0xFF0000,
			xxcolor: 0xFF0000,
		});
		
		styles.addStyle("BusyPopup", {
			backgroundImage: "skins/windows/popup/popup_border_no_title.png",
			backgroundImageScale9: "8,8,341,28",
			width: 230,
		});
		
		styles.addStyle("BusyPopup.content", {
			paddingLeft: 8,
			paddingTop: 12,
			paddingRight: 8,
			paddingBottom: 12,
		});
	}
}