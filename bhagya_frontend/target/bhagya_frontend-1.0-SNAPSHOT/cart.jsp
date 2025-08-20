<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="true" %>
<!DOCTYPE html>
<html>
<head>
    <title>Cart - Pahana Edu</title>
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
            max-width: 900px;
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

        #customerInfo {
            background: #F1EFEC;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            border-left: 4px solid #123458;
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

        input[type=number] {
            padding: 8px 12px;
            border: 2px solid #D4C9BE;
            border-radius: 8px;
            width: 80px;
        }

        input[type=number]:focus {
            border-color: #123458;
            outline: none;
            box-shadow: 0 0 0 3px rgba(18, 52, 88, 0.1);
        }

        .btn {
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

        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(18, 52, 88, 0.2);
        }

        .btn-danger {
            background: #D4C9BE;
            color: #123458;
        }

        #cartTotal {
            color: #123458;
            margin: 20px 0;
            font-size: 20px;
        }

        #bill {
            margin-top: 30px;
            background: #F1EFEC;
            padding: 24px;
            border-radius: 12px;
            border-left: 4px solid #123458;
        }

        #bill table {
            margin: 15px 0;
        }

        #bill h3 {
            color: #123458;
            margin-bottom: 15px;
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
        }
    </style>
</head>
<body>
    <header class="header">
        <a href="main.jsp" class="logo">Pahana Edu</a>
        
    </header>

    <div class="container">
        <h2>Shopping Cart</h2>
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
        <button class="btn" onclick="checkout()">
            <i class="fas fa-shopping-cart"></i> Checkout
        </button>
        <div id="bill" style="display:none;"></div>
    </div>

<!-- Keep your existing JavaScript code exactly as is -->
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
            `<i class="fas fa-user"></i> <b>Customer:</b> ${escapeHTML(customer.name)} <b>Mobile:</b> ${escapeHTML(customer.contact)}`;
    }
    let rows = '';
    let total = 0;
    cart.forEach((i, idx) => {
        const subtotal = i.price * i.quantity;
        total += subtotal;
        rows += `<tr>
            <td>${escapeHTML(i.name)}</td>
            <td>Rs. ${i.price.toFixed(2)}</td>
            <td>
                <input type="number" min="1" max="${i.availableQty}" value="${i.quantity}" onchange="updateQty(${idx}, this.value)">
            </td>
            <td>Rs. ${subtotal.toFixed(2)}</td>
            <td>
                <button class="btn btn-danger" onclick="removeFromCart(${idx})">
                    <i class="fas fa-trash"></i> Remove
                </button>
            </td>
        </tr>`;
    });
    document.getElementById('cartTable').innerHTML = rows || 
        `<tr><td colspan='5' style="text-align: center; padding: 20px;">Cart is empty</td></tr>`;
    document.getElementById('cartTotal').innerText = "Total Amount: Rs. " + total.toFixed(2);
}

// Keep all other functions exactly as they are
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
    let html = `<h3><i class="fas fa-receipt"></i> Order Bill</h3>
        <b>Customer Name:</b> ${escapeHTML(order.customer.name)}<br>
        <b>Mobile:</b> ${escapeHTML(order.customer.contact)}<br>
        <table style="width:100%;margin-top:12px;">
            <tr>
                <th>Item Name</th>
                <th>Price</th>
                <th>Quantity</th>
                <th>Subtotal</th>
            </tr>`;
    let total = 0;
    order.items.forEach(i => {
        let subtotal = i.price * i.quantity;
        total += subtotal;
        html += `<tr>
            <td>${escapeHTML(i.name)}</td>
            <td>Rs. ${i.price.toFixed(2)}</td>
            <td>${i.quantity}</td>
            <td>Rs. ${subtotal.toFixed(2)}</td>
        </tr>`;
    });
    html += `</table>
        <h3>Total Amount: Rs. ${total.toFixed(2)}</h3>`;
    document.getElementById('bill').innerHTML = html;
    document.getElementById('bill').style.display = "";
}

renderCart();
</script>
</body>
</html>