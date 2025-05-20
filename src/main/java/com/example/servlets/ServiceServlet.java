package com.example.servlets;

import com.example.models.PremiumService;
import com.example.models.RegularService;
import com.example.models.Service;
import com.example.filehandler.ServiceFileHandler;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = {"/services", "/services/create", "/services/update", "/services/delete"})
public class ServiceServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Handle listing services
        try {
            List<Service> services = ServiceFileHandler.readServices();
            request.setAttribute("services", services);
        } catch (Exception e) {
            request.getSession().setAttribute("error", "Error loading services: " + e.getMessage());
        }
        request.getRequestDispatcher("/services.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();

        try {
            switch (path) {
                case "/services/create":
                    handleCreate(request, response);
                    break;
                case "/services/update":
                    handleUpdate(request, response);
                    break;
                case "/services/delete":
                    handleDelete(request, response);
                    break;
                default:
                    request.getSession().setAttribute("error", "Invalid action!");
                    response.sendRedirect(request.getContextPath() + "/services");
            }
        } catch (Exception e) {
            request.getSession().setAttribute("error", "Operation failed: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/services");
        }
    }

    private void handleCreate(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String serviceName = request.getParameter("serviceName");
        String serviceType = request.getParameter("serviceType");
        double price = Double.parseDouble(request.getParameter("price"));
        Service service;

        if ("Premium".equals(serviceType)) {
            int serviceTimeDuration = Integer.parseInt(request.getParameter("serviceTimeDuration"));
            service = new PremiumService(0, serviceName, price, serviceTimeDuration);
        } else {
            service = new RegularService(0, serviceName, price);
        }

        ServiceFileHandler.saveService(service);
        request.getSession().setAttribute("message", "Service created successfully!");
        response.sendRedirect(request.getContextPath() + "/services");
    }

    private void handleUpdate(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int serviceId = Integer.parseInt(request.getParameter("serviceId"));
        String serviceName = request.getParameter("serviceName");
        String serviceType = request.getParameter("serviceType");
        double price = Double.parseDouble(request.getParameter("price"));

        List<Service> services = ServiceFileHandler.readServices();
        Service updatedService = null;

        for (Service service : services) {
            if (service.getServiceId() == serviceId) {
                if ("Premium".equals(serviceType)) {
                    int serviceTimeDuration = Integer.parseInt(request.getParameter("serviceTimeDuration"));
                    updatedService = new PremiumService(serviceId, serviceName, price, serviceTimeDuration);
                } else {
                    updatedService = new RegularService(serviceId, serviceName, price);
                }
                services.remove(service);
                services.add(updatedService);
                break;
            }
        }

        if (updatedService != null) {
            ServiceFileHandler.updateServices(services);
            request.getSession().setAttribute("message", "Service updated successfully!");
        } else {
            request.getSession().setAttribute("error", "Service not found!");
        }
        response.sendRedirect(request.getContextPath() + "/services");
    }

    private void handleDelete(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int serviceId = Integer.parseInt(request.getParameter("serviceId"));
        List<Service> services = ServiceFileHandler.readServices();
        boolean removed = services.removeIf(service -> service.getServiceId() == serviceId);

        if (removed) {
            ServiceFileHandler.updateServices(services);
            request.getSession().setAttribute("message", "Service deleted successfully!");
        } else {
            request.getSession().setAttribute("error", "Service not found!");
        }
        response.sendRedirect(request.getContextPath() + "/services");
    }
}