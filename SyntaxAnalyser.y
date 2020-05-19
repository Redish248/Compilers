%language "Java"

%define api.parser.class {SyntaxAnalyser}
%define api.parser.public


%token COMMENT
%token END_KEYWORD VAR_KEYWORD DO_KEYWORD BEGIN_KEYWORD
%token LOOP_START
%token SEMICOLON_SEPARATOR COMMA_SEPARATOR END_BRACKET
%token APPROPRIATION_OPERATOR
%token PLUS MULTIPLY DIVIDE GRATER_OPERATOR LESS_OPERATOR EQUALS_OPERATOR AND_OPERATOR OR_OPERATOR XOR_OPERATOR
%token UNARY_MINUS
%token START_BRACKET
%token <Integer> CONSTANT
%token IDENTIFIER
%token BINARY_MINUS


%start program

%%

program:
    variablesDeclarations programBody {}
    ;

programBody:
    BEGIN_KEYWORD operators END_KEYWORD { $$ = $2 }
    ;

variablesDeclarations:
    { $$ = NULL}
    | VAR_KEYWORD variables { $$ = $2 }
    ;

variables:
    IDENTIFIER SEMICOLON_SEPARATOR {}
    | IDENTIFIER COMMA_SEPARATOR variables { $$ = $3 }
    | IDENTIFIER SEMICOLON_SEPARATOR variables { $$ = $3 }
    ;

operators:
    operator
    | operator operators
    ;

operator:
   IDENTIFIER APPROPRIATION_OPERATOR expression
   | BEGIN_KEYWORD operators END_KEYWORD { $$ = $3 }
   | LOOP_START expression DO_KEYWORD operator
   ;


expression:
    UNARY_MINUS expression
    | START_BRACKET expression END_BRACKET { $$ = $2}
    | expression PLUS expression { $$ = $1 + $3; }
    | expression MULTIPLY expression { $$ = $1 * $3; }
    | expression DIVIDE expression { $$ = $1 / $3; }
    | expression GRATER_OPERATOR expression { $$ = $1 > $3 ? true : false; }
    | expression LESS_OPERATOR expression { $$ = $1 < $3; }
    | expression EQUALS_OPERATOR expression {}
    | expression AND_OPERATOR expression {}
    | expression OR_OPERATOR expression   {}
    | expression XOR_OPERATOR expression  {}
    | IDENTIFIER
    | CONSTANT
    ;

%%