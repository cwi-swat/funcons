module csf2rascal::generated::Decl::_Env::_

extend csf2rascal::generated::Decl::Decl;
import csf2rascal::generated::Env::Env;

 
@doc{An Env is a Decl which trivially computes it.}
 

data Decl = env(Env env);

		