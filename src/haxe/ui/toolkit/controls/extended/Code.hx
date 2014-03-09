package haxe.ui.toolkit.controls.extended;

import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.text.TextField;
import haxe.ui.toolkit.controls.extended.syntax.CodeSyntax;
import haxe.ui.toolkit.controls.TextInput;
import haxe.ui.toolkit.resources.ResourceManager;
import haxe.ui.toolkit.util.pseudothreads.AsyncThreadCaller;
import haxe.ui.toolkit.util.pseudothreads.Runner;

/**
 Simple regex based syntax highlighting component
 **/
class Code extends TextInput {
	private var _syntax:CodeSyntax;
	private var _async:Bool = false;
	
	public function new() {
		super();
		multiline = true;
		wrapLines = false;
		var tf:TextField = cast(_textDisplay.display, TextField);
		#if flash
			tf.alwaysShowSelection = true;
		#end
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
	
	private override function set_text(value:String):String {
		if (value != null) {
			value = super.set_text(value);
			value = StringTools.replace(value, "\t", "    ");
			super.set_text(value);
			applyRules();
		}
		return value;
	}
	
	//******************************************************************************************
	// Properties
	//******************************************************************************************
	/**
	 Syntax to use for highlighting, valid options are:
	
	 * `haxe` - Haxe syntax
	 **/
	public var syntax(get, set):String;
	public var async(get, set):Bool;
	
	private function get_syntax():String {
		return _syntax.identifier;
	}
	
	private function set_syntax(value:String):String {
		_syntax = CodeSyntax.getSyntax(value);
		applyRules();
		return value;
	}
	
	private function get_async():Bool {
		return _async;
	}
	
	private function set_async(value:Bool):Bool {
		_async = value;
		return value;
	}
	
	//******************************************************************************************
	// Event handlers
	//******************************************************************************************
	private function _onCodeChange(event:Event):Void {
		applyRules();
	}
	
	private function _onCodeKeyDown(event:KeyboardEvent):Void {
		if (event.keyCode == 9 && event.ctrlKey == false && event.altKey == false && event.shiftKey == false) {
			replaceSelectedText("    ");
			applyRules();
		}
	}
	
	//******************************************************************************************
	// Helpers
	//******************************************************************************************
	private var _caller:AsyncThreadCaller;
	
	private function applyRules() {
		var tf:TextField = cast(_textDisplay.display, TextField);
		if (_async == false) {
			var runner:SyntaxHighlightRunner = new SyntaxHighlightRunner(tf, _syntax);
			runner.needToExit = function() { return false; }
			runner.run();
		} else {
			if (_caller != null) {
				_caller.cancel();
			}
			
			_caller = new AsyncThreadCaller(new SyntaxHighlightRunner(tf, _syntax));
			_caller.start();
		}
	}
}

private class SyntaxHighlightRunner extends Runner {
	private var _tf:TextField;
	private var _syntax:CodeSyntax;
	private var _syntaxRules:Array<String>;
	private var _matches:Map<String, Array<Dynamic>>;
	private var _txt:String;
	private var _matchedSyntax:Bool = false;
	private var _matchIndex:Int = 0;
	
	public function new(tf:TextField, syntax:CodeSyntax, timeShare:Float = .9) {
		super();
		_tf = tf;
		_syntax = syntax;
		_runningTimeShare = timeShare;

		_syntaxRules = new Array<String>();
		for (rule in _syntax.rules.keys()) {
			_syntaxRules.push(rule);
		}
		_matches = new Map<String, Array<Dynamic>>();
		_txt = tf.text;
		if (_txt != "") {
			tf.setTextFormat(_syntax.defaultFormat, 0, _txt.length);
		}
	}
	
	private var _ruleIndex:Int = 0;
	
	public override function run() {
		if (_matchedSyntax == false) {
			for (n in _ruleIndex..._syntaxRules.length) {
				if (_needToExit() == true) {
					_ruleIndex = n;
					return;
				}
				
				var rule:String = _syntaxRules[n];
				var matches:Array<Dynamic> = new Array<Dynamic>();
				_matches.set(rule, matches);
				var r:EReg = _syntax.getCompiledRule(rule);
				r.map(_txt, function(e:EReg):String {
					var pos = e.matchedPos();
					matches.push(pos);
					return "";
				});
			}
			_ruleIndex = 0;
			_matchedSyntax = true;
		}
		
		if (_matchedSyntax == true) {
			for (n in _ruleIndex..._syntaxRules.length) {
				if (_needToExit() == true) {
					_ruleIndex = n;
					return;
				}
				
				var rule:String = _syntaxRules[n];
				var matches:Array<Dynamic> = _matches.get(rule);
				for (m in _matchIndex...matches.length) {
					if (_needToExit() == true) {
						_ruleIndex = n;
						_matchIndex = m;
						return;
					}
					
					var match:Dynamic = matches[m];
					_tf.setTextFormat(_syntax.rules.get(rule), match.pos, match.pos + match.len);
				}
				
				_matchIndex = 0;
			}
		}

		_needToExit = null;
		_isComplete = true;
	}
}