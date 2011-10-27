module csf2rascal::lang::csf::cst::Load

import csf2rascal::lang::csf::cst::MainCSFGrammar;
import ParseTree;
import util::IDE;

public start[CSF] parseCSF(str csfString) = 
	parse(#start[CSF], csfString); 
	
public start[CSF] parseCSF(loc csfFile) = 
	parse(#start[CSF], csfFile); 
	
public void registerIDE() {
	registerLanguage("The CSF funcons language", "csf", start[CSF] (str s, loc l) {
		return parse(#start[CSF], s, l); 
	});
}