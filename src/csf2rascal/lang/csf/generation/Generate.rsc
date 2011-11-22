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
	
	set[str] definedSorts = { s | csf(sort(s),_) <- csfs};
	set[str] usedSorts = {s | csf(sortAlternative(_,a),_) <- csfs, a.params?, s <- a.params}
		+ {a.param | csf(sortAlternative(_,a),_) <- csfs, a.param?}
		+ {a.sort | csf(sortAlternative(_,a),_) <- csfs, a.sort?}
		;
	generateUnDefinedSorts(usedSorts - definedSorts, basePath);
	
	generatePrimaryAllImporter(csfs, basePath);
}

private void generatePrimaryAllImporter(set[CSF] csfs, loc basePath) {
	loc fileName = basePath + "funcons.rsc";
	println("writing<fileName>");
	if (!exists(fileName.parent)) {
		mkDirectory(fileName.parent);
	}
	list[str] modules = sort([moduleName(basePath, a) | csf(a:sortAlternative(_,_),_) <- csfs]);
	
	writeFile(fileName, "module <moduleName(basePath, ["funcons"])>
		'<for (s <- modules) {>
			'extend <s>;
		'<}>
		"
	);
}

private void generateUnDefinedSorts(set[str] undefinedSorts, loc basePath) {
	for (us <- undefinedSorts) {
		list[Item] empty = [];
		generateSingleCSFFile(csf(Notation::sort(us), empty), basePath);
	}
}

private void generateSingleCSFFile(csf(s:sort(sortName), list[Item] items), loc basePath) {
	list[str] names = getModuleParts(s);
	loc fileName = (basePath | it + n | n <- names)[extension="rsc"];
	println("writing<fileName>");
	if (!exists(fileName.parent)) {
		mkDirectory(fileName.parent);
	}
	writeFile(fileName, "module <moduleName(basePath, s)>
		'
		'data <sortName>;
		'<if (/aliasSort(s) := items) {>
			'alias <s> = <sortName>;
		'<}>
		"
	);
}

private void generateSingleCSFFile(csf(s:sortAlternative(sortName, alt), list[Item] items), loc basePath) {
	list[str] names = getModuleParts(s);
	loc fileName = (basePath | it + n | n <- names)[extension="rsc"];
	println("writing<fileName>");
	if (!exists(fileName.parent)) {
		mkDirectory(fileName.parent);
	}
	str const = getAlternativeConstructor(alt);
	writeFile(fileName, "module <moduleName(basePath, s)>
		'
		'extend <moduleName(basePath, Notation::sort(sortName))>;
		'<getImplicitImport(alt, basePath, sortName)>
		'data <sortName> = <const>;
		'<if (/aliasName(n) := items) {>
			'public <sortName> <changeConstructorName(const, getAlternativeConstructor(getAlternativeOtherName(alt, n)))> = 
			'	<removeTypes(const)>;
		'<}>
		"
	);
}

private str changeConstructorName(str consOld, str consNew) {
	if (/^[^\(]+\(<rest:.*>$/ := consOld) {
		if (/^<pre:[^\(]+>\(/ := consNew) {
			return "<pre>(<rest>";
		}
	}
	return consNew;
}

private str removeTypes(str rascalConstructor) {
	return visit (rascalConstructor) {
		case /[A-Z][A-Za-z\-]* <v:[a-z][A-Za-z\-0-9]*>/ => v
		case /list\[[^\]]*\] <v:[a-z][A-Za-z\-0-9]*>/ => v
	}; 
}

private Alternative getAlternativeOtherName(Alternative alt, str newName) {
	if (alt.name ?)
		return alt[name = newName];
	else if (alt.sort ?)
		return alt[sort = newName];
	return alt;
}

private str getImplicitImport(nameParams(_, params), loc basePath, str currentSort) { 
	paramsToInclude = toSet(params - [currentSort]);
	if (isEmpty(paramsToInclude))
		return "";
	return intercalate("\n", ["import <moduleName(basePath, Notation::sort(p))>;" | p <- paramsToInclude]); 
}

private str getImplicitImport(nameParams(_, param, _), loc basePath, str currentSort) { 
	if (param == currentSort) 
		return "";
	else
		return "import <moduleName(basePath, Notation::sort(param))>;\n"; 
}

private str getImplicitImport(Alternative::sort(s), loc basePath, str currentSort) { 
	if (s == currentSort) 
		return "";
	else
		return "import <moduleName(basePath, Notation::sort(s))>;\n"; 
}

private default str getImplicitImport(Alternative a, loc basePath, str currentSort) = "";


private default void generateSingleCSFFile(CSF c, loc basePath) {
	throw "Unhandled CSF alternative";
}


private str moduleName(loc basePath, Notation name) {
	return moduleName(basePath, getModuleParts(name));
}

private str moduleName(loc basePath, list[str] names) {
	str startName = basePath.path;
	if (startsWith(basePath.path, "/src/")) {
		startName = substring(startName, 5);
	}
	return replaceAll(startName, "/", "::") 
		+ intercalate("::", names); 
}			

private alias ModuleParts = list[str]; 

private ModuleParts getModuleParts(Notation::sort(str sortName)) = [sortName, sortName];
private ModuleParts getModuleParts(sortAlternative(sortName, alt)) = [sortName, translateAlternative(alt)];
private default ModuleParts getModuleParts(Notation nt) {
	throw "Notation not handled";
}

private ModuleParts translateAlternative(name(str name)) = [fixUpName(name), fixUpName(name)];
private ModuleParts translateAlternative(Alternative::sort(str sort)) = ["_" + sort, "_"];
private ModuleParts translateAlternative(nameParams(str name, list[str] params)) = ["<fixUpName(name)>_<("" | it + p | p <- params)>", fixUpName(name)];
private ModuleParts translateAlternative(nameParams(str name, str params, str multiplier)) = ["<fixUpName(name)>_<params><getMultiplierPostFix(multiplier)>", fixUpName(name)];
private ModuleParts translateAlternative(sortParams(str sort, str params, str multiplier)) = ["_<sort><params><getMultiplierPostFix(multiplier)>", "_"];
private default ModuleParts translateAlternative(Alternative alt) { 
	throw "Alternative not translated to package name";
}

private str getAlternativeConstructor(name(str name)) = "<fixUpName(name)>()";
private str getAlternativeConstructor(Alternative::sort(str name)) = "<escapeKeywords(fixUpName(name))>(<fixUpSort(name)> <escapeKeywords(lowerCaseFirstChar(name))>)";
private str getAlternativeConstructor(nameParams(str name, list[str] params)) = "<escapeKeywords(fixUpName(name))>(<getConstrutorParameters(params)>)";
private str getAlternativeConstructor(nameParams(str name, str param, str multiplier)) = "<escapeKeywords(fixUpName(name))>(list[<param>] <escapeKeywords(lowerCaseFirstChar(param) + getMultiplierPostFix(multiplier))>)";
private str getAlternativeConstructor(sortParams(str sort, str param, str multiplier)) = "<escapeKeywords(fixUpName(sort))>(<fixUpSort(sort)> <escapeKeywords(lowerCaseFirstChar(sort))>, list[<param>] <escapeKeywords(lowerCaseFirstChar(param) + getMultiplierPostFix(multiplier))>)";
private default str getAlternativeConstructor(Alternative alt) { 
	throw "Alternative not translated to package name";
}

private str getMultiplierPostFix(str multiplier) = (multiplier == "?") ? "q" : "s";

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
