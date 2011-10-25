module funcons::Funcons

data Prog
	= \data(Data dt)
	| code(Prog p, Type t)
	| comm(Comm c)
	| compile(Prog p)
	| compile(Comm c)
	| decl(Decl d)
	| run(Prog p)
	;
data Expr 
	= \data(Data dt)
	| abs(Patt pattern, Comm command)
	| application(Op op, list[Expr] exprs)
	| assignVar(Expr var, Expr val)
	| bound(Id id)
	| deref(Expr var)
	| derefIfVar(Expr var)
	| env(Decl decl)
	| newVar(Expr typeExpr)
	| newVar(Type \type)
	| op(list[Expr] expressions)
	| tup(list[Expr] tuples)
	| tupSeq(list[Expr] tuples)
	| typed(Expr expr, Type check)
	;

data Data
	= \type(Type tp)
	| \bool(bool b)
	| application(Op op, list[Data] \data)
	| eval(Data dt)
	| undefined()
	| id(Id id)
	| \str(str s)
	| env(Env e)
	| \int(Int i)
	| package(Package p)
	| record()
	| store(Store st)
	| val(Val val)
	| tagged()
	| var(Var var)
	;

data Type
	= \type()
	| boolType()
	| strType()
	| opType(Type arg, Type result)
	| \type(Op operator)
	| intType()
	| natType()
	| env()
	| packageType()
	| recordType()
	| valType();

data Op 
	= init()
	| comp(list[Op] operators)
	| comp(Op op, list[Op] operators) 
	| tup(list[Op] operators) // alternative form: "(" Op {"," Op}+ "}"
	| strConcat()
	| recordData()
	| recordField()
	| assigned()
	| tagged()
	| taggedType()
	;
	
public Expr init(Expr e) = application(init(), [e]);
public Expr init(Type t) = application(init(), [\data(\type(t))]);
public Expr strConcat(Expr e1, Expr e2) = application(strConcat(), [e1, e2]);

	
// bool ops
data Op
	= \not()
	| \not(Expr e)
	| \and()
	| \and(Expr e1, Expr e2)
	| \or()
	| \or(Expr e1, Expr e2)
	| \eq()
	| \eq(Expr e1, Expr e2)
	| \noteq()
	| \noteq(Expr e1, Expr e2)
	;
	
public Expr \not(Expr e) = application(\not(), [e]);
public Expr \and(Expr e1, Expr e2) = application(\and(), [e1, e2]);
public Expr \or(Expr e1, Expr e2) = application(\or(), [e1, e2]);
public Expr \eq(Expr e1, Expr e2) = application(\eq(), [e1, e2]);
public Expr \noteq(Expr e1, Expr e2) = application(\noteq(), [e1, e2]);

// int ops
data Op 
	= rangeType()
	| intNeq()
	| intNeq(Expr e)
	| intPlus()
	| intPlus(Expr e1, Expr e2)
	| intMinus()
	| intMinus(Expr e1, Expr e2)	
	| intTimes()
	| intTimes(Expr e1, Expr e2)
	| intDiv()
	| intDiv(Expr e1, Expr e2)
	| intMod()
	| intMod(Expr e1, Expr e2)
	| intMin()
	| intMin(Expr e1, Expr e2)
	| intMax()
	| intMax(Expr e1, Expr e2)
	| intLt()
	| intLt(Expr e1, Expr e2)
	| intGt()
	| intGt(Expr e1, Expr e2)
	;


public Expr intNeq(Expr e) = application(intNeq(), [e]);	
public Expr intPlus(Expr e1, Expr e2) = application(intPlus(), [e1, e2]);
public Expr intMinus(Expr e1, Expr e2) = application(intMinus(), [e1, e2]);
public Expr intTimes(Expr e1, Expr e2) = application(intTimes(), [e1, e2]);
public Expr intDiv(Expr e1, Expr e2) = application(intDiv(), [e1, e2]);
public Expr intMod(Expr e1, Expr e2) = application(intMod(), [e1, e2]);
public Expr intMin(Expr e1, Expr e2) = application(intMin(), [e1, e2]);
public Expr intMax(Expr e1, Expr e2) = application(intMax(), [e1, e2]);
public Expr intLt(Expr e1, Expr e2) = application(intLt(), [e1, e2]);
public Expr intGt(Expr e1, Expr e2) = application(intGt(), [e1, e2]);

data Int
	= nat(Nat n)
	| intCon(int val)
	| minInt()
	;
	
data Nat
	= natCon(int val) // positive value
	| maxInt()
	;

public Expr natCon(int val) = \data(\int(nat(Nat::natCon(val)))); 
public Expr intCon(int val) = \data(\int(Int::intCon(val)));
	
data Package 
	= packageEmpty();
	
// package ops
data Op 
	= packageData()
	| packageEnv();


data Store
	= update(Store s, Var var, Var val)
	| allocate(Store s, Var var, Type tp)
	;

data Id 
	= meta(str name); 

data Comm
	= assign(Expr var, Expr val)
	| block(Decl decls, Comm body)
	| call(Expr name, Expr params)
	| cond(Expr condition, Comm trueBody, Comm falseBody)
	| seq(list[Comm] commands)
	| skip()
	| whileLoop(Expr condition, Comm body);

data Decl
	= bind(Id id, Expr val)
	| decl(Comm declCommands)
	| env() // not sure
	| seq(list[Decl] decls)
	;

data Env
	= mapEmpty()
	| \map(Id id, Data dt)
	| mapUnion(Env first, Env second)
	| mapOver(Env first, Env second)
	| mapLookup(Env env, Id id)
	;
	
data Patt
	= abs(Patt pattern, Decl decl)
	| id(Id id) // not sure..
	| tup(list[Patt] patterns)
	| typed(Patt pattern, Expr \type)
	;

data Val
	= assigned(Store s, Var v);
	
data Var = unknow(); // cannot find anything about this

/*
data Data 
	= undefined()
	| expr(Expr expr)
	| \type(Type tp)
	| \str(String \str);
	

data Prog 
	= code(Prog program, Type tp)
	| comm(Comm cm)
	| \data(Data dt)
	| compile(Prog program)
	| decl(Decl declaration)
	| run(Prog program);

data Comm 
	= block(Decl declarations, Comm body)
	| assign(Expr variableName, Expr newValue)
	| call(Expr func, Expr parm)
	| cond(Expr con, Comm trueComm, Comm falseComm)
	| seq(list[Comm] commands)
	| skip()
	| whileLoop(Expr con, Comm body);

data Decl
	= bind(Id id, Expr variableTypeAndValue)
	| decl(Comm body)
	| env()
	| seq(list[Decl] declarations);
	
data Expr // incomplete
	= abs(Patt pattern, Comm command)
	| assignVar(Expr variable, Expr newValue)
	| assignVar(Expr variable, Op opValue)
	| bound(Id id)
	| newVar(Expr typeExpression)
	| newVar(Type \type);

data Patt
	= abs(Patt pattern, Decl declaration)
	| id(Id id)
	| tup(list[Patt] patterns)
	| typed(Patt pattern, Expr expression);

data Bool 
	= boolCon(bool val)
	| and(Expr lhs, Expr rhs)
	| or(Expr lhs, Expr rhs)
	| eq(Expr lhs, Expr rhs)
	| not(Expr boolExpression)
	| not_eq(Expr lhs, Expr rhs);
	
	
data Int // incomplete
	= intCon(int intValue)
	| natCon(real realValue)
	| rangeType(Expr int1, Expr int2)
	| intPlus(Expr lhs, Expr rhs)
	| intMinus(Expr lhs, Expr rhs)
	| intMax(Expr lhs, Expr rhs);

data Op 
	= init(Type tp);

data Type
	= dataType()
	| tupType()
	| booleanType()
	| intType()
	| natType()
	| strType();

data String 
	= strCon(str val)
	| strConcat(Expr lhs, Expr rhs);

data Id = meta(str name); 
	*/
