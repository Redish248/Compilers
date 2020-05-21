import java.lang.String;
import java.util.ArrayList;
%%

%class LexerAnalyser
%implements SyntaxAnalyser.Lexer
%standalone
%line
%column
%state unaryMinus, binaryMinus

%{

    private Object yylval;

    public Object getLVal() {
        return yylval;
    }

    public void yyerror(String message) {
      System.out.println(message);
    }

	ArrayList<String> identifiersConstants = new ArrayList();

	private String getHex(String number) {
		return Integer.toString(Integer.parseInt(number), 16);
	}

	private boolean checkForKeyWords(String lexem, int line, int symbol) {
		String[] words = {"End", "Var", "Do", "Begin", "AND", "XOR", "WHILE", "OR"};

		for (int i = 0; i < 8; i++) {
			if (words[i].toLowerCase().equals(lexem.toLowerCase())) {
				System.out.printf("Found unknown Lexem: '%s'. Didn't you mean '%s'? Line - %d, start symbol - %d\n", lexem, words[i], line, symbol);
				return true;
			}
		}

		return false;
	}

%}

Comment = [/][*][^*]*[*]+([^*/][^*]*[*]+)*[/]
Keyword = "End" | "Var" | "DO" | "Begin"
Separator = [;,)]
AppropriationSymbol = ":="
BinaryOperator = "+" | "*" | "/" | ">" | "<" | "=" | "AND" | "OR" | "XOR"
MinusSymbol = "-"
Constant = [0-9]+
Identifier = [a-zA-Z]+
Whitespaces = [ \t\n\r]
BracketStart = "(" 
LoopStart = "WHILE"

%%

{Comment} {
            System.out.printf("Found Comment: %s - line: %d, start symbol: %d\n", yytext(), yyline+1, yycolumn);
            yylval = new String(yytext());
            //return SyntaxAnalyser.Lexer.COMMENT;
        }
{Keyword} {
            System.out.printf("Found Keyword: %s - line: %d, start symbol: %d\n", yytext(), yyline+1, yycolumn);
            yylval = new String(yytext());
            switch (yytext()) {
                case "End" : return SyntaxAnalyser.Lexer.END_KEYWORD;
                case "Var" : return SyntaxAnalyser.Lexer.VAR_KEYWORD;
                case "DO" : return SyntaxAnalyser.Lexer.DO_KEYWORD;
                case "Begin" : return SyntaxAnalyser.Lexer.BEGIN_KEYWORD;
            }
      }
{LoopStart} {
                System.out.printf("Found LoopStart: %s - line: %d, start symbol: %d\n", yytext(), yyline+1, yycolumn);
                yylval = new String(yytext());
                yybegin(unaryMinus);
                return SyntaxAnalyser.Lexer.LOOP_START;}
{Separator} {
                System.out.printf("Found Separator: %s - line: %d, start symbol: %d\n", yytext(), yyline+1, yycolumn);
                yylval = new String(yytext());
                switch (yytext()) {
                    case ";" : return SyntaxAnalyser.Lexer.SEMICOLON_SEPARATOR;
                    case "," : return SyntaxAnalyser.Lexer.COMMA_SEPARATOR;
                    case ")" : return SyntaxAnalyser.Lexer.END_BRACKET;
                }
            }
{AppropriationSymbol} {
                        System.out.printf("Found AppropriationSymbol: %s - line: %d, start symbol: %d\n", yytext(), yyline+1, yycolumn);
                        yylval = new String(yytext());
                        yybegin(unaryMinus);
                        return SyntaxAnalyser.Lexer.APPROPRIATION_OPERATOR;
                    }
{BracketStart} {
                    System.out.printf("Found BracketStart: %s - line: %d, start symbol: %d\n", yytext(), yyline+1, yycolumn);
                    yylval = new String(yytext());
                    yybegin(unaryMinus);
                    return SyntaxAnalyser.Lexer.START_BRACKET;
                }
{BinaryOperator} {
                    System.out.printf("Found BinaryOperator: %s - line: %d, start symbol: %d\n", yytext(), yyline+1, yycolumn);
                    yylval = new String(yytext());
                    yybegin(unaryMinus);
                    switch (yytext()) {
                                        case "+" : return SyntaxAnalyser.Lexer.PLUS;
                                        case "*" : return SyntaxAnalyser.Lexer.MULTIPLY;
                                        case "/" : return SyntaxAnalyser.Lexer.DIVIDE;
                                        case ">" : return SyntaxAnalyser.Lexer.GRATER_OPERATOR;
                                        case "<" : return SyntaxAnalyser.Lexer.LESS_OPERATOR;
                                        case "=" : return SyntaxAnalyser.Lexer.EQUALS_OPERATOR;
                                        case "AND" : return SyntaxAnalyser.Lexer.AND_OPERATOR;
                                        case "OR" : return SyntaxAnalyser.Lexer.OR_OPERATOR;
                                        case "XOR" : return SyntaxAnalyser.Lexer.XOR_OPERATOR;
                                    }

                    }
<unaryMinus> {
	{MinusSymbol} {
                    System.out.printf("Found Unary MinusSymbol: %s - line: %d, start symbol: %d\n", yytext(), yyline+1, yycolumn);
                    yylval = new String(yytext());
                    yybegin(unaryMinus);
                    return SyntaxAnalyser.Lexer.UNARY_MINUS;
                }
	{BracketStart} {
                    System.out.printf("Found BracketStart: %s - line: %d, start symbol: %d\n", yytext(), yyline+1, yycolumn);
                    yylval = new String(yytext());
                    yybegin(unaryMinus);
                    return SyntaxAnalyser.Lexer.START_BRACKET;
                }
	{Constant} 	{
					if (!identifiersConstants.contains(yytext())) {
						System.out.printf("Found Constant: %s, HEX: %s - line: %d, start symbol: %d\n", yytext(), getHex(yytext()), yyline+1, yycolumn);				 
						identifiersConstants.add(yytext());
					}
					yylval = new Integer(yytext());
					yybegin(binaryMinus);
					return SyntaxAnalyser.Lexer.CONSTANT;
				}
	{Identifier} {
						if (!checkForKeyWords(yytext(), yyline+1, yycolumn)) {
							if (!identifiersConstants.contains(yytext())) {
								System.out.printf("Found Identificator: %s - line: %d, start symbol: %d\n", yytext(), yyline+1, yycolumn);					 
								identifiersConstants.add(yytext());
							}
						}
						yylval = new String(yytext());
						yybegin(binaryMinus);
						return SyntaxAnalyser.Lexer.IDENTIFIER;
					}
}
{Constant}  {	
				if (!identifiersConstants.contains(yytext())) {
					System.out.printf("Found Constant: %s, HEX: %s - line: %d, start symbol: %d\n", yytext(), getHex(yytext()), yyline+1, yycolumn);				 
					identifiersConstants.add(yytext());
				}
				yylval = new Integer(yytext());
				yybegin(binaryMinus);
				return SyntaxAnalyser.Lexer.CONSTANT;
			}
{Identifier} {
					if (!checkForKeyWords(yytext(), yyline+1, yycolumn)) {
						if (!identifiersConstants.contains(yytext())) {
							System.out.printf("Found Identificator: %s - line: %d, start symbol: %d\n", yytext(), yyline+1, yycolumn);					 
							identifiersConstants.add(yytext());
						}
					}
					yylval = new String(yytext());
					yybegin(binaryMinus);
					return SyntaxAnalyser.Lexer.IDENTIFIER;
				}
<binaryMinus> {				
	{MinusSymbol} {
                    System.out.printf("Found Binary MinusSymbol: %s - line: %d, start symbol: %d\n", yytext(), yyline+1, yycolumn);
                    yylval = new String(yytext());
                    return SyntaxAnalyser.Lexer.BINARY_MINUS;
                }
}
{Whitespaces} {}
. {System.out.printf("ERROR. Unknown lexem: %s - line: %d, start symbol: %d\n", yytext(), yyline+1, yycolumn); System.exit(0);}
