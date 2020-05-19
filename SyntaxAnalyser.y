%language "Java"

%define api.parser.class {SyntaxAnalyser}
%define api.parser.public


%code imports {
  import java.io.IOException;
}

%token COMMENT
%token END_KEYWORD VAR_KEYWORD DO_KEYWORD BEGIN_KEYWORD
%token LOOP_START
%token SEMICOLON_SEPARATOR COMMA_SEPARATOR END_BRACKET
%token APPROPRIATION_OPERATOR
%token PLUS MULTIPLY DIVIDE GRATER_OPERATOR LESS_OPERATOR EQUALS_OPERATOR AND_OPERATOR OR_OPERATOR XOR_OPERATOR
%token UNARY_MINUS
%token START_BRACKET
%token CONSTANT
%token IDENTIFIER
%token BINARY_MINUS

%code {
     public static void main(String[] args) throws IOException {

           String encodingName = "UTF-8";

              try {
                 java.nio.charset.Charset.forName(encodingName); // Side-effect: is encodingName valid?
              } catch (Exception e) {
                 System.out.println("Invalid encoding '" + encodingName + "'");
                 return;
              }

           LexerAnalyser scanner = null;
           try {
              java.io.FileInputStream stream = new java.io.FileInputStream(args[0]);
              java.io.Reader reader = new java.io.InputStreamReader(stream, encodingName);
              scanner = new LexerAnalyser(reader);
           }
           catch (java.io.FileNotFoundException e) {
              System.out.println("File not found : \""+args[0]+"\"");
           }
           catch (java.io.IOException e) {
              System.out.println("IO error scanning file \""+args[0]+"\"");
              System.out.println(e);
           }
           catch (Exception e) {
              System.out.println("Unexpected exception:");
              e.printStackTrace();
           }

           SyntaxAnalyser syntaxAnalyser = new SyntaxAnalyser((SyntaxAnalyser.Lexer)scanner);
           Compiler compiler = new Compiler();
           compiler.createRootNode();
           syntaxAnalyser.parse();
        }
}

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