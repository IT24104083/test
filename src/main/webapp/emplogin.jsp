<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
  <title>Employee Login - Salon Booking System</title>
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
      max-width: 500px;
      margin: 2rem auto;
      padding: 0 1rem;
    }

    .login-card {
      background-color: white;
      border-radius: var(--border-radius);
      box-shadow: var(--box-shadow);
      padding: 2rem;
    }

    h1 {
      color: var(--primary-color);
      margin-bottom: 1.5rem;
      text-align: center;
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
      text-align: center;
    }

    .register-link {
      text-align: center;
      margin-top: 1rem;
    }

    .register-link a {
      color: var(--primary-color);
      text-decoration: none;
    }

    .register-link a:hover {
      text-decoration: underline;
    }
  </style>
</head>
<body>
<div class="container">
  <div class="login-card">
    <h1>Employee Login</h1>
    <form action="EmployeeLoginServlet" method="post">
      <div class="form-group">
        <label for="email">Email Address</label>
        <input type="email" id="email" name="email" required>
      </div>
      <div class="form-group">
        <label for="password">Password</label>
        <input type="password" id="password" name="password" required>
      </div>
      <button type="submit" class="submit-btn">Login</button>
    </form>
    <div class="register-link">
      <p>Don't have an account? <a href="employeeRegister.jsp">Register here</a></p>
    </div>
    <% if (request.getAttribute("error") != null) { %>
    <div class="error-message">
      <%= request.getAttribute("error") %>
    </div>
    <% } %>
  </div>
</div>
</body>
</html>