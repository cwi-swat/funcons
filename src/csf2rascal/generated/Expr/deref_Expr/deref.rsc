module csf2rascal::generated::Expr::deref_Expr::deref

extend csf2rascal::generated::Expr::Expr;

 
@doc{When Expr computes a Var, deref["Expr"] computes the Val currently assigned
 to Var.
 When Expr has var-type["Type"] for some Type, deref["Expr"] has Type.}
 

data Expr = deref(Expr expr);

public Expr dereference(Expr expr) = 
	deref(expr);

		