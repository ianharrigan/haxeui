copy ..\haxelib.json .\
copy ..\include.xml .\
del haxeui.zip
7za a haxeui.zip haxelib.json include.xml ../assets/styles ../assets/img ../assets/fonts ../src/haxe