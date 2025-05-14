<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.Objects" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%-- Ensure jakarta.servlet.jsp.jstl-api-2.0.0.jar and jakarta.servlet.jsp.jstl-2.0.0.jar are in WEB-INF/lib or included via Maven --%>
<html>
<head>
    <title>My Account - Salon Booking System</title>
    <style>
        :root {
            --primary-color: #6a5acd;
            --secondary-color: #9370db;
            --danger-color: #e74c3c;
            --success-color: #2ecc71;
            --text-color: #333;
            --light-gray: #f5f5f5;
            --border-radius: 8px;
            --box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        body {
            background-color: var(--light-gray);
            color: var(--text-color);
            line-height: 1.6;
        }

        .container {
            max-width: 1200px;
            margin: 2rem auto;
            padding: 0 1rem;
        }

        header {
            background-color: white;
            padding: 1.5rem;
            border-radius: var(--border-radius);
            box-shadow: var(--box-shadow);
            margin-bottom: 2rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .welcome-message h1 {
            color: var(--primary-color);
            margin-bottom: 0.5rem;
        }

        .header-actions {
            display: flex;
            gap: 1rem;
        }

        .logout-btn, .home-btn {
            background-color: var(--primary-color);
            color: white;
            border: none;
            padding: 0.5rem 1rem;
            border-radius: var(--border-radius);
            cursor: pointer;
            text-decoration: none;
            font-weight: 500;
            transition: background-color 0.3s;
        }

        .logout-btn:hover, .home-btn:hover {
            background-color: var(--secondary-color);
        }

        .account-section {
            display: grid;
            grid-template-columns: 1fr 2fr;
            gap: 2rem;
        }

        .profile-card {
            background-color: white;
            border-radius: var(--border-radius);
            box-shadow: var(--box-shadow);
            padding: 1.5rem;
            height: fit-content;
        }

        .profile-header {
            display: flex;
            align-items: center;
            margin-bottom: 1.5rem;
        }

        .profile-icon {
            width: 60px;
            height: 60px;
            background-color: var(--primary-color);
            color: white;
            border-radius: 50%;
            display: flex;
            justify-content: center;
            align-items: center;
            font-size: 1.5rem;
            margin-right: 1rem;
            font-weight: bold;
        }

        .profile-info h2 {
            color: var(--primary-color);
            margin-bottom: 0.25rem;
        }

        .profile-info p {
            color: #666;
        }

        .account-details {
            margin-top: 1.5rem;
        }

        .detail-item {
            margin-bottom: 1rem;
            padding-bottom: 1rem;
            border-bottom: 1px solid #eee;
        }

        .detail-item:last-child {
            border-bottom: none;
            margin-bottom: 0;
            padding-bottom: 0;
        }

        .detail-label {
            font-weight: 600;
            color: #666;
            margin-bottom: 0.25rem;
            display: block;
        }

        .detail-value {
            font-size: 1.1rem;
        }

        .actions-card {
            background-color: white;
            border-radius: var(--border-radius);
            box-shadow: var(--box-shadow);
            padding: 1.5rem;
        }

        .section-title {
            color: var(--primary-color);
            margin-bottom: 1.5rem;
            padding-bottom: 0.5rem;
            border-bottom: 2px solid var(--light-gray);
        }

        .action-btn {
            display: block;
            width: 100%;
            padding: 0.75rem;
            margin-bottom: 1rem;
            border: none;
            border-radius: var(--border-radius);
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s;
            text-align: center;
            text-decoration: none;
        }

        .update-email {
            background-color: var(--primary-color);
            color: white;
        }

        .update-email:hover {
            background-color: var(--secondary-color);
        }

        .update-password {
            background-color: #3498db;
            color: white;
        }

        .update-password:hover {
            background-color: #2980b9;
        }

        .delete-account {
            background-color: var(--danger-color);
            color: white;
        }

        .delete-account:hover {
            background-color: #c0392b;
        }

        .submit-feedback {
            background-color: #f1c40f;
            color: white;
        }

        .submit-feedback:hover {
            background-color: #d4ac0d;
        }

        .feedback-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 1rem;
        }

        .feedback-table th, .feedback-table td {
            padding: 0.75rem;
            border-bottom: 1px solid #eee;
            text-align: left;
        }

        .feedback-table th {
            background-color: var(--light-gray);
            color: var(--primary-color);
        }

        .feedback-actions {
            display: flex;
            gap: 0.5rem;
        }

        .edit-feedback {
            background-color: #3498db;
            color: white;
            padding: 0.5rem 1rem;
            border-radius: var(--border-radius);
            text-decoration: none;
        }

        .edit-feedback:hover {
            background-color: #2980b9;
        }

        .delete-feedback {
            background-color: var(--danger-color);
            color: white;
            padding: 0.5rem 1rem;
            border-radius: var(--border-radius);
            border: none;
            cursor: pointer;
        }

        .delete-feedback:hover {
            background-color: #c0392b;
        }

        .modal {
            display: none;
            position: fixed;
            z-index: 100;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5);
            overflow: auto;
        }

        .modal-content {
            background-color: white;
            margin: 10% auto;
            padding: 2rem;
            border-radius: var(--border-radius);
            width: 90%;
            max-width: 500px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.3);
            position: relative;
        }

        .close-btn {
            position: absolute;
            top: 1rem;
            right: 1rem;
            font-size: 1.5rem;
            cursor: pointer;
            color: #999;
        }

        .close-btn:hover {
            color: #666;
        }

        .modal-title {
            color: var(--primary-color);
            margin-bottom: 1.5rem;
        }

        .form-group {
            margin-bottom: 1.5rem;
        }

        .form-group label {
            display: block;
            margin-bottom: 0.5rem;
            font-weight: 500;
        }

        .form-group input, .form-group textarea {
            width: 100%;
            padding: 0.75rem;
            border: 1px solid #ddd;
            border-radius: var(--border-radius);
            font-size: 1rem;
        }

        .submit-btn {
            background-color: var(--success-color);
            color: white;
            border: none;
            padding: 0.75rem 1.5rem;
            border-radius: var(--border-radius);
            cursor: pointer;
            font-weight: 500;
            transition: background-color 0.3s;
        }

        .submit-btn:hover {
            background-color: #27ae60;
        }

        .error-message {
            color: var(--danger-color);
            margin-top: 1rem;
            font-size: 0.9rem;
        }

        .success-message {
            color: var(--success-color);
            margin-top: 1rem;
            font-size: 0.9rem;
        }

        @media (max-width: 768px) {
            .account-section {
                grid-template-columns: 1fr;
            }

            .modal-content {
                margin: 20% auto;
                width: 95%;
            }
        }
    </style>
</head>
<body>
<div class="container">
    <header>
        <div class="welcome-message">
            <h1>Welcome, ${user.name}!</h1>
            <p>Manage your salon booking account</p>
        </div>
        <div class="header-actions">
            <a href="landingPage.jsp" class="home-btn">Back to Home</a>
            <a href="LogoutServlet" class="logout-btn">Logout</a>
        </div>
    </header>

    <div class="account-section">
        <div class="profile-card">
            <div class="profile-header">
                <div class="profile-icon">
                    ${user.name.charAt(0)}
                </div>
                <div class="profile-info">
                    <h2>${user.name}</h2>
                    <p>Salon Customer</p>
                </div>
            </div>

            <div class="account-details">
                <div class="detail-item">
                    <span class="detail-label">Customer ID</span>
                    <span class="detail-value">${user.customerId}</span>
                </div>
                <div class="detail-item">
                    <span class="detail-label">Email Address</span>
                    <span class="detail-value">${user.email}</span>
                </div>
                <div class="detail-item">
                    <span class="detail-label">Member Since</span>
                    <span class="detail-value">Today</span>
                </div>
            </div>
        </div>

        <div class="actions-card">
            <h3 class="section-title">Account Actions</h3>

            <button class="action-btn update-email" onclick="openModal('emailModal')">
                Update Email Address
            </button>

            <button class="action-btn update-password" onclick="openModal('passwordModal')">
                Change Password
            </button>

            <button class="action-btn delete-account" onclick="openModal('deleteModal')">
                Delete My Account
            </button>

            <h3 class="section-title">My Feedback</h3>
            <button class="action-btn submit-feedback" onclick="openModal('feedbackModal')">
                Submit New Feedback
            </button>

            <c:choose>
                <c:when test="${empty userFeedbacks}">
                    <p class="no-feedback-message">No feedback submitted yet.</p>
                </c:when>
                <c:otherwise>
                    <table class="feedback-table">
                        <thead>
                        <tr>
                            <th>Feedback ID</th>
                            <th>Feedback</th>
                            <th>Actions</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="feedback" items="${userFeedbacks}">
                            <tr>
                                <td>${feedback.feedbackId}</td>
                                <td>${feedback.feedback}</td>
                                <td class="feedback-actions">
                                    <a href="#" class="edit-feedback" onclick="openEditFeedbackModal(${feedback.feedbackId}, '${feedback.feedback.replace("'", "\\'")}')">Edit</a>
                                    <form action="FeedbackServlet" method="post" style="display:inline;">
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="feedbackId" value="${feedback.feedbackId}">
                                        <button type="submit" class="delete-feedback">Delete</button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </c:otherwise>
            </c:choose>

            <% if (request.getAttribute("success") != null) { %>
            <div class="success-message">
                <%= request.getAttribute("success") %>
            </div>
            <% } %>

            <% if (request.getAttribute("error") != null) { %>
            <div class="error-message">
                <%= request.getAttribute("error") %>
            </div>
            <% } %>
        </div>
    </div>
</div>

<!-- Update Email Modal -->
<div id="emailModal" class="modal">
    <div class="modal-content">
        <span class="close-btn" onclick="closeModal('emailModal')">×</span>
        <h3 class="modal-title">Update Email Address</h3>
        <form action="UpdateEmailServlet" method="post">
            <div class="form-group">
                <label for="newEmail">New Email</label>
                <input type="email" id="newEmail" name="newEmail" required>
            </div>
            <div class="form-group">
                <label for="currentPasswordEmail">Current Password</label>
                <input type="password" id="currentPasswordEmail" name="currentPassword" required>
            </div>
            <button type="submit" class="submit-btn">Update Email</button>
        </form>
    </div>
</div>

<!-- Update Password Modal -->
<div id="passwordModal" class="modal">
    <div class="modal-content">
        <span class="close-btn" onclick="closeModal('passwordModal')">×</span>
        <h3 class="modal-title">Change Password</h3>
        <form action="UpdatePasswordServlet" method="post" onsubmit="return validatePasswordChange()">
            <div class="form-group">
                <label for="currentPassword">Current Password</label>
                <input type="password" id="currentPassword" name="currentPassword" required>
            </div>
            <div class="form-group">
                <label for="newPassword">New Password</label>
                <input type="password" id="newPassword" name="newPassword" required>
            </div>
            <div class="form-group">
                <label for="confirmPassword">Confirm New Password</label>
                <input type="password" id="confirmPassword" name="confirmPassword" required>
            </div>
            <div id="passwordError" class="error-message"></div>
            <button type="submit" class="submit-btn">Change Password</button>
        </form>
    </div>
</div>

<!-- Delete Account Modal -->
<div id="deleteModal" class="modal">
    <div class="modal-content">
        <span class="close-btn" onclick="closeModal('deleteModal')">×</span>
        <h3 class="modal-title">Delete Account</h3>
        <p>Are you sure you want to delete your account? This action cannot be undone. All your data will be permanently removed.</p>
        <form action="DeleteAccountServlet" method="post">
            <div class="form-group">
                <label for="confirmPasswordDelete">Enter your password to confirm</label>
                <input type="password" id="confirmPasswordDelete" name="password" required>
            </div>
            <button type="submit" class="submit-btn" style="background-color: var(--danger-color);">
                Permanently Delete Account
            </button>
        </form>
    </div>
</div>

<!-- Submit Feedback Modal -->
<div id="feedbackModal" class="modal">
    <div class="modal-content">
        <span class="close-btn" onclick="closeModal('feedbackModal')">×</span>
        <h3 class="modal-title">Submit Feedback</h3>
        <form action="FeedbackServlet" method="post">
            <input type="hidden" name="action" value="create">
            <input type="hidden" name="userId" value="${user.customerId}">
            <input type="hidden" name="userName" value="${user.name}">
            <div class="form-group">
                <label for="feedbackText">Your Feedback</label>
                <textarea id="feedbackText" name="feedback" rows="4" required></textarea>
            </div>
            <button type="submit" class="submit-btn">Submit Feedback</button>
        </form>
    </div>
</div>

<!-- Edit Feedback Modal -->
<div id="editFeedbackModal" class="modal">
    <div class="modal-content">
        <span class="close-btn" onclick="closeModal('editFeedbackModal')">×</span>
        <h3 class="modal-title">Edit Feedback</h3>
        <form action="FeedbackServlet" method="post">
            <input type="hidden" name="action" value="update">
            <input type="hidden" id="editFeedbackId" name="feedbackId">
            <input type="hidden" name="userId" value="${user.customerId}">
            <input type="hidden" name="userName" value="${user.name}">
            <div class="form-group">
                <label for="editFeedbackText">Your Feedback</label>
                <textarea id="editFeedbackText" name="feedback" rows="4" required></textarea>
            </div>
            <button type="submit" class="submit-btn">Update Feedback</button>
        </form>
    </div>
</div>

<script>
    function openModal(modalId) {
        document.getElementById(modalId).style.display = 'block';
    }

    function closeModal(modalId) {
        document.getElementById(modalId).style.display = 'none';
        document.getElementById('passwordError').textContent = '';
    }

    function openEditFeedbackModal(feedbackId, feedbackText) {
        document.getElementById('editFeedbackId').value = feedbackId;
        document.getElementById('editFeedbackText').value = feedbackText;
        openModal('editFeedbackModal');
    }

    window.onclick = function(event) {
        if (event.target.className === 'modal') {
            document.querySelectorAll('.modal').forEach(modal => {
                modal.style.display = 'none';
            });
        }
    }

    function validatePasswordChange() {
        const newPassword = document.getElementById('newPassword').value;
        const confirmPassword = document.getElementById('confirmPassword').value;
        const errorElement = document.getElementById('passwordError');

        if (newPassword !== confirmPassword) {
            errorElement.textContent = "Passwords do not match!";
            return false;
        }

        if (newPassword.length < 8) {
            errorElement.textContent = "Password must be at least 8 characters long!";
            return false;
        }

        return true;
    }
</script>
</body>
</html>