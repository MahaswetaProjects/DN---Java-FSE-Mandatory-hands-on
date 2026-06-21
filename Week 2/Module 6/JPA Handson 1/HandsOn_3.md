# Hands on 3: Hibernate with Annotation Configuration

## Country.java - same annotations used by both plain Hibernate and Spring Data JPA
```java
import javax.persistence.*;

@Entity
@Table(name = "country")
public class Country {

    @Id
    @Column(name = "code")
    private String code;

    @Column(name = "name")
    private String name;
}
```
`@Entity`, `@Table`, `@Id`, `@Column` are standard JPA annotations - Hibernate and Spring Data JPA both read them the same way.
