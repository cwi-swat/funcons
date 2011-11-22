module csf2rascal::generated::Prog::_Comm::_

extend csf2rascal::generated::Prog::Prog;
import csf2rascal::generated::Comm::Comm;

 
@doc{When a Prog is a Comm, it does not compute any result.}
 

data Prog = comm(Comm comm);

		