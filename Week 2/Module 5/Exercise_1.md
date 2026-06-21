# Exercise 1: Configuring a Basic Spring Application

## pom.xml (Spring Core dependency)
```xml
<dependency>
    <groupId>org.springframework</groupId>
    <artifactId>spring-context</artifactId>
    <version>5.3.30</version>
</dependency>
```

## src/main/resources/applicationContext.xml
```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
        http://www.springframework.org/schema/beans/spring-beans.xsd">

    <bean id="bookRepository" class="com.library.repository.BookRepository"/>

    <bean id="bookService" class="com.library.service.BookService">
        <property name="bookRepository" ref="bookRepository"/>
    </bean>

</beans>
```

## com/library/repository/BookRepository.java
```java
package com.library.repository;

import java.util.ArrayList;
import java.util.List;

public class BookRepository {
    private final List<String> books = new ArrayList<>();

    public BookRepository() {
        books.add("Effective Java");
        books.add("Clean Code");
    }

    public List<String> findAll() {
        return books;
    }

    public void save(String title) {
        books.add(title);
    }
}
```

## com/library/service/BookService.java
```java
package com.library.service;

import com.library.repository.BookRepository;
import java.util.List;

public class BookService {

    private BookRepository bookRepository;

    public void setBookRepository(BookRepository bookRepository) {
        this.bookRepository = bookRepository;
    }

    public List<String> getAllBooks() {
        return bookRepository.findAll();
    }

    public void addBook(String title) {
        bookRepository.save(title);
    }
}
```

## Main class to load context and test
```java
package com.library;

import com.library.service.BookService;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

public class LibraryManagementApplication {
    public static void main(String[] args) {
        ApplicationContext context = new ClassPathXmlApplicationContext("applicationContext.xml");
        BookService bookService = context.getBean(BookService.class);
        System.out.println(bookService.getAllBooks());
    }
}
```
