%{
#include "y.tab.h"
#include <stdlib.h>
#include <stdio.h>
extern YYSTYPE yylval;
void yyerror(char *);
%}

%%
"sqrt" {	ECHO;
			printf(" -> ");
                yylval.strVal = strdup(yytext);
                return SQRT;
	}
	
[a-z]	{	ECHO;
			printf(" -> ");
                yylval.iVal = *yytext - 'a';
				return VARIABLE;
	}

[0-9]+	{	ECHO;
			printf(" -> ");
                yylval.iVal = atoi(yytext);
                return INTEGER;
	}

(([0-9]+(\.[0-9]*)?)|([0-9]*\.[0-9]+))	{	ECHO;
			printf(" -> ");
                yylval.dVal = atof(yytext);
				return REAL;
	}
	

[-+()=/*\^\!\n]     { ECHO;
		  if (*yytext!='\n') printf(" -> \n");
		  return *yytext; 
    }

[\t]   ;       /* skip whitespace */

.               { yyerror("Unknown character"); }

%%

int yywrap(void) {
    return 1;
}
