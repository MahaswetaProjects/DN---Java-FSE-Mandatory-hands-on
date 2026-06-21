# Hands on 5: One-to-Many Relationship (Department -> Employee)

## Department.java
```java
import java.util.Set;

@Entity
public class Department {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;
    private String name;

    @OneToMany(mappedBy = "department", fetch = FetchType.EAGER)
    private Set<Employee> employeeList;
}
```

## Test
```java
Department department = departmentService.get(1);
System.out.println(department.getEmployeeList()); // all employees in this department
```
