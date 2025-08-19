<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="true" %>
<!DOCTYPE html>
<html>
<head>
    <title>Manage Customers</title>
    <style>
        body { font-family: Arial; background: #f9f9f9; }
        .container { width: 600px; margin: 40px auto; background: #fff; padding: 28px; box-shadow: 0 2px 8px #ccc; border-radius: 8px; }
        h2 { text-align: center; }
        form { margin-bottom: 20px; display: flex; gap: 12px; }
        input[type=text] { padding: 7px; border: 1px solid #ccc; border-radius: 4px; }
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
    <h2>Manage Customers</h2>
    <form id="customerForm" onsubmit="return saveCustomer();">
        <input type="hidden" id="customerId" value="">
        <input type="text" id="name" placeholder="Customer Name" required>
        <input type="text" id="contact" placeholder="Contact Number" required>
        <input type="submit" value="Add Customer" id="addBtn">
        <button type="button" onclick="resetForm();" id="resetBtn" style="display:none;">Cancel Edit</button>
    </form>
    <div class="search-box">
        <input type="text" id="search" placeholder="Search by name or contact..." oninput="loadCustomers();">
    </div>
    <table>
        <thead>
            <tr>
                <th>Name</th>
                <th>Contact</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody id="customerTable"></tbody>
    </table>
</div>
<script>
const API_URL = "http://localhost:8080/bhagya_backend/resources/customers";

// Escape HTML to prevent XSS and rendering issues
function escapeHTML(str) {
    if (!str) return '';
    return str.replace(/&/g, "&amp;")
              .replace(/</g, "&lt;")
              .replace(/>/g, "&gt;")
              .replace(/"/g, "&quot;")
              .replace(/'/g, "&#039;");
}

function loadCustomers() {
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
            data.forEach(c => {
                rows += `<tr>
                    <td>${escapeHTML(c.name)}</td>
                    <td>${escapeHTML(c.contact)}</td>
                    <td>
                        <button class="edit" onclick="editCustomer(${c.id}, '${escapeHTML(c.name)}', '${escapeHTML(c.contact)}')">Edit</button>
                        <button class="delete" onclick="deleteCustomer(${c.id})">Delete</button>
                    </td>
                </tr>`;
            });
            document.getElementById('customerTable').innerHTML = rows;
        })
        .catch(e => {
            document.getElementById('customerTable').innerHTML =
                `<tr><td colspan="3">Could not load data: ${e}</td></tr>`;
        });
}

function saveCustomer() {
    const id = document.getElementById('customerId').value;
    const name = document.getElementById('name').value;
    const contact = document.getElementById('contact').value;
    const body = JSON.stringify({ name, contact });
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
        loadCustomers();
    });
    return false;
}

function deleteCustomer(id) {
    if (confirm("Delete this customer?")) {
        fetch(API_URL + '/' + id, { method:'DELETE' })
        .then(() => loadCustomers());
    }
}

function editCustomer(id, name, contact) {
    document.getElementById('customerId').value = id;
    document.getElementById('name').value = name;
    document.getElementById('contact').value = contact;
    document.getElementById('addBtn').value = "Update Customer";
    document.getElementById('resetBtn').style.display = "";
}

function resetForm() {
    document.getElementById('customerId').value = "";
    document.getElementById('name').value = "";
    document.getElementById('contact').value = "";
    document.getElementById('addBtn').value = "Add Customer";
    document.getElementById('resetBtn').style.display = "none";
}

window.onload = loadCustomers;
</script>
</body>
</html>