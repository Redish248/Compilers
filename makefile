all : main

main: lex lex.jflex
	jflex lex.jflex

lex: LexerAnalyser.java
	javac LexerAnalyser.java	

check1: LexerAnalyser check1
	java LexerAnalyser check1

check2: LexerAnalyser check2
	java LexerAnalyser check2

check3: LexerAnalyser check3
	java LexerAnalyser check3

clean: 
	rm LexerAnalyser.class
	rm LexerAnalyser.java
