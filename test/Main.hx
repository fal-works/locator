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
		Sys.println('  quoted: ${filePath.quote()}');
		final file = filePath.find();
		Sys.println('\n------------------------\n${file.getContent()}\n------------------------');

		Sys.println("\nGet parent recursively:");
		final leafDirPathStr = filePath.getParentPath();
		// PathString.mode = PathStringMode.unix;
		// final leafDirPathStr = "/usr/local/bin/include/aaa/";
		var path = DirectoryPath.from(leafDirPathStr).getParentPath();
		var safetyCount = 0;
		while (path.isSome()) {
			final curPath = path.unwrap();
			Sys.println('${curPath} : ${curPath.getName()}');
			path = curPath.getParentPath();
			if (100 < ++safetyCount) throw "Something is wrong.";
		}

		Sys.println("\nGet relative path:");
		final absPath = FilePath.from("C:/aaa/bbb/ccc/ddd/e.hx");
		final refPath = DirectoryPath.from("C:/aaa/bbb/xxx/zzz/");
		Sys.println("abs: " + absPath);
		Sys.println("ref: " + refPath);
		Sys.println("rel: " + absPath.toRelative(refPath));

		Sys.println("\nGet contents of cwd:");
		for (element in cwdPath.find().getContents()) {
			switch element.toEnum() {
				case File(ref):
					Sys.println('File: ${ref.getName()}');
				case Directory(ref):
					Sys.println('Dir: ${ref.getName()}');
			}
		}
	}
}
