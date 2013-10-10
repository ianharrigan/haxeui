package haxe.ui.toolkit.controls.extended.syntax;

class HaxeSyntax extends CodeSyntax {
	public function new() {
		super();
		_identifier = "haxe";
		addRule("(class )|(extends )|(implements )|(function)|(package )|(import )|(var )|(null)|(if)|(while)|(trace)|(return)", 0x0000FF);
		addRule("(public )|(private )|(static )|(Void)|(Bool)|(Int)|(Dynamic)|(String)|(Float)", 0x3A99FF);
		addRule("(?:#.*)", 0x888888);
		addRule("(?:/\\*(?:[^*]|(?:\\*+[^*/]))*\\*+/)|(?://.*)", 0x008800);
		
		/*
		addRule("class ", 0x0000FF);
		addRule("extends ", 0x0000FF);
		addRule("function ", 0x0000FF);
		addRule("package ", 0x0000FF);
		addRule("import ", 0x0000FF);
		addRule("var ", 0x0000FF);
		addRule("null", 0x0000FF);
		addRule("if", 0x0000FF);
		addRule("while", 0x0000FF);
		addRule("trace", 0x0000FF);
		addRule("return", 0x0000FF);
		
		addRule("public ", 0x3A99FF);
		addRule("private ", 0x3A99FF);
		addRule("static ", 0x3A99FF);
		addRule("Void", 0x3A99FF);
		addRule("Bool", 0x3A99FF);
		addRule("Int", 0x3A99FF);
		addRule("Dynamic", 0x3A99FF);
		addRule("String", 0x3A99FF);
		addRule("Float", 0x3A99FF);
		*/
	}
}