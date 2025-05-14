package com.example.servlets;

import com.example.models.User;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try {
            List<User> users = FileHandler.readUsers();
            for (User user : users) {
                if (user.getEmail().equals(email) && user.getPassword().equals(password)) {
                    // Successful login
                    request.getSession().setAttribute("user", user);
                    response.sendRedirect("account.jsp");
                    return;
                }
            }

            // Invalid credentials
            request.setAttribute("error", "Invalid email or password");
            request.getRequestDispatcher("emplogin.jsp").forward(request, response);

        } catch (IOException e) {
            e.printStackTrace();
            request.setAttribute("error", "Login failed. Please try again.");
            request.getRequestDispatcher("emplogin.jsp").forward(request, response);
        }
    }
}