<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="true" %>
<!DOCTYPE html>
<html>
<head>
    <title>System Help - Bhagya POS</title>
    <style>
        body { font-family: Arial; background: #f9f9f9; }
        .container { width: 800px; margin: 40px auto; background: #fff; padding: 28px; box-shadow: 0 2px 8px #ccc; border-radius: 8px; }
        h1 { text-align: center; }
        h2 { margin-top: 32px; color: #0077b6; }
        ul { margin: 0 0 20px 22px; }
        li { margin-bottom: 8px; }
        .section { margin-bottom: 32px; }
        .tip { background: #e1eefa; padding: 10px; border-radius: 6px; margin: 12px 0; }
        code { background: #f0f8ff; padding: 2px 6px; border-radius: 3px; }
    </style>
</head>
<body>
<div class="container">
    <h1>Help & User Guide</h1>
    <div class="section">
        <h2>Introduction</h2>
        <p>
            Welcome to the PhanaEdu Billing System! This system lets you manage customers, items, orders, and view your order history. Below you’ll find guidance for each page and common tasks.
        </p>
    </div>
    <div class="section">
        <h2>Pages & Features</h2>
        <ul>
            <li><b>Manage Customers</b>: Add, edit, delete, and search customers by name or phone number.</li>
            <li><b>Manage Items</b>: Add new items, edit item details, delete items, and search by item name.</li>
            <li><b>New Order</b>: Create new orders for customers. Lookup or register customers, add items to cart, and complete orders.</li>
            <li><b>Cart</b>: Review and edit items in your cart, change quantities, view totals, and checkout to finalize orders.</li>
            <li><b>Order History</b>: View all past orders, search by customer name or phone, and delete order records.</li>
            <li><b>Help</b>: This page — a guide for using the system.</li>
        </ul>
    </div>
    <div class="section">
        <h2>Common Tasks</h2>
        <ul>
            <li>
                <b>Add a Customer:</b> Go to <code>Manage Customers</code>, enter the name and contact number, then click <b>Add Customer</b>.
            </li>
            <li>
                <b>Edit/Delete a Customer:</b> Use the <b>Edit</b> or <b>Delete</b> buttons beside each customer in the list.
            </li>
            <li>
                <b>Add an Item:</b> In <code>Manage Items</code>, fill in the item name, price per unit, and quantity, then click <b>Add Item</b>.
            </li>
            <li>
                <b>Start a New Order:</b> Go to <code>New Order</code>, enter a customer's mobile number. If the customer exists, their name is shown. Otherwise, register them.
            </li>
            <li>
                <b>Add Items to Cart:</b> After starting an order, enter quantity for each item and click <b>Add to Cart</b>. Click <b>View Cart</b> to review.
            </li>
            <li>
                <b>Checkout:</b> On the <code>Cart</code> page, adjust quantities as needed, then click <b>Checkout</b> to complete the order and print the bill.
            </li>
            <li>
                <b>View/Delete Order History:</b> Go to <code>Order History</code>, search by customer name/phone, and use the <b>Delete</b> button to remove records.
            </li>
        </ul>
    </div>
    <div class="section">
        <h2>Tips & Troubleshooting</h2>
        <div class="tip">
            <b>Searching:</b> Use the search boxes at the top of the pages to quickly filter customers, items, or orders.
        </div>
        <div class="tip">
            <b>Editing Quantities:</b> In cart or item lists, always ensure the new quantity does not exceed available stock.
        </div>
        <div class="tip">
            <b>Error Messages:</b> If you see an error (e.g. “Order failed!”), check your internet connection or ensure all required fields are filled correctly.
        </div>
        <div class="tip">
            <b>Data Safety:</b> Deleted customers, items, or orders cannot be recovered. Confirm before deletion.
        </div>
    </div>
    <div class="section">
        <h2>Contact & Support</h2>
        <p>
            For further help, contact the system administrator or refer to this guide. If you encounter persistent errors, please provide details of your issue and any error messages.
        </p>
    </div>
</div>
</body>
</html>