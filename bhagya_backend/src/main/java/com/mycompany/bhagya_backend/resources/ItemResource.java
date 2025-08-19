package com.mycompany.bhagya_backend.resources;

import com.mycompany.bhagya_backend.model.Item;
import com.mycompany.bhagya_backend.util.DBUtil;

import jakarta.ws.rs.*;
import jakarta.ws.rs.core.*;
import java.sql.*;
import java.util.*;

@Path("/items")
public class ItemResource {

    @GET
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
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response addItem(Item item) {
        try (Connection con = DBUtil.getConnection()) {
            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO item (name, price, quantity) VALUES (?, ?, ?)",
                Statement.RETURN_GENERATED_KEYS
            );
            ps.setString(1, item.getName());
            ps.setDouble(2, item.getPrice());
            ps.setInt(3, item.getQuantity());
            ps.executeUpdate();
            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) item.setId(rs.getInt(1));
            return Response.ok(item).build();
        } catch (Exception e) {
            e.printStackTrace();
            return Response.serverError().build();
        }
    }

    @PUT
    @Path("/{id}")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response updateItem(@PathParam("id") int id, Item item) {
        try (Connection con = DBUtil.getConnection()) {
            PreparedStatement ps = con.prepareStatement(
                "UPDATE item SET name=?, price=?, quantity=? WHERE id=?"
            );
            ps.setString(1, item.getName());
            ps.setDouble(2, item.getPrice());
            ps.setInt(3, item.getQuantity());
            ps.setInt(4, id);
            ps.executeUpdate();
            item.setId(id);
            return Response.ok(item).build();
        } catch (Exception e) {
            e.printStackTrace();
            return Response.serverError().build();
        }
    }

    @DELETE
    @Path("/{id}")
    public Response deleteItem(@PathParam("id") int id) {
        try (Connection con = DBUtil.getConnection()) {
            PreparedStatement ps = con.prepareStatement("DELETE FROM item WHERE id=?");
            ps.setInt(1, id);
            ps.executeUpdate();
            return Response.ok().build();
        } catch (Exception e) {
            e.printStackTrace();
            return Response.serverError().build();
        }
    }
}