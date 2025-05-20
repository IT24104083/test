<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
  <title>View Employee Appointments - Salon Booking System</title>
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
      max-width: 1200px;
      margin: 2rem auto;
      padding: 0 1rem;
    }

    header {
      background: var(--gradient-bg);
      padding: 1.5rem;
      border-radius: var(--border-radius);
      box-shadow: var(--box-shadow);
      margin-bottom: 2rem;
      color: white;
    }

    .section-title {
      font-family: 'Playfair Display', serif;
      color: var(--primary-color);
      margin-bottom: 1.5rem;
      padding-bottom: 0.5rem;
      border-bottom: 2px solid var(--light-gray);
      font-size: 28px;
    }

    .card {
      background-color: white;
      border-radius: var(--border-radius);
      box-shadow: var(--box-shadow);
      padding: 2rem;
      margin-bottom: 2rem;
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
      color: var(--text-color);
    }

    .form-group select {
      width: 100%;
      padding: 0.75rem;
      border: 1px solid #ddd;
      border-radius: var(--border-radius);
      font-family: 'Lora', serif;
      font-size: 1rem;
      background-color: #fafafa;
    }

    .form-group select:focus {
      border-color: var(--primary-color);
      outline: none;
      box-shadow: 0 0 5px rgba(106, 90, 205, 0.3);
    }

    .table {
      width: 100%;
      border-collapse: collapse;
      margin-top: 1rem;
      background-color: white;
    }

    .table th, .table td {
      padding: 1rem;
      border-bottom: 1px solid #eee;
      text-align: left;
      font-family: 'Lora', serif;
    }

    .table th {
      background-color: var(--light-gray);
      color: var(--primary-color);
      font-family: 'Playfair Display', serif;
      font-weight: 500;
    }

    .table tr:nth-child(even) {
      background-color: #fafafa;
    }

    .back-btn {
      background-color: var(--accent-color);
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
      margin-top: 1rem;
      box-shadow: var(--box-shadow);
    }

    .back-btn:hover {
      background-color: var(--secondary-color);
      transform: scale(1.05);
      box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2);
    }

    .no-appointments-message {
      font-family: 'Lora', serif;
      color: #666;
      font-size: 16px;
      margin-top: 1rem;
    }

    @media (max-width: 768px) {
      .container {
        padding: 0 0.5rem;
      }

      .section-title {
        font-size: 24px;
      }

      .table th, .table td {
        padding: 0.5rem;
        font-size: 0.9rem;
      }
    }
  </style>
</head>
<body>
<div class="container">
  <header>
    <h3 class="section-title">View Employee Appointments</h3>
  </header>
  <div class="card">
    <form action="${pageContext.request.contextPath}/employeeAppointments" method="get">
      <div class="form-group">
        <label for="employeeId">Select Employee</label>
        <select id="employeeId" name="employeeId" onchange="this.form.submit()">
          <option value="">Select an employee</option>
          <c:forEach var="employee" items="${employees}">
            <option value="${employee.employeeId}" ${param.employeeId == employee.employeeId ? 'selected' : ''}>
                ${employee.name}
            </option>
          </c:forEach>
        </select>
      </div>
    </form>
    <c:if test="${not empty employeeAppointments}">
      <table class="table">
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
        <c:forEach var="booking" items="${employeeAppointments}">
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
    </c:if>
    <c:if test="${empty employeeAppointments and not empty param.employeeId}">
      <p class="no-appointments-message">No appointments found for this employee.</p>
    </c:if>
    <a href="${pageContext.request.contextPath}/bookings" class="back-btn">Back to Account</a>
  </div>
</div>
</body>
</html>

