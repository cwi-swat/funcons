module csf2rascal::generated::Comm::whileLoop_ExprComm::whileLoop

extend csf2rascal::generated::Comm::Comm;
import csf2rascal::generated::Expr::Expr;
data Comm = whileLoop(Expr expr, Comm comm);
		