<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="true" %>
<!DOCTYPE html>
<html>
<head>
    <title>Manage Customers - Pahana Edu</title>
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
            max-width: 800px;
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
        }

        input[type=text] {
            padding: 12px 15px;
            border: 2px solid #D4C9BE;
            border-radius: 8px;
            font-size: 16px;
            transition: all 0.3s;
            flex: 1;
        }

        input[type=text]:focus {
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
// Keep your existing JavaScript code as is
const API_URL = "http://localhost:8080/bhagya_backend/resources/customers";

// Your existing JavaScript functions remain unchanged
function escapeHTML(str) {
    if (!str) return '';
    return str.replace(/&/g, "&amp;")
              .replace(/</g, "&lt;")
              .replace(/>/g, "&gt;")
              .replace(/"/g, "&quot;")
              .replace(/'/g, "&#039;");
}

// Update the loadCustomers function to include icons in buttons
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
                        <button class="edit" onclick="editCustomer(${c.id}, '${escapeHTML(c.name)}', '${escapeHTML(c.contact)}')">
                            <i class="fas fa-edit"></i> Edit
                        </button>
                        <button class="delete" onclick="deleteCustomer(${c.id})">
                            <i class="fas fa-trash"></i> Delete
                        </button>
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

// Keep all other JavaScript functions as they are
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