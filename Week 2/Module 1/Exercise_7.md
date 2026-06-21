# Exercise 7: Implementing Constructor and Setter Injection

## BookService.java - both constructor and setter
```java
public class BookService {
    private BookRepository bookRepository;

    // Constructor injection
    public BookService(BookRepository bookRepository) {
        this.bookRepository = bookRepository;
    }

    // Setter injection
    public void setBookRepository(BookRepository bookRepository) {
        this.bookRepository = bookRepository;
    }
}
```

## applicationContext.xml - constructor injection
```xml
<bean id="bookRepository" class="com.library.repository.BookRepository"/>

<bean id="bookService" class="com.library.service.BookService">
    <constructor-arg ref="bookRepository"/>
</bean>
```

## Same class wired with setter injection instead
```xml
<bean id="bookService" class="com.library.service.BookService">
    <property name="bookRepository" ref="bookRepository"/>
</bean>
```
