package com.example.models;

public class Employee {
    private int employeeId;
    private String name;
    private String email;
    private String password;

    public Employee() {
    }

    public Employee(int employeeId, String name, String email, String password) {
        this.employeeId = employeeId;
        this.name = name;
        this.email = email;
        this.password = password;
    }

    public int getEmployeeId() {
        return employeeId;
    }

    public void setEmployeeId(int employeeId) {
        this.employeeId = employeeId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String toFileString() {
        return String.format("%d,%s,%s,%s",
                employeeId,
                escapeCsv(name),
                escapeCsv(email),
                escapeCsv(password));
    }

    public static Employee fromFileString(String line) {
        String[] data = line.split(",", -1);
        if (data.length == 4) {
            try {
                return new Employee(
                        Integer.parseInt(data[0]), // employeeId
                        unescapeCsv(data[1]),      // name
                        unescapeCsv(data[2]),      // email
                        unescapeCsv(data[3])       // password
                );
            } catch (NumberFormatException e) {
                System.err.println("Error parsing employee line: " + line);
                return null;
            }
        }
        System.err.println("Malformed employee line: " + line);
        return null;
    }

    private String escapeCsv(String value) {
        if (value == null) return "";
        return value.replace(",", "\\u002C");
    }

    private static String unescapeCsv(String value) {
        if (value == null) return "";
        return value.replace("\\u002C", ",");
    }

    @Override
    public String toString() {
        return "Employee{" +
                "employeeId=" + employeeId +
                ", name='" + name + '\'' +
                ", email='" + email + '\'' +
                '}';
    }
}