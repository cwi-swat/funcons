module csf2rascal::generated::Expr::deref_Expr::deref

extend csf2rascal::generated::Expr::Expr;

data Expr = deref(Expr expr);

public Expr dereference(Expr expr) = 
	deref(expr);

		