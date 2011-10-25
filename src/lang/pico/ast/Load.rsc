module lang::pico::ast::Load

import lang::pico::cst::Load;
import lang::pico::ast::Main;
import ParseTree;



public lang::pico::ast::Main::Program loadAst(loc picoFile) 
	= implode(#lang::pico::ast::Main::Program, loadCst(picoFile));
	
public lang::pico::ast::Main::Program loadAst(str picoString) 
	= implode(#lang::pico::ast::Main::Program, loadCst(picoString));
