package haxe.ui.toolkit.controls.extended;

import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.text.TextField;
import haxe.ui.toolkit.controls.extended.syntax.CodeSyntax;
import haxe.ui.toolkit.controls.TextInput;
import haxe.ui.toolkit.resources.ResourceManager;

class Code extends TextInput {
	private var _syntax:CodeSyntax;
	
	public function new() {
		super();
		multiline = true;
		_textDisplay.wrapLines = false;
		_syntax = CodeSyntax.getSyntax("");
	}
	
	//******************************************************************************************
	// Overrides
	//******************************************************************************************
	private override function initialize():Void {
		super.initialize();
		_textDisplay.display.addEventListener(Event.CHANGE, _onCodeChange);
		_textDisplay.display.addEventListener(KeyboardEvent.KEY_DOWN, _onCodeKeyDown);
		
		applyRules();
	}

	public override function dispose() {
		_textDisplay.display.removeEventListener(Event.CHANGE, _onCodeChange);
		_textDisplay.display.removeEventListener(KeyboardEvent.KEY_DOWN, _onCodeKeyDown);
		super.dispose();
	}
	
	public override function set_text(value:String):String {
		value = super.set_text(value);
		value = StringTools.replace(value, "\r", "");
		value = StringTools.replace(value, "\t", "    ");
		super.set_text(value);
		applyRules();
		return value;
	}
	
	//******************************************************************************************
	// Properties
	//******************************************************************************************
	public var syntax(get, set):String;
	private function get_syntax():String {
		return _syntax.identifier;
	}
	
	private function set_syntax(value:String):String {
		_syntax = CodeSyntax.getSyntax(value);
		applyRules();
		return value;
	}
	
	//******************************************************************************************
	// Event handlers
	//******************************************************************************************
	private function _onCodeChange(event:Event):Void {
		applyRules();
	}
	
	private function _onCodeKeyDown(event:KeyboardEvent):Void {
		if (event.keyCode == 9) {
			var tf:TextField = cast(_textDisplay.display, TextField);
			tf.replaceSelectedText("    ");
			applyRules();
		}
	}
	
	//******************************************************************************************
	// Helpers
	//******************************************************************************************
	private function applyRules() {
		var txt:String = this.text;
		var tf:TextField = cast(_textDisplay.display, TextField);
		if (txt != "") {
			tf.setTextFormat(_syntax.defaultFormat, 0, txt.length);
		}
		for (rule in _syntax.rules.keys()) {
			var r:EReg = new EReg(rule, "g");
			r.map(txt, function(e:EReg):String {
				var pos = e.matchedPos();
				tf.setTextFormat(_syntax.rules.get(rule), pos.pos, pos.pos + pos.len);
				return "";
			});
		}
	}
}