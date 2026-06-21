# Hands on 5: Get All Employees Using Native Query

## EmployeeRepository.java
```java
public interface EmployeeRepository extends JpaRepository<Employee, Integer> {

    @Query(value = "SELECT * FROM employee", nativeQuery = true)
    List<Employee> getAllEmployeesNative();
}
```

Native queries use real table/column names (raw SQL) instead of entity/field names like HQL does.
Useful for DB-specific syntax HQL can't express.
