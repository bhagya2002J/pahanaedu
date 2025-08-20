<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="true" %>
<%
    session.invalidate();
    response.sendRedirect("login.jsp");
%>