# Exercise 6: Implementing Pagination and Sorting

## EmployeeRepository.java
```java
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

public interface EmployeeRepository extends JpaRepository<Employee, Long> {
    Page<Employee> findAll(Pageable pageable);
    Page<Employee> findByNameContaining(String name, Pageable pageable);
}
```

## EmployeeController.java - paginated + sorted endpoint
```java
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;

@GetMapping("/page")
public Page<Employee> getPage(@RequestParam(defaultValue = "0") int page,
                               @RequestParam(defaultValue = "5") int size,
                               @RequestParam(defaultValue = "name") String sortBy) {
    Pageable pageable = PageRequest.of(page, size, Sort.by(sortBy).ascending());
    return employeeRepository.findAll(pageable);
}
```

Call it: `GET /api/employees/page?page=0&size=5&sortBy=name`
