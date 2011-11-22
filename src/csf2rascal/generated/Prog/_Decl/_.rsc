module csf2rascal::generated::Prog::_Decl::_

extend csf2rascal::generated::Prog::Prog;
import csf2rascal::generated::Decl::Decl;

 
@doc{When a Prog is a Decl, it computes an Env.}
 

data Prog = decl(Decl decl);

		