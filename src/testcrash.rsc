module testcrash

layout JustSpaces = [\ ]*;

syntax Crash = VariableUnique+ vars;

lexical VariableUnique = [A-Z]+ [0-9]*;