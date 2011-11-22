module csf2rascal::generated::Comm::seq_Comms::seq

extend csf2rascal::generated::Comm::Comm;

data Comm = seq(list[Comm] comms);

public Comm sequential(list[Comm] comms) = 
	seq(comms);

		