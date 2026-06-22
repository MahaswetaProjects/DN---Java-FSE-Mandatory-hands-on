# Exercise 4: Resilient Microservices with Circuit Breaker

## pom.xml (payment-service)
```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-web</artifactId>
</dependency>
<dependency>
    <groupId>io.github.resilience4j</groupId>
    <artifactId>resilience4j-spring-boot3</artifactId>
</dependency>
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-aop</artifactId>
</dependency>
```

## application.properties
```properties
spring.application.name=payment-service
server.port=8084

resilience4j.circuitbreaker.instances.thirdPartyApi.slidingWindowSize=5
resilience4j.circuitbreaker.instances.thirdPartyApi.failureRateThreshold=50
resilience4j.circuitbreaker.instances.thirdPartyApi.waitDurationInOpenState=10000
resilience4j.circuitbreaker.instances.thirdPartyApi.registerHealthIndicator=true
```

## PaymentService.java
```java
import io.github.resilience4j.circuitbreaker.annotation.CircuitBreaker;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

@Service
public class PaymentService {

    private static final Logger LOGGER = LoggerFactory.getLogger(PaymentService.class);
    private final RestTemplate restTemplate = new RestTemplate();

    @CircuitBreaker(name = "thirdPartyApi", fallbackMethod = "paymentFallback")
    public String processPayment(String orderId) {
        LOGGER.info("Calling third-party payment API for order: {}", orderId);
        // Simulated slow / unreliable third-party endpoint
        return restTemplate.getForObject("http://third-party-payment-api/pay/" + orderId, String.class);
    }

    // Fallback triggered when circuit is open or call fails
    public String paymentFallback(String orderId, Throwable t) {
        LOGGER.warn("Fallback triggered for order: {}. Reason: {}", orderId, t.getMessage());
        return "Payment service temporarily unavailable. Order " + orderId + " queued for retry.";
    }
}
```

## PaymentController.java
```java
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/payments")
public class PaymentController {

    @Autowired
    private PaymentService paymentService;

    @PostMapping("/{orderId}")
    public String pay(@PathVariable String orderId) {
        return paymentService.processPayment(orderId);
    }
}
```

When the third-party API fails 50% of the time over 5 calls, the circuit opens and all
subsequent calls immediately return the fallback response without hitting the slow API.
After 10 seconds the circuit moves to half-open and retries.
