<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="true" %>
<!DOCTYPE html>
<html>
<head>
    <title>Manage Items - Pahana Edu</title>
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

        form {
            margin-bottom: 20px;
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
        }

        input[type=text], 
        input[type=number] {
            padding: 12px 15px;
            border: 2px solid #D4C9BE;
            border-radius: 8px;
            font-size: 16px;
            transition: all 0.3s;
            flex: 1;
            min-width: 120px;
        }

        input[type=text]:focus,
        input[type=number]:focus {
            border-color: #123458;
            outline: none;
            box-shadow: 0 0 0 3px rgba(18, 52, 88, 0.1);
        }

        button, input[type=submit] {
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

        button:hover, input[type=submit]:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(18, 52, 88, 0.2);
        }

        button.edit {
            background: #D4C9BE;
            color: #123458;
        }

        button.delete {
            background: #D4C9BE;
            color: #123458;
        }

        button:disabled {
            background: #D4C9BE;
            cursor: not-allowed;
            transform: none;
        }

        .search-box {
            margin-bottom: 20px;
            text-align: right;
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

        @media (max-width: 768px) {
            .container {
                width: 95%;
                padding: 1rem;
            }

            form {
                flex-direction: column;
            }

            button, input[type=submit] {
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
        <h2>Manage Items</h2>
        <form id="itemForm" onsubmit="return saveItem();">
            <input type="hidden" id="itemId" value="">
            <input type="text" id="itemName" placeholder="Item Name" required>
            <input type="number" step="0.01" min="0" id="itemPrice" placeholder="Price per unit" required>
            <input type="number" min="0" id="itemQuantity" placeholder="Quantity" required>
            <input type="submit" value="Add Item" id="addBtn">
            <button type="button" onclick="resetForm();" id="resetBtn" style="display:none;">
                <i class="fas fa-times"></i> Cancel Edit
            </button>
        </form>
        
        <div class="search-box">
            <input type="text" id="search" placeholder="Search by item name..." oninput="loadItems();">
        </div>
        
        <table>
            <thead>
                <tr>
                    <th>Name</th>
                    <th>Price per Unit</th>
                    <th>Quantity</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody id="itemTable"></tbody>
        </table>
    </div>

<script>
const API_URL = "http://localhost:8080/bhagya_backend/resources/items";

function escapeHTML(str) {
    if (!str) return '';
    return str.replace(/&/g, "&amp;")
              .replace(/</g, "&lt;")
              .replace(/>/g, "&gt;")
              .replace(/"/g, "&quot;")
              .replace(/'/g, "&#039;");
}

// Updated loadItems function with icons
function loadItems() {
    const search = document.getElementById('search').value;
    let url = API_URL;
    if (search) url += "?search=" + encodeURIComponent(search);
    fetch(url)
        .then(r => {
            if (!r.ok) throw new Error('Network response was not ok');
            return r.json();
        })
        .then(data => {
            let rows = '';
            data.forEach(i => {
                rows += `<tr>
                    <td>${escapeHTML(i.name)}</td>
                    <td>Rs. ${i.price.toFixed(2)}</td>
                    <td>${i.quantity}</td>
                    <td>
                        <button class="edit" onclick="editItem(${i.id}, '${escapeHTML(i.name)}', ${i.price}, ${i.quantity})">
                            <i class="fas fa-edit"></i> Edit
                        </button>
                        <button class="delete" onclick="deleteItem(${i.id})">
                            <i class="fas fa-trash"></i> Delete
                        </button>
                    </td>
                </tr>`;
            });
            document.getElementById('itemTable').innerHTML = rows;
        })
        .catch(e => {
            document.getElementById('itemTable').innerHTML =
                `<tr><td colspan="4">Could not load data: ${e}</td></tr>`;
        });
}

// Keep all other JavaScript functions as they are
function saveItem() {
    const id = document.getElementById('itemId').value;
    const name = document.getElementById('itemName').value;
    const price = parseFloat(document.getElementById('itemPrice').value);
    const quantity = parseInt(document.getElementById('itemQuantity').value);
    const body = JSON.stringify({ name, price, quantity });
    let method = id ? 'PUT' : 'POST';
    let url = API_URL + (id ? '/' + id : '');
    fetch(url, {
        method: method,
        headers: { 'Content-Type': 'application/json' },
        body: body
    })
    .then(r => r.ok ? r.json() : Promise.reject())
    .then(() => {
        resetForm();
        loadItems();
    });
    return false;
}

function deleteItem(id) {
    if (confirm("Delete this item?")) {
        fetch(API_URL + '/' + id, { method:'DELETE' })
        .then(() => loadItems());
    }
}

function editItem(id, name, price, quantity) {
    document.getElementById('itemId').value = id;
    document.getElementById('itemName').value = name;
    document.getElementById('itemPrice').value = price;
    document.getElementById('itemQuantity').value = quantity;
    document.getElementById('addBtn').value = "Update Item";
    document.getElementById('resetBtn').style.display = "";
}

function resetForm() {
    document.getElementById('itemId').value = "";
    document.getElementById('itemName').value = "";
    document.getElementById('itemPrice').value = "";
    document.getElementById('itemQuantity').value = "";
    document.getElementById('addBtn').value = "Add Item";
    document.getElementById('resetBtn').style.display = "none";
}

window.onload = loadItems;
</script>
</body>
</html>