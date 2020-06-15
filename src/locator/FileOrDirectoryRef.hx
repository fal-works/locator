package locator;

/**
	Value that specifies either a file or a directory.
**/
abstract FileOrDirectoryRef(Data) from Data to Data {
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
		@return `String` representation of `this`.
	**/
	@:to public inline function toString(): String {
		return switch this {
			case File(ref): ref.toString();
			case Directory(ref): ref.toString();
		}
	}

	/**
		@return The name of the file/directory specified by `this` path.
	**/
	public extern inline function getName(): String {
		return switch this {
			case File(ref): ref.getName();
			case Directory(ref): ref.getName();
		}
	}

	/**
		Converts `path` to `FileOrDirectoryRef`.
		Throws error if neither a file nor a directory is found.
	**/
	@:from public static function fromPath(path: PathString): FileOrDirectoryRef {
		try {
			if (FileSystem.isDirectory(path))
				return DirectoryRef.fromPath(path);
		} catch (e:Dynamic) {}
		return if (FilePath.from(path).exists()) {
			FileRef.fromPath(path);
		} else throw 'File or directory not found: $path';
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

	/**
		@return Enum representation of `this`.
	**/
	public extern inline function toEnum(): Data
		return this;
}

private enum Data {
	File(ref: FileRef);
	Directory(ref: DirectoryRef);
}
