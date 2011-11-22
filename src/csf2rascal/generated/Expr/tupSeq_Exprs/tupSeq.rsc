module csf2rascal::generated::Expr::tupSeq_Exprs::tupSeq

extend csf2rascal::generated::Expr::Expr;

 
@doc{The evaluations of the sub-expressions is sequential.
 A tuple is formed from the resulting sequence.
 When each sub-expression has a( possibly different) type, the tuple expression has
 the tuple type formed from those types.}
 

data Expr = tupSeq(list[Expr] exprs);

public Expr tupleSequential(list[Expr] exprs) = 
	tupSeq(exprs);

		