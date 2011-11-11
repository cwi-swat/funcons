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

private void generateSingleCSFFile(csf(s:sortAlternative(sortName, alt), list[Item] items), loc basePath) {
	list[str] names = getModuleNameList(getModuleParts(s));
	loc fileName = (basePath | it + n | n <- names)[extension="rsc"];
	println("writing<fileName>");
	if (!exists(fileName.parent)) {
		mkDirectory(fileName.parent);
	}
	writeFile(fileName, "module <moduleName(basePath, s)>
		'
		'extend <moduleName(basePath, Notation::sort(sortName))>;
		'
		'data <sortName> = <getAlternativeConstructor(alt)>;
		"
	);
}

private default void generateSingleCSFFile(CSF c, loc basePath) {
	throw "Unhandled CSF alternative";
}


private str moduleName(loc basePath, Notation name) {
	list[str] names = getModuleNameList(getModuleParts(name));
	return replaceAll(substring(basePath.path, 5),"/","::") // remove the  /src/
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

private ModuleParts translateAlternative(name(str name)) = package(fixUpName(name), \module(fixUpName(name)));
private ModuleParts translateAlternative(Alternative::sort(str sort)) = package("_" + sort, \module("_"));
private ModuleParts translateAlternative(nameParams(str name, list[str] params)) = package("<fixUpName(name)>_<("" | it + p | p <- params)>", \module(fixUpName(name)));
private ModuleParts translateAlternative(nameParams(str name, str params, _)) = package("<fixUpName(name)>_<params>", \module(fixUpName(name)));
private ModuleParts translateAlternative(sortParams(str sort, str params, _)) = package("_<sort><params>", \module("_"));
private default ModuleParts translateAlternative(Alternative alt) { 
	throw "Alternative not translated to package name";
}

private str getAlternativeConstructor(name(str name)) = "<fixUpName(name)>()";
private str getAlternativeConstructor(Alternative::sort(str name)) = "<fixUpName(name)>()";
private str getAlternativeConstructor(nameParams(str name, list[str] params)) = "<fixUpName(name)>(<getConstrutorParameters(params)>)";
private str getAlternativeConstructor(nameParams(str name, str param, str multiplier)) = "<fixUpName(name)>(list[<param>] <lowerCaseFirstChar(param)>)";
private str getAlternativeConstructor(sortParams(str sort, str param, str multiplier)) = "<fixUpName(sort)>(list[<param>] <lowerCaseFirstChar(param)>)";
private default str getAlternativeConstructor(Alternative alt) { 
	throw "Alternative not translated to package name";
}


private str lowerCaseFirstChar(str name) = toLowerCase(substring(name,0,1)) + substring(name,1);
private str upperCaseFirstChar(str name) = toUpperCase(substring(name,0,1)) + substring(name,1);

private str fixUpName(str name) {
	minusChars = findAll(name, "-");
	if (size(minusChars) > 0) {
		minusChars = [-1, minusChars, size(name)];
		nameParts = for (i <- [0..size(minusChars)-2]) {
			append substring(name, minusChars[i] + 1, minusChars[i+1]);
		};
		return lowerCaseFirstChar(("" | it + upperCaseFirstChar(n) | n <- nameParts));	
	}
	return name;
}

private str getConstrutorParameters(list[str] params) {
	map[str,int] paramCounter = ();
	for (p <- params) {
		paramCounter[p] ? 0 += 1;
	}	
	map[str,int] paramsSeen = ();
	str getParamName(str p) {
		paramsSeen[p] ? 0 += 1;
		return lowerCaseFirstChar( p +  ((paramCounter[p] == 1) ? "" : "<paramsSeen[p]>"));
	};
	return ("<head(params)> <getParamName(head(params))>" | it + ", <p> <getParamName(p)>" | p <- tail(params));
}
