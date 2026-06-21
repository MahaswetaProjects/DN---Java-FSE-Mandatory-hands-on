# Hands on 6: Many-to-Many Relationship (Employee <-> Skill)

## Employee.java
```java
import java.util.Set;

@Entity
public class Employee {
    // ... fields from Hands on 3/4

    @ManyToMany
    @JoinTable(
        name = "employee_skill",
        joinColumns = @JoinColumn(name = "em_id"),
        inverseJoinColumns = @JoinColumn(name = "sk_id"))
    private Set<Skill> skillList;
}
```

## Skill.java
```java
@Entity
public class Skill {
    // ... fields from Hands on 3

    @ManyToMany(mappedBy = "skillList")
    private Set<Employee> employeeList;
}
```

## Test - add a skill to an employee
```java
Employee employee = employeeService.get(2);
Skill skill = skillService.get(2);
Set<Skill> skills = employee.getSkillList();
skills.add(skill);
employee.setSkillList(skills);
employeeService.save(employee);
```
