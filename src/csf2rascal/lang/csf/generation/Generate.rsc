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
	set[CSF] csfs = getAllCSFs();
	for (c <- csfs) {
		generateSingleCSFFile(c, basePath);
	}
	
	for (c:csf(sort(_), _) <- csfs) {
		generateAllImportFile(c, basePath, csfs);
	}
	
	set[str] definedSorts = { s | csf(sort(s),_) <- csfs};
	set[str] usedSorts = {s | csf(sortAlternative(_,a),_) <- csfs, a.params?, s <- a.params}
		+ {a.param | csf(sortAlternative(_,a),_) <- csfs, a.param?}
		+ {a.sort | csf(sortAlternative(_,a),_) <- csfs, a.sort?}
		;
	generateUnDefinedSorts(usedSorts - definedSorts, basePath);
}

private void generateUnDefinedSorts(set[str] undefinedSorts, loc basePath) {
	for (us <- undefinedSorts) {
		list[Item] empty = [];
		generateSingleCSFFile(csf(Notation::sort(us), empty), basePath);
	}
}

private void generateAllImportFile(CSF c, loc basePath, set[CSF] csfs) {
	list[str] names = getModuleNameList(getModuleParts(c.notation));
	names[size(names)-1] = names[size(names) -1] + "_all"; 
	loc fileName = (basePath | it + n | n <- names)[extension="rsc"];
	println("writing<fileName>");
	if (!exists(fileName.parent)) {
		mkDirectory(fileName.parent);
	}
	str currentSort = c.notation.sort;
	writeFile(fileName, "module <moduleName(basePath, c.notation)>_all
		'<for (csf(a:sortAlternative(currentSort,_),_) <- csfs) {>
			'extend <moduleName(basePath, a)>;
		'<}>
		"
	);
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
		'<if (alt.params? && !isEmpty(alt.params - [sortName])) {>
			'<for (p <- toSet(alt.params - [sortName])) {>
				'import <moduleName(basePath, Notation::sort(p))>;
			'<}>
		'<}><if (alt.param? && alt.param != sortName) {>
			'import <moduleName(basePath, Notation::sort(alt.param))>;
		'<}>
		'<if (alt is sort) {>
			'import <moduleName(basePath, Notation::sort(alt.sort))>;
		'<}>
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
private str getAlternativeConstructor(Alternative::sort(str name)) = "<escapeKeywords(fixUpName(name))>(<fixUpSort(name)> <escapeKeywords(lowerCaseFirstChar(name))>)";
private str getAlternativeConstructor(nameParams(str name, list[str] params)) = "<escapeKeywords(fixUpName(name))>(<getConstrutorParameters(params)>)";
private str getAlternativeConstructor(nameParams(str name, str param, str multiplier)) = "<escapeKeywords(fixUpName(name))>(list[<param>] <escapeKeywords(lowerCaseFirstChar(param)+"s")>)";
private str getAlternativeConstructor(sortParams(str sort, str param, str multiplier)) = "<escapeKeywords(fixUpName(sort))>(list[<param>] <escapeKeywords(lowerCaseFirstChar(param) + "s")>)";
private default str getAlternativeConstructor(Alternative alt) { 
	throw "Alternative not translated to package name";
}

private set[str] toEscape = {
	"int", "break", "continue", "rat", "true", "bag", "num", "node", "finally",
	"private", "real", "list", "fail", "filter", "if", "tag", "extend",
	"append", "repeat", "rel", "void", "non-assoc", "assoc", "test", "anno",
	"layout", "data", "join", "it", "bracket", "in", "import", "false", "all",
	"dynamic", "solve", "type", "try", "catch", "notin", "else", "insert", "switch",
	"return", "case", "while", "str", "throws", "visit", "tuple", "for", "assert",
	"loc", "default", "map", "alias", "any", "module", "bool", "public", "one",
	"throw", "set", "start", "fun", "non-terminal", "rule", "constructor",
	"datetime", "value", "loc", "node", "num", "type", "bag", "int", "rat", "rel",
	"parameter", "real", "fun", "tuple", "str", "bool", "reified", "void",
	"non-terminal", "datetime", "set", "map", "constructor", "list", "adt",
	"import", "syntax", "start", "layout", "lexical", "keyword", "extend"
};

private str escapeKeywords(str nonEscaped) {
	if (nonEscaped in toEscape) 
		return "\\" + nonEscaped;
	return nonEscaped;
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
	return lowerCaseFirstChar(name);
}

private str fixUpSort(str sortName) {
	return upperCaseFirstChar(fixUpName(sortName));
}

private str getConstrutorParameters(list[str] params) {
	map[str,int] paramCounter = ();
	for (p <- params) {
		paramCounter[p] ? 0 += 1;
	}	
	map[str,int] paramsSeen = ();
	str getParamName(str p) {
		paramsSeen[p] ? 0 += 1;
		return escapeKeywords(lowerCaseFirstChar(p +  ((paramCounter[p] == 1) ? "" : "<paramsSeen[p]>")));
	};
	return ("<head(params)> <getParamName(head(params))>" | it + ", <p> <getParamName(p)>" | p <- tail(params));
}
