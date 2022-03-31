/* -*-bison-*- */
/* yacc_nonterm_hack Flex */
%option noyywrap
%option noinput
%option nounput

%%

\n				{ /* ignore newlines */ }

[ \t\r\f]+		{ /* ignore whitespace */ }

"//".*\r?\n		{ /* ignore single line comments */ }

"/*"([^*]|"*"+[^/*])*"*"+"/" 	{ /* ignore multi line comments */ }

\"([^"\n]|("\\\""))*\"			{ /* ignore string literals */ }


_PR_[A-Za-z0-9_]+\:				{ return 42; }
[A-Za-z0-9_]+\:					{ return 42; }
[A-Z0-9_]+						{ /* ignore longer words containing NT_ */ }

.								{ /* ignore all other characters */ }

%%
