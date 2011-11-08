module csf2rascal::lang::csf::ast::TestImplodes

import FileSystem;
import csf2rascal::lang::csf::ast::Load;
import IO;
import Set;
import ParseTree;

private void iterateOverAllCSFFiles(void (loc f) perFile) {
	csfFiles = crawl(|project://funcons/csf/|);
	for (/file(l) <- csfFiles) {
		println("Checking <l>");
		perFile(l);
	}
}

public rel[loc,str, str] checkForImplodeErrors() {
	result = {};
	iterateOverAllCSFFiles(void (loc f) {
		try {
			getCSF(f);
		}
		catch IllegalArgument(el, msg) : result += {<f, "<el>", msg>};
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
