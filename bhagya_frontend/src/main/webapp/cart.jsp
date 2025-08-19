<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="true" %>
<!DOCTYPE html>
<html>
<head>
    <title>Cart</title>
    <style>
        body { font-family: Arial; background: #f9f9f9; }
        .container { width: 700px; margin: 40px auto; background: #fff; padding: 28px; box-shadow: 0 2px 8px #ccc; border-radius: 8px; }
        h2 { text-align: center; }
        table { width: 100%; border-collapse: collapse; margin-top: 8px; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: center; }
        th { background: #e1eefa; }
        tr:nth-child(even) { background: #f0f8ff; }
        .btn { background: #0077b6; color: #fff; border: none; border-radius: 4px; padding: 7px 16px; cursor: pointer; }
        .btn-danger { background: #d90429; }
        #bill { margin-top: 30px; background: #f0f0f0; padding: 18px; border-radius: 8px; }
    </style>
</head>
<body>
<div class="container">
    <h2>Cart</h2>
    <div id="customerInfo"></div>
    <table>
        <thead>
            <tr>
                <th>Item Name</th>
                <th>Price per Unit</th>
                <th>Quantity</th>
                <th>Subtotal</th>
                <th>Action</th>
            </tr>
        </thead>
        <tbody id="cartTable"></tbody>
    </table>
    <h3 id="cartTotal"></h3>
    <button class="btn" onclick="checkout()">Checkout</button>
    <div id="bill" style="display:none;"></div>
</div>
<script>
const API_ORDER = "http://localhost:8080/bhagya_backend/resources/orders/submit";
let cart = JSON.parse(localStorage.getItem('cart') || "[]");
let customer = JSON.parse(localStorage.getItem('customer') || "null");

function escapeHTML(str) {
    if (!str) return '';
    return str.replace(/&/g, "&amp;")
              .replace(/</g, "&lt;")
              .replace(/>/g, "&gt;")
              .replace(/"/g, "&quot;")
              .replace(/'/g, "&#039;");
}

function renderCart() {
    if (customer) {
        document.getElementById('customerInfo').innerHTML =
            `<b>Customer:</b> ${escapeHTML(customer.name)} <b>Mobile:</b> ${escapeHTML(customer.contact)}`;
    }
    let rows = '';
    let total = 0;
    cart.forEach((i, idx) => {
        const subtotal = i.price * i.quantity;
        total += subtotal;
        rows += `<tr>
            <td>${escapeHTML(i.name)}</td>
            <td>${i.price.toFixed(2)}</td>
            <td>
                <input type="number" min="1" max="${i.availableQty}" value="${i.quantity}" onchange="updateQty(${idx}, this.value)">
            </td>
            <td>${subtotal.toFixed(2)}</td>
            <td>
                <button class="btn btn-danger" onclick="removeFromCart(${idx})">Remove</button>
            </td>
        </tr>`;
    });
    document.getElementById('cartTable').innerHTML = rows || "<tr><td colspan='5'>Cart is empty</td></tr>";
    document.getElementById('cartTotal').innerText = "Total: Rs. " + total.toFixed(2);
}

function updateQty(idx, val) {
    val = parseInt(val);
    if (val < 1 || val > cart[idx].availableQty) {
        alert("Invalid quantity!");
        renderCart();
        return;
    }
    cart[idx].quantity = val;
    localStorage.setItem('cart', JSON.stringify(cart));
    renderCart();
}

function removeFromCart(idx) {
    cart.splice(idx, 1);
    localStorage.setItem('cart', JSON.stringify(cart));
    renderCart();
}

function checkout() {
    if (cart.length === 0) return alert("Cart is empty!");
    if (!customer) return alert("Customer info missing!");
    fetch(API_ORDER, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ customer, cart })
    })
    .then(r => r.ok ? r.json() : Promise.reject())
    .then(data => {
        printBill(data);
        localStorage.removeItem('cart');
    })
    .catch(() => alert("Order failed!"));
}

function printBill(order) {
    let html = `<h3>Order Bill</h3>
        <b>Customer Name:</b> ${escapeHTML(order.customer.name)}<br>
        <b>Mobile:</b> ${escapeHTML(order.customer.contact)}<br>
        <table style="width:100%;margin-top:12px;">
            <tr>
                <th>Item Name</th><th>Price</th><th>Quantity</th><th>Subtotal</th>
            </tr>`;
    let total = 0;
    order.items.forEach(i => {
        let subtotal = i.price * i.quantity;
        total += subtotal;
        html += `<tr>
            <td>${escapeHTML(i.name)}</td>
            <td>${i.price.toFixed(2)}</td>
            <td>${i.quantity}</td>
            <td>${subtotal.toFixed(2)}</td>
        </tr>`;
    });
    html += `</table>
        <h3>Total: Rs. ${total.toFixed(2)}</h3>
       `;
    document.getElementById('bill').innerHTML = html;
    document.getElementById('bill').style.display = "";
}

renderCart();
</script>
</body>
</html>