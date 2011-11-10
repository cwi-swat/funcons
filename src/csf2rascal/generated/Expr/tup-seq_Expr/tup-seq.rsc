module csf2rascal::generated::Expr::tup-seq_Expr::tup-seq

extend csf2rascal::generated::Expr::Expr;

data Expr = tup-seq(list[Expr] expr);
		