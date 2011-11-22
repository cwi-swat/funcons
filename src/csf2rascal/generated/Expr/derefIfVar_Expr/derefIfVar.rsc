module csf2rascal::generated::Expr::derefIfVar_Expr::derefIfVar

extend csf2rascal::generated::Expr::Expr;

 
@doc{When Expr computes a Var, deref-if-var["Expr"] deferences Var to compute a Val
.
 When Expr computes a Non-Var, deref-if-var["Expr"] has the same effect.
 When Expr has var-type["Type"] for some Type, deref-if-var["Expr"] is equivalent
 to deref["Expr"] - otherwise it is equivalent to Expr.}
 

data Expr = derefIfVar(Expr expr);

public Expr dereferenceIfVariable(Expr expr) = 
	derefIfVar(expr);

		