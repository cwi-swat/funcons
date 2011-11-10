module csf2rascal::lang::csf::generation::Generate

import FileSystem;
import csf2rascal::lang::csf::ast::Load;
import csf2rascal::lang::csf::ast::Main;
import IO;
import Set;
import String;
import List;

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

private void generateSingleCSFFile(csf(s:sort(sortName), list[Item] items), loc basePath) {
	list[str] names = getModuleNameList(getModuleParts(s));
	loc fileName = (basePath | it + n | n <- names)[extension="rsc"];
	println("writing<fileName>");
	if (!exists(fileName.parent)) {
		mkDirectory(fileName.parent);
	}
	writeFile(fileName, "module <moduleName(basePath, s)>
		'
		'data <sortName>;
		"
	);
}

private default void generateSingleCSFFile(CSF csf, loc basePath) {
	str sortName = csf.notation.sort;
	
	loc fileName = basePath + sortName + "<sortName>.rsc";
}



private str moduleName(loc basePath, Notation name) {
	list[str] names = getModuleNameList(getModuleParts(name));
	return replaceAll(substring(basePath.path, 1),"/","::") 
		+ (head(names) | it + "::" + m | m <- tail(names));
}

private list[str] getModuleNameList(\module(str name)) = [name];
private list[str] getModuleNameList(\package(str name,ModuleParts nested)) = [name, getModuleNameList(nested)];
private default list[str] getModuleNameList(ModuleParts mp) {
	throw "ModuleParts not handled?";
}
			

private data ModuleParts 
	= package(str name, ModuleParts nested)
	| \module(str name)
	;	

private ModuleParts getModuleParts(Notation::sort(str sortName)) = package(sortName, \module(sortName));
private ModuleParts getModuleParts(sortAlternative(sortName, alt)) = package(sortName, translateAlternative(alt));
private default ModuleParts getModuleParts(Notation nt) {
	throw "Notation not handled";
}

private ModuleParts translateAlternative(name(str name)) = package(name, \module(name));
private ModuleParts translateAlternative(Alternative::sort(str sort)) = package("_" + sort, \module("_"));
private ModuleParts translateAlternative(nameParams(str name, list[str] params)) = package("<name>_<("" | it + p | p <- params)>", \module(name));
private ModuleParts translateAlternative(nameParams(str name, str params, _)) = package("<name>_<params>", \module(name));
private ModuleParts translateAlternative(sortParams(str sort, str params, _)) = package("_<sort><params>", \module("_"));
private default ModuleParts translateAlternative(Alternative alt) { 
	throw "Alternative not translated to package name";
}
