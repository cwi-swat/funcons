module Runner

import lang::pico::semantic::Load;
import funcons::Funcons;


public loc factorial = |project://funcons/pico/factorial.pico|;

public Prog getFuncons(loc picoFile) = loadFuncons(picoFile);
public Prog getFuncons(str picoString) = loadFuncons(picoString);
/*
public lang::pico::ast::Main::Program getAst(loc picoFile) {
	cst = getCst(picoFile);
	return implode(#lang::pico::ast::Main::Program, cst);
}*/

