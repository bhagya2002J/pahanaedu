<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="true" %>
<!DOCTYPE html>
<html>
<head>
    <title>Manage Items</title>
    <style>
        body { font-family: Arial; background: #f9f9f9; }
        .container { width: 700px; margin: 40px auto; background: #fff; padding: 28px; box-shadow: 0 2px 8px #ccc; border-radius: 8px; }
        h2 { text-align: center; }
        form { margin-bottom: 20px; display: flex; gap: 12px; }
        input[type=text], input[type=number] { padding: 7px; border: 1px solid #ccc; border-radius: 4px; }
        button, input[type=submit] { background: #0077b6; color: #fff; border: none; border-radius: 4px; padding: 7px 16px; cursor: pointer; }
        button.edit { background: #f9a826; }
        button.delete { background: #d90429; }
        button:disabled { background: #ccc; }
        table { width: 100%; border-collapse: collapse; margin-top: 8px; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: center; }
        th { background: #e1eefa; }
        tr:nth-child(even) { background: #f0f8ff; }
        .search-box { margin-bottom: 15px; text-align: right; }
    </style>
</head>
<body>
<div class="container">
    <h2>Manage Items</h2>
    <form id="itemForm" onsubmit="return saveItem();">
        <input type="hidden" id="itemId" value="">
        <input type="text" id="itemName" placeholder="Item Name" required>
        <input type="number" step="0.01" min="0" id="itemPrice" placeholder="Price per unit" required>
        <input type="number" min="0" id="itemQuantity" placeholder="Quantity" required>
        <input type="submit" value="Add Item" id="addBtn">
        <button type="button" onclick="resetForm();" id="resetBtn" style="display:none;">Cancel Edit</button>
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

// Escape HTML to prevent XSS and rendering issues
function escapeHTML(str) {
    if (!str) return '';
    return str.replace(/&/g, "&amp;")
              .replace(/</g, "&lt;")
              .replace(/>/g, "&gt;")
              .replace(/"/g, "&quot;")
              .replace(/'/g, "&#039;");
}

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
                    <td>${i.price.toFixed(2)}</td>
                    <td>${i.quantity}</td>
                    <td>
                        <button class="edit" onclick="editItem(${i.id}, '${escapeHTML(i.name)}', ${i.price}, ${i.quantity})">Edit</button>
                        <button class="delete" onclick="deleteItem(${i.id})">Delete</button>
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