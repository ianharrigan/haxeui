Haxe UI (Formerly <a href="https://github.com/ianharrigan/yahui">YAHUI</a>)
================================
Cross platfrom Haxe/OpenFL set of styleable application centric rich UI components to be used "out the box". Supports css type styling/skinning.

<img src="https://raw.github.com/ianharrigan/haxeui-test-app/master/docs/screenshots/main.jpg" />
<img src="https://raw.github.com/ianharrigan/haxeui-test-app/master/docs/screenshots/extended.jpg" />

<a href="https://github.com/ianharrigan/haxeui-test-app/blob/master/docs/demo/haxeuitestapp.swf?raw=true">Compiled SWF demo</a> (May be out of date)

<a href="https://github.com/ianharrigan/haxeui-test-app">Test App</a> (Used in demo/screenshots)

<a href="https://github.com/ianharrigan/hui-irc-threadtest">IRC client test app</a>

<a href="https://github.com/ianharrigan/haxeui/tree/master/samples">Samples</a>

Instructions
-------------------------
First install haxeui via haxelib:
```
haxelib install haxeui
```

Once installed add 
```
<haxelib name="haxeui" />
```
to your openfl application.xml. Finally, create a basic application with:
	
```haxe
import haxe.ui.toolkit.core.Macros;
import haxe.ui.toolkit.core.Toolkit;
import haxe.ui.toolkit.core.Root;
import haxe.ui.toolkit.controls.Button;

class Main {
	public static function main() {
		Macros.addStyleSheet("styles/gradient/gradient.css");
		Toolkit.init();
		Toolkit.openFullscreen(function(root:Root) {
			var button:Button = new Button();
			button.text = "HaxeUI!";
			root.addChild(button);
		});
	}
}
```

Note: haxeui comes with some styles ready for use, if no styles are added a default one is used.

Components
-------------------------
General components

- Button
- Check box
- Image
- Option box
- Progress bars (horizontal & vertical)
- Scroll bars (horizontal & vertical)
- Sliders (horizontal & vertical)
- Tab bars
- Text (static, input, multiline)
- List selection (drop downs, popup lists)
- Date selection (drop downs, popup calendar)
- Calendar 
- Menus

Extended components

 - Code editor (supports basic syntax highlighting)
 - RTF edtior (preliminary, only fully functional in flash due to neko/cpp limitations)

Layout, position and containment components

- Accordion
- Grid
- HBox
- ListView
- MenuBar
- ScrollView
- Stack
- TabView
- VBox

Popups
- Busy
- Simple
- List
- Custom
- Calendar

Data Sources
- Array
- JSON
- XML
- MySQL (Neko/Read-Only)
- Files (Neko/Read-Only)

Notes
-------------------------
html5 is still being tested, but functions to a degree.


Licence
-------------------------
    Unless indicated otherwise, this code was created by Ian Harrigan and
    provided under a MIT-style license. 
    Copyright (c) Ian Harrigan. All rights reserved.

    Permission is hereby granted, free of charge, to any person obtaining a 
    copy of this software and associated documentation files (the "Software"),
    to deal in the Software without restriction, including without limitation
    the rights to use, copy, modify, merge, publish, distribute, sublicense,
    and/or sell copies of the Software, and to permit persons to whom the
    Software is furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included
    in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL 
    THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
    THE SOFTWARE.