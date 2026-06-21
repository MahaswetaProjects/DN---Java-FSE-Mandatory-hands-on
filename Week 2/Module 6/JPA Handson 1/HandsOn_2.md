# Hands on 2: Hibernate with XML Configuration (concept walkthrough)

Spring Data JPA replaces this manual flow:
```java
SessionFactory sessionFactory = new Configuration().configure().buildSessionFactory();
Session session = sessionFactory.openSession();
Transaction tx = session.beginTransaction();
session.save(country);
tx.commit();
session.close();
```
with one line:
```java
countryRepository.save(country);
```
`JpaRepository` + `@Transactional` handle the SessionFactory/Session/Transaction lifecycle for you.
