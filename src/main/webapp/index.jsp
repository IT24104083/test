<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
  <title>Salon Booking - Register</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      background-color: #f5f5f5;
      margin: 0;
      padding: 0;
      display: flex;
      justify-content: center;
      align-items: center;
      height: 100vh;
    }
    .container {
      background-color: white;
      padding: 30px;
      border-radius: 8px;
      box-shadow: 0 2px 10px rgba(0,0,0,0.1);
      width: 350px;
    }
    h2 {
      text-align: center;
      color: #333;
      margin-bottom: 20px;
    }
    .form-group {
      margin-bottom: 15px;
    }
    label {
      display: block;
      margin-bottom: 5px;
      font-weight: bold;
      color: #555;
    }
    input[type="text"],
    input[type="email"],
    input[type="password"] {
      width: 100%;
      padding: 10px;
      border: 1px solid #ddd;
      border-radius: 4px;
      box-sizing: border-box;
    }
    button {
      background-color: #4CAF50;
      color: white;
      padding: 10px 15px;
      border: none;
      border-radius: 4px;
      cursor: pointer;
      width: 100%;
      font-size: 16px;
    }
    button:hover {
      background-color: #45a049;
    }
    .error {
      color: red;
      font-size: 14px;
      margin-top: 5px;
    }
    .login-link {
      text-align: center;
      margin-top: 15px;
    }
  </style>
</head>
<body>
<div class="container">
  <h2>Register for Salon Booking</h2>
  <form id="registerForm" action="RegisterServlet" method="post" onsubmit="return validateForm()">
    <div class="form-group">
      <label for="name">Full Name</label>
      <input type="text" id="name" name="name" required>
    </div>
    <div class="form-group">
      <label for="email">Email</label>
      <input type="email" id="email" name="email" required>
    </div>
    <div class="form-group">
      <label for="password">Password</label>
      <input type="password" id="password" name="password" required>
    </div>
    <div class="form-group">
      <label for="confirmPassword">Confirm Password</label>
      <input type="password" id="confirmPassword" name="confirmPassword" required>
      <div id="passwordError" class="error">
        <% if(request.getAttribute("error") != null) { %>
        <%= request.getAttribute("error") %>
        <% } %>
      </div>
    </div>
    <button type="submit">Register</button>
  </form>
  <div class="login-link">
    Already have an account? <a href="login.jsp">Login here</a>
  </div>
</div>

<script>
  function validateForm() {
    const password = document.getElementById('password').value;
    const confirmPassword = document.getElementById('confirmPassword').value;
    const errorElement = document.getElementById('passwordError');

    if (password !== confirmPassword) {
      errorElement.textContent = "Passwords do not match!";
      return false;
    }

    if (password.length < 6) {
      errorElement.textContent = "Password must be at least 6 characters!";
      return false;
    }

    errorElement.textContent = "";
    return true;
  }
</script>
</body>
</html>