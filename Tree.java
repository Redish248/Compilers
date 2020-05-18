import java.util.List;

public class Tree {

    private String name;

    private String type;

    private Tree parent;

    private List<Tree> children;

    public Tree(String name, String type, Tree parent, List<Tree> children) {
        this.name = name;
        this.type = type;
        this.parent = parent;
        this.children = children;
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
}
