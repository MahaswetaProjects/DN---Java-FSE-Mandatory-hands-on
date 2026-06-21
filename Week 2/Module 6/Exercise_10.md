# Exercise 10: Hibernate-Specific Features and Batch Processing

## application.properties
```properties
spring.jpa.properties.hibernate.format_sql=true
spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.H2Dialect

# Batch processing for bulk insert/update performance
spring.jpa.properties.hibernate.jdbc.batch_size=20
spring.jpa.properties.hibernate.order_inserts=true
spring.jpa.properties.hibernate.order_updates=true
spring.jpa.properties.hibernate.batch_versioned_data=true
```

## Saving in bulk so batching kicks in
```java
import java.util.List;

@Service
public class EmployeeBulkService {

    private final EmployeeRepository employeeRepository;

    public EmployeeBulkService(EmployeeRepository employeeRepository) {
        this.employeeRepository = employeeRepository;
    }

    @Transactional
    public void saveAll(List<Employee> employees) {
        employeeRepository.saveAll(employees); // batched per hibernate.jdbc.batch_size
    }
}
```
