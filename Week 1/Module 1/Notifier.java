public interface Notifier {
    void send(String message);
}

// Concrete component
public class EmailNotifier implements Notifier {
    public void send(String message) {
        System.out.println("Email: " + message);
    }
}

// Abstract decorator
public abstract class NotifierDecorator implements Notifier {
    protected Notifier wrapped;
    public NotifierDecorator(Notifier notifier) { this.wrapped = notifier; }
    public void send(String message) { wrapped.send(message); }
}

// Concrete decorators
public class SMSNotifierDecorator extends NotifierDecorator {
    public SMSNotifierDecorator(Notifier notifier) { super(notifier); }
    public void send(String message) {
        super.send(message);
        System.out.println("SMS: " + message);
    }
}
public class SlackNotifierDecorator extends NotifierDecorator {
    public SlackNotifierDecorator(Notifier notifier) { super(notifier); }
    public void send(String message) {
        super.send(message);
        System.out.println("Slack: " + message);
    }
}

// Test
public class Main {
    public static void main(String[] args) {
        Notifier notifier = new SlackNotifierDecorator(
                                new SMSNotifierDecorator(
                                    new EmailNotifier()));
        notifier.send("Server is down!");
    }
} {
    
}
