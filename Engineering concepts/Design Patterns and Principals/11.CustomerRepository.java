// Repository interface
// Dependency Injection
public interface CustomerRepository {
    String findCustomerById(int id);
}

// Concrete repository
public class CustomerRepositoryImpl implements CustomerRepository {
    public String findCustomerById(int id) {
        return "Customer #" + id + " - John Doe";
    }
}

// Service (depends on repository via constructor injection)
public class CustomerService {
    private CustomerRepository repository;
    public CustomerService(CustomerRepository repository) {
        this.repository = repository;
    }
    public void getCustomer(int id) {
        System.out.println(repository.findCustomerById(id));
    }
}

// Test
public class Main {
    public static void main(String[] args) {
        CustomerRepository repo = new CustomerRepositoryImpl();
        CustomerService service = new CustomerService(repo); // injected
        service.getCustomer(42);
    }
}