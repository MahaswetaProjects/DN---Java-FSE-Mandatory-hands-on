# Hands on 5: Implement Services for Managing Country (populate data)

## data.sql - load the full country list
```sql
insert into country (code, name) values ('AF', 'Afghanistan');
insert into country (code, name) values ('AL', 'Albania');
insert into country (code, name) values ('IN', 'India');
insert into country (code, name) values ('US', 'United States');
-- ... full list (249 rows) goes here, same pattern
```

## application.properties
```properties
spring.jpa.hibernate.ddl-auto=update
spring.jpa.defer-datasource-initialization=true
```

## CountryService.java
```java
@Service
public class CountryService {
    @Autowired
    private CountryRepository countryRepository;

    public List<Country> getAllCountries() {
        return countryRepository.findAll();
    }
}
```
