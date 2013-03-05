package haxe.ui.style.android;
import haxe.ui.style.Styles;

class ListViewStyles {
	public function new(styles:Styles) {
		styles.addStyle("ListView", {
			paddingLeft: 0,
			paddingRight: 0,
			paddingBottom: 0,
			paddingTop: 0,
			innerScrolls: false,
			//backgroundColor: 0xFF00FF,
			//backgroundImage: "skins/windows/container/container_bg.png",
			//backgroundImageScale9: "2,2,4,4",
		});

		styles.addStyle("ListView.content", {
			spacingY: 0,
		});
		
		styles.addStyle("ListView.item", {
			//backgroundColor: 0xFFFFFF,
			//color: 0x000000,
			backgroundImage: "skins/android/list/list_item_unselected.png",
			//backgroundImageScale9: "1,1,2,47", // if you know that your lists wont get big omit this for performance (TODO: performance)
			color: 0xFFFFFF,
			//backgroundColor: 0xFF0000,
			paddingLeft: 2,
			paddingTop: 12,
			paddingRight: 2,
			paddingBottom: 12,
			xxxxicon: "icons/fav_16.png",
		});

		styles.addStyle("ListView.item:over", {
			backgroundImage: "skins/android/list/list_item_unselected.png",
			//backgroundImageScale9: "1,1,2,47", // if you know that your lists wont get big omit this for performance (TODO: performance)
		});

		styles.addStyle("ListView.item:selected", {
			backgroundImage: "skins/android/list/list_item_selected.png",
			//backgroundImageScale9: "1,1,2,47", // if you know that your lists wont get big omit this for performance (TODO: performance)
		});
		
		styles.addStyle("ListView.item.text", {
			fontSize: 22,
			color: 0xFFFFFF,
		});

		styles.addStyle("ListView.item.subtext", {
			color: 0x3E9EEA,
			fontSize: 14,
			paddingLeft: 2,
			paddingTop: 0,
			paddingRight: 0,
			paddingBottom: 0,
		});
		
		styles.addStyle("ListView.item.text:over", {
			//backgroundColor: 0xFFFFFF,
			//color: 0x000000,
		});

		styles.addStyle("ListView.item.subtext:over", {
			color: 0x3E9EEA,
		});
		
		styles.addStyle("ListView.item.subtext:selected", {
			color: 0xFFFFFF,
		});
	}
	
}