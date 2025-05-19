package com.example.filehandler;

import com.example.models.Service;

import java.io.*;
import java.util.ArrayList;
import java.util.List;

public class ServiceFileHandler {
    private static final String SERVICES_FILE = "C:\\Users\\thami\\OneDrive\\Desktop\\final_OOP_project\\final_pj\\src\\main\\webapp\\data\\services.txt";

    // Generate a unique service ID
    private static synchronized int generateServiceId() throws IOException {
        List<Service> services = readServices();
        if (services.isEmpty()) {
            return 1; // Start with ID 1 if no services exist
        }
        int maxId = services.stream()
                .mapToInt(Service::getServiceId)
                .max()
                .orElse(0);
        return maxId + 1; // Increment the highest ID
    }

    // Save a new service with a generated serviceId
    public static synchronized void saveService(Service service) throws IOException {
        if (service.getServiceId() == 0) { // Only generate ID if not already set
            int newId = generateServiceId();
            service.setServiceId(newId);
        }
        try (PrintWriter out = new PrintWriter(new FileWriter(SERVICES_FILE, true))) {
            out.println(service.toFileString());
        }
    }

    // Read all services from the file
    public static synchronized List<Service> readServices() throws IOException {
        List<Service> services = new ArrayList<>();
        File file = new File(SERVICES_FILE);

        if (!file.exists()) {
            file.createNewFile();
            return services;
        }

        try (BufferedReader reader = new BufferedReader(new FileReader(SERVICES_FILE))) {
            String line;
            while ((line = reader.readLine()) != null) {
                if (!line.trim().isEmpty()) {
                    try {
                        services.add(Service.fromFileString(line));
                    } catch (Exception e) {
                        System.err.println("Error parsing line: " + line);
                    }
                }
            }
        }
        return services;
    }

    // Update the entire service list
    public static synchronized void updateServices(List<Service> services) throws IOException {
        try (PrintWriter out = new PrintWriter(new FileWriter(SERVICES_FILE))) {
            for (Service service : services) {
                out.println(service.toFileString());
            }
        }
    }
}