# Exercise 9: Creating a Spring Boot Application

## pom.xml
```xml
<parent>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-parent</artifactId>
    <version>2.7.18</version>
</parent>

<dependencies>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-web</artifactId>
    </dependency>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-data-jpa</artifactId>
    </dependency>
    <dependency>
        <groupId>com.h2database</groupId>
        <artifactId>h2</artifactId>
        <scope>runtime</scope>
    </dependency>
</dependencies>
```

## application.properties
```properties
spring.datasource.url=jdbc:h2:mem:librarydb
spring.datasource.driverClassName=org.h2.Driver
spring.datasource.username=sa
spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=true
```

## Book.java (entity)
```java
import javax.persistence.*;

@Entity
public class Book {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String title;
    private String author;
    private String isbn;
    // getters/setters
}
```

## BookRepository.java
```java
import org.springframework.data.jpa.repository.JpaRepository;

public interface BookRepository extends JpaRepository<Book, Long> {
}
```

## BookController.java (REST CRUD)
```java
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/books")
public class BookController {

    private final BookRepository bookRepository;

    public BookController(BookRepository bookRepository) {
        this.bookRepository = bookRepository;
    }

    @GetMapping
    public List<Book> getAll() { return bookRepository.findAll(); }

    @PostMapping
    public Book create(@RequestBody Book book) { return bookRepository.save(book); }

    @PutMapping("/{id}")
    public Book update(@PathVariable Long id, @RequestBody Book updated) {
        updated.setId(id);
        return bookRepository.save(updated);
    }

    @DeleteMapping("/{id}")
    public void delete(@PathVariable Long id) { bookRepository.deleteById(id); }
}
```

## Main class
```java
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class LibraryManagementApplication {
    public static void main(String[] args) {
        SpringApplication.run(LibraryManagementApplication.class, args);
    }
}
```

Run: `mvn spring-boot:run` then test `GET/POST/PUT/DELETE http://localhost:8080/api/books`
