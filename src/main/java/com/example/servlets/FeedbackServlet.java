package com.example.servlets;

import com.example.filehandler.FeedbackFileHandler;
import com.example.models.Feedback;
import com.example.models.User;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.util.List;
import java.util.logging.Logger;
import java.util.stream.Collectors;

@WebServlet("/FeedbackServlet")
public class FeedbackServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(FeedbackServlet.class.getName());

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("all".equals(action)) {
            try {
                List<Feedback> allFeedbacks = FeedbackFileHandler.readFeedbacks();
                request.setAttribute("allFeedbacks", allFeedbacks);
                request.getRequestDispatcher("feedbacks.jsp").forward(request, response);
            } catch (IOException e) {
                LOGGER.severe("Failed to fetch all feedbacks: " + e.getMessage());
                request.setAttribute("error", "Unable to load feedback");
                request.getRequestDispatcher("feedbacks.jsp").forward(request, response);
            }
        } else {
            // Default: fetch user's feedback
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("user") == null) {
                request.setAttribute("error", "Please log in to view your feedback");
                request.getRequestDispatcher("index.jsp").forward(request, response);
                return;
            }

            User user = (User) session.getAttribute("user");
            try {
                List<Feedback> userFeedbacks = FeedbackFileHandler.readFeedbacks().stream()
                        .filter(f -> f.getCustomerId() == user.getCustomerId())
                        .collect(Collectors.toList());
                request.setAttribute("userFeedbacks", userFeedbacks);
                request.getRequestDispatcher("account.jsp").forward(request, response);
            } catch (IOException e) {
                LOGGER.severe("Failed to fetch user feedbacks: " + e.getMessage());
                request.setAttribute("error", "Unable to load your feedback");
                request.getRequestDispatcher("account.jsp").forward(request, response);
            }
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            request.setAttribute("error", "Please log in to manage feedback");
            request.getRequestDispatcher("index.jsp").forward(request, response);
            return;
        }

        User user = (User) session.getAttribute("user");
        String action = request.getParameter("action");

        try {
            if ("create".equals(action)) {
                String feedbackText = request.getParameter("feedback");
                if (feedbackText == null || feedbackText.trim().isEmpty()) {
                    request.setAttribute("error", "Feedback cannot be empty");
                    request.getRequestDispatcher("account.jsp").forward(request, response);
                    return;
                }

                Feedback feedback = new Feedback(0, user.getCustomerId(), user.getName(), feedbackText);
                FeedbackFileHandler.saveFeedback(feedback);
                LOGGER.info("Feedback created by user: " + user.getEmail());

                request.setAttribute("success", "Feedback submitted successfully");
            } else if ("update".equals(action)) {
                int feedbackId = Integer.parseInt(request.getParameter("feedbackId"));
                String feedbackText = request.getParameter("feedback");
                if (feedbackText == null || feedbackText.trim().isEmpty()) {
                    request.setAttribute("error", "Feedback cannot be empty");
                    request.getRequestDispatcher("account.jsp").forward(request, response);
                    return;
                }

                List<Feedback> feedbacks = FeedbackFileHandler.readFeedbacks();
                boolean updated = false;
                for (Feedback feedback : feedbacks) {
                    if (feedback.getFeedbackId() == feedbackId && feedback.getCustomerId() == user.getCustomerId()) {
                        feedback.setFeedback(feedbackText);
                        updated = true;
                        break;
                    }
                }

                if (updated) {
                    FeedbackFileHandler.updateFeedbacks(feedbacks);
                    LOGGER.info("Feedback updated by user: " + user.getEmail());
                    request.setAttribute("success", "Feedback updated successfully");
                } else {
                    request.setAttribute("error", "Feedback not found or unauthorized");
                }
            } else if ("delete".equals(action)) {
                int feedbackId = Integer.parseInt(request.getParameter("feedbackId"));
                List<Feedback> feedbacks = FeedbackFileHandler.readFeedbacks();
                if (feedbacks.stream().anyMatch(f -> f.getFeedbackId() == feedbackId && f.getCustomerId() == user.getCustomerId())) {
                    FeedbackFileHandler.deleteFeedback(feedbackId);
                    LOGGER.info("Feedback deleted by user: " + user.getEmail());
                    request.setAttribute("success", "Feedback deleted successfully");
                } else {
                    request.setAttribute("error", "Feedback not found or unauthorized");
                }
            } else {
                request.setAttribute("error", "Invalid action");
            }

            // Refresh user's feedback
            List<Feedback> userFeedbacks = FeedbackFileHandler.readFeedbacks().stream()
                    .filter(f -> f.getCustomerId() == user.getCustomerId())
                    .collect(Collectors.toList());
            request.setAttribute("userFeedbacks", userFeedbacks);
            request.getRequestDispatcher("account.jsp").forward(request, response);

        } catch (IOException e) {
            LOGGER.severe("Feedback operation failed: " + e.getMessage());
            request.setAttribute("error", "Feedback operation failed: " + e.getMessage());
            request.getRequestDispatcher("account.jsp").forward(request, response);
        }
    }
}