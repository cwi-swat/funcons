module lang::pico::ast::Main

data Program = program(list[IdType] decls, list[Statement] body);

data IdType = idtype(str id, Type t);

data Statement 
	= assign(str var, Expression val)
	| cond(Expression cond, list[Statement] thenPart, list[Statement] elsePart)
	| cond(Expression cond, list[Statement] thenPart)
	| loop(Expression cond, list[Statement] body);

data Type 
	= natural()
	| string()
	| nil();

data Expression 
	= id(str name)
	| strcon(str string)
	| natcon(int natcon)
	| concat(Expression lhs, Expression rhs)
	| add(Expression lhs, Expression rhs)
	| min(Expression lhs, Expression rhs);
