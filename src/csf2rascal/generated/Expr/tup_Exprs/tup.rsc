module csf2rascal::generated::Expr::tup_Exprs::tup

extend csf2rascal::generated::Expr::Expr;

data Expr = tup(list[Expr] exprs);

public Expr \tuple(list[Expr] exprs) = 
	tup(exprs);

		