# Hands on 1: Spring Data JPA Quick Example

## Country.java (entity)
```java
import javax.persistence.*;

@Entity
@Table(name = "country")
public class Country {
    @Id
    private String code;
    private String name;
    // constructors, getters, setters
}
```

## CountryRepository.java
```java
import org.springframework.data.jpa.repository.JpaRepository;

public interface CountryRepository extends JpaRepository<Country, String> {
}
```

## CountryService.java
```java
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class CountryService {
    @Autowired
    private CountryRepository countryRepository;

    public List<Country> getAllCountries() {
        return countryRepository.findAll();
    }
}
```

## Test it
```java
List<Country> countries = countryService.getAllCountries();
System.out.println(countries.size());
```
