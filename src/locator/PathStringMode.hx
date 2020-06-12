package locator;

import greeter.Cli;
import greeter.CliType;
import locator.implementation.PathStringModeInstances;

/**
	Mode of `PathString`.

	@see `PathString.mode`
**/
@:structInit
class PathStringMode {
	/**
		Unix mode. Uses slash as delimiter.
	**/
	public static var unix(get, never): PathStringMode;

	/**
		DOS mode. Uses backslash as delimiter.
	**/
	public static var dos(get, never): PathStringMode;

	static extern inline function get_unix()
		return PathStringModeInstances.unix;

	static extern inline function get_dos()
		return PathStringModeInstances.dos;

	/**
		The CLI which `this` mode corresponds to.
	**/
	public final cli: Cli;

	/**
		The type of `cli`.
	**/
	public final cliType: CliType;

	/**
		Delimiter character of path string.
	**/
	public final delimiter: String;

	/**
		Delimiter character code of path string.
	**/
	public final delimiterCode: Int;

	function new(
		cli: Cli,
		cliType: CliType,
		delimiter: String,
		delimiterCode: Int
	) {
		this.cli = cli;
		this.cliType = cliType;
		this.delimiter = delimiter;
		this.delimiterCode = delimiterCode;
	}
}
