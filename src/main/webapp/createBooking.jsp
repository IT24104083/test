<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
  <title>Create Booking - Salon Booking System</title>
  <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;700&family=Lora:wght@400;500&display=swap" rel="stylesheet">
  <style>
    :root {
      --primary-color: #6a5acd; /* Deep purple */
      --secondary-color: #9370db; /* Lighter purple */
      --accent-color: #d4af37; /* Soft gold */
      --danger-color: #e74c3c;
      --success-color: #2ecc71;
      --text-color: #2e2e2e; /* Darker gray */
      --light-gray: #f8f1e9; /* Creamy white */
      --border-radius: 8px;
      --box-shadow: 0 6px 12px rgba(0, 0, 0, 0.15);
      --gradient-bg: linear-gradient(135deg, #6a5acd, #9370db);
    }
    * {
      box-sizing: border-box;
      margin: 0;
      padding: 0;
      font-family: 'Lora', serif;
    }
    body {
      background: url('images/salon-bg.jpeg') no-repeat center center/cover;
      background-attachment: fixed;
      color: var(--text-color);
      line-height: 1.6;
      position: relative;
    }
    body::before {
      content: '';
      position: fixed;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      background: rgba(255, 245, 238, 0.9); /* Warmer creamy overlay */
      z-index: -1;
    }
    .container {
      max-width: 800px;
      margin: 2rem auto;
      padding: 0 1rem;
    }
    .form-card {
      background-color: white;
      border-radius: var(--border-radius);
      box-shadow: var(--box-shadow);
      padding: 2rem;
    }
    .section-title {
      font-family: 'Playfair Display', serif;
      color: var(--primary-color);
      margin-bottom: 1.5rem;
      padding-bottom: 0.5rem;
      border-bottom: 2px solid var(--light-gray);
      font-size: 28px;
    }
    .form-group {
      margin-bottom: 1.5rem;
    }
    .form-group label {
      font-family: 'Lora', serif;
      display: block;
      margin-bottom: 0.5rem;
      font-weight: 500;
      font-size: 14px;
    }
    .form-group select, .form-group input {
      width: 100%;
      padding: 0.75rem;
      border: 1px solid #ddd;
      border-radius: var(--border-radius);
      font-family: 'Lora', serif;
      font-size: 1rem;
      background-color: #fafafa;
    }
    .form-group select:focus, .form-group input:focus {
      border-color: var(--primary-color);
      outline: none;
      box-shadow: 0 0 5px rgba(106, 90, 205, 0.3);
    }
    .form-group .checkbox-group {
      max-height: 200px;
      overflow-y: auto;
      padding: 0.5rem;
      border: 1px solid #ddd;
      border-radius: var(--border-radius);
      background-color: #fafafa;
    }
    .form-group .checkbox-group div {
      font-family: 'Lora', serif;
      margin-bottom: 0.5rem;
    }
    .submit-btn {
      background-color: var(--success-color);
      color: white;
      border: none;
      padding: 0.75rem 1.5rem;
      border-radius: var(--border-radius);
      cursor: pointer;
      font-family: 'Lora', serif;
      font-weight: 500;
      font-size: 16px;
      transition: background-color 0.3s, transform 0.3s, box-shadow 0.3s;
      box-shadow: var(--box-shadow);
    }
    .submit-btn:hover {
      background-color: #27ae60;
      transform: scale(1.05);
      box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2);
    }
    .cancel-btn {
      background-color: #666;
      color: white;
      border: none;
      padding: 0.75rem 1.5rem;
      border-radius: var(--border-radius);
      cursor: pointer;
      text-decoration: none;
      font-family: 'Lora', serif;
      font-weight: 500;
      font-size: 16px;
      transition: background-color 0.3s, transform 0.3s, box-shadow 0.3s;
      display: inline-block;
      margin-left: 1rem;
      box-shadow: var(--box-shadow);
    }
    .cancel-btn:hover {
      background-color: #555;
      transform: scale(1.05);
      box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2);
    }
    .error-message {
      font-family: 'Lora', serif;
      color: var(--danger-color);
      margin-top: 1rem;
      font-size: 0.9rem;
      background-color: #fee2e2;
      padding: 0.75rem;
      border-radius: var(--border-radius);
    }
    .success-message {
      font-family: 'Lora', serif;
      color: var(--success-color);
      margin-top: 1rem;
      font-size: 0.9rem;
      background-color: #d1fae5;
      padding: 0.75rem;
      border-radius: var(--border-radius);
    }
    @media (max-width: 768px) {
      .container {
        margin: 1rem auto;
        padding: 0 0.5rem;
      }
      .section-title {
        font-size: 24px;
      }
    }
  </style>
</head>
<body>
<div class="container">
  <div class="form-card">
    <h3 class="section-title">Create Booking</h3>
    <c:if test="${not empty error}">
      <div class="error-message">${error}</div>
    </c:if>
    <c:if test="${not empty success}">
      <div class="success-message">${success}</div>
    </c:if>
    <form action="${pageContext.request.contextPath}/bookings/create" method="post">
      <div class="form-group">
        <label for="scheduleId">Select Schedule</label>
        <select id="scheduleId" name="scheduleId" required>
          <option value="">Choose a schedule</option>
          <c:forEach var="schedule" items="${schedules}">
            <option value="${schedule.scheduleId}">
                ${schedule.date} at ${schedule.time} with ${schedule.employeeName}
            </option>
          </c:forEach>
        </select>
      </div>
      <div class="form-group">
        <label>Select Services</label>
        <div class="checkbox-group">
          <c:forEach var="service" items="${services}">
            <div>
              <input type="checkbox" name="serviceIds" value="${service.serviceId}">
                ${service.serviceName} - $${service.price}
            </div>
          </c:forEach>
        </div>
      </div>
      <button type="submit" class="submit-btn">Create Booking</button>
      <a href="${pageContext.request.contextPath}/bookings" class="cancel-btn">Cancel</a>
    </form>
  </div>
</div>
<script>
  document.querySelector('form').addEventListener('submit', function(e) {
    const serviceCheckboxes = document.querySelectorAll('input[name="serviceIds"]:checked');
    if (serviceCheckboxes.length === 0) {
      e.preventDefault();
      alert('Please select at least one service.');
    }
  });
</script>
</body>
</html>