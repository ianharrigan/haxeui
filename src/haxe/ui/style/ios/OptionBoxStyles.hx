package haxe.ui.style.ios;
import haxe.ui.style.Styles;

class OptionBoxStyles {
	public function new(styles:Styles) {
		styles.addStyle("OptionBox", {
		});

		styles.addStyle("OptionBox:over", {
		});
		
		styles.addStyle("OptionBox.value", {
			width: 32,
			height: 32,
		});

		styles.addStyle("OptionBox.value.unselected", {
			backgroundImage: "skins/ios/optionbox/optionbox_unselected_up.png",
		});

		styles.addStyle("OptionBox.value.unselected:over", {
			backgroundImage: "skins/ios/optionbox/optionbox_unselected_up.png",
		});

		styles.addStyle("OptionBox.value.unselected:down", {
			backgroundImage: "skins/ios/optionbox/optionbox_unselected_up.png",
		});

		styles.addStyle("OptionBox.value.selected", {
			backgroundImage: "skins/ios/optionbox/optionbox_selected_up.png",
		});
		
		styles.addStyle("OptionBox.value.selected:over", {
			backgroundImage: "skins/ios/optionbox/optionbox_selected_up.png",
		});
		
		styles.addStyle("OptionBox.value.selected:down", {
			backgroundImage: "skins/ios/optionbox/optionbox_selected_up.png",
		});
	}
	
}