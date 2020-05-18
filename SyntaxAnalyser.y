%language "Java"

%define api.parser.class {SyntaxAnalyser}
%define api.parser.public

%token COMMENT
%token END_KEYWORD VAR_KEYWORD DO_KEYWORD BEGIN_KEYWORD
%token LOOP_START
%token SEMICOLON_SEPARATOR COMMA_SEPARATOR END_BRACKET
%token APPROPRIATION
%token PLUS MULTIPLY DIVIDE GRATER_OPERATOR LESS_OPERATOR EQUALS_OPERATOR AND_OPERATOR OR_OPERATOR XOR_OPERATOR
%token UNARY_MINUS
%token START_BRACKET
%token CONSTANT
%token IDENTIFIER
%token BINARY_MINUS EOL NUM

%start program

%%

program:
    variablesDeclarations programBody {}
    ;

programBody:
    BEGIN_KEYWORD operators END_KEYWORD { $$ = $3 }
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
   appropriation
   | complexOperator
   | hardOperator
   ;

appropriation:
    IDENTIFIER
    | expression SEMICOLON_SEPARATOR
    ;

complexOperator:
    BEGIN_KEYWORD operators END_KEYWORD { $$ = $3 }
    ;

hardOperator:
    loopOperator
    ;

expression:
    UNARY_MINUS subExpression
    | subExpression
    ;

subExpression:
    expression
    | operand
    | subExpression PLUS subExpression { $$ = $1 + $3; }
    | subExpression MULTIPLY subExpression { $$ = $1 * $3; }
    | subExpression DIVIDE subExpression { $$ = $1 / $3; }
    | subExpression GRATER_OPERATOR subExpression { $$ = $1 > $3; }
    | subExpression LESS_OPERATOR subExpression { $$ = $1 < $3; }
    | subExpression EQUALS_OPERATOR subExpression {}
    | subExpression AND_OPERATOR subExpression {}
    | subExpression OR_OPERATOR subExpression   {}
    | subExpression XOR_OPERATOR subExpression  {}
    ;

loopOperator:
    LOOP_START expression DO_KEYWORD operator
    ;

%%