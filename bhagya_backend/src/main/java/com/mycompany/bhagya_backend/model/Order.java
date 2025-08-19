package com.mycompany.bhagya_backend.model;

import java.sql.Timestamp;
import java.util.List;

public class Order {
    private int id;
    private Timestamp orderDate;
    private Customer customer;
    private List<OrderItem> items;

    // Getters and setters...
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public Timestamp getOrderDate() { return orderDate; }
    public void setOrderDate(Timestamp orderDate) { this.orderDate = orderDate; }
    public Customer getCustomer() { return customer; }
    public void setCustomer(Customer customer) { this.customer = customer; }
    public List<OrderItem> getItems() { return items; }
    public void setItems(List<OrderItem> items) { this.items = items; }
}