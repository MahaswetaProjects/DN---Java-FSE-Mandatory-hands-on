# Exercise 5: Defining Query Methods

## EmployeeRepository.java - query methods + @Query + named query
```java
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import java.util.List;

public interface EmployeeRepository extends JpaRepository<Employee, Long> {

    // Derived query method
    List<Employee> findByNameContainingIgnoreCase(String name);

    // Custom JPQL with @Query
    @Query("SELECT e FROM Employee e WHERE e.department.name = :deptName")
    List<Employee> searchByDepartmentName(@Param("deptName") String deptName);

    // Uses the @NamedQuery declared on Employee.java below
    List<Employee> findByDepartmentName(String departmentName);
}
```

## Employee.java - named query
```java
import javax.persistence.*;

@Entity
@NamedQuery(
    name = "Employee.findByDepartmentName",
    query = "SELECT e FROM Employee e WHERE e.department.name = :departmentName"
)
public class Employee {
    // ... fields as in Exercise 2
}
```
