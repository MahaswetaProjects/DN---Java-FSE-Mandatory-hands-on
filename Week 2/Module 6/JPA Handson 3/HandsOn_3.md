# Hands on 3: Fetch Quiz Attempt Details Using HQL

## Entities
```java
@Entity public class AppUser { @Id @GeneratedValue private Integer id; private String username; }

@Entity public class Question { @Id @GeneratedValue private Integer id; private String text; }

@Entity public class Options {
    @Id @GeneratedValue private Integer id;
    @ManyToOne private Question question;
    private String text;
    private BigDecimal score;
}

@Entity public class Attempt {
    @Id @GeneratedValue private Integer id;
    @ManyToOne private AppUser user;
    @OneToMany(mappedBy = "attempt") private List<AttemptQuestion> attemptQuestions;
}

@Entity public class AttemptQuestion {
    @Id @GeneratedValue private Integer id;
    @ManyToOne private Attempt attempt;
    @ManyToOne private Question question;
    @OneToMany(mappedBy = "attemptQuestion") private List<AttemptOption> attemptOptions;
}

@Entity public class AttemptOption {
    @Id @GeneratedValue private Integer id;
    @ManyToOne private AttemptQuestion attemptQuestion;
    @ManyToOne private Options option;
    private boolean selected;
}
```

## AttemptRepository.java - HQL joining all 6 tables in order
```java
public interface AttemptRepository extends JpaRepository<Attempt, Integer> {

    @Query("SELECT DISTINCT a FROM Attempt a " +
           "JOIN FETCH a.user u " +
           "JOIN FETCH a.attemptQuestions aq " +
           "JOIN FETCH aq.question q " +
           "JOIN FETCH aq.attemptOptions ao " +
           "JOIN FETCH ao.option o " +
           "WHERE u.id = :userId AND a.id = :attemptId")
    Optional<Attempt> getAttempt(@Param("userId") int userId, @Param("attemptId") int attemptId);
}
```

## Print the result
```java
Attempt attempt = attemptRepository.getAttempt(1, 1).orElseThrow();
for (AttemptQuestion aq : attempt.getAttemptQuestions()) {
    System.out.println(aq.getQuestion().getText());
    for (AttemptOption ao : aq.getAttemptOptions()) {
        System.out.println(" - " + ao.getOption().getText() + "\t" + ao.getOption().getScore() + "\t" + ao.isSelected());
    }
}
```
