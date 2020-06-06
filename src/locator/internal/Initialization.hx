package locator.internal;

#if macro
import haxe.macro.Compiler;

class Initialization {
	/**
		Initialization macro for locator.
	**/
	static function run() {
		#if !locator_windows
		if (Sys.systemName() == "Windows")
			Compiler.define("locator_windows", "1");
		#end
	}
}
#end
