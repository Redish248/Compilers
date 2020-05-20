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

%type <Tree> program programBody variablesDeclarations variables operators operator expression


%start program

%%

program:
    variablesDeclarations programBody { $$ = astNode("ROOT", "Variable Declaration", "Program Body") }
    ;

programBody:
    BEGIN_KEYWORD operators END_KEYWORD { $$ = $2 }
    ;

variablesDeclarations:
    VAR_KEYWORD variables { $$ = astNode("Variables Declaration", "Var", "Variables") }
    ;

variables:
    IDENTIFIER SEMICOLON_SEPARATOR { $$ = astNode("", "", "") }
    | IDENTIFIER COMMA_SEPARATOR variables { $$ = astNode("", "", "") }
    | IDENTIFIER SEMICOLON_SEPARATOR variables { $$ = astNode("", "", "") }
    ;

operators:
    operator { $$ = astNode("", "", "") }
    | operator operators { $$ = astNode("", "", "") }
    ;

operator:
   IDENTIFIER APPROPRIATION_OPERATOR expression { $$ = astNode("", "", "") }
   | BEGIN_KEYWORD operators END_KEYWORD { $$ = astNode("", "", "") }
   | LOOP_START expression DO_KEYWORD operator { $$ = astNode("", "", "") }
   ;


expression:
    UNARY_MINUS expression { $$ = astNode("", "", "") }
    | START_BRACKET expression END_BRACKET { $$ = astNode("", "", "") }
    | expression PLUS expression { $$ = astNode("+", "Expression", "Expression"); }
    | expression MULTIPLY expression { $$ = astNode("*", "Expression", "Expression");; }
    | expression DIVIDE expression { $$ = astNode("/", "Expression", "Expression");; }
    | expression GRATER_OPERATOR expression { $$ = astNode(">", "Expression", "Expression");; }
    | expression LESS_OPERATOR expression { $$ = astNode("<", "Expression", "Expression");; }
    | expression EQUALS_OPERATOR expression { $$ = astNode("=", "Expression", "Expression"); }
    | expression AND_OPERATOR expression { $$ = astNode("AND", "Expression", "Expression"); }
    | expression OR_OPERATOR expression   { $$ = astNode("OR", "Expression", "Expression"); }
    | expression XOR_OPERATOR expression  { $$ = astNode("XOR", "Expression", "Expression"); }
    | IDENTIFIER { $$ = astNode("", "", "") }
    | CONSTANT { $$ = astNode("", "", "") }
    ;

%%