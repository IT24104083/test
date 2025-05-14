package com.example.servlets;

import com.example.models.User;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "reg", value = "/RegisterServlet")
public class RegisterServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try {
            // Check if user already exists
            List<User> users = FileHandler.readUsers();
            User newUser = new User(0, name, email, password); // customerId = 0 for auto-generation

            if (users.contains(newUser)) {
                request.setAttribute("error", "Email already registered!");
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }

            // Save new user
            FileHandler.saveUser(newUser);

            // Set user in session and redirect to account page
            request.getSession().setAttribute("user", newUser);
            response.sendRedirect("account.jsp");

        } catch (IOException e) {
            e.printStackTrace();
            request.setAttribute("error", "Registration failed. Please try again.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }
}