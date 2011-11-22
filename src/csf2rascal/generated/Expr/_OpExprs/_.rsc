module csf2rascal::generated::Expr::_OpExprs::_

extend csf2rascal::generated::Expr::Expr;

data Expr = op(Op op, list[Expr] exprs);

public Expr operationApplication(Op op, list[Expr] exprs) = 
	op(op, exprs);

		