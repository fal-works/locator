package locator.internal;

/**
	Static extension for `String`.
**/
class StringExtension {
	public static extern inline function endsWithCharCode(s: String, code: Int): Bool
		return s.charCodeAt(s.length - 1) == code;
}
