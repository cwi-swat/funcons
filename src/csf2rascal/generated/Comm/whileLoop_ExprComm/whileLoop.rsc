module csf2rascal::generated::Comm::whileLoop_ExprComm::whileLoop

extend csf2rascal::generated::Comm::Comm;
import csf2rascal::generated::Expr::Expr;

 
@doc{The loop starts by evaluating Expr, then executing Comm if the result is true
, and terminating normally if it is false.
 It is well-typed only if Expr is of bool-type.}
 

data Comm = whileLoop(Expr expr, Comm comm);

		