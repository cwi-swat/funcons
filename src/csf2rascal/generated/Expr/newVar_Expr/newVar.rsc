module csf2rascal::generated::Expr::newVar_Expr::newVar

extend csf2rascal::generated::Expr::Expr;

data Expr = newVar(Expr expr);

public Expr newVariableAllocation(Expr expr) = 
	newVar(expr);

		