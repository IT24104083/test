<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
  <title>Employee Profile - Salon Booking System</title>
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
      max-width: 800px;
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

    .profile-card {
      background-color: white;
      border-radius: var(--border-radius);
      box-shadow: var(--box-shadow);
      padding: 2rem;
    }

    .section-title {
      color: var(--primary-color);
      margin-bottom: 1.5rem;
      padding-bottom: 0.5rem;
      border-bottom: 2px solid var(--light-gray);
    }

    .detail-item {
      margin-bottom: 1rem;
      padding-bottom: 1rem;
      border-bottom: 1px solid #eee;
    }

    .detail-item:last-child {
      border-bottom: none;
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

    .form-group {
      margin-bottom: 1.5rem;
    }

    .form-group label {
      display: block;
      margin-bottom: 0.5rem;
      font-weight: 500;
    }

    .form-group input {
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
      width: 100%;
      transition: background-color 0.3s;
    }

    .submit-btn:hover {
      background-color: #27ae60;
    }

    .error-message {
      color: var(--danger-color);
      margin-top: 1rem;
      font-size: 0.9rem;
      background-color: #fee2e2;
      padding: 0.75rem;
      border-radius: var(--border-radius);
    }

    .success-message {
      color: var(--success-color);
      margin-top: 1rem;
      font-size: 0.9rem;
      background-color: #d1fae5;
      padding: 0.75rem;
      border-radius: var(--border-radius);
    }

    @media (max-width: 768px) {
      .container {
        padding: 0 0.5rem;
      }
    }
  </style>
</head>
<body>
<div class="container">
  <header>
    <div class="welcome-message">
      <h1>Welcome, ${employee.name}!</h1>
      <p>Manage your employee account</p>
    </div>
    <div class="header-actions">
      <a href="landingPage.jsp" class="home-btn">Home</a>
      <a href="EmployeeLogoutServlet" class="logout-btn">Logout</a>
    </div>
  </header>

  <div class="profile-card">
    <h3 class="section-title">Employee Details</h3>
    <div class="detail-item">
      <span class="detail-label">Employee ID</span>
      <span class="detail-value">${employee.employeeId}</span>
    </div>
    <div class="detail-item">
      <span class="detail-label">Name</span>
      <span class="detail-value">${employee.name}</span>
    </div>
    <div class="detail-item">
      <span class="detail-label">Email</span>
      <span class="detail-value">${employee.email}</span>
    </div>

    <h3 class="section-title">Update Details</h3>
    <form action="EmployeeUpdateServlet" method="post">
      <input type="hidden" name="employeeId" value="${employee.employeeId}">
      <div class="form-group">
        <label for="name">Full Name</label>
        <input type="text" id="name" name="name" value="${employee.name}" required>
      </div>
      <div class="form-group">
        <label for="email">Email Address</label>
        <input type="email" id="email" name="email" value="${employee.email}" required>
      </div>
      <div class="form-group">
        <label for="currentPassword">Current Password</label>
        <input type="password" id="currentPassword" name="currentPassword" required>
      </div>
      <div class="form-group">
        <label for="password">New Password (leave blank to keep current)</label>
        <input type="password" id="password" name="password">
      </div>
      <button type="submit" class="submit-btn">Update Profile</button>
    </form>

    <c:if test="${not empty success}">
      <div class="success-message">
        <c:out value="${success}"/>
      </div>
    </c:if>
    <c:if test="${not empty error}">
      <div class="error-message">
        <c:out value="${error}"/>
      </div>
    </c:if>
  </div>
</div>
</body>
</html>