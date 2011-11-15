module csf2rascal::generated::Comm::cond_ExprCommComm::cond

extend csf2rascal::generated::Comm::Comm;
import csf2rascal::generated::Expr::Expr;
data Comm = cond(Expr expr, Comm comm1, Comm comm2);
		