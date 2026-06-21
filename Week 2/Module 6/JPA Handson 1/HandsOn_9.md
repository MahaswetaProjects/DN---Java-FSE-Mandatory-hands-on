# Hands on 9: Delete a Country Based on Code

## CountryService.java
```java
public void deleteCountry(String code) {
    countryRepository.deleteById(code);
}
```

## Test
```java
countryService.deleteCountry("ZZ");
```
