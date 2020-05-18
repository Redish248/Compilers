%language "Java"

%define api.parser.class {SyntaxAnalyser}
%define api.parser.public

%token COMMENT
%token END_KEYWORD VAR_KEYWORD DO_KEYWORD BEGIN_KEYWORD
%token LOOP_START
%token SEMICOLON_SEPARATOR COMMA_SEPARATOR END_BRACKET
%token APPROPRIATION
%token PLUS TIMES DIVIDE GRATER_OPERATOR LESS_OPERATOR EQUALS_BRACKET AND_OPERATOR OR_OPERATOR XOR_OPERATOR
%token UNARY_MINUS
%token START_BRACKET
%token CONSTANT
%token IDENTIFIER
%token BINARY_MINUS EOL NUM



%%
input:
  line
| input line
;

line:
  EOL
| exp EOL            { System.out.println($exp); }
| error EOL
;

exp:
  NUM                { $$ = $1; }
| exp "=" exp
  {
    if ($1.intValue() != $3.intValue())
      yyerror(@$, "calc: error: " + $1 + " != " + $3);
  }
| exp "+" exp        { $$ = $1 + $3;  }
| exp "-" exp        { $$ = $1 - $3;  }
| exp "*" exp        { $$ = $1 * $3;  }
| exp "/" exp        { $$ = $1 / $3;  }
| exp "^" exp        { $$ = (int) Math.pow($1, $3); }
| "(" exp ")"        { $$ = $2; }
| "(" error ")"      { $$ = 1111; }
;

%%