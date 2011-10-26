module csf2rascal::lang::csf::cst::MainCSFGrammar

start syntax CSF = csf: Notation notations Item* items;

syntax Notation 
	= sort: Sort sort
	| sortAlternative: Sort sort "::=" Alternative alt;

syntax Alternative
	= name: Name name
	| nameParams: Name name "(" {Sort ","}+ params ")"
	| nameParams: Name name "(" Sort param Reg multiplier ")"
	| sortParams: Sort sort "(" Sort param Reg multiplier ")"
	| sort: Sort sort;

syntax Item
	= \aliasSort: "Alias:" Sort sort // sort and name closely related?
	| \aliasName: "Alias:" Name name
	| glossay: "Glossary:" Text+ text
	| uses: "Uses:" {Notation ","}+ notations
	| local: "Local:" {Definition ","}+ definitions
	| relations: "Relations:" Part+ parts Computes? computes
	| singleRule: Rule singleRule;
	
syntax Text
	= term: "$" Term term "$"
	| word: Word w
	| punctuation: Punctuation p;
	
syntax Definition
	= single: Sort lhs "=" Sort rhs
	| alternative: Sort lhs "=" Sort rhs "\\\\" Alternative alt;