module csf2rascal::lang::csf::cst::MainCSFGrammar

extend lang::std::Whitespace;
extend lang::std::Comment;

lexical Comment 
	= @category="Comment" "%%"![\n]* $
	| @category="Comment" "%" ![%\n]+ "%"$; // add comments from sdf
 
layout Standard 
  = WhitespaceOrComment* !>> [\ \t\n\f\r] !>> "//" !>> "%%";
  
syntax WhitespaceOrComment 
  = whitespace: Whitespace
  | comment: Comment
  ; 

lexical Sort = ([A-Z] [A-Za-z\-]* !>> [A-Za-z\-]) \ Keywords;

lexical Name = [a-z] [a-z\-]* !>> [a-z\-];

//lexical Symbol = [=\<\>|\-:]+ !>> [=\<\>|\-:];
// we have to make sure the Symbol will not be ambigui with Infer, therefore we do the repeated character classes with the third missing the -
lexical Symbol = ([=\<\>|\-:] ([=\<\>|\-:] ([=\<\>|:] [=\<\>|\-:]*)?)? !>> [=\<\>|\-:]) \ "="; // remove the single = as a possible match to avoid ambiguity with Equation
	
lexical Infer = "---" "-"* !>> "-"; // prefer in sdf??


// To avoid ambiguities caused by Sort + Symbol (Part+) matching stuff like "Alias:"
keyword Keywords = "Alias" | "Glossary" | "Uses" | "Local" | "Relation" | "Computes";

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

lexical Reg = [*+?];

syntax Item
	= aliasSort: "Alias" ":" Sort sort 
	| aliasName: "Alias" ":" Name name
	| glossary: "Glossary" ":" Text+ text
	| uses: "Uses" ":" {Notation ","}+ notations
	| local: "Local" ":" {Definition ","}+ definitions
	| relations: "Relation" ":" Part+ parts Computes? computes
	| singleRule: Rule singleRule;
	
syntax Text
	= term: "$" Term term "$"
	| word: Word w
	| punctuation: Punctuation p;
	
lexical Word = [A-Za-z\-]+ !>> [A-Za-z\-] \ Keywords;

lexical Punctuation = [.,;:\'()];
	
syntax Definition
	= single: Sort lhs "=" Sort rhs
	| alternative: Sort lhs "=" Sort rhs "\\\\" Alternative alt;
	
syntax Part // in sdf only parts alternative may have layout, the others should be lexical
	= parts: "(" {Part ","}+ parts ")"
	| variable: Variable variable 
	| variable: "_" Variable variable "_"
	| symbol: Symbol symbol
	| symbol: "_" Symbol symbol "_";

lexical Variable = Sort sort Reg? reg Suffix? suffix;
	
lexical Suffix 
	= [0-9]+ [\']?
	| [\']
	;

syntax Computes = computes: "Computes" ":" {Variable ","}+ vars;

syntax Rule 
	= basic: Label label Formula formula
	| complex: Label label {Formula ","}+ formulas Infer infer Formula formula;

lexical Label = [0-9]+ [:];

syntax Formula
	= relation: Relation relation
	| equation: Equation eq
	| definition: "def" Term term // avoid in sdf??
	| negation: "not" Formula formula; // avoid in sdf?
	
syntax Relation = term: Term term;

syntax Equation = eqation: Term lhs [=\<\>|\-:] !<< "=" !>> [=\<\>|\-:] Term rhs; // follow restriction is not in SDF?
	
syntax Term = term: Atom+ atom;

syntax Atom
	 = variable: Variable var
	 | constant: Constant const
	 | name: Name name
	 | symbol: Symbol sym
	 | terms: "(" {Term ","}* terms ")";
	 
lexical Constant
	= natCon: NatCon nat !>> ":"
	| strCon : StrCon str !>> ":";
	
// NatCon and StrCon from sdf
lexical NatCon = digits: [0-9]+; 

lexical StrCon = def: [\"] StrChar* chars [\"];

lexical StrChar
	= newline: [\n]
	| tab: [\t]
	| quote: [\\\"]
	| decimal: [\\] [0-9] a [0-9] b [0-9] c
	| normal: ![\0-\31 \n \t \" \\]
	;
