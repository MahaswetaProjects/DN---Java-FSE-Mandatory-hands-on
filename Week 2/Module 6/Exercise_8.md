# Exercise 8: Implementing Projections

## EmployeeSummary.java - interface-based projection
```java
public interface EmployeeSummary {
    Long getId();
    String getName();
    String getEmail();
}
```

## EmployeeNameOnly.java - class/DTO-based projection
```java
public class EmployeeNameOnly {
    private final String name;
    private final String email;

    public EmployeeNameOnly(String name, String email) {
        this.name = name;
        this.email = email;
    }
    public String getName() { return name; }
    public String getEmail() { return email; }
}
```

## EmployeeRepository.java
```java
import java.util.List;

public interface EmployeeRepository extends JpaRepository<Employee, Long> {

    List<EmployeeSummary> findByDepartmentId(Long departmentId);

    @Query("SELECT new com.example.ems.EmployeeNameOnly(e.name, e.email) FROM Employee e")
    List<EmployeeNameOnly> findAllNameAndEmail();
}
```
