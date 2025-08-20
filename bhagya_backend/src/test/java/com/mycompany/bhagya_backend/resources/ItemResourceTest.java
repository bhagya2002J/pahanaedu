package com.mycompany.bhagya_backend.resources;

import com.mycompany.bhagya_backend.model.Item;
import jakarta.ws.rs.core.Response;
import java.util.List;

import org.junit.jupiter.api.*;

import static org.junit.jupiter.api.Assertions.*;

/**
 * Unit tests for ItemResource (JUnit 5).
 */
@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
public class ItemResourceTest {

    private ItemResource instance;

    @BeforeAll
    public static void setUpClass() {
        // Initialize DB connection or other shared resources if needed
    }

    @AfterAll
    public static void tearDownClass() {
        // Clean up shared resources if needed
    }

    @BeforeEach
    public void setUp() {
        instance = new ItemResource();
    }

    @AfterEach
    public void tearDown() {
        instance = null;
    }

    @Test
    @Order(1)
    public void testGetItems_noSearch_shouldReturnList() {
        List<Item> result = instance.getItems("");
        assertNotNull(result, "Item list should not be null");
        // Optionally assert that DB has seeded items
    }

    @Test
    @Order(2)
    public void testAddItem_validItem_shouldReturnOkResponse() {
        Item item = new Item();
        item.setName("Test Item");
        item.setPrice(99.99);
        item.setQuantity(10);

        Response response = instance.addItem(item);

        assertNotNull(response, "Response should not be null");
        assertEquals(Response.Status.OK.getStatusCode(), response.getStatus());

        Item created = (Item) response.getEntity();
        assertEquals("Test Item", created.getName());
        assertEquals(99.99, created.getPrice(), 0.001);
        assertEquals(10, created.getQuantity());
        assertTrue(created.getId() > 0, "Created item should have an ID");
    }

    @Test
    @Order(3)
    public void testUpdateItem_validItem_shouldReturnOkResponse() {
        // Add item to update
        Item item = new Item();
        item.setName("ToUpdate");
        item.setPrice(25.00);
        item.setQuantity(7);

        Response addResponse = instance.addItem(item);
        Item created = (Item) addResponse.getEntity();

        // Update item
        created.setName("UpdatedName");
        created.setPrice(30.00);
        created.setQuantity(12);

        Response updateResponse = instance.updateItem(created.getId(), created);

        assertNotNull(updateResponse);
        assertEquals(Response.Status.OK.getStatusCode(), updateResponse.getStatus());

        Item updated = (Item) updateResponse.getEntity();
        assertEquals("UpdatedName", updated.getName());
        assertEquals(30.00, updated.getPrice(), 0.001);
        assertEquals(12, updated.getQuantity());
    }

    @Test
    @Order(4)
    public void testDeleteItem_validId_shouldReturnOkResponse() {
        // Add item to delete
        Item item = new Item();
        item.setName("ToDelete");
        item.setPrice(10.00);
        item.setQuantity(5);

        Response addResponse = instance.addItem(item);
        Item created = (Item) addResponse.getEntity();

        // Delete item
        Response deleteResponse = instance.deleteItem(created.getId());
        assertNotNull(deleteResponse);
        assertEquals(Response.Status.OK.getStatusCode(), deleteResponse.getStatus());

        // Verify deletion
        List<Item> itemList = instance.getItems("");
        boolean exists = itemList.stream().anyMatch(i -> i.getId() == created.getId());
        assertFalse(exists, "Item should be deleted");
    }

    @Test
    @Order(5)
    public void testGetItems_search_shouldFilterResults() {
        // Add a unique item for search
        Item item = new Item();
        item.setName("UniqueSearchItem");
        item.setPrice(123.45);
        item.setQuantity(3);
        instance.addItem(item);

        // Search by name
        List<Item> result = instance.getItems("UniqueSearchItem");
        assertNotNull(result);
        assertTrue(result.stream().anyMatch(i -> "UniqueSearchItem".equals(i.getName())),
                   "Search should return the unique item");
    }
}
