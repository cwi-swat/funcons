module Runner

import lang::pico::ast::Main;
import lang::pico::ast::Load;



public loc factorial = |project://funcons/pico/factorial.pico|;

public Program getAst(loc picoFile) = loadAst(picoFile);
public Program getAst(str picoString) = loadAst(picoString);
/*
public lang::pico::ast::Main::Program getAst(loc picoFile) {
	cst = getCst(picoFile);
	return implode(#lang::pico::ast::Main::Program, cst);
}*/

