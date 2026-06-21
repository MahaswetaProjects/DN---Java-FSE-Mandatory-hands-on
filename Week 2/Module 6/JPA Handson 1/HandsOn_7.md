# Hands on 7: Add a New Country

## CountryService.java
```java
public void addCountry(Country country) {
    countryRepository.save(country);
}
```

## Test
```java
Country country = new Country("ZZ", "Test Land");
countryService.addCountry(country);
```
