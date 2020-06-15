package locator;

private typedef Data = Array<FileRef>;

/**
	Array of `FileRef`.
**/
@:notNull @:forward
abstract FileList(Data) from Data to Data {
	/**
		Casts `Array<FileRef>` to `FileList` explicitly.
	**/
	public static extern inline function from(array: Data): FileList
		return array;

	/**
		Casts `this` to `Array<FileRef>` explicitly.
	**/
	public extern inline function array(): Data
		return this;

	/**
		@return New list of file names without directory paths.
	**/
	public inline function names(): Array<String>
		return this.map(file -> file.getName());

	/**
		Copies all files in `this` list to `destination` with the same file names.
		Overwrites destination files if they already exist.
		@param prepareDirectory If `true`, creates the destination directory if absent.
	**/
	public inline function copyTo(
		destinationPath: DirectoryPath,
		prepareDirectory = true
	): Void {
		if (prepareDirectory && !destinationPath.exists())
			destinationPath.createDirectory();

		for (i in 0...this.length) {
			final file = this[i];
			final destinationFilePath = destinationPath.makeFilePath(file.getName());
			File.copy(file.path, destinationFilePath);
		}
	}
}
