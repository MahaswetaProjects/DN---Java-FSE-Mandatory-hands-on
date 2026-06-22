# Exercise 1: User and Order Management System

## user-service — UserController.java
```java
import org.springframework.web.bind.annotation.*;
import java.util.*;

@RestController
@RequestMapping("/users")
public class UserController {

    private final Map<Long, User> users = new HashMap<>();

    @GetMapping("/{id}")
    public User getUser(@PathVariable Long id) {
        return users.getOrDefault(id, new User(id, "Unknown"));
    }

    @PostMapping
    public User createUser(@RequestBody User user) {
        users.put(user.getId(), user);
        return user;
    }
}
```

## User.java
```java
public class User {
    private Long id;
    private String name;
    // constructors, getters, setters
}
```

## order-service — OrderController.java
```java
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.reactive.function.client.WebClient;
import java.util.*;

@RestController
@RequestMapping("/orders")
public class OrderController {

    @Autowired
    private WebClient.Builder webClientBuilder;

    private final Map<Long, Order> orders = new HashMap<>();

    @GetMapping("/{id}")
    public Order getOrder(@PathVariable Long id) {
        return orders.getOrDefault(id, new Order(id, 0L, "UNKNOWN"));
    }

    @PostMapping
    public Order createOrder(@RequestBody Order order) {
        // Call user-service to verify user exists before saving order
        User user = webClientBuilder.build()
                .get()
                .uri("http://user-service/users/" + order.getUserId())
                .retrieve()
                .bodyToMono(User.class)
                .block();
        orders.put(order.getId(), order);
        return order;
    }
}
```

## Order.java
```java
public class Order {
    private Long id;
    private Long userId;
    private String status;
    // constructors, getters, setters
}
```

## order-service — application.properties
```properties
spring.application.name=order-service
server.port=8081
```

## user-service — application.properties
```properties
spring.application.name=user-service
server.port=8080
```

## WebClient Bean (in OrderServiceApplication.java)
```java
@Bean
@LoadBalanced
public WebClient.Builder webClientBuilder() {
    return WebClient.builder();
}
```
`@LoadBalanced` lets `http://user-service/...` resolve via Eureka/LoadBalancer by service name.
