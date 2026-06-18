import java.util.HashMap;

class Product {
    int productId;
    String productName;
    int quantity;
    double price;

    Product(int productId, String productName, int quantity, double price) {
        this.productId = productId;
        this.productName = productName;
        this.quantity = quantity;
        this.price = price;
    }
}

public class InventoryManagement {
    static HashMap<Integer, Product> inventory = new HashMap<>();

    static void addProduct(Product p) {
        inventory.put(p.productId, p);
        System.out.println("Added: " + p.productName);
    }

    static void updateProduct(int id, int newQty, double newPrice) {
        Product p = inventory.get(id);
        if (p != null) {
            p.quantity = newQty;
            p.price = newPrice;
            System.out.println("Updated: " + p.productName);
        } else {
            System.out.println("Product not found.");
        }
    }

    static void deleteProduct(int id) {
        Product p = inventory.remove(id);
        if (p != null) System.out.println("Deleted: " + p.productName);
        else System.out.println("Product not found.");
    }

    public static void main(String[] args) {
        addProduct(new Product(1, "Laptop", 10, 75000));
        addProduct(new Product(2, "Mouse", 50, 500));
        updateProduct(1, 8, 72000);
        deleteProduct(2);
    }
}
// Time Complexity: add O(1), update O(1), delete O(1) — HashMap gives constant time ops