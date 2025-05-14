package com.example.servlets;
import com.example.models.User;

import java.io.*;
import java.util.ArrayList;
import java.util.List;

public class FileHandler {
    private static final String USERS_FILE = "C:\\Users\\thami\\OneDrive\\Desktop\\final-OOP-project\\project\\src\\main\\webapp\\data\\customers.txt";

    // Generate a unique customer ID
    private static synchronized int generateCustomerId() throws IOException {
        List<User> users = readUsers();
        if (users.isEmpty()) {
            return 1; // Start with ID 1 if no users exist
        }
        int maxId = users.stream()
                .mapToInt(User::getCustomerId)
                .max()
                .orElse(0);
        return maxId + 1; // Increment the highest ID
    }

    // Save a new user with a generated customerId
    public static synchronized void saveUser(User user) throws IOException {
        if (user.getCustomerId() == 0) { // Only generate ID if not already set
            int newId = generateCustomerId();
            user.setCustomerId(newId);
        }
        try (PrintWriter out = new PrintWriter(new FileWriter(USERS_FILE, true))) {
            out.println(user.toFileString());
        }
    }

    // Read all users from the file
    public static synchronized List<User> readUsers() throws IOException {
        List<User> users = new ArrayList<>();
        File file = new File(USERS_FILE);

        if (!file.exists()) {
            file.createNewFile();
            return users;
        }

        try (BufferedReader reader = new BufferedReader(new FileReader(USERS_FILE))) {
            String line;
            while ((line = reader.readLine()) != null) {
                if (!line.trim().isEmpty()) {
                    try {
                        users.add(User.fromFileString(line));
                    } catch (Exception e) {
                        System.err.println("Error parsing line: " + line);
                    }
                }
            }
        }
        return users;
    }

    // Update the entire user list
    public static synchronized void updateUsers(List<User> users) throws IOException {
        try (PrintWriter out = new PrintWriter(new FileWriter(USERS_FILE))) {
            for (User user : users) {
                out.println(user.toFileString());
            }
        }
    }
}