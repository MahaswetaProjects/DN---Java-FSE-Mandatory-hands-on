# Exercise 1: Implementing Edge Services for Routing and Filtering

## pom.xml
```xml
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-gateway</artifactId>
</dependency>
```

## application.properties
```properties
spring.cloud.gateway.routes[0].id=example_route
spring.cloud.gateway.routes[0].uri=http://example.org
spring.cloud.gateway.routes[0].predicates[0]=Path=/example/**
```

## LoggingFilter.java
```java
import org.springframework.cloud.gateway.filter.GatewayFilterChain;
import org.springframework.cloud.gateway.filter.GlobalFilter;
import org.springframework.stereotype.Component;
import org.springframework.web.server.ServerWebExchange;
import reactor.core.publisher.Mono;

@Component
public class LoggingFilter implements GlobalFilter {

    @Override
    public Mono<Void> filter(ServerWebExchange exchange, GatewayFilterChain chain) {
        System.out.println("Request: " + exchange.getRequest().getURI());
        return chain.filter(exchange);
    }
}
```

Any request to `/example/**` is routed to `http://example.org` and logged by the filter.
