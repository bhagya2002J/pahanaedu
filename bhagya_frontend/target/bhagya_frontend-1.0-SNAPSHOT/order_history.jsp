<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="true" %>
<!DOCTYPE html>
<html>
<head>
    <title>Order History</title>
    <style>
        body { font-family: Arial; background: #f9f9f9; }
        .container { width: 900px; margin: 40px auto; background: #fff; padding: 28px; box-shadow: 0 2px 8px #ccc; border-radius: 8px; }
        h2 { text-align: center; }
        .search-box { margin-bottom: 20px; text-align: right; }
        input[type=text] { padding: 7px; border: 1px solid #ccc; border-radius: 4px; }
        button { background: #0077b6; color: #fff; border: none; border-radius: 4px; padding: 7px 16px; cursor: pointer; }
        button.delete { background: #d90429; }
        table { width: 100%; border-collapse: collapse; margin-top: 8px; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: center; }
        th { background: #e1eefa; }
        tr:nth-child(even) { background: #f0f8ff; }
        .items-list { font-size: 0.95em; color: #444; }
    </style>
</head>
<body>
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
                <th>Delete</th>
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
                    itemsText += `${escapeHTML(item.name)} (x${item.quantity}, Rs.${item.price.toFixed(2)} each)<br>`;
                });
                rows += `<tr>
                    <td>${order.id}</td>
                 
                    <td>${escapeHTML(order.customer.name)}</td>
                    <td>${escapeHTML(order.customer.contact)}</td>
                    <td class="items-list">${itemsText}</td>
                    <td><b>Rs.${total.toFixed(2)}</b></td>
                    <td>
                        <button class="delete" onclick="deleteOrder(${order.id})">Delete</button>
                    </td>
                </tr>`;
            });
            document.getElementById('historyTable').innerHTML = rows || "<tr><td colspan='7'>No orders found</td></tr>";
        });
}

function deleteOrder(orderId) {
    if (!confirm("Delete this order?")) return;
    fetch(`${API_URL}/${orderId}`, { method: 'DELETE' })
        .then(r => r.ok ? loadHistory() : alert("Delete failed!"));
}

window.onload = loadHistory;
</script>
</body>
</html>