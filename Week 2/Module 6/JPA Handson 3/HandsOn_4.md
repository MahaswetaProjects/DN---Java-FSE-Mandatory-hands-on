# Hands on 4: Get Average Salary Using HQL

## EmployeeRepository.java
```java
public interface EmployeeRepository extends JpaRepository<Employee, Integer> {

    @Query("SELECT AVG(e.salary) FROM Employee e")
    double getAverageSalary();

    @Query("SELECT AVG(e.salary) FROM Employee e WHERE e.department.id = :id")
    double getAverageSalary(@Param("id") int departmentId);
}
```

## Test
```java
double overall = employeeRepository.getAverageSalary();
double dept1 = employeeRepository.getAverageSalary(1);
```
