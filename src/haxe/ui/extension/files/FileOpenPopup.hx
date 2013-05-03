package haxe.ui.extension.files;

import haxe.ui.containers.HBox;
import haxe.ui.containers.ListView;
import haxe.ui.containers.VBox;
import haxe.ui.controls.Button;
import haxe.ui.controls.Label;
import haxe.ui.controls.TextInput;
import haxe.ui.core.Root;
import haxe.ui.popup.Popup;
import nme.events.Event;
import nme.events.MouseEvent;

#if !(flash)
import sys.FileSystem;
#end

class FileOpenPopup extends Popup {
	private var fileNameInput:TextInput;
	private var fileList:ListView;
	private var selectButton:Button;
	private var cancelButton:Button;
	private var upButton:Button;
	private var currentDirLabel:Label;
	public var fnCallback:Dynamic->Void;
	
	private var currentDir:String;

	public function new(dir:String = null) {
		super();
		title = "Select File";
		currentDir = dir;
		#if !(flash)
		if (currentDir == null) {
			currentDir = Sys.getCwd();
		}
		#end
		currentDir = fixDir(currentDir);
		
		#if !(flash)
		try {
			if (isDir(currentDir) == false) {
				currentDir = fixDir(Sys.getCwd());
			}
		} catch (e:Dynamic) {
			trace(e);
		}
		#end
	}
	
	//************************************************************
	//                  OVERRIDES
	//************************************************************
	public override function initialize():Void {
		super.initialize();
		
		 // create ui manually, no xml dependancies
		var vbox:VBox = new VBox();
		vbox.percentWidth = vbox.percentHeight = 100;
			
		#if !(flash)
		{
			var hbox:HBox = new HBox();
			hbox.percentWidth  = 100;
			
			upButton = new Button();
			upButton.text = "Up";
			upButton.addEventListener(MouseEvent.CLICK, onUp);
			hbox.addChild(upButton);
			
			var label:Label = new Label();
			label.text = "Current Dir:";
			label.verticalAlign = "center";
			hbox.addChild(label);
			
			currentDirLabel = new Label();
			currentDirLabel.text = currentDir;
			currentDirLabel.verticalAlign = "center";
			hbox.addChild(currentDirLabel);

			vbox.addChild(hbox);
		}
		
		{
			fileList = new ListView();
			fileList.percentWidth = fileList.percentHeight = 100;
			vbox.addChild(fileList);
			fileList.addEventListener(Event.CHANGE, function (e:Event) {
				var li:ListViewItem = fileList.getListItem(fileList.selectedIndex);
				fileNameInput.text = li.text;
			});
			fileList.addEventListener(MouseEvent.DOUBLE_CLICK, function (e:MouseEvent) {
				onOpen(e);
			});
		}
		#end
		
		
		{
			var hbox:HBox = new HBox();
			hbox.percentWidth  = 100;
			fileNameInput = new TextInput();
			fileNameInput.percentWidth = 100;
			hbox.addChild(fileNameInput);
			
			selectButton = new Button();
			selectButton.text = "Open";
			selectButton.addEventListener(MouseEvent.CLICK, onOpen);
			hbox.addChild(selectButton);

			cancelButton = new Button();
			cancelButton.text = "Cancel";
			cancelButton.addEventListener(MouseEvent.CLICK, function(e) {
				Popup.hidePopup(this);
				if (fnCallback != null) {
					fnCallback(null);
				}
			});
			hbox.addChild(cancelButton);
			
			vbox.addChild(hbox);
		}
		
		content.addChild(vbox);
		
		#if !(flash) 
			height = 300;
		#else
			height = content.layout.padding.top + content.layout.padding.bottom + content.height;
		#end
		
		refreshList();
	}
	
	private function refreshList():Void {
		#if !(flash)
		//fileList.enabled = false;
		
		if (fileList.dataSource.moveFirst()) { // TODO: data sources should have a removeAll function or similar
			do {
				fileList.dataSource.remove();
			} while (fileList.dataSource.moveFirst());
		}
		
		currentDirLabel.text = currentDir;
		if (isDir(currentDir)) {
			var files:Array<String> = FileSystem.readDirectory(currentDir);
			
			for (file in files) {
				if (FileSystem.isDirectory(currentDir + "/" + file)) { // add dirs first
//					trace("DIR = " + file);
					fileList.dataSource.add({text: file, id: "dir"});
				}
			}
			
			for (file in files) {
				if (!FileSystem.isDirectory(currentDir + "/" + file)) { // add dirs first
//					trace("FILE = " + file);
					fileList.dataSource.add({text: file, id: getFileId(file)});
				}
			}
		} else {
			trace("Its not a dir!");
		}
		
		fileList.selectedIndex = -1;
		fileNameInput.text = "";
		fileList.vscrollPosition = 0;
		
		//fileList.enabled = true; // TODO: problem with reenabling list items, events lost
		#end
	}
	
	private function onUp(event:MouseEvent):Void {
		var arr:Array<String> = currentDir.split("/");
		var s:String = arr.pop();
		var newPath:String;
		if (arr.length == 1) {
			newPath = fixDir(arr[0]) + "/"; // root
		} else {
			newPath = arr.join("/");
		}
		currentDir = fixDir(newPath);
		refreshList();
	}
	
	private function onOpen(event:MouseEvent):Void {
		#if !(flash)
		var li:ListViewItem = fileList.getListItem(fileList.selectedIndex);
		if (FileSystem.isDirectory(currentDir + "/" + li.text)) {
			currentDir = currentDir + "/" + li.text;
			refreshList();
		} else {
			Popup.hidePopup(this);
			if (fnCallback != null) {
				fnCallback(li.text);
			}
		}
		#end
	}
	
	private function isDir(dir:String):Bool { // neko throws an exception on isDirectory, so move to a safer function
		var isDir:Bool = false;
		
		#if !(flash)
		try {
			if (isRoot(dir)) {
				dir += "/";
			}
			isDir = FileSystem.isDirectory(dir);
		} catch (ex:Dynamic) {
			isDir = false;
		}
		#end
		
		return isDir;
	}
	
	private function isRoot(dir:String):Bool {
		var isRoot:Bool = false;
		
		#if !(flash)
		isRoot = dir.split("/").length == 1;
		#end
		
		return isRoot;
	}
	
	private function fixDir(dir:String):String {
		if (dir == null) {
			return "";
		}
		
		var fixedDir:String = dir;
		fixedDir = StringTools.replace(fixedDir, "\\", "/");
		
		if (fixedDir.lastIndexOf("/") == fixedDir.length-1 || fixedDir.lastIndexOf("\\") == fixedDir.length-1) {
			fixedDir = fixedDir.substr(0, fixedDir.length - 1);
		}
		
		return fixedDir;
	}
	
	private function getFileId(file:String):String {
		var s:String = "file";
		var n:Int = file.indexOf(".");
		if (n != -1) {
			var ext:String = file.substr(n + 1, file.length);
			ext = ext.toLowerCase();
			if (ext == "exe") {
				s = "app";
			} else if (ext == "jpg" || ext == "jpeg" || ext == "png" || ext == "bmp") {
				s = "image";
			} else if (ext == "txt") {
				s = "text";
			} else if (ext == "avi" || ext == "mpeg" || ext == "mpg") {
				s = "video";
			}
		}
		return s;
	}
	
	public static function show(root:Root, dir:String = null, fnCallback:Dynamic->Void = null):FileOpenPopup {
		var popup:FileOpenPopup = new FileOpenPopup(dir);
		popup.fnCallback = fnCallback;
		popup.root = root;
		Popup.showPopup(popup);
		Popup.centerPopup(popup);
		return popup;
	}
}