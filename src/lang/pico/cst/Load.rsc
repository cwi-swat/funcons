module lang::pico::cst::Load

import lang::pico::\syntax::Main;
import ParseTree;

public lang::pico::\syntax::Main::Program loadCst(loc picoFile) 
	= parse(#lang::pico::\syntax::Main::Program, picoFile);

public lang::pico::\syntax::Main::Program loadCst(str picoString) 
	= parse(#lang::pico::\syntax::Main::Program, picoString);