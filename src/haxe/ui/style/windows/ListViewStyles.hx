package haxe.ui.style.windows;
import haxe.ui.style.Styles;

class ListViewStyles {
	public function new(styles:Styles) {
		styles.addStyle("ListView", {
			paddingLeft: 2,
			paddingRight: 2,
			paddingBottom: 2,
			paddingTop: 2,
			backgroundImage: "skins/windows/container/container_bg.png",
			backgroundImageScale9: "2,2,4,4",
			backgroundColor: 0xFF0000,
		});

		styles.addStyle("ListView.content", {
			spacingY: 0,
		});
		
		styles.addStyle("ListView.item", {
			backgroundColor: 0xFFFFFF,
			color: 0x000000,
			paddingLeft: 2,
			paddingTop: 2,
			paddingRight: 2,
			paddingBottom: 2,
			xxxxicon: "icons/fav_16.png",
		});

		styles.addStyle("ListView.item:over", {
			backgroundImage: "skins/windows/listview/listview_item_over.png",
			backgroundImageScale9: "5,5,15,15",
			//color: 0x000000,
			//backgroundColor: 0x0000FF,
		});

		styles.addStyle("ListView.item:selected", {
			backgroundImage: "skins/windows/listview/listview_item_selected.png",
			backgroundImageScale9: "5,5,15,15",
		});
		
		styles.addStyle("ListView.item.text", {
			xxxbackgroundColor: 0xFFFFFF,
			xxspacingY: 0,
			color: 0x000000,
		});

		styles.addStyle("ListView.item.subtext", {
			xxxxbackgroundColor: 0xFFFFFF,
			color: 0x888888,
		});
		
		styles.addStyle("ListView.item.text:over", {
			//backgroundColor: 0xFFFFFF,
			color: 0x000000,
		});

		styles.addStyle("ListView.item.subtext:over", {
			color: 0x888888,
		});
	}
	
}