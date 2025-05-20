package com.example.filehandler;
import com.example.models.User;

import java.io.*;
import java.util.ArrayList;
import java.util.List;


public class CustomerFileHandler {
    private static final String USERS_FILE = "C:\\Users\\thami\\OneDrive\\Desktop\\final_OOP_project\\final_pj\\src\\main\\webapp\\data\\customers.txt";


    private static synchronized int generateCustomerId() throws IOException {
        List<User> users = readUsers();
        if (users.isEmpty()) {
            return 1;
        }
        int maxId = users.stream()
                .mapToInt(User::getCustomerId)
                .max()
                .orElse(0);
        return maxId + 1;
    }

    // Save a new user with a generated customerId
    public static synchronized void saveUser(User user) throws IOException {
        if (user.getCustomerId() == 0) {
            int newId = generateCustomerId();
            user.setCustomerId(newId);
        }
        try (PrintWriter out = new PrintWriter(new FileWriter(USERS_FILE, true))) {
            out.println(user.toFileString());
        }
    }


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


    public static synchronized void updateUsers(List<User> users) throws IOException {
        try (PrintWriter out = new PrintWriter(new FileWriter(USERS_FILE))) {
            for (User user : users) {
                out.println(user.toFileString());
            }
        }
    }
}