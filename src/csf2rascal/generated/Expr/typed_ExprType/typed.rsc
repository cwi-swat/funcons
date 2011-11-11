module csf2rascal::generated::Expr::typed_ExprType::typed

extend csf2rascal::generated::Expr::Expr;



import csf2rascal::generated::Type::Type;



data Expr = typed(Expr expr, Type \type);
		