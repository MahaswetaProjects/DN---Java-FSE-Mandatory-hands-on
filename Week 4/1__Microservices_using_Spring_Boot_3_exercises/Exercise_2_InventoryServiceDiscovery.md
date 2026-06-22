# Exercise 2: Inventory Management System with Service Discovery

## pom.xml (both product-service and inventory-service)
```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-web</artifactId>
</dependency>
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-netflix-eureka-client</artifactId>
</dependency>
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-config</artifactId>
</dependency>
```

## eureka-server — EurekaServerApplication.java
```java
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.netflix.eureka.server.EnableEurekaServer;

@SpringBootApplication
@EnableEurekaServer
public class EurekaServerApplication {
    public static void main(String[] args) {
        SpringApplication.run(EurekaServerApplication.class, args);
    }
}
```

## eureka-server — application.properties
```properties
server.port=8761
spring.application.name=eureka-server
eureka.client.register-with-eureka=false
eureka.client.fetch-registry=false
```

## product-service — ProductController.java
```java
import org.springframework.web.bind.annotation.*;
import java.util.*;

@RestController
@RequestMapping("/products")
public class ProductController {

    private final Map<Long, Product> products = new HashMap<>();

    @GetMapping
    public Collection<Product> all() { return products.values(); }

    @PostMapping
    public Product create(@RequestBody Product product) {
        products.put(product.getId(), product);
        return product;
    }

    @GetMapping("/{id}")
    public Product get(@PathVariable Long id) { return products.get(id); }
}
```

## product-service — application.properties
```properties
spring.application.name=product-service
server.port=8082
eureka.client.service-url.defaultZone=http://localhost:8761/eureka/
```

## inventory-service — InventoryController.java
```java
import org.springframework.web.bind.annotation.*;
import java.util.*;

@RestController
@RequestMapping("/inventory")
public class InventoryController {

    private final Map<Long, Integer> stock = new HashMap<>();

    @GetMapping("/{productId}")
    public int getStock(@PathVariable Long productId) {
        return stock.getOrDefault(productId, 0);
    }

    @PostMapping("/{productId}")
    public void updateStock(@PathVariable Long productId, @RequestParam int quantity) {
        stock.put(productId, quantity);
    }
}
```

## inventory-service — application.properties
```properties
spring.application.name=inventory-service
server.port=8083
eureka.client.service-url.defaultZone=http://localhost:8761/eureka/
```

Start order: eureka-server → product-service → inventory-service.
Check `http://localhost:8761` to confirm both services are registered.
