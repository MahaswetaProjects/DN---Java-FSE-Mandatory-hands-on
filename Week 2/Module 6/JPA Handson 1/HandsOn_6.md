# Hands on 6: Find a Country Based on Country Code

## CountryNotFoundException.java
```java
public class CountryNotFoundException extends Exception {
    public CountryNotFoundException(String message) {
        super(message);
    }
}
```

## CountryService.java
```java
public Country findCountryByCode(String code) throws CountryNotFoundException {
    return countryRepository.findById(code)
        .orElseThrow(() -> new CountryNotFoundException("Country not found for code: " + code));
}
```

## Test
```java
try {
    Country country = countryService.findCountryByCode("IN");
    System.out.println(country);
} catch (CountryNotFoundException e) {
    System.out.println(e.getMessage());
}
```
