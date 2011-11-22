module csf2rascal::generated::Expr::typed_ExprType::typed

extend csf2rascal::generated::Expr::Expr;
import csf2rascal::generated::Type::Type;

 
@doc{When Expr computes Data in Type, typed["Expr","Type"] computes the same.
 When Expr has Type' related to Type, typed["Expr","Type"] has Type.}
 

data Expr = typed(Expr expr, Type \type);

public Expr typedCast(Expr expr, Type \type) = 
	typed(expr, \type);

		