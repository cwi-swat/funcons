module csf2rascal::generated::Expr::_OpExpr::_

extend csf2rascal::generated::Expr::Expr;


data Expr = Op(list[Expr] expr);
		