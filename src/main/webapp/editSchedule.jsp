<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page import="com.example.models.Schedule, com.example.filehandler.ScheduleFileHandler" %>
<%
  int scheduleId = Integer.parseInt(request.getParameter("scheduleId"));
  Schedule schedule = null;
  try {
    ScheduleFileHandler fileHandler = new ScheduleFileHandler();
    for (Schedule s : fileHandler.readSchedules()) {
      if (s.getScheduleId() == scheduleId) {
        schedule = s;
        break;
      }
    }
  } catch (Exception e) {
    request.getSession().setAttribute("error", "Error loading schedule: " + e.getMessage());
    response.sendRedirect(request.getContextPath() + "/schedules");
    return;
  }
  if (schedule == null) {
    request.getSession().setAttribute("error", "Schedule not found!");
    response.sendRedirect(request.getContextPath() + "/schedules");
    return;
  }
  request.setAttribute("schedule", schedule);

  // Convert time (double) to hour and minute for form
  int hour = (int) schedule.getTime();
  int minute = (int) Math.round((schedule.getTime() - hour) * 60);
  // Adjust minute to nearest 15-minute increment
  minute = (minute / 15) * 15;
  request.setAttribute("hour", hour);
  request.setAttribute("minute", minute);
%>
<html>
<head>
  <title>Edit Schedule - Salon Booking System</title>
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
      max-width: 600px;
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
      font-size: 24px;
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

    @media (max-width: 768px) {
      .container {
        padding: 0 0.5rem;
      }

      .section-title {
        font-size: 20px;
      }
    }
  </style>
</head>
<body>
<div class="container">
  <div class="form-card">
    <h3 class="section-title">Edit Schedule</h3>
    <form action="${pageContext.request.contextPath}/schedules/update" method="post" id="scheduleForm">
      <input type="hidden" name="scheduleId" value="${schedule.scheduleId}">
      <div class="form-group">
        <label for="date">Date</label>
        <input type="date" id="date" name="date" value="${schedule.date}" required>
      </div>
      <div class="form-group">
        <label>Time</label>
        <div class="time-group">
          <select id="hour" name="hour" required>
            <option value="" disabled>Hour</option>
            <c:forEach var="h" begin="9" end="17">
              <option value="${h}" ${h == hour ? 'selected' : ''}>${h}</option>
            </c:forEach>
          </select>
          <select id="minute" name="minute" required>
            <option value="" disabled>Minute</option>
            <option value="0" ${minute == 0 ? 'selected' : ''}>00</option>
            <option value="15" ${minute == 15 ? 'selected' : ''}>15</option>
            <option value="30" ${minute == 30 ? 'selected' : ''}>30</option>
            <option value="45" ${minute == 45 ? 'selected' : ''}>45</option>
          </select>
        </div>
      </div>
      <button type="submit" class="submit-btn">Update Schedule</button>
      <a href="${pageContext.request.contextPath}/schedules" class="cancel-btn">Cancel</a>
    </form>
  </div>
</div>
<script>
  document.getElementById('scheduleForm').addEventListener('submit', function(e) {
    const dateInput = document.getElementById('date').value;
    const today = new Date();
    today.setHours(0, 0, 0, 0);
    const selectedDate = new Date(dateInput);

    if (selectedDate < today) {
      e.preventDefault();
      alert('Please select a future date or today.');
    }
  });
</script>
</body>
</html>