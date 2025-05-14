package com.example.servlets;

import com.example.models.User;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/UpdateEmailServlet")
public class UpdateEmailServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");

        String newEmail = request.getParameter("newEmail");
        String currentPassword = request.getParameter("currentPassword");

        try {
            // Verify current password
            if (!currentUser.getPassword().equals(currentPassword)) {
                request.setAttribute("error", "Current password is incorrect");
                request.getRequestDispatcher("account.jsp").forward(request, response);
                return;
            }

            List<User> users = FileHandler.readUsers();

            // Check if new email already exists
            for (User user : users) {
                if (user.getEmail().equals(newEmail)) {
                    request.setAttribute("error", "Email already in use by another account");
                    request.getRequestDispatcher("account.jsp").forward(request, response);
                    return;
                }
            }

            // Update email
            for (User user : users) {
                if (user.getCustomerId() == currentUser.getCustomerId()) { // Use customerId for identification
                    user.setEmail(newEmail);
                    currentUser.setEmail(newEmail);
                    break;
                }
            }

            FileHandler.updateUsers(users);
            session.setAttribute("user", currentUser);
            response.sendRedirect("account.jsp");

        } catch (IOException e) {
            e.printStackTrace();
            request.setAttribute("error", "Email update failed");
            request.getRequestDispatcher("account.jsp").forward(request, response);
        }
    }
}