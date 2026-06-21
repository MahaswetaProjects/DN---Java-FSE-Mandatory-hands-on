# Hands on 2: Get All Permanent Employees Using HQL (and optimize it)

## First cut - works, but triggers extra lazy-load queries if you touch department/skills
```java
@Query("SELECT e FROM Employee e WHERE e.permanent = true")
List<Employee> getAllPermanentEmployees();
```

## Optimized - fetch joins load department + skills in ONE query
```java
@Query("SELECT DISTINCT e FROM Employee e " +
       "LEFT JOIN FETCH e.department d " +
       "LEFT JOIN FETCH e.skillList " +
       "WHERE e.permanent = true")
List<Employee> getAllPermanentEmployeesOptimized();
```

Use the optimized version whenever you know you'll need the related entities right away -
it avoids the classic Hibernate N+1 query problem.
