package locator.internal;

#if macro
import haxe.macro.Compiler;

class Initialization {
	/**
		Initialization macro for locator.

		Sets compilation flag `locator_debug` if it is not set and `debug` is set.
	**/
	static function run() {
		#if (debug && !locator_debug)
		Compiler.define("locator_debug", "1");
		#end

		#if !locator_windows
		if (Sys.systemName() == "Windows")
			Compiler.define("locator_windows", "1");
		#end
	}
}
#end
