# Hands on 4: Many-to-One Relationship (Employee -> Department)

## Employee.java
```java
@Entity
public class Employee {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;
    private String name;

    @ManyToOne
    @JoinColumn(name = "dp_id")
    private Department department;
}
```

## Test - add employee with a department, then read it back
```java
Employee employee = new Employee();
employee.setName("New Hire");
employee.setDepartment(departmentService.get(1));
employeeService.save(employee);

Employee fetched = employeeService.get(employee.getId());
System.out.println(fetched.getDepartment());
```
