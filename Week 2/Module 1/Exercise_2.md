# Exercise 2: Implementing Dependency Injection

## applicationContext.xml - wire BookRepository into BookService
```xml
<bean id="bookRepository" class="com.library.repository.BookRepository"/>

<bean id="bookService" class="com.library.service.BookService">
    <property name="bookRepository" ref="bookRepository"/>
</bean>
```

## BookService.java - setter for injection
```java
public class BookService {
    private BookRepository bookRepository;

    public void setBookRepository(BookRepository bookRepository) {
        this.bookRepository = bookRepository;
    }
}
```

## Test in LibraryManagementApplication
```java
ApplicationContext context = new ClassPathXmlApplicationContext("applicationContext.xml");
BookService bookService = context.getBean(BookService.class);
System.out.println(bookService.getAllBooks()); // confirms BookRepository was injected
```
