package com.example.models;

import java.util.Objects;

public class User {
    private int customerId;
    private String name;
    private String email;
    private String password;

    public User(int customerId, String name, String email, String password) {
        this.customerId = customerId;
        this.name = name;
        this.email = email;
        this.password = password;
    }

    // Getters and setters
    public int getCustomerId() { return customerId; }
    public String getName() { return name; }
    public String getEmail() { return email; }
    public String getPassword() { return password; }

    public void setCustomerId(int customerId) { this.customerId = customerId; }
    public void setEmail(String email) { this.email = email; }
    public void setPassword(String password) { this.password = password; }

    // Convert user to file string format
    public String toFileString() {
        return "customerId:" + customerId + ",name:" + name + ",email:" + email + ",password:" + password;
    }

    // Create user from file string
    public static User fromFileString(String fileString) {
        String[] parts = fileString.split(",");
        int customerId = Integer.parseInt(parts[0].split(":")[1]);
        String name = parts[1].split(":")[1];
        String email = parts[2].split(":")[1];
        String password = parts[3].split(":")[1];
        return new User(customerId, name, email, password);
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        User user = (User) o;
        return email.equals(user.email);
    }

    @Override
    public int hashCode() {
        return Objects.hash(email);
    }
}