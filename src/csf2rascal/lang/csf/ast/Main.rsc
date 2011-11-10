module csf2rascal::lang::csf::ast::Main

data CSF = csf(Notation notation, list[Item] items);

data Notation 
	= sort(str sort)
	| sortAlternative(str sort, Alternative alt)
	;
	
data Alternative 
	= name(str name)
	| sort(str sort)
	| nameParams(str name, list[str] params)
	| nameParams(str name, str param, str multiplier)
	| sortParams(str sort, str param, str multiplier)
	;
	
data Item
	= aliasSort(str sort)
	| aliasName(str name)
	| glossary(list[Text] text)
	| uses(list[Notation] notations)
	| local(list[Definition] definitions)
	| relations(list[Part] parts, list[str] computes)
	| singleRule(Rule singleRule)
	;
	
data Text 
	= term(Term term)
	| word(str w)
	| punctuation(str p)
	;
	
data Definition
	= single(str lhs, str rhs)
	| alternative(str lhs, str rhs, Alternative alt); 
	
data Part
	= parts(list[Part] parts)
	| variable(str variable)
	| symbol(str symbol)
	;
	
data Rule
	= basic(str label, Formula formula)
	| complex(str label, list[Formula] formulas, str infer, Formula formula) 
	;

data Formula
	= relation(Relation relation)
	| equation(Equation eq)
	| definition(Term term)
	| negation(Formula formula)
	; 

data Relation = term(Term term);

data Equation = equation(Term lhs, Term rhs);

data Term = term(list[Atom] atoms);

data Atom
	= variable(str var)
	| constant(Constant const)
	| name(str name)
	| symbol(str sym)
	| terms(list[Term] terms)
	;
	
data Constant
	= natCon(int nat)
	| strCon(str \str)
	;