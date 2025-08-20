<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="true" %>
<!DOCTYPE html>
<html>
<head>
    <title>Order History - Pahana Edu</title>
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

        .container {
            width: 90%;
            max-width: 1200px;
            margin: 100px auto 40px;
            background: #fff;
            padding: 2rem;
            box-shadow: 0 4px 20px rgba(3, 3, 3, 0.08);
            border-radius: 15px;
        }

        h2 {
            color: #123458;
            text-align: center;
            margin-bottom: 30px;
            font-size: 28px;
        }

        .search-box {
            margin-bottom: 20px;
            text-align: right;
        }

        input[type=text] {
            padding: 12px 15px;
            border: 2px solid #D4C9BE;
            border-radius: 8px;
            font-size: 16px;
            transition: all 0.3s;
            width: 300px;
            max-width: 100%;
        }

        input[type=text]:focus {
            border-color: #123458;
            outline: none;
            box-shadow: 0 0 0 3px rgba(18, 52, 88, 0.1);
        }

        button {
            background: #123458;
            color: #F1EFEC;
            border: none;
            border-radius: 8px;
            padding: 12px 24px;
            cursor: pointer;
            font-weight: 600;
            transition: all 0.3s;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        button:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(18, 52, 88, 0.2);
        }

        button.delete {
            background: #D4C9BE;
            color: #123458;
            padding: 8px 16px;
        }

        table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            margin-top: 20px;
            border-radius: 10px;
            overflow: hidden;
        }

        th, td {
            padding: 15px;
            text-align: left;
            border-bottom: 1px solid #D4C9BE;
        }

        th {
            background: #123458;
            color: #F1EFEC;
            font-weight: 600;
        }

        tr:nth-child(even) {
            background: rgba(212, 201, 190, 0.1);
        }

        tr:hover {
            background: rgba(18, 52, 88, 0.05);
        }

        .items-list {
            font-size: 0.95em;
            color: #030303;
            line-height: 1.6;
        }

        .total-amount {
            font-weight: bold;
            color: #123458;
        }

        @media (max-width: 768px) {
            .container {
                width: 95%;
                padding: 1rem;
            }

            table {
                display: block;
                overflow-x: auto;
                white-space: nowrap;
            }

            .search-box input[type=text] {
                width: 100%;
            }
        }
    </style>
</head>
<body>
    <header class="header">
        <a href="main.jsp" class="logo">Pahana Edu</a>
    </header>

    <div class="container">
        <h2>Order History</h2>
        <div class="search-box">
            <input type="text" id="search" placeholder="Search by customer name or phone..." oninput="loadHistory();">
        </div>
        <table>
            <thead>
                <tr>
                    <th>Order ID</th>
                    <th>Customer</th>
                    <th>Contact</th>
                    <th>Items</th>
                    <th>Total</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody id="historyTable"></tbody>
        </table>
    </div>

<script>
const API_URL = "http://localhost:8080/bhagya_backend/resources/orderhistory";

function escapeHTML(str) {
    if (!str) return '';
    return str.replace(/&/g, "&amp;")
              .replace(/</g, "&lt;")
              .replace(/>/g, "&gt;")
              .replace(/"/g, "&quot;")
              .replace(/'/g, "&#039;");
}

function loadHistory() {
    const search = document.getElementById('search').value;
    let url = API_URL;
    if (search) url += "?search=" + encodeURIComponent(search);
    fetch(url)
        .then(r => r.ok ? r.json() : [])
        .then(data => {
            let rows = '';
            data.forEach(order => {
                let itemsText = '';
                let total = 0;
                order.items.forEach(item => {
                    const subtotal = item.price * item.quantity;
                    total += subtotal;
                    itemsText += `<div>${escapeHTML(item.name)} <span style="color: #123458;">×${item.quantity}</span> (Rs.${item.price.toFixed(2)} each)</div>`;
                });
                rows += `<tr>
                    <td>#${order.id}</td>
                    <td>${escapeHTML(order.customer.name)}</td>
                    <td>${escapeHTML(order.customer.contact)}</td>
                    <td class="items-list">${itemsText}</td>
                    <td class="total-amount">Rs.${total.toFixed(2)}</td>
                    <td>
                        <button class="delete" onclick="deleteOrder(${order.id})">
                            <i class="fas fa-trash"></i> Delete
                        </button>
                    </td>
                </tr>`;
            });
            document.getElementById('historyTable').innerHTML = rows || 
                `<tr><td colspan="6" style="text-align: center; padding: 20px;">No orders found</td></tr>`;
        });
}

function deleteOrder(orderId) {
    if (!confirm("Are you sure you want to delete this order?")) return;
    fetch(`${API_URL}/${orderId}`, { method: 'DELETE' })
        .then(r => r.ok ? loadHistory() : alert("Failed to delete the order!"));
}

window.onload = loadHistory;
</script>
</body>
</html>