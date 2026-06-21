# Hands on 3: Payroll Tables and Bean Mapping

## Department.java
```java
@Entity
public class Department {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;
    private String name;
}
```

## Skill.java
```java
@Entity
public class Skill {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;
    private String name;
}
```

## Employee.java
```java
@Entity
public class Employee {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;
    private String name;
    private double salary;
    private boolean permanent;
    private LocalDate dateOfBirth;
}
```

## Repositories
```java
public interface DepartmentRepository extends JpaRepository<Department, Integer> {}
public interface SkillRepository extends JpaRepository<Skill, Integer> {}
public interface EmployeeRepository extends JpaRepository<Employee, Integer> {}
```

## Services - get() and save()
```java
@Service
public class EmployeeService {
    @Autowired
    private EmployeeRepository employeeRepository;

    public Employee get(int id) { return employeeRepository.findById(id).get(); }
    public void save(Employee employee) { employeeRepository.save(employee); }
}
```
