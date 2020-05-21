import java.io.IOException;
import java.util.ArrayList;
import java.util.HashSet;

public class Compiler {

   private HashSet<String> variablesList;

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
      syntaxAnalyser.parse();
   }

   public Tree astNode(String parent, Tree ... children) {
        Tree parentNode = new Tree(parent);
        ArrayList<Tree> childrenNodes = new ArrayList<>();
        for (Tree child: children) {
            childrenNodes.add(child);
        }
        parentNode.setChildren(childrenNodes);
        if (parent.equals("ROOT")) {
            printTree(parentNode);
        }
        return parentNode;
   }

   public Tree identifierReference(String name) {
       // todo check
       Tree identifier = new Tree(name);
       identifier.setType("Identifier");
       return identifier;
   }

    public Tree constant(String value) {
        Tree node = new Tree(value);
        node.setType("Const");
        return node;
    }

   public Tree addVariable(String identifier, Tree variables) {
       Tree varNode = new Tree("Variables list");
       ArrayList<Tree> children = new ArrayList<>();
       children.add(new Tree(identifier));
       children.get(0).setType("Identifier");
       if (variables != null) children.add(variables);
       varNode.setChildren(children);
       return varNode;
   }

    public Tree newAppropriation(String identifier, Tree exp) {
        Tree node = new Tree("Operator");
        Tree appropriation = new Tree(":=");
        ArrayList<Tree> children = new ArrayList<>();
        ArrayList<Tree> apprChildren = new ArrayList<>();
        children.add(identifierReference(identifier));
        children.add(exp);
        appropriation.setChildren(children);
        apprChildren.add(appropriation);
        node.setChildren(apprChildren);
        return node;
    }

   public void printTree(Tree root) {
        // :)
   }

}
