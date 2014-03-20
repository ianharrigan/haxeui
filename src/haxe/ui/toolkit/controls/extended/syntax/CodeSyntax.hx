package haxe.ui.toolkit.controls.extended.syntax;

import flash.text.TextFormat;

class CodeSyntax {
	private var _rules:Map<String, TextFormat>;
	private var _compiledRules:Map<String, EReg>;
	private var _defaultFormat:TextFormat;
	private var _identifier:String;
	
	public function new() {
		_identifier = "";
		_rules = new Map<String, TextFormat>();
		_compiledRules = new Map<String, EReg>();
		_defaultFormat = new TextFormat("_typewriter", 13, 0x000000);
	}
	
	public function addRule(regex:String, color:Int, bold:Bool = false):Void {
		var f:TextFormat = new TextFormat(_defaultFormat.font, _defaultFormat.size, color);
		f.bold = bold;
		_rules.set(regex, f);
	}	
	
	public static function getSyntax(id:String):CodeSyntax {
		var syntax:CodeSyntax = new CodeSyntax();
		if (id == "haxe") {
			syntax = new HaxeSyntax();
		} else if (id == "xml") {
			syntax = new XMLSyntax();
		} else if (id == "css") {
			syntax = new CSSSyntax();
		}
		return syntax;
	}
	
	//******************************************************************************************
	// Getters/Setters
	//******************************************************************************************
	public var identifier(get, null):String;
	public var defaultFormat(get, set):TextFormat;
	public var rules(get, null):Map<String, TextFormat>;
	
	private function get_identifier():String {
		return _identifier;
	}
	
	private function get_defaultFormat():TextFormat {
		return _defaultFormat;
	}
	
	private function set_defaultFormat(value:TextFormat):TextFormat {
		_defaultFormat = value;
		return value;
	}
	
	private function get_rules():Map<String, TextFormat> {
		return _rules;
	}
	
	//******************************************************************************************
	// Helpers
	//******************************************************************************************
	public function getCompiledRule(rule:String):EReg {
		var r:EReg = _compiledRules.get(rule);
		if (r == null) {
			r = new EReg(rule, "g");
			_compiledRules.set(rule, r);
		}
		return r;
	}
	
}