build:
    jflex lex.flex
    bison SyntaxAnalyser.y
	javac Compiler.java
	./Compiler check1


