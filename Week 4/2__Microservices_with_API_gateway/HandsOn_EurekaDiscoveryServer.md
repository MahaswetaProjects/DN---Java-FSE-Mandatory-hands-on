# Hands on: Create Eureka Discovery Server and Register Microservices

## pom.xml (eureka-discovery-server)
```xml
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-netflix-eureka-server</artifactId>
</dependency>
```

## EurekaDiscoveryServerApplication.java
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

## application.properties (eureka-discovery-server)
```properties
server.port=8761
eureka.client.register-with-eureka=false
eureka.client.fetch-registry=false
logging.level.com.netflix.eureka=OFF
logging.level.com.netflix.discovery=OFF
```

Visit `http://localhost:8761` to see the Eureka dashboard.

---

## Register account-service and loan-service with Eureka

### pom.xml — add to both account and loan service
```xml
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-netflix-eureka-client</artifactId>
</dependency>
```

### AccountServiceApplication.java
```java
import org.springframework.cloud.client.discovery.EnableDiscoveryClient;

@SpringBootApplication
@EnableDiscoveryClient
public class AccountServiceApplication {
    public static void main(String[] args) {
        SpringApplication.run(AccountServiceApplication.class, args);
    }
}
```

### account-service application.properties
```properties
spring.application.name=account-service
server.port=8080
eureka.client.service-url.defaultZone=http://localhost:8761/eureka/
```

### loan-service application.properties
```properties
spring.application.name=loan-service
server.port=8081
eureka.client.service-url.defaultZone=http://localhost:8761/eureka/
```

**Start order:**
1. Start `eureka-discovery-server` → confirm `http://localhost:8761` shows no instances
2. Start `account-service` → refresh Eureka dashboard → `ACCOUNT-SERVICE` appears
3. Start `loan-service` → refresh → `LOAN-SERVICE` appears
