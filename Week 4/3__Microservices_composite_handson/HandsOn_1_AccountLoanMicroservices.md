# Hands on 1: Account and Loan Microservices

## account-service — AccountController.java
```java
import org.springframework.web.bind.annotation.*;

@RestController
public class AccountController {

    @GetMapping("/accounts/{number}")
    public Account getAccount(@PathVariable String number) {
        return new Account("00987987973432", "savings", 234343);
    }
}
```

## Account.java
```java
public class Account {
    private String number;
    private String type;
    private double balance;

    public Account(String number, String type, double balance) {
        this.number = number;
        this.type = type;
        this.balance = balance;
    }
    // getters/setters
}
```

## account-service/application.properties
```properties
spring.application.name=account-service
server.port=8080
```

## loan-service — LoanController.java
```java
import org.springframework.web.bind.annotation.*;

@RestController
public class LoanController {

    @GetMapping("/loans/{number}")
    public Loan getLoan(@PathVariable String number) {
        return new Loan("H00987987972342", "car", 400000, 3258, 18);
    }
}
```

## Loan.java
```java
public class Loan {
    private String number;
    private String type;
    private double loan;
    private double emi;
    private int tenure;

    public Loan(String number, String type, double loan, double emi, int tenure) {
        this.number = number;
        this.type = type;
        this.loan = loan;
        this.emi = emi;
        this.tenure = tenure;
    }
    // getters/setters
}
```

## loan-service/application.properties
```properties
spring.application.name=loan-service
server.port=8081
```

Test:
- `http://localhost:8080/accounts/any` → `{"number":"00987987973432","type":"savings","balance":234343}`
- `http://localhost:8081/loans/any` → `{"number":"H00987987972342","type":"car","loan":400000,"emi":3258,"tenure":18}`
