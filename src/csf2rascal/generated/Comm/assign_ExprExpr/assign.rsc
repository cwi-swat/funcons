module csf2rascal::generated::Comm::assign_ExprExpr::assign

extend csf2rascal::generated::Comm::Comm;
import csf2rascal::generated::Expr::Expr;
data Comm = assign(Expr expr1, Expr expr2);

public Comm assignToVariable(Expr expr1, Expr expr2) = 
	assign(expr1, expr2);

		