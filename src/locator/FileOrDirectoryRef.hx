package locator;

/**
	Value that specifies either a file or a directory.
**/
abstract FileOrDirectoryRef(Data) from Data {
	/**
		Callback function for `FileOrDirectoryRef.fromFile()`.
	**/
	public static final fromFileCallback = (ref: FileRef) -> fromFile(ref);

	/**
		Callback function for `FileOrDirectoryRef.fromDirectory()`.
	**/
	public static final fromDirectoryCallback = (ref: DirectoryRef) -> fromDirectory(ref);

	/**
		Callback function for `FileOrDirectoryRef.fromPath()`.
	**/
	public static final fromPathCallback = (path: PathString) -> fromPath(path);

	/**
		Callback function for `FileOrDirectoryRef.fromPath(s: String)`.
	**/
	public static final fromStringCallback = (s: String) -> fromPath(s);

	/**
		Callback function for `FileOrDirectoryRef.toDirectory()`.
	**/
	public static final toDirectoryCallback = (
		ref: FileOrDirectoryRef
	) -> ref.toDirectory();

	/**
		Converts `ref` to `FileOrDirectoryRef`.
	**/
	@:from public static extern inline function fromFile(ref: FileRef): FileOrDirectoryRef
		return File(ref);

	/**
		Converts `ref` to `FileOrDirectoryRef`.
	**/
	@:from public static extern inline function fromDirectory(
		ref: DirectoryRef
	): FileOrDirectoryRef
		return Directory(ref);

	/**
		Converts `path` to `FileOrDirectoryRef`.
		Throws error if neither a file nor a directory is found.
	**/
	@:from public static extern inline function fromPath(
		path: PathString
	): FileOrDirectoryRef {
		return if (FilePath.from(path)
			.exists()) FileRef.fromPath(path) else if (DirectoryPath.from(path)
			.exists()) DirectoryRef.fromPath(path) else
			throw 'File or directory not found: $path';
	}

	/**
		Unifies `this` to a file path.
		@param defaultRelativePath Used if `this` is `Directory`.
	**/
	public extern inline function toFilePath(defaultRelativePath: String): FilePath {
		return switch this {
			case File(ref): ref.path;
			case Directory(ref): ref.makeFilePath(defaultRelativePath);
		}
	}

	/**
		Unifies `this` to a directory.
		If `this` is `File`, the parent directory is returned.
	**/
	@:to public extern inline function toDirectory(): DirectoryRef {
		return switch this {
			case File(ref): ref.getParent();
			case Directory(ref): ref;
		}
	}
}

private enum Data {
	File(path: FileRef);
	Directory(path: DirectoryRef);
}
