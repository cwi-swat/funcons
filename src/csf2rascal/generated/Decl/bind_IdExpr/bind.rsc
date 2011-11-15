module csf2rascal::generated::Decl::bind_IdExpr::bind

extend csf2rascal::generated::Decl::Decl;
import csf2rascal::generated::Id::Id;
import csf2rascal::generated::Expr::Expr;
data Decl = bind(Id id, Expr expr);
		