<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="true" %>
<!DOCTYPE html>
<html>
<head>
    <title>New Order</title>
    <style>
        body { font-family: Arial; background: #f9f9f9; }
        .container { width: 700px; margin: 40px auto; background: #fff; padding: 28px; box-shadow: 0 2px 8px #ccc; border-radius: 8px; }
        h2 { text-align: center; }
        .input-row { margin-bottom: 15px; display: flex; gap: 10px; }
        input[type=text], input[type=number] { padding: 7px; border: 1px solid #ccc; border-radius: 4px; }
        button { background: #0077b6; color: #fff; border: none; border-radius: 4px; padding: 7px 16px; cursor: pointer; }
        button:disabled { background: #ccc; }
        table { width: 100%; border-collapse: collapse; margin-top: 8px; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: center; }
        th { background: #e1eefa; }
        tr:nth-child(even) { background: #f0f8ff; }
        .cart-btn { background: #f9a826; }
        .search-box { margin-bottom: 10px; text-align: right; }
        .hidden { display: none; }
    </style>
</head>
<body>
<div class="container">
    <h2>New Order</h2>
    <div id="step1">
        <div class="input-row">
            <input type="text" id="customerContact" placeholder="Enter customer mobile number" required>
            <button onclick="lookupCustomer()">Check Customer</button>
        </div>
        <div id="customerResult"></div>
    </div>
    <div id="step2" class="hidden">
        <div id="customerInfo"></div>
        <button onclick="showItems()">Start Order</button>
    </div>
    <div id="step3" class="hidden">
        <div class="search-box">
            <input type="text" id="itemSearch" placeholder="Search items by name..." oninput="loadItems();">
            <button class="cart-btn" onclick="viewCart()">View Cart (<span id="cartCount">0</span>)</button>
        </div>
        <table>
            <thead>
                <tr>
                    <th>Name</th>
                    <th>Price per Unit</th>
                    <th>Available Quantity</th>
                    <th>Order Quantity</th>
                    <th>Add to Cart</th>
                </tr>
            </thead>
            <tbody id="itemTable"></tbody>
        </table>
    </div>
    <div id="cartModal" class="hidden">
        <h3>Cart</h3>
        <table>
            <thead>
                <tr>
                    <th>Item Name</th>
                    <th>Price</th>
                    <th>Quantity</th>
                    <th>Subtotal</th>
                    <th>Remove</th>
                </tr>
            </thead>
            <tbody id="cartTable"></tbody>
        </table>
        <div id="cartTotal"></div>
        <button onclick="completeOrder()">Complete Order</button>
        <button onclick="closeCart()">Close Cart</button>
    </div>
</div>
<script>
const API_BASE = "http://localhost:8080/bhagya_backend/resources/orders";
let currentCustomer = null;
let cart = [];

function escapeHTML(str) {
    if (!str) return '';
    return str.replace(/&/g, "&amp;")
              .replace(/</g, "&lt;")
              .replace(/>/g, "&gt;")
              .replace(/"/g, "&quot;")
              .replace(/'/g, "&#039;");
}

// Step 1: Lookup customer or register new
function lookupCustomer() {
    const contact = document.getElementById('customerContact').value.trim();
    if (!contact) return alert("Enter customer mobile number!");
    fetch(`${API_BASE}/lookupCustomer?contact=${encodeURIComponent(contact)}`)
        .then(r => r.ok ? r.json() : null)
        .then(data => {
            if (data && data.name) {
                currentCustomer = data;
                document.getElementById('customerResult').innerHTML =
                    `Customer found: <b>${escapeHTML(data.name)}</b>`;
                showStep2();
            } else {
                document.getElementById('customerResult').innerHTML =
                    `Customer not found.<br>
                    <input type="text" id="customerName" placeholder="Enter customer name to register">
                    <button onclick="registerCustomer('${contact}')">Register Customer</button>`;
            }
        });
}

function registerCustomer(contact) {
    const name = document.getElementById('customerName').value.trim();
    if (!name) return alert("Enter customer name!");
    fetch(`${API_BASE}/registerCustomer`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ name, contact })
    })
    .then(r => r.ok ? r.json() : Promise.reject())
    .then(data => {
        currentCustomer = data;
        document.getElementById('customerResult').innerHTML =
            `Customer registered: <b>${escapeHTML(data.name)}</b>`;
        showStep2();
    });
}

function showStep2() {
    document.getElementById('step1').classList.add('hidden');
    document.getElementById('step2').classList.remove('hidden');
    document.getElementById('customerInfo').innerHTML =
        `Customer: <b>${escapeHTML(currentCustomer.name)}</b> (<b>${escapeHTML(currentCustomer.contact)}</b>)`;
}

function showItems() {
    document.getElementById('step2').classList.add('hidden');
    document.getElementById('step3').classList.remove('hidden');
    loadItems();
}

function loadItems() {
    const search = document.getElementById('itemSearch').value;
    let url = `${API_BASE}/listItems`;
    if (search) url += `?search=${encodeURIComponent(search)}`;
    fetch(url)
        .then(r => r.ok ? r.json() : [])
        .then(data => {
            let rows = '';
            data.forEach(item => {
                rows += `<tr>
                    <td>${escapeHTML(item.name)}</td>
                    <td>${item.price.toFixed(2)}</td>
                    <td>${item.quantity}</td>
                    <td>
                        <input type="number" min="1" max="${item.quantity}" id="qty_${item.id}" style="width:55px;">
                    </td>
                    <td>
                        <button onclick="addToCart(${item.id}, '${escapeHTML(item.name)}', ${item.price}, ${item.quantity})">Add to Cart</button>
                    </td>
                </tr>`;
            });
            document.getElementById('itemTable').innerHTML = rows;
        });
}

function addToCart(id, name, price, availableQty) {
    const qtyInput = document.getElementById('qty_' + id);
    const qty = parseInt(qtyInput.value);
    if (!qty || qty < 1 || qty > availableQty) {
        return alert("Enter a valid quantity (max: " + availableQty + ")");
    }
    // Check if already in cart
    const idx = cart.findIndex(i => i.id === id);
    if (idx >= 0) {
        if (cart[idx].quantity + qty > availableQty) {
            return alert("Total quantity exceeds available stock.");
        }
        cart[idx].quantity += qty;
    } else {
        cart.push({ id, name, price, quantity: qty, availableQty });
    }
    qtyInput.value = "";
    updateCartCount();
}

function updateCartCount() {
    document.getElementById('cartCount').innerText = cart.reduce((sum, i) => sum + i.quantity, 0);
}

function viewCart() {
    localStorage.setItem('cart', JSON.stringify(cart));
    localStorage.setItem('customer', JSON.stringify(currentCustomer));
    window.location.href = "cart.jsp";
}

function removeFromCart(idx) {
    cart.splice(idx, 1);
    viewCart();
    updateCartCount();
}

function closeCart() {
    document.getElementById('cartModal').classList.add('hidden');
}

function completeOrder() {
    if (cart.length === 0) return alert("Cart is empty!");
    // Here you would send the order to backend, register customer if not exists, etc.
    // For demo, just alert
    alert("Order completed! Thank you.");
    cart = [];
    updateCartCount();
    closeCart();
    document.getElementById('step1').classList.remove('hidden');
    document.getElementById('step2').classList.add('hidden');
    document.getElementById('step3').classList.add('hidden');
    document.getElementById('customerContact').value = "";
    document.getElementById('customerResult').innerHTML = "";
}
</script>
</body>
</html>