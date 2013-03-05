package haxe.ui.style.android;

import haxe.ui.style.Styles;

class PopupStyles {
	public function new(styles:Styles) {
		styles.addStyle("Popup", {
			backgroundImage: "skins/android/popup/popup_border.png",
			backgroundImageScale9: "4,50,258,86",
			width: 294,
		});

		styles.addStyle("Popup.title", {
			paddingLeft: 5,
			paddingTop: 10,
			paddingRight: 0,
			paddingBottom: 0,
			fontSize: 26,
			color: 0xFFFFFF,
		});
		
		styles.addStyle("Popup.list", {
			innerScrolls: true,
		});
		
		styles.addStyle("Popup.content", {
			paddingLeft: 2,
			paddingTop: 50,
			paddingRight: 2,
			paddingBottom: 2,
		});

		styles.addStyle("Popup.list.item", {
			backgroundImage: "skins/android/list/list_item_popup_unselected.png",
			//backgroundImageScale9: "1,1,2,47", // if you know that your lists wont get big omit this for performance (TODO: performance)
			paddingLeft: 2,
			paddingTop: 12,
			paddingRight: 10,
			paddingBottom: 12,
			icon: "skins/android/optionbox/optionbox_unselected_up.png",
			iconPosition: "farRight",
		});

		styles.addStyle("Popup.list.item:over", {
			backgroundImage: "skins/android/list/list_item_popup_unselected.png",
			//backgroundImageScale9: "1,1,2,47", // if you know that your lists wont get big omit this for performance (TODO: performance)
		});

		styles.addStyle("Popup.list.item:selected", {
			backgroundImage: "skins/android/list/list_item_selected.png",
			icon: "skins/android/optionbox/optionbox_selected_up.png",
			//backgroundImageScale9: "1,1,2,47", // if you know that your lists wont get big omit this for performance (TODO: performance)
		});
		
		styles.addStyle("Popup.list.item.text", {
			fontSize: 22,
			color: 0x000000,
		});

		styles.addStyle("Popup.list.item.text:selected", {
			fontSize: 22,
			color: 0xFFFFFF,
		});
		
		styles.addStyle("Popup.list.item.subtext", {
			color: 0x3E9EEA,
			fontSize: 14,
			paddingLeft: 2,
			paddingTop: 0,
			paddingRight: 0,
			paddingBottom: 0,
		});
		
		
		/*
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
		})
		;
		*/
	}
}