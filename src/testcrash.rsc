module testcrash

layout JustSpaces = [\ ]*;

lexical Syms = "---" <<! [+\-]+ !>> [+\-];

lexical Sep = "---" "-"*;

lexical Vars = [a-z];

syntax S 
	= F  f 
	| F f Sep Vars v
	;

syntax F 
	= Vars v 
	| F lhs Syms s F rhs
	;