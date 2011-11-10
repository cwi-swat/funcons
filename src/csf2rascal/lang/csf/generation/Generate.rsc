module csf2rascal::lang::csf::generation::Generate

import FileSystem;
import csf2rascal::lang::csf::ast::Load;
import csf2rascal::lang::csf::ast::Main;
import IO;
import Set;
import String;

private set[CSF] getAllCSFs() {
	csfFiles = crawl(|project://funcons/csf/|);
	return { getCSF(f) | /file(f) <- csfFiles, toLowerCase(f.extension) == "csf" }; 
}

public void generateCSFFiles() {
	generateCSFFiles(|project://funcons/src/csf2rascal/generated/|);
}

public void generateCSFFiles(loc basePath) {
	for (c <- getAllCSFs()) {
		generateSingleCSFFile(c, basePath);
	}
}

private void generateSingleCSFFile(csf(sort(sortName), list[Item] items), loc basePath) {
	loc fileName = basePath + sortName + "<sortName>.rsc";
	println("writing<fileName>");
	if (!exists(fileName.parent)) {
		mkDirectory(fileName.parent);
	}
	writeFile(fileName, "module <moduleName(basePath, sortName)>
		'
		'data <sortName>;
		"
	);
}

private default void generateSingleCSFFile(CSF csf, loc basePath) {
	;
}

private str moduleName(loc basePath, str sortName) {
	return replaceAll(substring(basePath.path, 1),"/","::") + "<sortName>::<sortName>";
}
