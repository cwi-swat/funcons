module csf2rascal::generated::Expr::tup_Exprs::tup

extend csf2rascal::generated::Expr::Expr;

 
@doc{The evaluations of the sub-expressions may be interleaved.
 A tuple is formed from the resulting sequence.
 When each sub-expression has a( possibly different) type, the tuple expression has
 the tuple type formed from those types.}
 

data Expr = tup(list[Expr] exprs);

public Expr \tuple(list[Expr] exprs) = 
	tup(exprs);

		