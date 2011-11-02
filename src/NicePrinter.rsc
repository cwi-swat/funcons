module NicePrinter

import ParseTree;
import IO;
import String;
import Node;
import List;

data SimplifiedTree
	= ProdNode(str label, list[SimplifiedTree] children)
	| AmbNode(set[SimplifiedTree] alts)
	| LitNode(str lit)
	| LexNode(str lit)
	;
	
//data Tree 
//  = appl(Production prod, list[Tree] args) 
//  | cycle(Symbol symbol, int cycleLength) 
//  | amb(set[Tree] alternatives)  
//  | char(int character)
//  ;
//data Tree 
//  = error(Production prod, list[Tree] args, list[Tree] rest)
//  | expected(Symbol symbol)
//  | erroramb(set[Tree] alternatives)
//  | errorcycle(Symbol symbol, int cycleLength)
//  ;
private SimplifiedTree simplifyNoCollapse(Tree pt) {
	switch(pt) {
		case appl(p,ags) :
			return simplifyNoCollapse(p,ags);
		case cycle(_,_) :
			throw "We do not currently handle cycle nodes";
		case amb(alts) :
			return AmbNode({simplifyNoCollapse(altsi) | altsi <- alts});
		case char(n) :
			return LitNode("<stringChar(n)>");
		case error(_,_,_) :
			throw "We do not currently handle error trees";
		case expected(_) :
			throw "We do not currently handle error trees";
		case erroramb(_) :
			throw "We do not currently handle error trees";
		case errorcycle(_,_) :
			throw "We do not currently handle error trees";
		default :
			throw "Unhandled node <getName(pt)>";				
	}
}

//data Production 
//  = prod(Symbol def, list[Symbol] symbols, set[Attr] attributes) 
//  | regular(Symbol def)
//  ;
private SimplifiedTree simplifyNoCollapse(Production p, list[Tree] args) {
	switch(p) {
		case prod(\start(s),ss,ats) :
			return simplifyNoCollapse(prod(s,ss,ats),args); 
		case prod(\sort(sn),ss,ats) :
			return ProdNode(sn,[simplifyNoCollapse(ag) | ag <- args]); 
		case prod(\lex(ln),ss,ats) :
			return ProdNode(ln,[simplifyNoCollapse(ag) | ag <- args]); 
		case prod(\layouts(_),ss,ats) :
			return LitNode(""); 
		case prod(s:\parameterized-sort(sn,ps),ss,ats) :
			return ProdNode(stringifySymbol(s),[simplifyNoCollapse(ag) | ag <- args]); 
		case prod(\label(pn,sy),ss,ats) :
			return ProdNode(pn,[simplifyNoCollapse(ag) | ag <- args]); 
		case prod(\lit(s),ss,ats) :
			return LitNode(s);
		case prod(\cilit(s),ss,ats) :
			return LitNode(s);
		case regular(s) :
			return LexNode(stringifySymbol(s));
		default :
			throw "Unhandled node <p>";				
	}
}

private str stringifySymbol(Symbol s) {
	switch(s) {
		case \sort(sn) : return sn;
		case \lex(ln) : return ln;
		case \layouts(ln) : return "";
		case \keywords(kn) : return kn;
		case \parameterized-sort(sn,ps) : return "<sn>[<intercalate(",",[stringifySymbol(p)|p<-ps])>]";
		case \parameter(pn) : return pn;
		case \label(ln,s2) : return ln;
		case \lit(s2) : return s2;
		case \cilit(s2) : return s2;
		case \char-class(rs) : return "<rs>"; // TODO: Make this better...
		case \empty() : return "";
		case \opt(s2) : return "<stringifySymbol(s2)>?";
		case \iter(s2) : return "<stringifySymbol(s2)>+"; 		
		case \iter-star(s2) : return "<stringifySymbol(s2)>*"; 		
		case \iter-seps(s2,seps) : return "{<stringifySymbol(s2)> <intercalate(",",["\"<stringifySymbol(sep)>\"" | sep <- seps])>}+"; 		
		case \iter-star-seps(s2,seps) : return "{<stringifySymbol(s2)> <intercalate(",",["\"<stringifySymbol(sep)>\"" | sep <- seps])>}*"; 
		case \alt(alts) : return intercalate(" | ", [stringifySymbol(alti) | alti <- alts]);
		case \seq(alts) : return intercalate(" ", [stringifySymbol(alti) | alti <- alts]);
		case \conditional(s2,_) : return "<stringifySymbol(s2)>??"; // TODO: add conditional logic
		default : throw "Unhandled Symbol <s>";
	}
}

//private SimplifiedTree simplifyNoCollapse(Tree pt) {
//	switch(pt) {
//		case appl(prod(\label(pn,s),ss,ats),ags) :
//			return ProdNode(pn,[simplifyNoCollapse(ag) | ag <- ags]); 
//		case appl(prod(\sort(sn),ss,ats),ags) :
//			return ProdNode(sn,[simplifyNoCollapse(ag) | ag <- ags]); 
//		case appl(prod(\lex(ln),ss,ats),ags) :
//			return ProdNode(ln,[simplifyNoCollapse(ag) | ag <- ags]); 
//		case appl(prod(\layouts(_),ss,ats),ags) :
//			return LitNode(""); 
//		case appl(prod(\lit(s),ss,ats),ags) :
//			return LitNode(s);
//		case amb(alts) :
//			return AmbNode({simplifyNoCollapse(altsi) | altsi <- alts});
//		case char(n) :
//			return LitNode("<stringChar(n)>");
//		default: {
//			iprint(pt);
//			throw "ERROR";
//		}
//	}
//}

private SimplifiedTree simplifyTree(Tree pt) {
	SimplifiedTree st = simplifyNoCollapse(pt);
	stp = visit(st) {
		case ProdNode(l,cs) : {
			while ([c1*,LitNode(s1),LitNode(s2),c2*] := cs) cs = [c1,LitNode(s1+s2),c2];
			while ([c1*,LexNode(s1),LexNode(s2),c2*] := cs) cs = [c1,LexNode(s1+" "+s2),c2];
			insert(ProdNode(l,cs));
		}
	}
	return stp;
}

private node simplify(SimplifiedTree st) {
	switch(st) {
		case ProdNode(l,cs) : {
			list[value] vl = [];
			vl = for (c <- cs) if (LitNode(s) := c)  append(s); else append(simplify(c));
			return makeNode(l,vl);
		}
		case AmbNode(alts) : {
			list[value] vl = [];
			vl = for (a <- alts) if (LitNode(s) := a)  append(s); else append(simplify(a));
			return makeNode("amb",vl);
		}
		case LitNode(l) :
			return makeNode(l);
		case LexNode(l) :
			return makeNode("lex",l);
	}
}

public node simplify(Tree pt) {
	return simplify(simplifyTree(pt));
}

