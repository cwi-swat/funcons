module csf2rascal::generated::Comm::cond_ExprCommComm::cond

extend csf2rascal::generated::Comm::Comm;
import csf2rascal::generated::Expr::Expr;

 
@doc{The command cond["Expr","Comm1","Comm2"] starts by evaluating Expr, then executing
 Comm1 if the result is true, or executing Comm2 if it is false.
 It is well-typed only if Expr is of bool-type.}
 

data Comm = cond(Expr expr, Comm comm1, Comm comm2);

public Comm conditional(Expr expr, Comm comm1, Comm comm2) = 
	cond(expr, comm1, comm2);

		