# Exercise 3: Implement an API Gateway

## pom.xml
```xml
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-gateway</artifactId>
</dependency>
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-netflix-eureka-client</artifactId>
</dependency>
```

## application.properties
```properties
server.port=9090
spring.application.name=api-gateway
eureka.client.service-url.defaultZone=http://localhost:8761/eureka/

# Route to customer-service
spring.cloud.gateway.routes[0].id=customer-route
spring.cloud.gateway.routes[0].uri=lb://customer-service
spring.cloud.gateway.routes[0].predicates[0]=Path=/customers/**
spring.cloud.gateway.routes[0].filters[0]=RewritePath=/customers/(?<segment>.*), /$\{segment}

# Route to billing-service
spring.cloud.gateway.routes[1].id=billing-route
spring.cloud.gateway.routes[1].uri=lb://billing-service
spring.cloud.gateway.routes[1].predicates[0]=Path=/billing/**
spring.cloud.gateway.routes[1].filters[0]=RewritePath=/billing/(?<segment>.*), /$\{segment}

# Rate limiting (uses Redis by default - or use RequestRateLimiter filter)
spring.cloud.gateway.routes[0].filters[1]=RequestRateLimiter=10, 20
```

## RateLimiterConfig.java
```java
import org.springframework.cloud.gateway.filter.ratelimit.KeyResolver;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import reactor.core.publisher.Mono;

@Configuration
public class RateLimiterConfig {

    // Rate limit per IP address
    @Bean
    public KeyResolver ipKeyResolver() {
        return exchange -> Mono.just(
                exchange.getRequest().getRemoteAddress().getAddress().getHostAddress());
    }
}
```

Access via: `http://localhost:9090/customers/...` and `http://localhost:9090/billing/...`
