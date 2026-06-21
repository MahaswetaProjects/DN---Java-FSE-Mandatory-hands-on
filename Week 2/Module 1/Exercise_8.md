# Exercise 8: Implementing Basic AOP with Spring

## com/library/aspect/LoggingAspect.java
```java
package com.library.aspect;

import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.After;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;

@Aspect
public class LoggingAspect {

    @Before("execution(* com.library.service.BookService.*(..))")
    public void logBefore(JoinPoint joinPoint) {
        System.out.println("Entering: " + joinPoint.getSignature().toShortString());
    }

    @After("execution(* com.library.service.BookService.*(..))")
    public void logAfter(JoinPoint joinPoint) {
        System.out.println("Exiting: " + joinPoint.getSignature().toShortString());
    }
}
```

## applicationContext.xml - register aspect + enable auto-proxy
```xml
<aop:aspectj-autoproxy/>
<bean id="loggingAspect" class="com.library.aspect.LoggingAspect"/>
```
