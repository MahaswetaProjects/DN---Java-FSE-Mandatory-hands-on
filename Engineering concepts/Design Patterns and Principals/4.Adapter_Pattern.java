// Target interface
public interface PaymentProcessor {
    void processPayment(double amount);
}

// Adaptees (third-party gateways)
public class PayPalGateway {
    public void makePayment(double amount) {
        System.out.println("PayPal payment: $" + amount);
    }
}
public class StripeGateway {
    public void charge(double amount) {
        System.out.println("Stripe charge: $" + amount);
    }
}

// Adapters
public class PayPalAdapter implements PaymentProcessor {
    private PayPalGateway paypal = new PayPalGateway();
    public void processPayment(double amount) { paypal.makePayment(amount); }
}
public class StripeAdapter implements PaymentProcessor {
    private StripeGateway stripe = new StripeGateway();
    public void processPayment(double amount) { stripe.charge(amount); }
}

// Test
public class Main {
    public static void main(String[] args) {
        PaymentProcessor p = new PayPalAdapter();
        p.processPayment(100.0);
        p = new StripeAdapter();
        p.processPayment(200.0);
    }
}