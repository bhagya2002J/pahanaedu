<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="true" %>
<!DOCTYPE html>
<html>
<head>
    <title>System Help - Pahana Edu</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Arial, sans-serif;
            background: #F1EFEC;
            min-height: 100vh;
        }

        .header {
            background: #123458;
            padding: 1rem 2rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 10px rgba(3, 3, 3, 0.1);
            position: fixed;
            width: 100%;
            top: 0;
            z-index: 1000;
        }

        .logo {
            color: #F1EFEC;
            font-size: 24px;
            font-weight: bold;
            text-decoration: none;
            transition: opacity 0.3s;
        }

        .logo:hover {
            opacity: 0.9;
        }

        .user-info {
            color: #F1EFEC;
            font-size: 14px;
            text-align: right;
        }

        .container {
            width: 90%;
            max-width: 1000px;
            margin: 100px auto 40px;
            background: #fff;
            padding: 2rem;
            box-shadow: 0 4px 20px rgba(3, 3, 3, 0.08);
            border-radius: 15px;
        }

        h1 {
            color: #123458;
            text-align: center;
            margin-bottom: 30px;
            font-size: 32px;
        }

        h2 {
            color: #123458;
            margin-top: 32px;
            font-size: 24px;
            border-bottom: 2px solid #D4C9BE;
            padding-bottom: 8px;
            margin-bottom: 16px;
        }

        .section {
            margin-bottom: 32px;
        }

        ul {
            margin: 0 0 20px 22px;
            list-style-type: none;
        }

        li {
            margin-bottom: 12px;
            position: relative;
            padding-left: 24px;
        }

        li:before {
            content: "•";
            color: #123458;
            font-size: 20px;
            position: absolute;
            left: 0;
            top: -2px;
        }

        .tip {
            background: #F1EFEC;
            padding: 16px;
            border-radius: 8px;
            margin: 12px 0;
            border-left: 4px solid #123458;
        }

        .tip b {
            color: #123458;
            display: block;
            margin-bottom: 6px;
        }

        code {
            background: rgba(18, 52, 88, 0.1);
            padding: 3px 8px;
            border-radius: 4px;
            color: #123458;
            font-family: monospace;
            font-size: 0.95em;
        }

        p {
            line-height: 1.6;
            margin-bottom: 16px;
            color: #030303;
        }

        @media (max-width: 768px) {
            .container {
                width: 95%;
                padding: 1.5rem;
            }

            h1 {
                font-size: 28px;
            }

            h2 {
                font-size: 22px;
            }
        }
    </style>
</head>
<body>
    <header class="header">
        <a href="main.jsp" class="logo">Pahana Edu</a>
        
    </header>

    <div class="container">
        <h1><i class="fas fa-question-circle"></i> Help & User Guide</h1>
        
        <div class="section">
            <h2><i class="fas fa-info-circle"></i> Introduction</h2>
            <p>
                Welcome to the Pahana Edu Billing System! This system lets you manage customers, items, orders, and view your order history. Below you'll find guidance for each page and common tasks.
            </p>
        </div>

        <div class="section">
            <h2><i class="fas fa-list-alt"></i> Pages & Features</h2>
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
            <h2><i class="fas fa-tasks"></i> Common Tasks</h2>
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
            <h2><i class="fas fa-lightbulb"></i> Tips & Troubleshooting</h2>
            <div class="tip">
                <b><i class="fas fa-search"></i> Searching</b>
                Use the search boxes at the top of the pages to quickly filter customers, items, or orders.
            </div>
            <div class="tip">
                <b><i class="fas fa-edit"></i> Editing Quantities</b>
                In cart or item lists, always ensure the new quantity does not exceed available stock.
            </div>
            <div class="tip">
                <b><i class="fas fa-exclamation-triangle"></i> Error Messages</b>
                If you see an error (e.g. "Order failed!"), check your internet connection or ensure all required fields are filled correctly.
            </div>
            <div class="tip">
                <b><i class="fas fa-shield-alt"></i> Data Safety</b>
                Deleted customers, items, or orders cannot be recovered. Confirm before deletion.
            </div>
        </div>

        <div class="section">
            <h2><i class="fas fa-headset"></i> Contact & Support</h2>
            <p>
                For further help, contact the system administrator or refer to this guide. If you encounter persistent errors, please provide details of your issue and any error messages.
            </p>
        </div>
    </div>
</body>
</html>