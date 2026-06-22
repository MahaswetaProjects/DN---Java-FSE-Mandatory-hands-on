# Exercise 1: Implementing Centralized Authentication with OAuth 2.1/OIDC

## pom.xml
```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-security</artifactId>
</dependency>
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-oauth2-client</artifactId>
</dependency>
```

## application.yml
```yaml
spring:
  security:
    oauth2:
      client:
        registration:
          my-client:
            client-id: YOUR_CLIENT_ID
            client-secret: YOUR_CLIENT_SECRET
            scope: openid, profile, email
            authorization-grant-type: authorization_code
            redirect-uri: "{baseUrl}/login/oauth2/code/{registrationId}"
        provider:
          my-provider:
            authorization-uri: https://accounts.google.com/o/oauth2/auth
            token-uri: https://oauth2.googleapis.com/token
            user-info-uri: https://openidconnect.googleapis.com/v1/userinfo
            user-name-attribute: sub
```

## SecurityConfig.java (Spring Boot 3 style - SecurityFilterChain bean, not WebSecurityConfigurerAdapter)
```java
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
public class SecurityConfig {

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
            .authorizeHttpRequests(auth -> auth.anyRequest().authenticated())
            .oauth2Login();
        return http.build();
    }
}
```

## UserController.java
```java
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import java.security.Principal;

@RestController
public class UserController {

    @GetMapping("/user")
    public Principal user(Principal principal) {
        return principal;
    }
}
```

Hit `http://localhost:8080/user` after login - Spring Security redirects to the OAuth2 provider
(here, Google), then returns the authenticated `Principal`.
