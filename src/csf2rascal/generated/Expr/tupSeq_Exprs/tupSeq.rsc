module csf2rascal::generated::Expr::tupSeq_Exprs::tupSeq

extend csf2rascal::generated::Expr::Expr;

data Expr = tupSeq(list[Expr] exprs);

public Expr tupleSequential(list[Expr] exprs) = 
	tupSeq(exprs);

		