# Hands on 1: Query Methods on Country Table

## CountryRepository.java
```java
import java.util.List;

public interface CountryRepository extends JpaRepository<Country, String> {

    // Countries whose name contains given text, ascending order
    List<Country> findByNameContainingOrderByNameAsc(String partialName);

    // Countries whose name starts with a letter (alphabet index)
    List<Country> findByNameStartingWith(String letter);
}
```

## Test
```java
List<Country> withOu = countryRepository.findByNameContainingOrderByNameAsc("ou");
List<Country> startingZ = countryRepository.findByNameStartingWith("Z");
```
