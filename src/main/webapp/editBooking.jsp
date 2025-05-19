<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
  <title>Edit Booking - Salon Booking System</title>
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
    .form-card {
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
    .form-group {
      margin-bottom: 1.5rem;
    }
    .form-group label {
      display: block;
      margin-bottom: 0.5rem;
      font-weight: 500;
    }
    .form-group select, .form-group input {
      width: 100%;
      padding: 0.75rem;
      border: 1px solid #ddd;
      border-radius: var(--border-radius);
      font-size: 1rem;
    }
    .form-group .checkbox-group {
      max-height: 200px;
      overflow-y: auto;
      padding: 0.5rem;
      border: 1px solid #ddd;
      border-radius: var(--border-radius);
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
    .cancel-btn {
      background-color: #666;
      color: white;
      border: none;
      padding: 0.75rem 1.5rem;
      border-radius: var(--border-radius);
      cursor: pointer;
      text-decoration: none;
      font-weight: 500;
      transition: background-color 0.3s;
      display: inline-block;
      margin-left: 1rem;
    }
    .cancel-btn:hover {
      background-color: #555;
    }
    .error-message {
      color: var(--danger-color);
      margin-top: 1rem;
      font-size: 0.9rem;
      background-color: #fee2e2;
      padding: 0.75rem;
      border-radius: var(--border-radius);
    }
  </style>
</head>
<body>
<div class="container">
  <div class="form-card">
    <h3 class="section-title">Edit Booking</h3>
    <c:if test="${not empty error}">
      <div class="error-message">${error}</div>
    </c:if>
    <form action="${pageContext.request.contextPath}/bookings/edit" method="post">
      <input type="hidden" name="bookingId" value="${booking.bookingId}">
      <div class="form-group">
        <label for="scheduleId">Select Schedule</label>
        <select id="scheduleId" name="scheduleId" required>
          <option value="">Choose a schedule</option>
          <c:forEach var="schedule" items="${schedules}">
            <option value="${schedule.scheduleId}" ${schedule.scheduleId == booking.scheduleId ? 'selected' : ''}>
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
              <input type="checkbox" name="serviceIds" value="${service.serviceId}"
                     <c:if test="${booking.serviceIds.contains(service.serviceId)}">checked</c:if>>
                ${service.serviceName} - $${service.price}
            </div>
          </c:forEach>
        </div>
      </div>
      <button type="submit" class="submit-btn">Update Booking</button>
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