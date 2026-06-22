# Hands on 2: Eureka Discovery Server + API Gateway + Global Log Filter

## Step 1: Eureka Discovery Server

### pom.xml dependency
```xml
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-netflix-eureka-server</artifactId>
</dependency>
```

### EurekaDiscoveryServerApplication.java
```java
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.netflix.eureka.server.EnableEurekaServer;

@SpringBootApplication
@EnableEurekaServer
public class EurekaDiscoveryServerApplication {
    public static void main(String[] args) {
        SpringApplication.run(EurekaDiscoveryServerApplication.class, args);
    }
}
```

### application.properties
```properties
server.port=8761
eureka.client.register-with-eureka=false
eureka.client.fetch-registry=false
logging.level.com.netflix.eureka=OFF
logging.level.com.netflix.discovery=OFF
```

---

## Step 2: Register account-service and loan-service

### Add to pom.xml of both services
```xml
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-netflix-eureka-client</artifactId>
</dependency>
```

### Add @EnableDiscoveryClient to each application class
```java
@SpringBootApplication
@EnableDiscoveryClient
public class AccountServiceApplication { ... }
```

### account-service/application.properties (update)
```properties
spring.application.name=account-service
server.port=8080
eureka.client.service-url.defaultZone=http://localhost:8761/eureka/
```

### loan-service/application.properties (update)
```properties
spring.application.name=loan-service
server.port=8081
eureka.client.service-url.defaultZone=http://localhost:8761/eureka/
```

---

## Step 3: greet-service (Hello World microservice)

### GreetController.java
```java
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class GreetController {

    @GetMapping("/greet")
    public String sayHello() {
        return "Hello World!!";
    }
}
```

### application.properties
```properties
spring.application.name=greet-service
server.port=8082
eureka.client.service-url.defaultZone=http://localhost:8761/eureka/
```

---

## Step 4: api-gateway

### pom.xml dependencies
```xml
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-gateway</artifactId>
</dependency>
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-netflix-eureka-client</artifactId>
</dependency>
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-actuator</artifactId>
</dependency>
```

### application.properties
```properties
server.port=9090
spring.application.name=api-gateway
eureka.client.service-url.defaultZone=http://localhost:8761/eureka/
spring.cloud.gateway.discovery.locator.enabled=true
spring.cloud.gateway.discovery.locator.lower-case-service-id=true
```

### LogFilter.java
```java
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.cloud.gateway.filter.GatewayFilterChain;
import org.springframework.cloud.gateway.filter.GlobalFilter;
import org.springframework.stereotype.Component;
import org.springframework.web.server.ServerWebExchange;
import reactor.core.publisher.Mono;

@Component
public class LogFilter implements GlobalFilter {

    Logger logger = LoggerFactory.getLogger(LogFilter.class);

    @Override
    public Mono<Void> filter(ServerWebExchange exchange, GatewayFilterChain chain) {
        logger.info("====> Request URL {}", exchange.getRequest().getURI());
        return chain.filter(exchange);
    }
}
```

---

## Start order and Test URLs

| Step | Action |
|---|---|
| 1 | Start eureka-discovery-server → `http://localhost:8761` (empty list) |
| 2 | Start account-service → Eureka shows ACCOUNT-SERVICE |
| 3 | Start loan-service → Eureka shows LOAN-SERVICE |
| 4 | Start greet-service → Eureka shows GREET-SERVICE |
| 5 | Start api-gateway → Eureka shows API-GATEWAY |

**Call services via gateway:**
- `http://localhost:9090/greet-service/greet` → Hello World!!
- `http://localhost:9090/account-service/accounts/123` → account JSON
- `http://localhost:9090/loan-service/loans/456` → loan JSON

Check api-gateway console — every request logs: `====> Request URL http://...`
