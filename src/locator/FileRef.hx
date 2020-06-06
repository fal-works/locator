package locator;

/**
	Value referring to an existing file.
**/
@:notNull
@:forward(getParentPath, getName, getExtension)
abstract FileRef(FilePath) {
	/**
		Callback function for `FileRef.from()`.
	**/
	public static final createCallback = (path: FilePath) -> FileRef.fromPath(path);

	/**
		Callback function for `FileRef.from(s: String)`.
	**/
	public static final fromStringCallback = (s: String) -> FileRef.from(s);

	/**
		Creates a `FileRef` value.

		(`#if locator_debug`) Throws error if the file does not exist.
	**/
	@:from public static extern inline function fromPath(path: FilePath): FileRef {
		#if locator_debug
		if (!path.exists())
			throw "File not found: " + path;
		#end
		return new FileRef(path);
	}

	/**
		Creates a `FileRef` value from a string.

		(`#if locator_debug`) Throws error if the file does not exist.
	**/
	public static extern inline function from(s: String): FileRef
		return fromPath(FilePath.from(s));

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
		Copies `this` file to `destination` with the same file name.
		Overwrites the destination file if it already exists.
		@return New `FileRef` value for the destination file.
	**/
	public extern inline function copyTo(destination: DirectoryRef): FileRef {
		final destinationPath = destination.makeFilePath(this.getName());
		File.copy(this, destinationPath);
		return new FileRef(destinationPath);
	}

	/**
		@return The parent directory of `this`.
	**/
	@:access(locator.DirectoryRef)
	public extern inline function getParent(): DirectoryRef {
		return new DirectoryRef(this.getParentPath());
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
