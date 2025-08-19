<%@ page language="java" %>
<html>
<head>
    <title>Pahana Edu - Login</title>
</head>
<body>
    <h2>Login to Pahana Edu</h2>
    <form method="post" action="LoginServlet">
        Username: <input type="text" name="username" /><br/>
        Password: <input type="password" name="password" /><br/>
        <input type="submit" value="Login"/>
    </form>
    <%
        String error = request.getParameter("error");
        if ("1".equals(error)) {
    %>
        <p style="color:red;">Invalid credentials. Try again.</p>
    <% } %>
</body>
</html>