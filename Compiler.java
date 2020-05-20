
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashSet;

public class Compiler {

   private Tree currentNode;
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
      Compiler compiler = new Compiler();
      compiler.createRootNode();
      syntaxAnalyser.parse();
   }


   public void createRootNode() {
       Tree tree = new Tree("ROOT", null);
       currentNode = tree;
   }

   public Tree addNode() {
      return null;
   }

   public Tree astNode(String parent, String firstChild, String secondChild) {
        if (!currentNode.getName().equals(parent)) {
            Tree p = new Tree(parent, currentNode);
            currentNode = p;
        }
        ArrayList<Tree> children = new ArrayList<>();
        children.add(new Tree(firstChild, currentNode));
        children.add(new Tree(secondChild, currentNode));
        currentNode.setChildren(children);
        Tree node = currentNode;
        findNextNode();
        return node;
   }

   private void findNextNode() {
       while (checkCurrentNodeProcessing() && !(currentNode.getName().equals("ROOT") && currentNode.isProcessed())) {}
   }

   private boolean checkCurrentNodeProcessing() {
       for (Tree node: currentNode.getChildren()) {
           if (!node.isProcessed()) {
               currentNode = node;
               return false;
           }
       }
       currentNode.setProcessed(true);
       currentNode = currentNode.getParent();
       return true;
   }

   public void printTree() {
        // :)
   }

   public void goToParent() {
       currentNode = currentNode.getParent();
   }


   public Tree newNumber() {
      return null;
   }

   public Tree newAppropriation() {
      return null;
   }

   public Tree newVariable() {
       //чекать на объявление
      return null;
   }

   public void addToVariablesList(Tree variable) {
       variablesList.add(variable.getName());
   }

}
