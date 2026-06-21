# Hands on 1: Introduction to HQL and JPQL

HQL/JPQL queries the entity (Java class) and its fields, not the raw table/columns:
```java
public interface EmployeeRepository extends JpaRepository<Employee, Integer> {

    @Query("SELECT e FROM Employee e WHERE e.permanent = true")
    List<Employee> getAllPermanentEmployees();
}
```
`Employee` and `e.permanent` here refer to the Java entity class and field - Hibernate translates
this into the real SQL table/column names underneath.
