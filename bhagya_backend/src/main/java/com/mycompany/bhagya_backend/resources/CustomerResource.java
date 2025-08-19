package com.mycompany.bhagya_backend.resources;

import com.mycompany.bhagya_backend.model.Customer;
import com.mycompany.bhagya_backend.util.DBUtil;

import jakarta.ws.rs.*;
import jakarta.ws.rs.core.*;
import java.sql.*;
import java.util.*;

@Path("/customers")
public class CustomerResource {

    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public List<Customer> getCustomers(@QueryParam("search") String search) {
        List<Customer> list = new ArrayList<>();
        try (Connection con = DBUtil.getConnection()) {
            PreparedStatement ps;
            if (search != null && !search.isEmpty()) {
                ps = con.prepareStatement("SELECT * FROM customer WHERE name LIKE ? OR contact LIKE ?");
                String pattern = "%" + search + "%";
                ps.setString(1, pattern);
                ps.setString(2, pattern);
            } else {
                ps = con.prepareStatement("SELECT * FROM customer");
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Customer c = new Customer();
                c.setId(rs.getInt("id"));
                c.setName(rs.getString("name"));
                c.setContact(rs.getString("contact"));
                list.add(c);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    @POST
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response addCustomer(Customer customer) {
        try (Connection con = DBUtil.getConnection()) {
            PreparedStatement ps = con.prepareStatement("INSERT INTO customer (name, contact) VALUES (?, ?)", Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, customer.getName());
            ps.setString(2, customer.getContact());
            ps.executeUpdate();
            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) customer.setId(rs.getInt(1));
            return Response.ok(customer).build();
        } catch (Exception e) {
            e.printStackTrace();
            return Response.serverError().build();
        }
    }

    @PUT
    @Path("/{id}")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response updateCustomer(@PathParam("id") int id, Customer customer) {
        try (Connection con = DBUtil.getConnection()) {
            PreparedStatement ps = con.prepareStatement("UPDATE customer SET name=?, contact=? WHERE id=?");
            ps.setString(1, customer.getName());
            ps.setString(2, customer.getContact());
            ps.setInt(3, id);
            ps.executeUpdate();
            customer.setId(id);
            return Response.ok(customer).build();
        } catch (Exception e) {
            e.printStackTrace();
            return Response.serverError().build();
        }
    }

    @DELETE
    @Path("/{id}")
    public Response deleteCustomer(@PathParam("id") int id) {
        try (Connection con = DBUtil.getConnection()) {
            PreparedStatement ps = con.prepareStatement("DELETE FROM customer WHERE id=?");
            ps.setInt(1, id);
            ps.executeUpdate();
            return Response.ok().build();
        } catch (Exception e) {
            e.printStackTrace();
            return Response.serverError().build();
        }
    }
}