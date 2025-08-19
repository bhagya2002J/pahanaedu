package com.mycompany.bhagya_backend.resources;

import jakarta.ws.rs.*;
import jakarta.ws.rs.core.*;

@Path("/login")
public class LoginResource {

    @POST
    @Consumes(MediaType.APPLICATION_FORM_URLENCODED)
    @Produces(MediaType.APPLICATION_JSON)
    public Response login(@FormParam("username") String username, @FormParam("password") String password) {
        // Hardcoded credentials
        if ("user".equals(username) && "user123".equals(password)) {
            return Response.ok("{\"status\":\"success\"}").build();
        } else {
            return Response.status(Response.Status.UNAUTHORIZED)
                           .entity("{\"status\":\"fail\"}").build();
        }
    }
}