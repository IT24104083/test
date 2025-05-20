package com.example.servlets;

import com.example.filehandler.EmployeeFileHandler;
import com.example.models.Employee;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/EmployeeLoginServlet")
public class EmployeeLoginServlet extends HttpServlet {
    private EmployeeFileHandler employeeFileHandler;

    @Override
    public void init() throws ServletException {
        employeeFileHandler = new EmployeeFileHandler();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try {
            Employee employee = employeeFileHandler.findEmployeeByEmail(email, request);
            if (employee == null || !employee.getPassword().equals(password)) {
                request.setAttribute("error", "Invalid email or password");
                request.getRequestDispatcher("emplogin.jsp").forward(request, response);
                return;
            }

            HttpSession session = request.getSession();
            session.setAttribute("employee", employee);
            response.sendRedirect("employeeProfile.jsp");
        } catch (Exception e) {
            request.setAttribute("error", "Login failed: " + e.getMessage());
            request.getRequestDispatcher("emplogin.jsp").forward(request, response);
        }
    }
}