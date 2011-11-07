module csf2rascal::lang::csf::cst::TestForParsingProblems

import FileSystem;
import csf2rascal::lang::csf::cst::Load;
import IO;
import Set;
import ParseTree;

public bool checkAll() {
	return (size(checkAllAmbiguities()) == 0)
		&& (size(checkParsingErrors()) == 0);
}

public rel[loc,Tree] checkAllAmbiguities() {
	result = {};
	iterateOverAllCSFFiles(void (loc f) {
		try {
			parsed = parseCSF(f);
			if (/a:amb(_) := parsed) {
				result += {<f, a>};
			}
		}
		catch: ;
	});
	return result;
}

private void iterateOverAllCSFFiles(void (loc f) perFile) {
	csfFiles = crawl(|project://funcons/csf/|);
	for (/file(l) <- csfFiles) {
		println("Checking <l>");
		perFile(l);
	}
}

public rel[loc,loc] checkParsingErrors() {
	result = {};
	iterateOverAllCSFFiles(void (loc f) {
		try {
			parsed = parseCSF(f);
		}
		catch ParseError(el) : result += {<f, el>};
	});
	return result;
}

public set[loc] searchForInstance(bool (Tree tree) tryMatch) {
	result = {};
	iterateOverAllCSFFiles(void (loc f) {
		if (tryMatch(parseCSF(f))) {
			result += {f};
		}
	});
	return result;
}
