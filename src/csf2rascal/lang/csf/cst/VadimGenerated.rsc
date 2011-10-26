module csf2rascal::lang::csf::cst::VadimGenerated

syntax RELATION
       =
       TERM
 ;
syntax EQUATION
       =
       TERM "=" TERM
 ;
syntax TERM
       =
       ATOM+
 ;
syntax ATOM
       = VARIABLE
       | CONSTANT
       | NAME
       | SYMBOL
       | "(" {TERM ","}* ")"
 ;
syntax FORMULA
       = "def" TERM
       | "not" FORMULA
       | RELATION
       | EQUATION
 ;
syntax CSF
       =
       NOTATION ITEM*
 ;
syntax NOTATION
       = SORT
       | SORT "::=" ALTERNATIVE
 ;
syntax ALTERNATIVE
       = NAME
       | NAME "(" SORT ("," SORT)* ")"
       | NAME "(" SORT REG ")"
       | SORT "(" SORT REG ")"
       | SORT
 ;
syntax ITEM
       = "Alias:" SORT
       | "Alias:" NAME
       | "Glossary:" TEXT+
       | "Uses:" NOTATION ("," NOTATION)*
       | "Local:" DEFINITION ("," DEFINITION)*
       | "Relation:" PART+ COMPUTES?
       | RULE
 ;
syntax TEXT
       = "$" TERM "$"
       | WORD
       | PUNCTUATION
 ;
syntax DEFINITION
       = SORT "=" SORT
       | SORT "=" SORT "strcon2chardata(\"\\\\\")" ALTERNATIVE
 ;
syntax PART
       =
       "(" PART ("," PART)* ")"
 ;
syntax COMPUTES
       =
       "Computes:" VARIABLE ("," VARIABLE)*
 ;
syntax RULE
       = LABEL FORMULA
       | LABEL FORMULA ("," FORMULA)* INFER FORMULA
 ;