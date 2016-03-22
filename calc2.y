%{
#include <stdio.h>
#include <math.h>
void yyerror(char *);
int yylex(void);
int sym[26];
%}
%union{
	int iVal;
	double dVal;
	char* strVal;
}
%token <iVal> INTEGER
%token <dVal> REAL
%token <iVal> VARIABLE
%token <strVal> SQRT
%type <dVal>  statement expression

%left '+' '-'
%left '*' '/'
%right '^'

%%
program:
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
%%

void yyerror(char *s) {
    fprintf(stderr, "%s\n", s);
}

int main(void) {
    yyparse();
}
