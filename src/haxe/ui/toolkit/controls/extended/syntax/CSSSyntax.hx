package haxe.ui.toolkit.controls.extended.syntax;

class CSSSyntax extends CodeSyntax {
	public function new() {
		super();
		_identifier = "css";
		addRule("(#|\\w|.)(.*?){|}", 0x0000FF, true);
		addRule("(\\w*)\\:", 0x3A99FF, true);
		addRule(":(.*?)\\;", 0x880000);
	}
	
}