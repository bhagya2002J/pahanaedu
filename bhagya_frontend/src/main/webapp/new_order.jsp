<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="true" %>
<!DOCTYPE html>
<html>
<head>
    <title>New Order - Pahana Edu</title>
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

        .input-row {
            margin-bottom: 20px;
            display: flex;
            gap: 15px;
            align-items: center;
        }

        input[type=text], 
        input[type=number] {
            padding: 12px 15px;
            border: 2px solid #D4C9BE;
            border-radius: 8px;
            font-size: 16px;
            transition: all 0.3s;
            flex: 1;
        }

        input[type=text]:focus, 
        input[type=number]:focus {
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

        button:disabled {
            background: #D4C9BE;
            cursor: not-allowed;
            transform: none;
        }

        .cart-btn {
            background: #D4C9BE;
            color: #123458;
        }

        .cart-btn:hover {
            background: #123458;
            color: #F1EFEC;
        }

        .search-box {
            margin-bottom: 20px;
            display: flex;
            gap: 15px;
            justify-content: flex-end;
            align-items: center;
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

        #cartModal {
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            background: white;
            padding: 2rem;
            border-radius: 15px;
            box-shadow: 0 5px 30px rgba(3, 3, 3, 0.2);
            max-width: 90%;
            width: 800px;
            max-height: 90vh;
            overflow-y: auto;
            z-index: 1001;
        }

        .modal-backdrop {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(3, 3, 3, 0.5);
            display: none;
            z-index: 1000;
        }

        .modal-backdrop.show {
            display: block;
        }

        #customerInfo {
            background: #F1EFEC;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            border-left: 4px solid #123458;
        }

        .hidden {
            display: none;
        }

        @media (max-width: 768px) {
            .container {
                width: 95%;
                padding: 1rem;
            }

            .input-row {
                flex-direction: column;
            }

            button {
                width: 100%;
            }

            .search-box {
                flex-direction: column;
            }
        }
    </style>
</head>
<body>
    <header class="header">
        <a href="main.jsp" class="logo">Pahana Edu</a>
       
    </header>

    <div class="container">
        <h2>New Order</h2>
        
        <div id="step1">
            <div class="input-row">
                <input type="text" id="customerContact" placeholder="Enter customer mobile number" required>
                <button onclick="lookupCustomer()">
                    <i class="fas fa-search"></i> Check Customer
                </button>
            </div>
            <div id="customerResult"></div>
        </div>

        <div id="step2" class="hidden">
            <div id="customerInfo"></div>
            <button onclick="showItems()">
                <i class="fas fa-shopping-cart"></i> Start Order
            </button>
        </div>

        <div id="step3" class="hidden">
            <div class="search-box">
                <input type="text" id="itemSearch" placeholder="Search items by name..." oninput="loadItems();">
                <button class="cart-btn" onclick="viewCart()">
                    <i class="fas fa-shopping-cart"></i> View Cart (<span id="cartCount">0</span>)
                </button>
            </div>
            <table>
                <thead>
                    <tr>
                        <th>Name</th>
                        <th>Price per Unit</th>
                        <th>Available Quantity</th>
                        <th>Order Quantity</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody id="itemTable"></tbody>
            </table>
        </div>

        <div id="cartModal" class="hidden">
            <h3 style="margin-bottom: 20px; color: #123458;">Shopping Cart</h3>
            <table>
                <thead>
                    <tr>
                        <th>Item Name</th>
                        <th>Price</th>
                        <th>Quantity</th>
                        <th>Subtotal</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody id="cartTable"></tbody>
            </table>
            <div id="cartTotal" style="margin: 20px 0; font-weight: bold; color: #123458;"></div>
            <div class="input-row" style="justify-content: flex-end;">
                <button onclick="completeOrder()">
                    <i class="fas fa-check-circle"></i> Complete Order
                </button>
                <button style="background: #D4C9BE;" onclick="closeCart()">
                    <i class="fas fa-times"></i> Close Cart
                </button>
            </div>
        </div>
    </div>

    <div class="modal-backdrop" id="modalBackdrop" onclick="closeCart()"></div>

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
        `<i class="fas fa-user"></i> Customer: <b>${escapeHTML(currentCustomer.name)}</b> (<b>${escapeHTML(currentCustomer.contact)}</b>)`;
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
                    <td>Rs. ${item.price.toFixed(2)}</td>
                    <td>${item.quantity}</td>
                    <td>
                        <input type="number" min="1" max="${item.quantity}" 
                               id="qty_${item.id}" style="width: 80px;">
                    </td>
                    <td>
                        <button onclick="addToCart(${item.id}, '${escapeHTML(item.name)}', ${item.price}, ${item.quantity})">
                            <i class="fas fa-plus"></i> Add
                        </button>
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