module lang::pico::semantic::Main

import lang::pico::ast::Main;
import funcons::Funcons;

import List;
import Set;

public Prog pico2Prog(Program::program(list[IdType] decls, list[Statement] body)) =
	Prog::run(compile(block( 
		pico2Decl(decls), 
		pico2Comm(body)
	)));

	
public Decl pico2Decl(list[IdType] decls) =
	(decls == []) ? decl(skip()) : seq([ pico2Decl(d) | d <- decls]);
	
public Decl pico2Decl(idtype(str id, Type tp)) = 
	bind( 
		pico2Id(id), 
		assignVar(newVar(pico2Type(tp)), init(pico2Type(tp)))
	);


public Comm pico2Comm(list[Statement] statements) =
	(statements == [] ) ? skip() : seq([ pico2Comm(s) | s <- statements]);


public Comm pico2Comm(Statement::cond(con, thenPart, elsePart)) =
	cond(
		not_eq(pico2Expr(con), 0 ), 
		pico2Comm(thenPart), 
		pico2Comm(elsePart)
	);
	
public Comm pico2Comm(Statement::cond(con, thenPart)) =
	cond(
		not_eq(pico2Expr(con), 0 ), 
		pico2Comm(thenPart), 
		skip()
	);
	
public Comm pico2Comm(Statement::assign(str var,  Expression val)) =
	assign(
		bound(pico2Id(var)),
		pico2Expr(val)
	);

public Comm pico2Comm(Statement::loop(con, body)) =
	whileLoop( 
		noteq(pico2Expr(con), natCon(0)), 
		pico2Comm(body)
	);
		
		
public Expr pico2Expr(Expression::id(name)) =
	derefIfVar(
		bound(pico2Id(name))
	);
	
public Expr pico2Expr(strcon(str string)) = \data(\str(string));

public Expr pico2Expr(natcon(int natcon)) = natCon(natcon);

public Expr pico2Expr(Expression::add(lhs, rhs)) = intPlus(pico2Expr(lhs), pico2Expr(rhs));

public Expr pico2Expr(Expression::min(lhs, rhs)) = intMax(natCon(0), intMinus(pico2Expr(lhs), pico2Expr(rhs)));

public Expr pico2Expr(concat(lhs, rhs)) = strConcat(pico2Expr(lhs), pico2Expr(rhs));

public Id pico2Id(str id) = meta(id);

public Type pico2Type(natural()) = natType();

public Type pico2Type(string()) = stringType();

public Type pico2Type(string()) = nilType();





