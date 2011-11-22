module csf2rascal::generated::Comm::assign_ExprExpr::assign

extend csf2rascal::generated::Comm::Comm;
import csf2rascal::generated::Expr::Expr;

 
@doc{When Expr1 computes a Var and Expr2 computes a Val, assign["Expr1","Expr2"]
 assigns Val to Var.
 When Expr1 has var-type["Type1"] for some Type1, and Expr2 has some Type2 included
 in Type1, assign["Expr1","Expr2"] is well-typed.
( The static semantics rules do not yet specify type inclusion.
)}
 

data Comm = assign(Expr expr1, Expr expr2);

public Comm assignToVariable(Expr expr1, Expr expr2) = 
	assign(expr1, expr2);

		