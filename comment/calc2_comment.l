%{
#include "y.tab.h"
#include <stdlib.h>
#include <stdio.h>
extern YYSTYPE yylval;	/* variable and function is declared in .y file */
void yyerror(char *);
%}

%%
"sqrt" {	ECHO;    /* when the name of sqrt() is matched,return the token which input is matched to and set the value of token */
		printf(" -> ");
                yylval.strVal = strdup(yytext);		/* set the string("sqrt") to yylval whose data type is char* */
                return SQRT;
	}
	
[a-z]	{	ECHO;
		printf(" -> ");
                yylval.iVal = *yytext - 'a';		/* the index of sym[26] declared in .y file */
                return VARIABLE;
	}

[0-9]+	{	ECHO;
		printf(" -> ");
                yylval.iVal = atoi(yytext);  				/* integer */
                return INTEGER;
	}

(([0-9]+(\.[0-9]*)?)|([0-9]*\.[0-9]+))	{	ECHO;		/* real number */
		printf(" -> ");
                yylval.dVal = atof(yytext);				/* default data type of return (integer) to float */
                return REAL;
	}
	

[-+()=/*\^\!\n]     { ECHO; 						/* '^' and '!' have to be escaped with '\' */
		  if (*yytext!='\n') printf(" -> \n");
		  return *yytext; 
                }

[\t]   ;       /* skip whitespace */

.               { yyerror("Unknown character"); }

%%

int yywrap(void) {
    return 1;
}
