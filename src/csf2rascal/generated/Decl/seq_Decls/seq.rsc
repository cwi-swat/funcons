module csf2rascal::generated::Decl::seq_Decls::seq

extend csf2rascal::generated::Decl::Decl;

 
@doc{The sub-declarations are executed sequentially, each in the scope of all the
 previous declarations.
 The resulting environments are combined, with later bindigs overriding earlier ones
.}
 

data Decl = seq(list[Decl] decls);

public Decl sequential(list[Decl] decls) = 
	seq(decls);

		