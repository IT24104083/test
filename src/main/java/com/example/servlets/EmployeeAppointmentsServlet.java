package com.example.servlets;

import com.example.filehandler.AppointmentsFileHandler;
import com.example.filehandler.EmployeeFileHandler;
import com.example.filehandler.ServiceFileHandler;
import com.example.models.Booking;
import com.example.models.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/employeeAppointments")
public class EmployeeAppointmentsServlet extends HttpServlet {
    private final AppointmentsFileHandler appointmentsFileHandler = new AppointmentsFileHandler();
    private final ServiceFileHandler serviceFileHandler = new ServiceFileHandler();
    private final EmployeeFileHandler employeeFileHandler = new EmployeeFileHandler();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String employeeIdStr = request.getParameter("employeeId");
        List<Booking> employeeAppointments = new ArrayList<>();
        if (employeeIdStr != null && !employeeIdStr.isEmpty()) {
            int employeeId = Integer.parseInt(employeeIdStr);
            employeeAppointments = appointmentsFileHandler.readAppointmentsByEmployeeId(employeeId);
        }

        request.setAttribute("employeeAppointments", employeeAppointments);
        request.setAttribute("employees", employeeFileHandler.readAllEmployees());
        request.setAttribute("services", serviceFileHandler.readServices());
        request.getRequestDispatcher("/viewEmployeeAppointments.jsp").forward(request, response);
    }
}