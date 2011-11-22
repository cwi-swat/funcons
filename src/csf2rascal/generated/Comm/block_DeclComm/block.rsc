module csf2rascal::generated::Comm::block_DeclComm::block

extend csf2rascal::generated::Comm::Comm;
import csf2rascal::generated::Decl::Decl;

 
@doc{The bindings in the Env computed by Decl are local to the block body Comm.}
 

data Comm = block(Decl decl, Comm comm);

public Comm blockScope(Decl decl, Comm comm) = 
	block(decl, comm);

		