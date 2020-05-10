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

%}

Comment = [/][*][^*]*[*]+([^*/][^*]*[*]+)*[/]
Keywords = "End" | "Var" | "DO" | "Begin"
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

{Comment} {System.out.printf("Found Comment %s - line %d, symbol number %d\n", yytext(), yyline+1, yycolumn);}
{Keywords} {System.out.printf("Found Keywords %s - line %d, symbol number %d\n", yytext(), yyline+1, yycolumn);}
{LoopStart} {System.out.printf("Found LoopStart %s - line %d, symbol number %d\n", yytext(), yyline+1, yycolumn); yybegin(unaryMinus);}		
{Separator} {System.out.printf("Found Separator %s - line %d, symbol number %d\n", yytext(), yyline+1, yycolumn);}
{AppropriationSymbol} {System.out.printf("Found AppropriationSymbol %s - line %d, symbol number %d\n", yytext(), yyline+1, yycolumn); yybegin(unaryMinus);}
{BinaryOperator} {System.out.printf("Found BinaryOperator %s - line %d, symbol number %d\n", yytext(), yyline+1, yycolumn);}
{BracketStart} {System.out.printf("Found BracketStart %s - line %d, symbol number %d\n", yytext(), yyline+1, yycolumn); yybegin(unaryMinus);}
{Constant}  {
				if (!identifiersConstants.contains(yytext())) {
						System.out.printf("Found Constant %s, HEX: %s - line %d, symbol number %d\n", yytext(), getHex(yytext()), yyline+1, yycolumn);				 
						identifiersConstants.add(yytext());
				}
			}
{Identificator} { 
					if (!identifiersConstants.contains(yytext())) {
						System.out.printf("Found Identificator %s - line %d, symbol number %d\n", yytext(), yyline+1, yycolumn);					 
						identifiersConstants.add(yytext());
					}
				}		
{MinusSymbol} {System.out.printf("Found Binary MinusSymbol %s - line %d, symbol number %d\n", yytext(), yyline+1, yycolumn);}
<unaryMinus> {
	{MinusSymbol} {System.out.printf("Found Unary MinusSymbol %s - line %d, symbol number %d\n", yytext(), yyline+1, yycolumn);}
	{Constant} {System.out.printf("Found Constant %s, HEX: %s - line %d, symbol number %d\n", yytext(), getHex(yytext()), yyline+1, yycolumn);}
	{Identificator} {System.out.printf("Found Identificator %s - line %d, symbol number %d\n", yytext(), yyline+1, yycolumn);}
	{BracketStart} {System.out.printf("Found BracketStart %s - line %d, symbol number %d\n", yytext(), yyline+1, yycolumn);}
}
{Whitespaces} {}
. {System.out.printf("ERROR. Unknown lexem %s - line %d, symbol number %d", yytext(), yyline+1, yycolumn);}
