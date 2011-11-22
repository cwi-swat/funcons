module csf2rascal::generated::Expr::derefIfVar_Expr::derefIfVar

extend csf2rascal::generated::Expr::Expr;

data Expr = derefIfVar(Expr expr);

public Expr dereferenceIfVariable(Expr expr) = 
	derefIfVar(expr);

		