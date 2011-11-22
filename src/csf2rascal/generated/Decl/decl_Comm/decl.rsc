module csf2rascal::generated::Decl::decl_Comm::decl

extend csf2rascal::generated::Decl::Decl;
import csf2rascal::generated::Comm::Comm;

 
@doc{This allows Comm to be executed in a sequence of declarations, computing the
 empty environment.}
 

data Decl = decl(Comm comm);

public Decl declaration(Comm comm) = 
	decl(comm);

		