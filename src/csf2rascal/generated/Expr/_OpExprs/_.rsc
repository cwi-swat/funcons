module csf2rascal::generated::Expr::_OpExprs::_

extend csf2rascal::generated::Expr::Expr;
import csf2rascal::generated::Op::Op;

 
@doc{The evaluations of the sub-expressions may be interleaved.
 The Op is applied to the resulting sequence.
 When Op can be resolved to an Op' of a type applicable to the sequence of sub-expressions
, Op["Expr+"] has the corresponding result type.}
 

data Expr = op(Op op, list[Expr] exprs);

public Expr operationApplication(Op op, list[Expr] exprs) = 
	op(op, exprs);

		