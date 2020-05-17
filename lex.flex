import java.util.ArrayList;
import SyntaxAnalyser;
%%

%class LexerAnalyser
%standalone
%line
%column
%state unaryMinus, binaryMinus

%{

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

{Comment} {System.out.printf("Found Comment: %s - line: %d, start symbol: %d\n", yytext(), yyline+1, yycolumn); return COMMENT;}
{Keyword} {
            System.out.printf("Found Keyword: %s - line: %d, start symbol: %d\n", yytext(), yyline+1, yycolumn);
            switch (yytext()) {
                case "End" : return END_KEYWORD; break;
                case "Var" : return VAR_KEYWORD; break;
                case "DO" : return DO_KEYWORD; break;
                case "Begin" : return BEGIN_KEYWORD; break;
            }
      }
{LoopStart} {System.out.printf("Found LoopStart: %s - line: %d, start symbol: %d\n", yytext(), yyline+1, yycolumn); yybegin(unaryMinus); return LOOP_START;}
{Separator} {
                System.out.printf("Found Separator: %s - line: %d, start symbol: %d\n", yytext(), yyline+1, yycolumn);
                switch (yytext()) {
                    case ";" : return SEMICOLON_SEPARATOR; break;
                    case "," : return COMMA_SEPARATOR; break;
                    case ")" : return END_BRACKET; break;
                }
            }
{AppropriationSymbol} {System.out.printf("Found AppropriationSymbol: %s - line: %d, start symbol: %d\n", yytext(), yyline+1, yycolumn); yybegin(unaryMinus); return APPROPRIATION;}
{BinaryOperator} {
                    System.out.printf("Found BinaryOperator: %s - line: %d, start symbol: %d\n", yytext(), yyline+1, yycolumn); yybegin(unaryMinus);

                    switch (yytext()) {
                                        case "+" : return PLUS; break;
                                        case "*" : return TIMES; break;
                                        case "/" : return DIVIDE; break;
                                        case ">" : return GRATER_OPERATOR; break;
                                        case "<" : return LESS_OPERATOR; break;
                                        case "=" : return END_BRACKET; break;
                                        case "AND" : return AND_OPERATOR; break;
                                        case "OR" : return OR_OPERATOR; break;
                                        case "XOR" : return XOR_OPERATOR; break;
                                    }

                    }
{BracketStart} {System.out.printf("Found BracketStart: %s - line: %d, start symbol: %d\n", yytext(), yyline+1, yycolumn); yybegin(unaryMinus); return START_BRACKET;}
<unaryMinus> {
	{MinusSymbol} {System.out.printf("Found Unary MinusSymbol: %s - line: %d, start symbol: %d\n", yytext(), yyline+1, yycolumn); yybegin(unaryMinus); return UNARY_MINUS;}
	{BracketStart} {System.out.printf("Found BracketStart: %s - line: %d, start symbol: %d\n", yytext(), yyline+1, yycolumn); yybegin(unaryMinus); return START_BRACKET;}
	{Constant} 	{
					if (!identifiersConstants.contains(yytext())) {
						System.out.printf("Found Constant: %s, HEX: %s - line: %d, start symbol: %d\n", yytext(), getHex(yytext()), yyline+1, yycolumn);				 
						identifiersConstants.add(yytext());
					}
					yybegin(binaryMinus);
					return CONSTANT;
				}
	{Identifier} {
						if (!checkForKeyWords(yytext(), yyline+1, yycolumn)) {
							if (!identifiersConstants.contains(yytext())) {
								System.out.printf("Found Identificator: %s - line: %d, start symbol: %d\n", yytext(), yyline+1, yycolumn);					 
								identifiersConstants.add(yytext());
							}
						}
						yybegin(binaryMinus);
						return IDENTIFIER;
					}
}
{Constant}  {	
				if (!identifiersConstants.contains(yytext())) {
					System.out.printf("Found Constant: %s, HEX: %s - line: %d, start symbol: %d\n", yytext(), getHex(yytext()), yyline+1, yycolumn);				 
					identifiersConstants.add(yytext());
				}
				yybegin(binaryMinus);
				return CONSTANT;
			}
{Identifier} {
					if (!checkForKeyWords(yytext(), yyline+1, yycolumn)) {
						if (!identifiersConstants.contains(yytext())) {
							System.out.printf("Found Identificator: %s - line: %d, start symbol: %d\n", yytext(), yyline+1, yycolumn);					 
							identifiersConstants.add(yytext());
						}
					}
					yybegin(binaryMinus);
					return IDENTIFIER;
				}
<binaryMinus> {				
	{MinusSymbol} {System.out.printf("Found Binary MinusSymbol: %s - line: %d, start symbol: %d\n", yytext(), yyline+1, yycolumn); return BINARY_MINUS;}
}
{Whitespaces} {return SPACE;}
. {System.out.printf("ERROR. Unknown lexem: %s - line: %d, start symbol: %d\n", yytext(), yyline+1, yycolumn); return ERROR;}
