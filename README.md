Haxe UI (Formerly <a href="https://github.com/ianharrigan/yahui">YAHUI</a>)
================================
Cross platform/target set of styleable rich UI components for Haxe NME intended to be used "out the box".

<img src="https://raw.github.com/ianharrigan/haxeui/master/docs/screenshots/main.jpg" />

<a href="https://github.com/ianharrigan/haxeui/blob/master/docs/demo/YAHUI.swf?raw=true">Compiled demo</a> (May be out of date)

<a href="https://github.com/ianharrigan/hui-irc-threadtest">IRC client test app</a> (Only tested on cpp targets because of multithreading)

Components
-------------------------
General components

- Button
- CheckBox
- DropDownList (method is style dependent, eg: "popup")
- HScroll
- Image
- Label
- OptionBox
- ProgressBar
- RatingControl
- Selector
- TabBar
- TextInput (can also be used as text area with TextInput.multiline)
- ValueControl
- VScroll

Layout, position and containment components

- HBox
- VBox
- ListView
- ScrollView
- TabView

Popups
- SimplePopup
- ListPopup

Notes
-------------------------
The html5 target works to a point, however, scroll views, list views, text inputs do not currently work due to limitations.


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