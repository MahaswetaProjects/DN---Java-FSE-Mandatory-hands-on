# Hands on 4: JPA vs Hibernate vs Spring Data JPA

| | Hibernate (raw) | Spring Data JPA |
|---|---|---|
| Get all | `session.createQuery("from Country").list()` | `countryRepository.findAll()` |
| Save | `session.save(country)` | `countryRepository.save(country)` |
| Find by id | `session.get(Country.class, code)` | `countryRepository.findById(code)` |
| Delete | `session.delete(country)` | `countryRepository.deleteById(code)` |

JPA = the specification (interfaces like `EntityManager`).
Hibernate = an implementation of that spec.
Spring Data JPA = a layer on top that auto-generates the repository implementation, so you write almost no boilerplate.
