module csf2rascal::generated::Prog::code_ProgType::code

extend csf2rascal::generated::Prog::Prog;
import csf2rascal::generated::Type::Type;

 
@doc{The result of a compilation.}
 

data Prog = code(Prog prog, Type \type);

		