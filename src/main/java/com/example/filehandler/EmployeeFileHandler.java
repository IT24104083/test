package com.example.filehandler;

import com.example.models.Employee;
import jakarta.servlet.http.HttpServletRequest;

import java.io.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class EmployeeFileHandler {
    private static final Logger LOGGER = Logger.getLogger(EmployeeFileHandler.class.getName());
    private static final String EMPLOYEES_FILE = "C:\\Users\\thami\\OneDrive\\Desktop\\final_OOP_project\\final_pj\\src\\main\\webapp\\data\\employees.txt";

    public synchronized void saveEmployee(Employee employee) throws IOException {
        if (employee.getEmployeeId() == 0) {
            int newId = getNextEmployeeId();
            employee.setEmployeeId(newId);
        }
        try (PrintWriter out = new PrintWriter(new FileWriter(EMPLOYEES_FILE, true))) {
            out.println(employee.toFileString());
            LOGGER.info("Saved employee: " + employee.getEmail());
        } catch (IOException e) {
            LOGGER.log(Level.SEVERE, "Failed to save employee: " + employee.getEmail(), e);
            throw e;
        }
    }

    public synchronized List<Employee> readAllEmployees() throws IOException {
        List<Employee> employees = new ArrayList<>();
        File file = new File(EMPLOYEES_FILE);

        if (!file.exists()) {
            LOGGER.warning("Employees file does not exist, creating new: " + file.getAbsolutePath());
            file.getParentFile().mkdirs();
            file.createNewFile();
            return employees;
        }

        try (BufferedReader reader = new BufferedReader(new FileReader(EMPLOYEES_FILE))) {
            String line;
            while ((line = reader.readLine()) != null) {
                if (!line.trim().isEmpty()) {
                    Employee employee = Employee.fromFileString(line);
                    if (employee != null) {
                        employees.add(employee);
                    }
                }
            }
        } catch (IOException e) {
            LOGGER.log(Level.SEVERE, "Failed to read employees file", e);
            throw e;
        }
        LOGGER.info("Read " + employees.size() + " employees from file");
        return employees;
    }

    public synchronized Employee findEmployeeByEmail(String email, HttpServletRequest request) throws IOException {
        for (Employee employee : readAllEmployees()) {
            if (employee.getEmail().equalsIgnoreCase(email)) {
                LOGGER.info("Found employee by email: " + email);
                return employee;
            }
        }
        LOGGER.info("No employee found for email: " + email);
        return null;
    }

    public synchronized void updateEmployees(List<Employee> employees) throws IOException {
        try (PrintWriter out = new PrintWriter(new FileWriter(EMPLOYEES_FILE))) {
            for (Employee employee : employees) {
                out.println(employee.toFileString());
            }
            LOGGER.info("Updated employee list in file");
        } catch (IOException e) {
            LOGGER.log(Level.SEVERE, "Failed to update employees file", e);
            throw e;
        }
    }

    public synchronized void updateEmployee(Employee updatedEmployee) throws IOException {
        List<Employee> employees = readAllEmployees();
        boolean updated = false;
        for (int i = 0; i < employees.size(); i++) {
            if (employees.get(i).getEmployeeId() == updatedEmployee.getEmployeeId()) {
                employees.set(i, updatedEmployee);
                updated = true;
                break;
            }
        }
        if (!updated) {
            LOGGER.warning("No employee found with ID: " + updatedEmployee.getEmployeeId());
            throw new IOException("Employee not found for update");
        }
        updateEmployees(employees);
        LOGGER.info("Updated employee: " + updatedEmployee.getEmail());
    }

    private synchronized int getNextEmployeeId() throws IOException {
        List<Employee> employees = readAllEmployees();
        if (employees.isEmpty()) {
            return 1;
        }
        int maxId = employees.stream()
                .mapToInt(Employee::getEmployeeId)
                .max()
                .orElse(0);
        return maxId + 1;
    }
}