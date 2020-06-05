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
		Sys.println('  dir: ${filePath.getDirectoryPath()}');
		Sys.println('  name: ${filePath.getName()}');
		Sys.println('  ext: ${filePath.getExtension()}');
		Sys.println('  quoted: ${filePath.quote()}');
		final file = filePath.find();
		Sys.println('\n------------------------\n${file.getContent()}\n------------------------');
	}
}
