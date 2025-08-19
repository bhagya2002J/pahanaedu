<%@ page language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Main Page - Pahana Edu</title>
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

        .logout-btn {
            background: #D4C9BE;
            color: #123458;
            border: none;
            padding: 8px 20px;
            border-radius: 5px;
            cursor: pointer;
            font-weight: bold;
            transition: all 0.3s;
        }

        .logout-btn:hover {
            background: #F1EFEC;
            transform: translateY(-2px);
        }

        .container {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 2rem;
            max-width: 1200px;
            margin: 120px auto 40px;
            padding: 0 20px;
        }

        .card {
            width: 180px;
            height: 180px;
            background: #fff;
            border-radius: 20px;
            box-shadow: 0 4px 15px rgba(3, 3, 3, 0.08);
            margin: auto;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            text-align: center;
            transition: all 0.3s ease;
            text-decoration: none;
            position: relative;
            overflow: hidden;
        }

        .card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 4px;
            background: #123458;
            transform: scaleX(0);
            transition: transform 0.3s ease;
        }

        .card:hover::before {
            transform: scaleX(1);
        }

        .card:hover {
            transform: translateY(-10px);
            box-shadow: 0 12px 30px rgba(3, 3, 3, 0.12);
        }

        .card-icon {
            font-size: 45px;
            margin-bottom: 20px;
            color: #123458;
            transition: transform 0.3s ease;
        }

        .card:hover .card-icon {
            transform: scale(1.1);
        }

        .card-title {
            font-size: 18px;
            font-weight: 600;
            color: #030303;
        }

        @media (max-width: 768px) {
            .container {
                grid-template-columns: repeat(auto-fit, minmax(160px, 1fr));
                gap: 1.5rem;
                padding: 0 15px;
            }

            .card {
                width: 160px;
                height: 160px;
            }

            .card-icon {
                font-size: 40px;
            }

            .card-title {
                font-size: 16px;
            }
        }
    </style>
</head>
<body>
    <header class="header">
        <a href="main.jsp" class="logo">Pahana Edu</a>
        <button onclick="window.location.href='logout.jsp'" class="logout-btn">
            <i class="fas fa-sign-out-alt"></i> Logout
        </button>
    </header>

    <div class="container">
        <a href="new_order.jsp" class="card">
            <div class="card-icon"><i class="fa fa-shopping-cart"></i></div>
            <div class="card-title">New Order</div>
        </a>
        
        <a href="Customers.jsp" class="card">
            <div class="card-icon"><i class="fa fa-users"></i></div>
            <div class="card-title">Manage Customers</div>
        </a>

        <a href="Items.jsp" class="card">
            <div class="card-icon"><i class="fa fa-book"></i></div>
            <div class="card-title">Manage Items</div>
        </a>

        <a href="order_history.jsp" class="card">
            <div class="card-icon"><i class="fa fa-history"></i></div>
            <div class="card-title">View History</div>
        </a>

        <a href="help.jsp" class="card">
            <div class="card-icon"><i class="fa fa-question-circle"></i></div>
            <div class="card-title">Help</div>
        </a>
    </div>
</body>
</html>