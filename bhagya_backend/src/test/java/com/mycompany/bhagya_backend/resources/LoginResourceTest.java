package com.mycompany.bhagya_backend.resources;

import jakarta.ws.rs.core.Response;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

/**
 * Unit test for LoginResource (JUnit 5).
 */
public class LoginResourceTest {

    private LoginResource loginResource;

    @BeforeEach
    public void setUp() {
        loginResource = new LoginResource();
    }

    @AfterEach
    public void tearDown() {
        loginResource = null;
    }

    /**
     * Test login with correct credentials.
     */
    @Test
    public void testLoginSuccess() {
        String username = "user";
        String password = "user123";

        Response result = loginResource.login(username, password);

        assertNotNull(result, "Response should not be null");
        assertEquals(Response.Status.OK.getStatusCode(),
                result.getStatus(),
                "Expected HTTP 200 for valid credentials");
    }

    /**
     * Test login with wrong credentials.
     */
    @Test
    public void testLoginFailure() {
        String username = "wrong";
        String password = "wrong123";

        Response result = loginResource.login(username, password);

        assertNotNull(result, "Response should not be null");
        assertEquals(Response.Status.UNAUTHORIZED.getStatusCode(),
                result.getStatus(),
                "Expected HTTP 401 for invalid credentials");
    }
}
