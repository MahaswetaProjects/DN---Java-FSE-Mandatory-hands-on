# Exercise 3: Resilience Patterns in an API Gateway

## pom.xml
```xml
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-gateway</artifactId>
</dependency>
<dependency>
    <groupId>io.github.resilience4j</groupId>
    <artifactId>resilience4j-spring-boot2</artifactId>
</dependency>
```

## application.properties
```properties
resilience4j.circuitbreaker.instances.exampleCircuitBreaker.registerHealthIndicator=true
resilience4j.circuitbreaker.instances.exampleCircuitBreaker.slidingWindowSize=10
resilience4j.circuitbreaker.instances.exampleCircuitBreaker.failureRateThreshold=50
```
- `slidingWindowSize=10` — last 10 calls are evaluated
- `failureRateThreshold=50` — circuit opens if 50% of calls fail

## ResilienceConfiguration.java
```java
import io.github.resilience4j.circuitbreaker.CircuitBreakerConfig;
import io.github.resilience4j.timelimiter.TimeLimiterConfig;
import org.springframework.cloud.circuitbreaker.resilience4j.ReactiveResilience4JCircuitBreakerFactory;
import org.springframework.cloud.circuitbreaker.resilience4j.Resilience4JConfigBuilder;
import org.springframework.cloud.client.circuitbreaker.Customizer;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class ResilienceConfiguration {

    @Bean
    public Customizer<ReactiveResilience4JCircuitBreakerFactory> defaultCustomizer() {
        return factory -> factory.configureDefault(id ->
                new Resilience4JConfigBuilder(id)
                        .circuitBreakerConfig(CircuitBreakerConfig.ofDefaults())
                        .timeLimiterConfig(TimeLimiterConfig.ofDefaults())
                        .build());
    }
}
```
