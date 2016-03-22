%{
#include <stdio.h>
#include <math.h>	/* for using the built-in function of sqrt 
void yyerror(char *);
int yylex(void);
int sym[26];		/* input:a=value,0-25 is the index of a-z,the value of array is value of expression */
%}
%union{
	int iVal;
	double dVal;
	char* strVal;
}					/* the data type of yylval from yylex() */
%token <iVal> INTEGER		/* take from "return .." in .l file */
%token <dVal> REAL
%token <iVal> VARIABLE
%token <strVal> SQRT      /* the type of  string sqrt of "sqrt()" */
%type <dVal>  statement expression 		/* default type of statement and expression is double */

%left '+' '-' 		/* left combination */
%left '*' '/'
%right '^'

%%   /* when input is read form left to right,create syntax tree using rules from upper to bottom */
program:		/* root of tree */
        program  statement '\n'		{ printf("result = %lf\n", $2); }
        | /* NULL */
        ;

statement:
        expression                      { printf("expression -> statement \n"); $$ = $1;}
        | VARIABLE '=' expression       { printf("VARIABLE = expression -> statement\n"); sym[$1] = $3; }
		;

expression:
        INTEGER							{ printf("INTEGER -> expression\n");$$ = $1;}	
		| INTEGER '!'					{ printf("INTEGER ! -> expression\n");
										  $$=1;
										  do{
											$$ *= $1;
											$1 =$1-1;;
										  }while($1>=1);
										  }	
        | VARIABLE                      { printf("VARIABLE -> expression\n"); $$ = sym[$1]; }	
		| REAL							{ printf("REAL -> expression\n");$$ = $1;}
        | expression '+' expression     { printf("expression + expression -> expression\n"); $$ = $1 + $3; }
        | expression '-' expression     { printf("expression - expression -> expression\n"); $$ = $1 - $3; }
        | expression '*' expression     { printf("expression * expression -> expression\n"); $$ = $1 * $3; }
        | expression '/' expression     { printf("expression / expression -> expression\n"); $$ = $1 / $3; }
		| expression '^' expression     { printf("expression ^ expression -> expression\n"); $$ = pow($1,$3); }
		| '(' expression ')'            { printf("( expression ) -> expression\n"); $$ = $2; }
		| SQRT '(' expression ')'		{ printf("SQRT( expression ) -> expression"); $$ = sqrt($3);}
		;
/* shift input into stack one by one until the top ones are matched by the right of one rule,
   reduce the top ones from stack and calculate the value,
   the priority of rule : low to high (upper to bottom),so that the longest is matched */
%%

void yyerror(char *s) {
    fprintf(stderr, "%s\n", s);
}

int main(void) {
    yyparse();			/* call "yylex()"" automaticly */
}
