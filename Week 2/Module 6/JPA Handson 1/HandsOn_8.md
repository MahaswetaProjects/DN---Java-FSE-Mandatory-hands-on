# Hands on 8: Update a Country Based on Code

## CountryService.java
```java
public void updateCountry(String code, String newName) throws CountryNotFoundException {
    Country country = countryRepository.findById(code)
        .orElseThrow(() -> new CountryNotFoundException("Country not found for code: " + code));
    country.setName(newName);
    countryRepository.save(country);
}
```

## Test
```java
countryService.updateCountry("ZZ", "Updated Test Land");
```
