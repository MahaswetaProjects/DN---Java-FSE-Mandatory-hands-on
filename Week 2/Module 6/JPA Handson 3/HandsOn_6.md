# Hands on 6: Criteria Query

Used when filters are dynamic - you don't know ahead of time which search fields the user picked
(e.g. searching laptops by RAM, CPU, OS, weight, only if the user set those filters).

## ProductCriteriaSearch.java
```java
import javax.persistence.EntityManager;
import javax.persistence.criteria.*;
import java.util.ArrayList;
import java.util.List;

@Component
public class ProductCriteriaSearch {

    @PersistenceContext
    private EntityManager entityManager;

    public List<Product> search(String category, Integer minRamGb, String operatingSystem) {
        CriteriaBuilder cb = entityManager.getCriteriaBuilder();
        CriteriaQuery<Product> query = cb.createQuery(Product.class);
        Root<Product> product = query.from(Product.class);

        List<Predicate> predicates = new ArrayList<>();

        if (category != null) {
            predicates.add(cb.equal(product.get("category"), category));
        }
        if (minRamGb != null) {
            predicates.add(cb.greaterThanOrEqualTo(product.get("ramGb"), minRamGb));
        }
        if (operatingSystem != null) {
            predicates.add(cb.equal(product.get("operatingSystem"), operatingSystem));
        }

        query.select(product).where(predicates.toArray(new Predicate[0]));
        return entityManager.createQuery(query).getResultList();
    }
}
```

## Test
```java
List<Product> results = productCriteriaSearch.search("Laptop", 8, "Windows");
```

Only filters that are non-null get added as predicates - so the same method handles any
combination of search criteria without writing a separate query for each combination.
