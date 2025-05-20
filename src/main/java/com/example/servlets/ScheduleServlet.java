package com.example.servlets;

import com.example.models.Employee;
import com.example.models.Schedule;
import com.example.filehandler.ScheduleFileHandler;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

@WebServlet(urlPatterns = {"/schedules", "/schedules/create", "/schedules/update", "/schedules/delete"})
public class ScheduleServlet extends HttpServlet {
    private final ScheduleFileHandler scheduleFileHandler = new ScheduleFileHandler();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Employee employee = (Employee) request.getSession().getAttribute("employee");
        if (employee == null) {
            request.getSession().setAttribute("error", "Please log in to view schedules.");
            response.sendRedirect(request.getContextPath() + "/employeeLogin.jsp");
            return;
        }

        try {
            List<Schedule> schedules = scheduleFileHandler.readSchedulesByEmployeeId(employee.getEmployeeId());
            request.setAttribute("schedules", schedules);
        } catch (IOException e) {
            request.getSession().setAttribute("error", "Error loading schedules: " + e.getMessage());
        }
        request.getRequestDispatcher("/employeeProfile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Employee employee = (Employee) request.getSession().getAttribute("employee");
        if (employee == null) {
            request.getSession().setAttribute("error", "Please log in to perform this action.");
            response.sendRedirect(request.getContextPath() + "/employeeLogin.jsp");
            return;
        }

        String path = request.getServletPath();
        try {
            switch (path) {
                case "/schedules/create":
                    handleCreate(request, response, employee);
                    break;
                case "/schedules/update":
                    handleUpdate(request, response, employee);
                    break;
                case "/schedules/delete":
                    handleDelete(request, response, employee);
                    break;
                default:
                    request.getSession().setAttribute("error", "Invalid action!");
                    response.sendRedirect(request.getContextPath() + "/schedules");
            }
        } catch (Exception e) {
            request.getSession().setAttribute("error", "Operation failed: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/schedules");
        }
    }

    private void handleCreate(HttpServletRequest request, HttpServletResponse response, Employee employee) throws IOException {
        String date = request.getParameter("date");
        double time = parseTime(request.getParameter("hour"), request.getParameter("minute"));

        // Validate date and time
        if (!isValidDate(date)) {
            request.getSession().setAttribute("error", "Invalid or past date.");
            response.sendRedirect(request.getContextPath() + "/schedules");
            return;
        }

        if (scheduleFileHandler.isTimeSlotTaken(employee.getEmployeeId(), date, time)) {
            request.getSession().setAttribute("error", "Time slot already taken for this date.");
            response.sendRedirect(request.getContextPath() + "/schedules");
            return;
        }

        Schedule schedule = new Schedule(0, time, date, employee.getEmployeeId(), employee.getName());
        scheduleFileHandler.saveSchedule(schedule);
        request.getSession().setAttribute("success", "Schedule created successfully!");
        response.sendRedirect(request.getContextPath() + "/schedules");
    }

    private void handleUpdate(HttpServletRequest request, HttpServletResponse response, Employee employee) throws IOException {
        int scheduleId = Integer.parseInt(request.getParameter("scheduleId"));
        String date = request.getParameter("date");
        double time = parseTime(request.getParameter("hour"), request.getParameter("minute"));

        // Validate date and time
        if (!isValidDate(date)) {
            request.getSession().setAttribute("error", "Invalid or past date.");
            response.sendRedirect(request.getContextPath() + "/schedules");
            return;
        }

        // Check if new time slot is taken (excluding current schedule)
        List<Schedule> schedules = scheduleFileHandler.readSchedules();
        for (Schedule s : schedules) {
            if (s.getScheduleId() != scheduleId &&
                    s.getEmployeeId() == employee.getEmployeeId() &&
                    s.getDate().equals(date) &&
                    Math.abs(s.getTime() - time) < 0.01) {
                request.getSession().setAttribute("error", "Time slot already taken for this date.");
                response.sendRedirect(request.getContextPath() + "/schedules");
                return;
            }
        }

        Schedule updatedSchedule = null;
        for (Schedule schedule : schedules) {
            if (schedule.getScheduleId() == scheduleId && schedule.getEmployeeId() == employee.getEmployeeId()) {
                updatedSchedule = new Schedule(scheduleId, time, date, employee.getEmployeeId(), employee.getName());
                schedules.remove(schedule);
                schedules.add(updatedSchedule);
                break;
            }
        }

        if (updatedSchedule != null) {
            scheduleFileHandler.updateSchedules(schedules);
            request.getSession().setAttribute("success", "Schedule updated successfully!");
        } else {
            request.getSession().setAttribute("error", "Schedule not found or unauthorized!");
        }
        response.sendRedirect(request.getContextPath() + "/schedules");
    }

    private void handleDelete(HttpServletRequest request, HttpServletResponse response, Employee employee) throws IOException {
        int scheduleId = Integer.parseInt(request.getParameter("scheduleId"));
        List<Schedule> schedules = scheduleFileHandler.readSchedules();
        boolean removed = schedules.removeIf(schedule -> schedule.getScheduleId() == scheduleId && schedule.getEmployeeId() == employee.getEmployeeId());

        if (removed) {
            scheduleFileHandler.updateSchedules(schedules);
            request.getSession().setAttribute("success", "Schedule deleted successfully!");
        } else {
            request.getSession().setAttribute("error", "Schedule not found or unauthorized!");
        }
        response.sendRedirect(request.getContextPath() + "/schedules");
    }

    private double parseTime(String hour, String minute) {
        int h = Integer.parseInt(hour);
        int m = Integer.parseInt(minute);
        return h + (m / 60.0);
    }

    private boolean isValidDate(String dateStr) {
        try {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            sdf.setLenient(false);
            Date inputDate = sdf.parse(dateStr);
            Date currentDate = new Date();
            return !inputDate.before(currentDate); // Allow today and future dates
        } catch (Exception e) {
            return false;
        }
    }
}