# Exercise 9: Managing Data Source Configuration

## application.properties - externalized datasource config
```properties
spring.datasource.url=jdbc:h2:mem:testdb
spring.datasource.driverClassName=org.h2.Driver
spring.datasource.username=sa
spring.datasource.password=password
spring.jpa.hibernate.ddl-auto=update
```

## Multiple data sources example
```java
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.boot.jdbc.DataSourceBuilder;
import org.springframework.context.annotation.*;
import javax.sql.DataSource;

@Configuration
public class MultiDataSourceConfig {

    @Primary
    @Bean
    @ConfigurationProperties(prefix = "app.datasource.primary")
    public DataSource primaryDataSource() {
        return DataSourceBuilder.create().build();
    }

    @Bean
    @ConfigurationProperties(prefix = "app.datasource.secondary")
    public DataSource secondaryDataSource() {
        return DataSourceBuilder.create().build();
    }
}
```

```properties
# matching properties for the two data sources above
app.datasource.primary.url=jdbc:h2:mem:primarydb
app.datasource.primary.driver-class-name=org.h2.Driver
app.datasource.secondary.url=jdbc:h2:mem:secondarydb
app.datasource.secondary.driver-class-name=org.h2.Driver
```
