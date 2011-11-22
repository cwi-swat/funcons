module csf2rascal::generated::Decl::bind_IdExpr::bind

extend csf2rascal::generated::Decl::Decl;
import csf2rascal::generated::Id::Id;
import csf2rascal::generated::Expr::Expr;

 
@doc{The computed environment only maps Id to the result of evaluating Expr.
 The declaration has a type that maps Id to an entity that provides both the type
 of Expr and the static value of Expr.}
 

data Decl = bind(Id id, Expr expr);

public Decl bindResult(Id id, Expr expr) = 
	bind(id, expr);

		