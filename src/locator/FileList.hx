package locator;

private typedef Data = Array<FileRef>;

/**
	Array of `FileRef`.
**/
@:notNull @:forward @:transitive
abstract FileList(Data) from Data to Data {
	/**
		Casts `Array<FileRef>` to `FileList` explicitly.
	**/
	public static extern inline function from(array: Data): FileList
		return array;

	@:from static extern inline function fromStdArray(array: std.Array<FileRef>): FileList
		return from(array);

	/**
		Casts `this` to `Array<FileRef>` explicitly.
	**/
	public extern inline function array(): Data
		return this;

	/**
		@return New list of file names without directory paths.
	**/
	public inline function getNames(): Array<String>
		return this.map(file -> file.getName());

	/**
		Copies all files in `this` list to `destination` with the same file names.
		Overwrites destination files if they already exist.
		@param prepareDirectory If `true`, creates the destination directory if absent.
		@return New list of files after copied.
	**/
	@:access(locator.FileRef)
	public inline function copyTo(
		destinationPath: DirectoryPath,
		prepareDirectory = true
	): FileList {
		if (prepareDirectory && !destinationPath.exists())
			destinationPath.createDirectory();

		final newFiles: FileList = [];
		for (i in 0...this.length) {
			final file = this[i];
			final destinationFilePath = destinationPath.makeFilePath(file.getName());
			File.copy(file.path, destinationFilePath);
			newFiles.push(new FileRef(destinationFilePath));
		}
		return newFiles;
	}
}
