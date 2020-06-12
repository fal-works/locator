package locator.implementation;

import greeter.Cli;
import greeter.CliType;

/**
	Set of `PathString` instances.
**/
@:structInit
@:access(locator.PathStringMode)
class PathStringModeInstances {
	public static final unix: PathStringMode = {
		cli: Cli.unix,
		cliType: CliType.Unix,
		delimiter: "/",
		delimiterCode: "/".code
	};

	public static final dos: PathStringMode = {
		cli: Cli.dos,
		cliType: CliType.Dos,
		delimiter: "\\",
		delimiterCode: "\\".code
	};

	/**
		@return The `PathStringMode` instance that corresponds to `cliType`.
	**/
	public static inline function get(cliType: CliType): PathStringMode {
		return switch cliType {
			case Unix: unix;
			case Dos: dos;
		};
	}
}
