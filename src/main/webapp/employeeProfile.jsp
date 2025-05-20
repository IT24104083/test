<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
  <title>Employee Profile - Salon Booking System</title>
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
    header {
      background: var(--gradient-bg);
      padding: 1.5rem;
      border-radius: var(--border-radius);
      box-shadow: var(--box-shadow);
      margin-bottom: 2rem;
      display: flex;
      justify-content: space-between;
      align-items: center;
      color: white;
    }
    .welcome-message h1 {
      font-family: 'Playfair Display', serif;
      margin-bottom: 0.5rem;
      font-size: 28px;
    }
    .welcome-message p {
      font-family: 'Lora', serif;
      font-size: 14px;
    }
    .header-actions {
      display: flex;
      gap: 1rem;
    }
    .logout-btn, .home-btn, .services-btn {
      background-color: var(--accent-color);
      color: white;
      border: none;
      padding: 0.5rem 1rem;
      border-radius: var(--border-radius);
      cursor: pointer;
      text-decoration: none;
      font-family: 'Lora', serif;
      font-weight: 500;
      font-size: 14px;
      transition: background-color 0.3s, transform 0.3s, box-shadow 0.3s;
      box-shadow: var(--box-shadow);
    }
    .logout-btn:hover, .home-btn:hover, .services-btn:hover {
      background-color: var(--secondary-color);
      transform: scale(1.05);
      box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2);
    }
    .profile-card {
      background-color: white;
      border-radius: var(--border-radius);
      box-shadow: var(--box-shadow);
      padding: 2rem;
      margin-bottom: 2rem;
    }
    .section-title {
      font-family: 'Playfair Display', serif;
      color: var(--primary-color);
      margin-bottom: 1.5rem;
      padding-bottom: 0.5rem;
      border-bottom: 2px solid var(--light-gray);
      font-size: 24px;
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
      font-family: 'Lora', serif;
      font-weight: 600;
      color: #666;
      margin-bottom: 0.25rem;
      display: block;
      font-size: 14px;
    }
    .detail-value {
      font-family: 'Lora', serif;
      font-size: 1.1rem;
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
    .form-group input, .form-group select {
      width: 100%;
      padding: 0.75rem;
      border: 1px solid #ddd;
      border-radius: var(--border-radius);
      font-family: 'Lora', serif;
      font-size: 1rem;
      background-color: #fafafa;
    }
    .form-group input:focus, .form-group select:focus {
      border-color: var(--primary-color);
      outline: none;
      box-shadow: 0 0 5px rgba(106, 90, 205, 0.3);
    }
    .form-group .time-group {
      display: flex;
      gap: 1rem;
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
    .schedule-table, .booking-table {
      width: 100%;
      border-collapse: collapse;
      margin-top: 1rem;
      background-color: white;
    }
    .schedule-table th, .schedule-table td, .booking-table th, .booking-table td {
      padding: 0.75rem;
      border: 1px solid #ddd;
      text-align: left;
      font-family: 'Lora', serif;
    }
    .schedule-table th, .booking-table th {
      background-color: var(--primary-color);
      color: white;
      font-family: 'Playfair Display', serif;
      font-weight: 500;
    }
    .schedule-table tr:nth-child(even), .booking-table tr:nth-child(even) {
      background-color: #f9f9f9;
    }
    .action-btn {
      padding: 0.5rem 1rem;
      border: none;
      border-radius: var(--border-radius);
      cursor: pointer;
      text-decoration: none;
      display: inline-block;
      margin-right: 0.5rem;
      font-family: 'Lora', serif;
      font-weight: 500;
      transition: background-color 0.3s, transform 0.3s;
    }
    .edit-btn {
      background-color: #f39c12;
      color: white;
    }
    .edit-btn:hover {
      background-color: #e67e22;
      transform: scale(1.05);
    }
    .delete-btn {
      background-color: var(--danger-color);
      color: white;
    }
    .delete-btn:hover {
      background-color: #c0392b;
      transform: scale(1.05);
    }
    .add-schedule-btn, .view-appointments-btn {
      background-color: var(--accent-color);
      color: white;
      padding: 0.75rem 1.5rem;
      border-radius: var(--border-radius);
      text-decoration: none;
      display: inline-block;
      margin-bottom: 1rem;
      font-family: 'Lora', serif;
      font-weight: 500;
      transition: background-color 0.3s, transform 0.3s, box-shadow 0.3s;
      box-shadow: var(--box-shadow);
    }
    .add-schedule-btn:hover, .view-appointments-btn:hover {
      background-color: var(--secondary-color);
      transform: scale(1.05);
      box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2);
    }
    @media (max-width: 768px) {
      .container {
        margin: 1rem auto;
        padding: 0 0.5rem;
      }
      .welcome-message h1 {
        font-size: 24px;
      }
      .section-title {
        font-size: 20px;
      }
      .header-actions {
        flex-direction: column;
        gap: 0.5rem;
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
      <a href="${pageContext.request.contextPath}/services" class="services-btn">Services</a>
      <a href="EmployeeLogoutServlet" class="logout-btn">Logout</a>
    </div>
  </header>

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
  </div>

  <div class="profile-card">
    <h3 class="section-title">Manage Schedules</h3>
    <a href="${pageContext.request.contextPath}/createSchedule.jsp" class="add-schedule-btn">Add New Schedule</a>
    <c:choose>
      <c:when test="${empty schedules}">
        <p>No schedules available.</p>
      </c:when>
      <c:otherwise>
        <table class="schedule-table">
          <thead>
          <tr>
            <th>ID</th>
            <th>Time</th>
            <th>Date</th>
            <th>Actions</th>
          </tr>
          </thead>
          <tbody>
          <c:forEach var="schedule" items="${schedules}">
            <tr>
              <td>${schedule.scheduleId}</td>
              <td>${schedule.time}</td>
              <td>${schedule.date}</td>
              <td>
                <a href="${pageContext.request.contextPath}/editSchedule.jsp?scheduleId=${schedule.scheduleId}" class="action-btn edit-btn">Edit</a>
                <form action="${pageContext.request.contextPath}/schedules/delete" method="post" style="display:inline;">
                  <input type="hidden" name="scheduleId" value="${schedule.scheduleId}">
                  <button type="submit" class="action-btn delete-btn" onclick="return confirm('Are you sure you want to delete this schedule?')">Delete</button>
                </form>
              </td>
            </tr>
          </c:forEach>
          </tbody>
        </table>
      </c:otherwise>
    </c:choose>
  </div>

  <div class="profile-card">
    <h3 class="section-title">My Bookings</h3>
    <a href="${pageContext.request.contextPath}/employeeAppointments?employeeId=${employee.employeeId}" class="view-appointments-btn">View Employee Appointments</a>
    <c:choose>
      <c:when test="${empty bookings}">
        <p>No bookings assigned.</p>
      </c:when>
      <c:otherwise>
        <table class="booking-table">
          <thead>
          <tr>
            <th>Booking ID</th>
            <th>Customer</th>
            <th>Date</th>
            <th>Time</th>
            <th>Services</th>
            <th>Total Price</th>
          </tr>
          </thead>
          <tbody>
          <c:forEach var="booking" items="${bookings}">
            <tr>
              <td>${booking.bookingId}</td>
              <td>${booking.customerName}</td>
              <td>${booking.date}</td>
              <td>${booking.time}</td>
              <td>
                <c:forEach var="serviceId" items="${booking.serviceIds}">
                  <c:forEach var="service" items="${services}">
                    <c:if test="${service.serviceId == serviceId}">
                      ${service.serviceName}<br>
                    </c:if>
                  </c:forEach>
                </c:forEach>
              </td>
              <td>$${booking.totalPrice}</td>
            </tr>
          </c:forEach>
          </tbody>
        </table>
      </c:otherwise>
    </c:choose>
  </div>
</div>
</body>
</html>