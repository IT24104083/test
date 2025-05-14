package com.example.servlets;

import com.example.models.User;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/UpdatePasswordServlet")
public class UpdatePasswordServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");

        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");

        try {
            // Verify current password
            if (!currentUser.getPassword().equals(currentPassword)) {
                request.setAttribute("error", "Current password is incorrect");
                request.getRequestDispatcher("account.jsp").forward(request, response);
                return;
            }

            List<User> users = FileHandler.readUsers();

            // Update password
            for (User user : users) {
                if (user.getCustomerId() == currentUser.getCustomerId()) { // Use customerId for identification
                    user.setPassword(newPassword);
                    currentUser.setPassword(newPassword);
                    break;
                }
            }

            FileHandler.updateUsers(users);
            session.setAttribute("user", currentUser);
            response.sendRedirect("account.jsp");

        } catch (IOException e) {
            e.printStackTrace();
            request.setAttribute("error", "Password update failed");
            request.getRequestDispatcher("account.jsp").forward(request, response);
        }
    }
}