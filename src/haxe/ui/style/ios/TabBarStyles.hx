package haxe.ui.style.ios;
import haxe.ui.style.Styles;

class TabBarStyles {
	public function new(styles:Styles) {
		styles.addStyle("TabView.content", {
			paddingLeft: 2,
			paddingTop: 2,
			paddingBottom: 2,
			paddingRight: 1,
		});

		styles.addStyle("TabBar", {
			paddingLeft: 0,
			paddingTop: 0,
			paddingBottom: 0,
			paddingRight: 0,
			height: 64,
			backgroundImage: "skins/ios/tabbar/tabbar_bg.png",
		});
		
		styles.addStyle("TabBar.content", {
			spacingX: 0,
		});
		
		styles.addStyle("TabBar.tab", {
			height: 64,
			width: 80,
			paddingLeft: 5,
			paddingTop: 2,
			paddingBottom: 2,
			paddingRight: 5,
			backgroundImage: "skins/ios/tabs/tab_unselected_bg.png",
			color: 0xFFFFFF,
			fontSize: 12,
			iconPosition: "top",
			textPosition: "center",
		});
		
		styles.addStyle("TabBar.tab:over", {
				backgroundImage: "skins/ios/tabs/tab_unselected_bg.png",
		});

		styles.addStyle("TabBar.tab:down", {
				backgroundImage: "skins/ios/tabs/tab_selected_bg.png",
		});
	}
	
}