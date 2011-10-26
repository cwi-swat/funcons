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
	= aliasSort: "Alias:" Sort sort // sort and name closely related?
	| aliasName: "Alias:" Name name
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
	
syntax Part // in sdf only parts alternative may have layout, the others should be lexical
	= parts: "(" {Part ","}+ parts ")"
	| variable: Variable variable 
	| variable: "_" Variable variable "_"
	| symbol: Symbol symbol
	| symbol: "_" Symbol symbol "_";
	
syntax Computes = computes: "Computes:" {Variable ","}+ vars;

syntax Rule 
	= basic: Label label Formula formula
	| complex: Label label {Formula ","}+ formulas Infer infer Formula formula;

syntax Formula
	= relation: Relation relation
	| equation: Equation eq
	| definition: "def" Term term // avoid in sdf??
	| negation: "not" Formula formula; // avoid in sdf?
	
syntax Relation = term: Term term;

syntax Equation = eqation: Term lhs "=" Term rhs;
	
syntax Term = term: Atom+ atom;

syntax Atom
	 = variable: Variable var
	 | constant: Constant const
	 | name: Name name
	 | symbol: Symbol sym
	 | terms: "(" {Term ","}* terms ")";
	