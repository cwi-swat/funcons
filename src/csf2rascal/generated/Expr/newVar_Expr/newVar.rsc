module csf2rascal::generated::Expr::newVar_Expr::newVar

extend csf2rascal::generated::Expr::Expr;

 
@doc{When Expr computes a Type, new-var["Expr"] allocates and gives a currently unallocated
 Var.
 When Expr evaluates statically to a Type of value, new-var["Expr"] has var-type["Type"]
.}
 

data Expr = newVar(Expr expr);

public Expr newVariableAllocation(Expr expr) = 
	newVar(expr);

		