# Hands on 2: Query Methods on Stock Table

## Stock.java (entity)
```java
import javax.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDate;

@Entity
public class Stock {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;
    private String code;
    private LocalDate date;
    private BigDecimal open;
    private BigDecimal close;
    private Long volume;
    // getters/setters
}
```

## StockRepository.java
```java
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

public interface StockRepository extends JpaRepository<Stock, Integer> {

    // FB stock for September 2019
    List<Stock> findByCodeAndDateBetweenOrderByDateAsc(String code, LocalDate start, LocalDate end);

    // GOOGL with closing price > 1250
    List<Stock> findByCodeAndCloseGreaterThan(String code, BigDecimal close);

    // Top 3 highest-volume trading days
    List<Stock> findTop3ByOrderByVolumeDesc();

    // 3 lowest closing prices for NFLX
    List<Stock> findTop3ByCodeOrderByCloseAsc(String code);
}
```

## Test
```java
stockRepository.findByCodeAndDateBetweenOrderByDateAsc("FB", LocalDate.of(2019,9,1), LocalDate.of(2019,9,30));
stockRepository.findByCodeAndCloseGreaterThan("GOOGL", new BigDecimal("1250"));
stockRepository.findTop3ByOrderByVolumeDesc();
stockRepository.findTop3ByCodeOrderByCloseAsc("NFLX");
```
