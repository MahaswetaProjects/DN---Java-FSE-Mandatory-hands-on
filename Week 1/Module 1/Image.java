public interface Image {
    void display();
}

// Real subject
public class RealImage implements Image {
    private String filename;
    public RealImage(String filename) {
        this.filename = filename;
        System.out.println("Loading image from server: " + filename);
    }
    public void display() { System.out.println("Displaying: " + filename); }
}

// Proxy (lazy init + caching)
public class ProxyImage implements Image {
    private String filename;
    private RealImage realImage;

    public ProxyImage(String filename) { this.filename = filename; }

    public void display() {
        if (realImage == null) {
            realImage = new RealImage(filename); // loads only once
        }
        realImage.display();
    }
}

// Test
public class Main {
    public static void main(String[] args) {
        Image img = new ProxyImage("photo.jpg");
        img.display(); // loads + displays
        img.display(); // only displays (cached)
    }
}