import java.util.ArrayList;
import java.util.HashSet;

public class Compiler {

   private Tree currentNode;
   private HashSet<String> variablesList;


   public void createRootNode() {
       Tree tree = new Tree(null, "ROOT", null, new ArrayList<>());
       currentNode = tree;
   }

   public Tree addNode() {

   }

   public void printTree() {
        // :)
   }

   public void goToParent() {
       currentNode = currentNode.getParent();
   }

   public Tree newVariable() {

   }

   public Tree newNumber() {

   }

   public Tree newAppropriation() {

   }

   public Tree newVariable() {
       //чекать на объявление
   }

   public void addToVariablesList(Tree variable) {
       variablesList.add(variable.getName());
   }

}
