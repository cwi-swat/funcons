module csf2rascal::generated::Expr::assignVar_ExprExpr::assignVar

extend csf2rascal::generated::Expr::Expr;

data Expr = assignVar(Expr expr1, Expr expr2);

public Expr assignGivingVariable(Expr expr1, Expr expr2) = 
	assignVar(expr1, expr2);

		