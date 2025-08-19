package com.mycompany.bhagya_backend.resources;

import com.mycompany.bhagya_backend.model.Customer;
import com.mycompany.bhagya_backend.model.Item;
import com.mycompany.bhagya_backend.util.DBUtil;

import jakarta.ws.rs.*;
import jakarta.ws.rs.core.*;
import java.sql.*;
import java.util.*;

@Path("/orders")
public class OrderResource {

    @GET
    @Path("/lookupCustomer")
    @Produces(MediaType.APPLICATION_JSON)
    public Response lookupCustomer(@QueryParam("contact") String contact) {
        try (Connection con = DBUtil.getConnection()) {
            PreparedStatement ps = con.prepareStatement("SELECT * FROM customer WHERE contact=?");
            ps.setString(1, contact);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Customer c = new Customer();
                c.setId(rs.getInt("id"));
                c.setName(rs.getString("name"));
                c.setContact(rs.getString("contact"));
                return Response.ok(c).build();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return Response.status(Response.Status.NOT_FOUND).build();
    }

    @POST
    @Path("/registerCustomer")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response registerCustomer(Customer customer) {
        try (Connection con = DBUtil.getConnection()) {
            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO customer (name, contact) VALUES (?, ?)", Statement.RETURN_GENERATED_KEYS);
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

    @GET
    @Path("/listItems")
    @Produces(MediaType.APPLICATION_JSON)
    public List<Item> getItems(@QueryParam("search") String search) {
        List<Item> list = new ArrayList<>();
        try (Connection con = DBUtil.getConnection()) {
            PreparedStatement ps;
            if (search != null && !search.isEmpty()) {
                ps = con.prepareStatement("SELECT * FROM item WHERE name LIKE ?");
                String pattern = "%" + search + "%";
                ps.setString(1, pattern);
            } else {
                ps = con.prepareStatement("SELECT * FROM item");
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Item i = new Item();
                i.setId(rs.getInt("id"));
                i.setName(rs.getString("name"));
                i.setPrice(rs.getDouble("price"));
                i.setQuantity(rs.getInt("quantity"));
                list.add(i);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    @POST
    @Path("/submit")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response submitOrder(Map<String, Object> payload) {
        Map<String, Object> custMap = (Map<String, Object>) payload.get("customer");
        List<Map<String, Object>> cart = (List<Map<String, Object>>) payload.get("cart");

        // Debugging output
        System.out.println("custMap: " + custMap);
        System.out.println("cart: " + cart);

        Connection con = null;
        PreparedStatement psOrder = null, psItem = null, psUpdate = null;
        ResultSet rsOrder = null;
        try {
            con = DBUtil.getConnection();
            con.setAutoCommit(false); // Transaction

            // Safe type cast for customer id
            int customerId = ((Number) custMap.get("id")).intValue();

            // Insert order
            psOrder = con.prepareStatement(
                "INSERT INTO orders (customer_id, order_date) VALUES (?, NOW())", Statement.RETURN_GENERATED_KEYS);
            psOrder.setInt(1, customerId);
            psOrder.executeUpdate();
            rsOrder = psOrder.getGeneratedKeys();
            int orderId = 0;
            if (rsOrder.next()) orderId = rsOrder.getInt(1);

            // Insert order items and update item quantity
            List<Map<String, Object>> itemsForBill = new ArrayList<>();
            for (Map<String, Object> i : cart) {
                System.out.println("Item: " + i); // Debugging

                int itemId = ((Number) i.get("id")).intValue();
                String name = (String) i.get("name");
                double price = Double.valueOf(i.get("price").toString());
                int quantity = ((Number) i.get("quantity")).intValue();

                // Insert order item
                psItem = con.prepareStatement(
                    "INSERT INTO order_item (order_id, item_id, quantity, price) VALUES (?, ?, ?, ?)");
                psItem.setInt(1, orderId);
                psItem.setInt(2, itemId);
                psItem.setInt(3, quantity);
                psItem.setDouble(4, price);
                psItem.executeUpdate();

                // Deduct quantity from item table
                psUpdate = con.prepareStatement(
                    "UPDATE item SET quantity = quantity - ? WHERE id = ? AND quantity >= ?");
                psUpdate.setInt(1, quantity);
                psUpdate.setInt(2, itemId);
                psUpdate.setInt(3, quantity);
                int affected = psUpdate.executeUpdate();
                if (affected == 0) {
                    con.rollback();
                    return Response.status(Response.Status.CONFLICT)
                        .entity("Not enough stock for item: " + name).build();
                }

                Map<String, Object> billItem = new HashMap<>();
                billItem.put("name", name);
                billItem.put("price", price);
                billItem.put("quantity", quantity);
                itemsForBill.add(billItem);
            }
            con.commit();

            // Prepare response (bill)
            Map<String, Object> resp = new HashMap<>();
            resp.put("customer", custMap);
            resp.put("items", itemsForBill);
            resp.put("orderDate", new java.util.Date().toString());
            return Response.ok(resp).build();
        } catch (Exception e) {
            e.printStackTrace();
            try { if (con != null) con.rollback(); } catch (Exception ex) { ex.printStackTrace(); }
            return Response.serverError().build();
        } finally {
            try { if (rsOrder != null) rsOrder.close(); } catch (Exception e) {}
            try { if (psOrder != null) psOrder.close(); } catch (Exception e) {}
            try { if (psItem != null) psItem.close(); } catch (Exception e) {}
            try { if (psUpdate != null) psUpdate.close(); } catch (Exception e) {}
            try { if (con != null) con.setAutoCommit(true); con.close(); } catch (Exception e) {}
        }
    }
}