<%@ page language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Pahana Edu - Login</title>
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
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .login-container {
            background: #fff;
            padding: 2.5rem;
            border-radius: 15px;
            box-shadow: 0 4px 20px rgba(3, 3, 3, 0.08);
            width: 90%;
            max-width: 400px;
        }

        .logo-section {
            text-align: center;
            margin-bottom: 30px;
        }

        .logo-section h1 {
            color: #123458;
            font-size: 28px;
            margin-top: 15px;
        }

        .logo-icon {
            font-size: 48px;
            color: #123458;
            margin-bottom: 15px;
        }

        h2 {
            color: #123458;
            text-align: center;
            margin-bottom: 30px;
            font-size: 24px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #123458;
            font-weight: 500;
        }

        .input-group {
            position: relative;
        }

        .input-group i {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #D4C9BE;
        }

        input[type="text"],
        input[type="password"] {
            width: 100%;
            padding: 12px 15px 12px 45px;
            border: 2px solid #D4C9BE;
            border-radius: 8px;
            font-size: 16px;
            transition: all 0.3s;
        }

        input[type="text"]:focus,
        input[type="password"]:focus {
            border-color: #123458;
            outline: none;
            box-shadow: 0 0 0 3px rgba(18, 52, 88, 0.1);
        }

        input[type="submit"] {
            width: 100%;
            background: #123458;
            color: #F1EFEC;
            border: none;
            border-radius: 8px;
            padding: 14px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 8px;
        }

        input[type="submit"]:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(18, 52, 88, 0.2);
        }

        .error-message {
            background: #fde8e8;
            color: #dc2626;
            padding: 12px;
            border-radius: 8px;
            margin-top: 20px;
            text-align: center;
            font-size: 14px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }

        .copyright {
            text-align: center;
            margin-top: 20px;
            color: #666;
            font-size: 14px;
        }

        @media (max-width: 480px) {
            .login-container {
                padding: 1.5rem;
            }

            .logo-section h1 {
                font-size: 24px;
            }

            h2 {
                font-size: 20px;
            }
        }
    </style>
</head>
<body>
    <div class="login-container">
        <div class="logo-section">
            <i class="fas fa-book-reader logo-icon"></i>
            <h1>Pahana Edu</h1>
        </div>
        
        <h2>Welcome Back</h2>
        
        <form method="post" action="LoginServlet">
            <div class="form-group">
                <label for="username">Username</label>
                <div class="input-group">
                    <i class="fas fa-user"></i>
                    <input type="text" id="username" name="username" placeholder="Enter your username" required />
                </div>
            </div>
            
            <div class="form-group">
                <label for="password">Password</label>
                <div class="input-group">
                    <i class="fas fa-lock"></i>
                    <input type="password" id="password" name="password" placeholder="Enter your password" required />
                </div>
            </div>
            
            <input type="submit" value="Login">
            <i class="fas fa-sign-in-alt"></i>
        </form>
        
        <%
            String error = request.getParameter("error");
            if ("1".equals(error)) {
        %>
            <div class="error-message">
                <i class="fas fa-exclamation-circle"></i>
                Invalid username or password. Please try again.
            </div>
        <% } %>
        
        <div class="copyright">
            © 2025 Pahana Edu. All rights reserved.
        </div>
    </div>
</body>
</html>