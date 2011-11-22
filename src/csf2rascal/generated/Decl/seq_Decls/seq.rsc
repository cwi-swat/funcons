module csf2rascal::generated::Decl::seq_Decls::seq

extend csf2rascal::generated::Decl::Decl;

data Decl = seq(list[Decl] decls);

public Decl sequential(list[Decl] decls) = 
	seq(decls);

		