@echo OFF
IF "%~1"=="" GOTO install
IF "%~1"=="bundle" GOTO bundle
IF "%~1"=="build" GOTO build
IF "%~1"=="install" GOTO install
IF "%~1"=="submit" GOTO submit


:bundle
	echo Bundling HaxeUI
	neko haxebundler.n bundle -openfl
	neko haxebundler.n bundle -haxelib
GOTO end

:build
	echo Bundling HaxeUI
	neko haxebundler.n bundle -openfl
	neko haxebundler.n bundle -haxelib
	
	echo Building HaxeUI haxelib

	del bin\haxeui.zip
	7za a bin\haxeui.zip haxelib.json include.xml assets haxe
GOTO end

:install
	echo Bundling HaxeUI
	neko haxebundler.n bundle -openfl
	neko haxebundler.n bundle -haxelib
	
	echo Installing HaxeUI haxelib

	del bin\haxeui.zip
	7za a bin\haxeui.zip haxelib.json include.xml assets haxe

	haxelib local bin\haxeui.zip
GOTO end

:submit
	echo Bundling HaxeUI
	neko haxebundler.n bundle -openfl
	neko haxebundler.n bundle -haxelib
	
	echo Submitting HaxeUI haxelib

	del bin\haxeui.zip
	7za a bin\haxeui.zip haxelib.json include.xml assets haxe

	haxelib local bin\haxeui.zip
	
	haxelib submit bin\haxeui.zip
GOTO end


:end
echo Complete