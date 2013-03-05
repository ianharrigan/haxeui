package haxe.ui.style.windows;
import haxe.ui.style.Styles;

class OptionBoxStyles {
	public function new(styles:Styles) {
		styles.addStyle("OptionBox", {
			xxxxbackgroundColor: 0xFF00FF,
			color: 0x000000,
			paddingLeft: 3,
			paddingRight: 3,
			paddingBottom: 3,
			paddingTop: 3,
		});

		styles.addStyle("OptionBox:over", {
			xxxbackgroundColor: 0x880088,
			xxxcolor: 0xFFFFFF,
		});
		
		styles.addStyle("OptionBox.value", {
			xxxxbackgroundColor: 0xFFFFFF,
			paddingLeft: 3,
			paddingRight: 3,
			paddingBottom: 3,
			paddingTop: 3,
			width: 12,
			height: 12,
		});

		styles.addStyle("OptionBox.value.unselected", {
			backgroundImage: "skins/windows/optionbox/optionbox_unselected_up.png",
		});

		styles.addStyle("OptionBox.value.unselected:over", {
			backgroundImage: "skins/windows/optionbox/optionbox_unselected_over.png",
		});

		styles.addStyle("OptionBox.value.unselected:down", {
			backgroundImage: "skins/windows/optionbox/optionbox_unselected_over.png",
		});

		styles.addStyle("OptionBox.value.selected", {
			backgroundImage: "skins/windows/optionbox/optionbox_selected_up.png",
		});
		
		styles.addStyle("OptionBox.value.selected:over", {
			backgroundImage: "skins/windows/optionbox/optionbox_selected_over.png",
		});
		
		styles.addStyle("OptionBox.value.selected:down", {
			backgroundImage: "skins/windows/optionbox/optionbox_selected_over.png",
		});
	}
	
}