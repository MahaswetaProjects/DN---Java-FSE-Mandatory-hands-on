# Exercise 5: Configuring the Spring IoC Container

Same central `applicationContext.xml` as Exercise 1/2 — this IS the IoC container config:

```xml
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

```java
// Load it and test
ApplicationContext context = new ClassPathXmlApplicationContext("applicationContext.xml");
BookService bookService = context.getBean(BookService.class);
```
