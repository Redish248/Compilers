import java.util.List;

public class Tree {

    private String name;

    private String type;

    private Tree parent;

    private List<Tree> children;

    public boolean isProcessed() {
        return isProcessed;
    }

    public void setProcessed(boolean processed) {
        isProcessed = processed;
    }

    private boolean isProcessed;

    public Tree(String name, Tree parent) {
        this.name = name;
        checkName();
        this.parent = parent;
        this.children = null;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Tree getParent() {
        return parent;
    }

    public void setParent(Tree parent) {
        this.parent = parent;
    }

    public List<Tree> getChildren() {
        return children;
    }

    public void setChildren(List<Tree> children) {
        this.children = children;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    private void checkName() {
        switch (name) {
            case "+":
            case "-":
            case "*":
            case "/":
            case ">":
            case "<":
            case "=":
            case "AND":
            case "OR":
            case "XOR":
                type = "Binary operator";
                isProcessed = true;
                break;
            case "Var":
            case "Begin":
            case "End":
            case "While":
            case "Do":
                type = "Keyword";
                isProcessed = true;
                break;
            case ":=":
                type = "Appropriation";
                isProcessed = false;
                break;
            default:
                type = null;
                isProcessed = false;
        }
    }
}
