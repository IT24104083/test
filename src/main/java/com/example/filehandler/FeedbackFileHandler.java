package com.example.filehandler;

import com.example.models.Feedback;

import java.io.*;
import java.util.ArrayList;
import java.util.List;

public class FeedbackFileHandler {
    private static final String FEEDBACKS_FILE = "C:\\Users\\thami\\OneDrive\\Desktop\\final_OOP_project\\final_pj\\src\\main\\webapp\\data\\feedbacks.txt";

    // Generate a unique feedback ID
    private static synchronized int generateFeedbackId() throws IOException {
        List<Feedback> feedbacks = readFeedbacks();
        if (feedbacks.isEmpty()) {
            return 1; // Start with ID 1 if no feedbacks exist
        }
        int maxId = feedbacks.stream()
                .mapToInt(Feedback::getFeedbackId)
                .max()
                .orElse(0);
        return maxId + 1; // Increment the highest ID
    }

    // Save a new feedback with a generated feedbackId
    public static synchronized void saveFeedback(Feedback feedback) throws IOException {
        if (feedback.getFeedbackId() == 0) { // Only generate ID if not already set
            int newId = generateFeedbackId();
            feedback.setFeedbackId(newId);
        }
        try (PrintWriter out = new PrintWriter(new FileWriter(FEEDBACKS_FILE, true))) {
            out.println(feedback.toFileString());
        }
    }

    // Read all feedbacks from the file
    public static synchronized List<Feedback> readFeedbacks() throws IOException {
        List<Feedback> feedbacks = new ArrayList<>();
        File file = new File(FEEDBACKS_FILE);

        if (!file.exists()) {
            file.createNewFile();
            return feedbacks;
        }

        try (BufferedReader reader = new BufferedReader(new FileReader(FEEDBACKS_FILE))) {
            String line;
            while ((line = reader.readLine()) != null) {
                if (!line.trim().isEmpty()) {
                    try {
                        Feedback feedback = Feedback.fromFileString(line);
                        if (feedback != null) {
                            feedbacks.add(feedback);
                        }
                    } catch (Exception e) {
                        System.err.println("Error parsing feedback line: " + line);
                    }
                }
            }
        }
        return feedbacks;
    }

    // Update the entire feedback list
    public static synchronized void updateFeedbacks(List<Feedback> feedbacks) throws IOException {
        try (PrintWriter out = new PrintWriter(new FileWriter(FEEDBACKS_FILE))) {
            for (Feedback feedback : feedbacks) {
                out.println(feedback.toFileString());
            }
        }
    }

    // Delete a feedback by ID
    public static synchronized void deleteFeedback(int feedbackId) throws IOException {
        List<Feedback> feedbacks = readFeedbacks();
        feedbacks.removeIf(feedback -> feedback.getFeedbackId() == feedbackId);
        updateFeedbacks(feedbacks);
    }
}