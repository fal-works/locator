package locator;

/**
	Value referring to an existing file.
**/
@:notNull
@:forward(getDirectoryPath, getName, getExtension)
abstract FileRef(FilePath) {
	/**
		Callback function for `FileRef.from()`.
	**/
	public static final createCallback = (path: FilePath) -> FileRef.from(path);

	/**
		Callback function for `FileRef.from(s: String)`.
	**/
	public static final fromStringCallback = (s: String) -> FileRef.from(s);

	/**
		Creates a `FileRef` value.
		Throws error if the file does not exist.
	**/
	@:from public static extern inline function from(path: FilePath) {
		#if locator_debug
		if (!path.exists())
			throw "File not found: " + path;
		#end
		return new FileRef(path);
	}

	/**
		The path of `this` file.
	**/
	public var path(get, never): FilePath;

	/**
		@return The content of `this` file as `String`.
	**/
	public extern inline function getContent(): String
		return File.getContent(this);

	/**
		Saves `content` in `this` file.
	**/
	public extern inline function saveContent(content: String): Void
		return File.saveContent(this, content);

	/**
		Copies `this` file to `destinationPath`.
		Overwrites the destination file if it already exists.
		@return New `FileRef` value for the destination file.
	**/
	public extern inline function copy(destinationPath: FilePath): FileRef {
		File.copy(this, destinationPath);
		return new FileRef(destinationPath);
	}

	/**
		@return The directory where `this` file is located.
	**/
	@:access(locator.DirectoryRef)
	public extern inline function getDirectory(): DirectoryRef {
		return new DirectoryRef(this.getDirectoryPath());
	}

	/**
		@return The path of `this` file as `String`.
	**/
	public extern inline function toString(): String
		return this;

	/**
		For internal use.
		Creates `FileRef` without checking existence.
	**/
	extern inline function new(path: FilePath)
		this = path;

	extern inline function get_path(): FilePath
		return this;
}
