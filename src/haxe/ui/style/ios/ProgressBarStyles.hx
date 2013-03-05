package haxe.ui.style.ios;
import haxe.ui.style.Styles;

class ProgressBarStyles {
	public function new(styles:Styles) {
		styles.addStyle("ProgressBar", {
			width: 100,
			height: 15,
			paddingLeft: 0,
			paddingTop: 0,
			paddingBottom: 0,
			paddingRight: 0,
			backgroundImage: "skins/ios/progress/progress_background.png",
			backgroundImageScale9: "5,5,185,10",
		});

		styles.addStyle("ProgressBar.value", {
			backgroundImage: "skins/ios/progress/progress_value.png",
			backgroundImageScale9: "5,5,185,10",
		});
	}
}