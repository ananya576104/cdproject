%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
 
void yyerror(const char *s);
int yylex(void);

extern FILE* yyin;
%}
 
%union {
    int num;
    char* str;
}
 
%token <num> NUM
%token <str> ID
%token IF ELSE NEWLINE
%left '+' '-'
%left '*' '/'
 
%%
 
program:
    line_list
;
 
line_list:
    /* empty */
    | line_list line
;
 
line:
    NEWLINE
    | ID '=' expr NEWLINE
    {
        printf("Assignment: %s = expr\n", $1);
        free($1);
    }
    | IF '(' expr ')' ':' NEWLINE
    {
        printf("If statement detected\n");
    }
    | ELSE ':' NEWLINE
    {
        printf("Else statement detected\n");
    }
;
 
expr:
    expr '+' expr
    {
        printf("Addition expression\n");
    }
    | expr '-' expr
    {
        printf("Subtraction expression\n");
    }
    | expr '*' expr
    {
        printf("Multiplication expression\n");
    }
    | expr '/' expr
    {
        printf("Division expression\n");
    }
    | '(' expr ')'
    {
        printf("Parenthesized expression\n");
    }
    | ID
    {
        printf("Variable reference: %s\n", $1);
        free($1);
    }
    | NUM
    {
        printf("Number: %d\n", $1);
    }
;
 
%%
 
void yyerror(const char *s) {
    fprintf(stderr, "Syntax error: %s\n", s);
}

int main(int argc, char **argv) {
    if (argc > 1) {
        yyin = fopen(argv[1], "r");
        if (!yyin) {
            fprintf(stderr, "Error: Could not open file %s\n", argv[1]);
            return 1;
        }
    } else {
        yyin = stdin;
    }
    
    yyparse();
    
    if (yyin != stdin) {
        fclose(yyin);
    }
    
    printf("Parsing completed successfully\n");
    return 0;
}
