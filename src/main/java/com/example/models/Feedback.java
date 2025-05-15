package com.example.models;

import java.util.Objects;

public class Feedback {
    private int feedbackId;
    private int customerId;
    private String customerName;
    private String feedback;

    public Feedback() {
    }

    public Feedback(int feedbackId, int customerId, String customerName, String feedback) {
        this.feedbackId = feedbackId;
        this.customerId = customerId;
        this.customerName = customerName;
        this.feedback = feedback;
    }

    public int getFeedbackId() {
        return feedbackId;
    }

    public void setFeedbackId(int feedbackId) {
        this.feedbackId = feedbackId;
    }

    public int getCustomerId() {
        return customerId;
    }

    public void setCustomerId(int customerId) {
        this.customerId = customerId;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public String getFeedback() {
        return feedback;
    }

    public void setFeedback(String feedback) {
        this.feedback = feedback;
    }

    public String toFileString() {
        return String.format("%d,%d,%s,%s",
                feedbackId,
                customerId,
                escapeCsv(customerName),
                escapeCsv(feedback));
    }

    public static Feedback fromFileString(String line) {
        String[] data = line.split(",", -1);
        if (data.length == 4) {
            try {
                return new Feedback(
                        Integer.parseInt(data[0]), // feedbackId
                        Integer.parseInt(data[1]), // customerId
                        unescapeCsv(data[2]),      // customerName
                        unescapeCsv(data[3])       // feedback
                );
            } catch (NumberFormatException e) {
                System.err.println("Error parsing feedback line: " + line);
                return null;
            }
        }
        System.err.println("Malformed feedback line: " + line);
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
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Feedback feedback = (Feedback) o;
        return feedbackId == feedback.feedbackId;
    }

    @Override
    public int hashCode() {
        return Objects.hash(feedbackId);
    }
}