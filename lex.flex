import java.util.ArrayList; 

%%

%class LexerAnalyser
%standalone
%line
%column
%state unaryMinus



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
Identificator = [a-zA-Z]+
Whitespaces = [ \t\n\r]
BracketStart = "(" 
LoopStart = "WHILE"

%%

{Comment} {System.out.printf("Found Comment: %s - line: %d, start symbol: %d\n", yytext(), yyline+1, yycolumn);}
{Keyword} {System.out.printf("Found Keyword: %s - line: %d, start symbol: %d\n", yytext(), yyline+1, yycolumn);}
{LoopStart} {System.out.printf("Found LoopStart: %s - line: %d, start symbol: %d\n", yytext(), yyline+1, yycolumn); yybegin(unaryMinus);}		
{Separator} {System.out.printf("Found Separator: %s - line: %d, start symbol: %d\n", yytext(), yyline+1, yycolumn);}
{AppropriationSymbol} {System.out.printf("Found AppropriationSymbol: %s - line: %d, start symbol: %d\n", yytext(), yyline+1, yycolumn); yybegin(unaryMinus);}
{BinaryOperator} {System.out.printf("Found BinaryOperator: %s - line: %d, start symbol: %d\n", yytext(), yyline+1, yycolumn);}
{BracketStart} {System.out.printf("Found BracketStart: %s - line: %d, start symbol: %d\n", yytext(), yyline+1, yycolumn); yybegin(unaryMinus);}
{Constant}  {
	
				if (!identifiersConstants.contains(yytext())) {
					System.out.printf("Found Constant: %s, HEX: %s - line: %d, start symbol: %d\n", yytext(), getHex(yytext()), yyline+1, yycolumn);				 
					identifiersConstants.add(yytext());
				}
			}
{Identificator} { 
					if (!checkForKeyWords(yytext(), yyline+1, yycolumn)) {
						if (!identifiersConstants.contains(yytext())) {
							System.out.printf("Found Identificator: %s - line: %d, start symbol: %d\n", yytext(), yyline+1, yycolumn);					 
							identifiersConstants.add(yytext());
						}
					}
				}		
{MinusSymbol} {System.out.printf("Found Binary MinusSymbol: %s - line: %d, start symbol: %d\n", yytext(), yyline+1, yycolumn);}
<unaryMinus> {
	{MinusSymbol} {System.out.printf("Found Unary MinusSymbol: %s - line: %d, start symbol: %d\n", yytext(), yyline+1, yycolumn);}
	{Constant} {System.out.printf("Found Constant: %s, HEX: %s - line: %d, start symbol: %d\n", yytext(), getHex(yytext()), yyline+1, yycolumn);}
	{Identificator} {System.out.printf("Found Identificator: %s - line: %d, start symbol: %d\n", yytext(), yyline+1, yycolumn);}
	{BracketStart} {System.out.printf("Found BracketStart: %s - line: %d, start symbol: %d\n", yytext(), yyline+1, yycolumn);}
}
{Whitespaces} {}
. {System.out.printf("ERROR. Unknown lexem: %s - line: %d, start symbol: %d", yytext(), yyline+1, yycolumn);}
