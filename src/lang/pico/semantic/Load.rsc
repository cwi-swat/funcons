module lang::pico::semantic::Load

import lang::pico::semantic::Main;
import lang::pico::ast::Load;
import funcons::Funcons;

public Prog loadFuncons(loc picoFile) 
	= pico2Prog(loadAst(picoFile));
	
public Prog loadFuncons(str picoString) 
	= pico2Prog(loadAst(picoString));