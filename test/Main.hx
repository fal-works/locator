import locator.*;

using StringTools;

class Main {
	static function main() {
		final cwdPath = DirectoryPath.current();
		Sys.println('cwd: $cwdPath');
		final parentDirPath = cwdPath.concat('../');
		Sys.println('parentDir: $parentDirPath');

		final filePath = FilePath.from('test/testdata.txt');
		final altFilePath = cwdPath.makeFilePath("test/testdata.txt");
		if (filePath != altFilePath) throw '$filePath != $altFilePath';
		Sys.println('file: $filePath');
		Sys.println('  dir: ${filePath.getParentPath()}');
		Sys.println('  name: ${filePath.getName()}');
		Sys.println('  ext: ${filePath.getExtension()}');
		Sys.println('  quoted: ${filePath.quoteForCli()}');
		final file = filePath.find();
		Sys.println('\n------------------------\n${file.getContent()}\n------------------------');

		Sys.println("\nGet parent recursively:");
		var path = filePath.getParentPath().getParentPath();
		var safetyCount = 0;
		while (path.isSome()) {
			final curPath = path.unwrap();
			Sys.println('${curPath} : ${curPath.getName()}');
			path = curPath.getParentPath();
			if (100 < ++safetyCount) throw "Something is wrong.";
		}
	}
}
