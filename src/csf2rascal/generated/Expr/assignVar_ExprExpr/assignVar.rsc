module csf2rascal::generated::Expr::assignVar_ExprExpr::assignVar

extend csf2rascal::generated::Expr::Expr;

 
@doc{When Expr1 computes a Var and Expr2 computes a Val, assign-var["Expr1","Expr2"]
 assigns Val to Var and gives Var.
 When Expr1 has var-type["Type1"] for some Type1, and Expr2 has some Type2 included
 in Type1, assign-var["Expr1","Expr2"] has var-type["Type1"].
( The static semantics rules do not yet specify type inclusion.
)}
 

data Expr = assignVar(Expr expr1, Expr expr2);

public Expr assignGivingVariable(Expr expr1, Expr expr2) = 
	assignVar(expr1, expr2);

		