package haxe.ui.style.windows;
import haxe.ui.style.Styles;

class TabBarStyles {
	public function new(styles:Styles) {
		styles.addStyle("TabView.content", {
			paddingLeft: 5,
			paddingTop: 5,
			paddingBottom: 5,
			paddingRight: 5,
		});
		
		styles.addStyle("TabBar", {
			paddingTop: 15,
			paddingLeft: 5,
			paddingBottom: 0,
			paddingRight: 5,
			height: 45,
			backgroundImage: "skins/windows/tabbar/tabbar_bg.png",
			backgroundImageScale9: "5,5,15,15",
		});
		
		styles.addStyle("TabBar.content", {
			spacingX: 0,
		});
		
		styles.addStyle("TabBar.tab", {
			backgroundImage: "skins/windows/tabs/tab_unselected_up.png",
			backgroundImageScale9: "5,5,15,15",
			paddingLeft: 5,
			paddingTop: 5,
			paddingBottom: 5,
			paddingRight: 5,
			height: 30,
		});
		
		styles.addStyle("TabBar.tab:over", {
			backgroundImage: "skins/windows/tabs/tab_unselected_over.png",
			backgroundImageScale9: "5,5,15,15",
		});

		styles.addStyle("TabBar.tab:down", {
			backgroundImage: "skins/windows/tabs/tab_selected_up.png",
			backgroundImageScale9: "5,5,15,15",
		});
	}
	
}