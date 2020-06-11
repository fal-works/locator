package locator;

/**
	Value that specifies either a file or a directory.
**/
abstract FileOrDirectoryRef(Data) from Data {
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
	@:to public extern inline function toDirectoryRef(): DirectoryRef {
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
