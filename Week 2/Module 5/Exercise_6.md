# Exercise 6: Configuring Beans with Annotations

## BookService.java
```java
import org.springframework.stereotype.Service;

@Service
public class BookService {
    private BookRepository bookRepository;
    public void setBookRepository(BookRepository bookRepository) {
        this.bookRepository = bookRepository;
    }
}
```

## BookRepository.java
```java
import org.springframework.stereotype.Repository;

@Repository
public class BookRepository {
    // ... same as before
}
```

## applicationContext.xml - component scan instead of explicit beans
```xml
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:context="http://www.springframework.org/schema/context"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
        http://www.springframework.org/schema/beans/spring-beans.xsd
        http://www.springframework.org/schema/context
        http://www.springframework.org/schema/context/spring-context.xsd">

    <context:component-scan base-package="com.library"/>

</beans>
```
