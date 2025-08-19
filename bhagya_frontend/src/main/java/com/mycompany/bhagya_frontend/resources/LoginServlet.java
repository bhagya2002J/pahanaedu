package com.mycompany.bhagya_frontend.resources;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.*;
import java.net.*;
import java.nio.charset.StandardCharsets;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    private static final String BACKEND_URL = "http://localhost:8080/bhagya_backend/resources/login";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // Prepare REST call to backend
        URL url = new URL(BACKEND_URL);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("POST");
        conn.setDoOutput(true);
        conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");

        String params = "username=" + URLEncoder.encode(username, StandardCharsets.UTF_8) +
                        "&password=" + URLEncoder.encode(password, StandardCharsets.UTF_8);

        try (OutputStream os = conn.getOutputStream()) {
            os.write(params.getBytes(StandardCharsets.UTF_8));
        }

        int code = conn.getResponseCode();
        if (code == 200) {
            // Success
            response.sendRedirect("main.jsp");
        } else {
            // Failure
            response.sendRedirect("login.jsp?error=1");
        }
    }
}