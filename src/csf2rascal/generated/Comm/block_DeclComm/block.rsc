module csf2rascal::generated::Comm::block_DeclComm::block

extend csf2rascal::generated::Comm::Comm;



import csf2rascal::generated::Decl::Decl;


data Comm = block(Decl decl, Comm comm);
		