package com.mycompany.bhagya_backend.resources;

import com.mycompany.bhagya_backend.model.Customer;
import jakarta.ws.rs.core.Response;
import java.util.List;
import org.junit.jupiter.api.*;

import static org.junit.jupiter.api.Assertions.*;

/**
 * Unit tests for CustomerResource.
 */
@TestInstance(TestInstance.Lifecycle.PER_CLASS)
public class CustomerResourceTest {

    private CustomerResource instance;

    @BeforeAll
    public void setUpClass() {
        // Initialize any required resources, e.g., test database connection
        instance = new CustomerResource();
    }

    @AfterAll
    public void tearDownClass() {
        // Cleanup resources if needed
    }

    @BeforeEach
    public void setUp() {
        // Setup before each test (optional)
    }

    @AfterEach
    public void tearDown() {
        // Cleanup after each test (optional)
    }

    @Test
    public void testGetCustomers_noSearch_shouldReturnList() {
        List<Customer> result = instance.getCustomers("");
        assertNotNull(result, "Customer list should not be null");
        // Optionally, check if the list contains expected customers
    }

    @Test
    public void testAddCustomer_validCustomer_shouldReturnOkResponse() {
        Customer customer = new Customer();
        customer.setName("Test Customer");
        customer.setContact("9999999999");
        Response response = instance.addCustomer(customer);
        assertNotNull(response, "Response should not be null");
        assertEquals(Response.Status.OK.getStatusCode(), response.getStatus(), "Status should be OK");
        Customer created = (Customer) response.getEntity();
        assertEquals("Test Customer", created.getName());
        assertEquals("9999999999", created.getContact());
        assertTrue(created.getId() > 0, "Created customer should have a valid ID");
    }

    @Test
    public void testUpdateCustomer_validCustomer_shouldReturnOkResponse() {
        // First, create a customer to update
        Customer customer = new Customer();
        customer.setName("Customer To Update");
        customer.setContact("8888888888");
        Response addResponse = instance.addCustomer(customer);
        Customer created = (Customer) addResponse.getEntity();

        // Update customer
        created.setName("Updated Name");
        Response updateResponse = instance.updateCustomer(created.getId(), created);
        assertNotNull(updateResponse);
        assertEquals(Response.Status.OK.getStatusCode(), updateResponse.getStatus());
        Customer updated = (Customer) updateResponse.getEntity();
        assertEquals("Updated Name", updated.getName());
    }

    @Test
    public void testDeleteCustomer_validId_shouldReturnOkResponse() {
        // First, create a customer to delete
        Customer customer = new Customer();
        customer.setName("Customer To Delete");
        customer.setContact("7777777777");
        Response addResponse = instance.addCustomer(customer);
        Customer created = (Customer) addResponse.getEntity();

        // Delete customer
        Response deleteResponse = instance.deleteCustomer(created.getId());
        assertNotNull(deleteResponse);
        assertEquals(Response.Status.OK.getStatusCode(), deleteResponse.getStatus());

        // Verify deletion
        List<Customer> customerList = instance.getCustomers("");
        boolean exists = customerList.stream().anyMatch(c -> c.getId() == created.getId());
        assertFalse(exists, "Customer should be deleted");
    }

    @Test
    public void testGetCustomers_search_shouldFilterResults() {
        // Add a unique customer for search
        Customer customer = new Customer();
        customer.setName("UniqueSearchName");
        customer.setContact("1234567890");
        instance.addCustomer(customer);

        // Search by name
        List<Customer> result = instance.getCustomers("UniqueSearchName");
        assertNotNull(result);
        assertTrue(result.stream().anyMatch(c -> "UniqueSearchName".equals(c.getName())));
    }
}