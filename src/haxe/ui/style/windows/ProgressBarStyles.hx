package haxe.ui.style.windows;

class ProgressBarStyles {
	public function new(styles:Styles) {
		styles.addStyle("ProgressBar", {
			width: 100,
			height: 15,
			paddingLeft: 1,
			paddingTop: 1,
			paddingBottom: 1,
			paddingRight: 1,
			backgroundImage: "skins/windows/progress/progress_background.png",
			backgroundImageScale9: "5,5,185,10",
		});

		styles.addStyle("ProgressBar.value", {
			backgroundImage: "skins/windows/progress/progress_value.png",
			backgroundImageScale9: "5,5,183,8",
		});
	}
	
}