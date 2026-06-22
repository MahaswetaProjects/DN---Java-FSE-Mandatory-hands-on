# Hands on: API Gateway with Global Logging Filter

## greet-service — GreetController.java
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

## greet-service — application.properties
```properties
spring.application.name=greet-service
server.port=8080
eureka.client.service-url.defaultZone=http://localhost:8761/eureka/
```

---

## api-gateway — pom.xml
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

## api-gateway — application.properties
```properties
server.port=9090
spring.application.name=api-gateway
eureka.client.service-url.defaultZone=http://localhost:8761/eureka/
spring.cloud.gateway.discovery.locator.enabled=true
spring.cloud.gateway.discovery.locator.lower-case-service-id=true
```

## LogFilter.java (api-gateway)
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

**Start order:**
1. `eureka-discovery-server` (port 8761)
2. `greet-service` (port 8080) → verify `http://localhost:8080/greet` shows "Hello World!!"
3. `api-gateway` (port 9090) → verify both registered at `http://localhost:8761`

**Test via gateway:** `http://localhost:9090/greet-service/greet` → "Hello World!!"
Check api-gateway console for: `====> Request URL http://localhost:9090/greet-service/greet`
