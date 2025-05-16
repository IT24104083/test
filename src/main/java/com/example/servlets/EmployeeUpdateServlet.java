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
import java.util.List;
import java.util.logging.Logger;

@WebServlet("/EmployeeUpdateServlet")
public class EmployeeUpdateServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(EmployeeUpdateServlet.class.getName());
    private EmployeeFileHandler employeeFileHandler;

    @Override
    public void init() throws ServletException {
        employeeFileHandler = new EmployeeFileHandler();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("employee") == null) {
            LOGGER.warning("No active session or employee found, redirecting to login");
            response.sendRedirect("emplogin.jsp");
            return;
        }

        Employee currentEmployee = (Employee) session.getAttribute("employee");
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String currentPassword = request.getParameter("currentPassword");

        LOGGER.info("Attempting to update employee ID: " + currentEmployee.getEmployeeId() + ", Email: " + email);

        try {
            // Verify current password if provided
            if (currentPassword != null && !currentEmployee.getPassword().equals(currentPassword)) {
                LOGGER.warning("Incorrect current password for employee: " + currentEmployee.getEmail());
                request.setAttribute("error", "Current password is incorrect");
                request.setAttribute("employee", currentEmployee);
                request.getRequestDispatcher("employeeProfile.jsp").forward(request, response);
                return;
            }

            // Validate inputs
            if (name == null || name.trim().isEmpty() || email == null || email.trim().isEmpty()) {
                LOGGER.warning("Invalid input: Name or email empty");
                request.setAttribute("error", "Name and email are required");
                request.setAttribute("employee", currentEmployee);
                request.getRequestDispatcher("employeeProfile.jsp").forward(request, response);
                return;
            }

            // Check if email is taken by another employee
            List<Employee> employees = employeeFileHandler.readAllEmployees();
            for (Employee employee : employees) {
                if (employee.getEmail().equalsIgnoreCase(email) && employee.getEmployeeId() != currentEmployee.getEmployeeId()) {
                    LOGGER.warning("Email already in use: " + email);
                    request.setAttribute("error", "Email already in use by another employee");
                    request.setAttribute("employee", currentEmployee);
                    request.getRequestDispatcher("employeeProfile.jsp").forward(request, response);
                    return;
                }
            }

            // Update employee in list
            for (Employee employee : employees) {
                if (employee.getEmployeeId() == currentEmployee.getEmployeeId()) {
                    employee.setName(name);
                    employee.setEmail(email);
                    if (password != null && !password.trim().isEmpty()) {
                        employee.setPassword(password);
                    }
                    currentEmployee.setName(name);
                    currentEmployee.setEmail(email);
                    if (password != null && !password.trim().isEmpty()) {
                        currentEmployee.setPassword(password);
                    }
                    break;
                }
            }

            // Persist updated list
            employeeFileHandler.updateEmployees(employees);
            LOGGER.info("Employee updated successfully: " + currentEmployee.getEmail());

            // Update session
            session.setAttribute("employee", currentEmployee);
            request.setAttribute("success", "Profile updated successfully");
            request.setAttribute("employee", currentEmployee);
            request.getRequestDispatcher("employeeProfile.jsp").forward(request, response);
        } catch (IOException e) {
            LOGGER.severe("Update failed for employee ID: " + currentEmployee.getEmployeeId() + ", Error: " + e.getMessage());
            request.setAttribute("error", "Update failed: " + e.getMessage());
            request.setAttribute("employee", currentEmployee);
            request.getRequestDispatcher("employeeProfile.jsp").forward(request, response);
        }
    }
}