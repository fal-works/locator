package locator;

/**
	Value referring to an existing file.
**/
@:notNull
@:forward(
	toString,
	getParentPath,
	getName,
	getExtension,
	getNameWithoutExtension
)
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
		Throws error if the file does not exist.
	**/
	@:from public static extern inline function fromPath(path: FilePath): FileRef {
		#if !locator_validation_disable
		if (!path.exists())
			throw "File not found: " + path;
		#end
		return new FileRef(path);
	}

	/**
		Creates a `FileRef` value without checking if the file exists.
	**/
	public static extern inline function fromPathUnsafe(path: FilePath): FileRef
		return new FileRef(path);

	/**
		Creates a `FileRef` value from a string.
		Throws error if the file does not exist.
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
		Copies `this` file to `destinationFilePath`.
		Overwrites the destination file if it already exists.
		@param prepareDirectory If `true`, creates the destination directory if absent.
		@return New `FileRef` value for the destination file.
	**/
	public extern inline function copy(
		destinationFilePath: FilePath,
		prepareDirectory = true
	): FileRef {
		if (prepareDirectory) {
			final destination = destinationFilePath.getParentPath();
			if (!destination.exists()) destination.createDirectory();
		}

		File.copy(this, destinationFilePath);
		return new FileRef(destinationFilePath);
	}

	/**
		Copies `this` file to `destinationPath` with the same file name.
		Overwrites the destination file if it already exists.
		@param prepareDirectory If `true`, creates the destination directory if absent.
		@return New `FileRef` value for the destination file.
	**/
	public extern inline function copyTo(
		destinationPath: DirectoryPath,
		prepareDirectory = true
	): FileRef {
		if (prepareDirectory && !destinationPath.exists())
			destinationPath.createDirectory();

		final destinationFilePath = destinationPath.makeFilePath(this.getName());

		File.copy(this, destinationFilePath);
		return new FileRef(destinationFilePath);
	}

	/**
		@return The parent directory of `this`.
	**/
	@:access(locator.DirectoryRef)
	public extern inline function getParent(): DirectoryRef {
		return new DirectoryRef(this.getParentPath());
	}

	/**
		For internal use.
		Creates `FileRef` without checking existence.
	**/
	extern inline function new(path: FilePath)
		this = path;

	extern inline function get_path(): FilePath
		return this;
}
