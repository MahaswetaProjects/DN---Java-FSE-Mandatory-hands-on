public class Computer {
    private String cpu;
    private String ram;
    private String storage;

    private Computer(Builder builder) {
        this.cpu = builder.cpu;
        this.ram = builder.ram;
        this.storage = builder.storage;
    }

    public String toString() {
        return "Computer [CPU=" + cpu + ", RAM=" + ram + ", Storage=" + storage + "]";
    }

    public static class Builder {
        private String cpu;
        private String ram;
        private String storage;

        public Builder cpu(String cpu) { this.cpu = cpu; return this; }
        public Builder ram(String ram) { this.ram = ram; return this; }
        public Builder storage(String storage) { this.storage = storage; return this; }
        public Computer build() { return new Computer(this); }
    }
}

// Test
public class Main {
    public static void main(String[] args) {
        Computer c = new Computer.Builder()
            .cpu("Intel i9")
            .ram("32GB")
            .storage("1TB SSD")
            .build();
        System.out.println(c);
    }
}