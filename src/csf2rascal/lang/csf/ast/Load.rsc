module csf2rascal::lang::csf::ast::Load

import csf2rascal::lang::csf::cst::Load;
import csf2rascal::lang::csf::ast::Main;
import ParseTree;

public CSF getCSF(str csfString) = implode(#CSF, parseCSF(csfString));

public CSF getCSF(loc csfFile) = implode(#CSF, parseCSF(csfFile));

