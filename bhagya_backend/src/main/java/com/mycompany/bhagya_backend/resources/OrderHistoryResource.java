package com.mycompany.bhagya_backend.resources;

import com.mycompany.bhagya_backend.model.Order;
import com.mycompany.bhagya_backend.model.OrderItem;
import com.mycompany.bhagya_backend.model.Customer;
import com.mycompany.bhagya_backend.util.DBUtil;

import jakarta.ws.rs.*;
import jakarta.ws.rs.core.*;
import java.sql.*;
import java.util.*;

@Path("/orderhistory")
public class OrderHistoryResource {

    // Get all orders, optionally filtered by customer phone or name
    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public List<Order> getOrders(@QueryParam("search") String search) {
        List<Order> orders = new ArrayList<>();
        try (Connection con = DBUtil.getConnection()) {
            String sql =
                "SELECT o.id, o.order_date, c.id as customer_id, c.name as customer_name, c.contact as customer_contact " +
                "FROM orders o " +
                "JOIN customer c ON o.customer_id = c.id ";
            if (search != null && !search.isEmpty()) {
                sql += "WHERE c.contact LIKE ? OR c.name LIKE ? ORDER BY o.order_date DESC";
            } else {
                sql += "ORDER BY o.order_date DESC";
            }
            PreparedStatement ps = con.prepareStatement(sql);
            if (search != null && !search.isEmpty()) {
                String pattern = "%" + search + "%";
                ps.setString(1, pattern);
                ps.setString(2, pattern);
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Order o = new Order();
                o.setId(rs.getInt("id"));
                o.setOrderDate(rs.getTimestamp("order_date"));
                Customer cust = new Customer();
                cust.setId(rs.getInt("customer_id"));
                cust.setName(rs.getString("customer_name"));
                cust.setContact(rs.getString("customer_contact"));
                o.setCustomer(cust);

                // Get order items
                PreparedStatement psi = con.prepareStatement(
                    "SELECT oi.id, i.name, oi.price, oi.quantity " +
                    "FROM order_item oi JOIN item i ON oi.item_id = i.id WHERE oi.order_id = ?");
                psi.setInt(1, o.getId());
                ResultSet rsi = psi.executeQuery();
                List<OrderItem> items = new ArrayList<>();
                while (rsi.next()) {
                    OrderItem oi = new OrderItem();
                    oi.setId(rsi.getInt("id"));
                    oi.setName(rsi.getString("name"));
                    oi.setPrice(rsi.getDouble("price"));
                    oi.setQuantity(rsi.getInt("quantity"));
                    items.add(oi);
                }
                o.setItems(items);
                orders.add(o);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return orders;
    }

    // Delete an order (and its items)
    @DELETE
    @Path("/{orderId}")
    public Response deleteOrder(@PathParam("orderId") int orderId) {
        try (Connection con = DBUtil.getConnection()) {
            PreparedStatement psi = con.prepareStatement("DELETE FROM order_item WHERE order_id=?");
            psi.setInt(1, orderId);
            psi.executeUpdate();
            PreparedStatement ps = con.prepareStatement("DELETE FROM orders WHERE id=?");
            ps.setInt(1, orderId);
            ps.executeUpdate();
            return Response.ok().build();
        } catch (Exception e) {
            e.printStackTrace();
            return Response.serverError().build();
        }
    }
}