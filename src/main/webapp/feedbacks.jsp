<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
  <title>Customer Feedback - Salon Maleesha</title>
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
      display: flex;
      justify-content: space-between;
      align-items: center;
      color: white;
    }

    .header-title h1 {
      font-family: 'Playfair Display', serif;
      margin-bottom: 0.5rem;
      font-size: 32px;
    }

    .header-title p {
      font-family: 'Lora', serif;
      font-size: 16px;
    }

    .home-btn {
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
      box-shadow: var(--box-shadow);
    }

    .home-btn:hover {
      background-color: var(--secondary-color);
      transform: scale(1.05);
      box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2);
    }

    .feedback-card {
      background-color: white;
      border-radius: var(--border-radius);
      box-shadow: var(--box-shadow);
      padding: 1.5rem;
    }

    .section-title {
      font-family: 'Playfair Display', serif;
      color: var(--primary-color);
      margin-bottom: 1.5rem;
      padding-bottom: 0.5rem;
      border-bottom: 2px solid var(--light-gray);
      font-size: 28px;
    }

    .feedback-table {
      width: 100%;
      border-collapse: collapse;
      margin-top: 1rem;
      background-color: white;
    }

    .feedback-table th, .feedback-table td {
      padding: 0.75rem;
      border: 1px solid #ddd;
      text-align: left;
      font-family: 'Lora', serif;
    }

    .feedback-table th {
      background-color: var(--primary-color);
      color: white;
      font-family: 'Playfair Display', serif;
      font-weight: 500;
    }

    .feedback-table tr:nth-child(even) {
      background-color: #f9f9f9;
    }

    .no-feedback-message {
      font-family: 'Lora', serif;
      color: #666;
      font-size: 16px;
      margin-top: 1rem;
    }

    @media (max-width: 768px) {
      .container {
        padding: 0 0.5rem;
      }

      .header-title h1 {
        font-size: 24px;
      }

      .section-title {
        font-size: 24px;
      }

      .feedback-table th, .feedback-table td {
        padding: 0.5rem;
        font-size: 0.9rem;
      }
    }
  </style>
</head>
<body>
<div class="container">
  <header>
    <div class="header-title">
      <h1>Customer Feedback</h1>
      <p>What our customers say about Salon Maleesha</p>
    </div>
    <a href="landingPage.jsp" class="home-btn">Back to Home</a>
  </header>

  <div class="feedback-card">
    <h3 class="section-title">All Feedback</h3>
    <c:choose>
      <c:when test="${empty allFeedbacks}">
        <p class="no-feedback-message">No feedback available yet.</p>
      </c:when>
      <c:otherwise>
        <table class="feedback-table">
          <thead>
          <tr>
            <th>Feedback ID</th>
            <th>Customer</th>
            <th>Feedback</th>
          </tr>
          </thead>
          <tbody>
          <c:forEach var="feedback" items="${allFeedbacks}">
            <tr>
              <td><c:out value="${feedback.feedbackId}"/></td>
              <td><c:out value="${feedback.customerName}"/></td>
              <td><c:out value="${feedback.feedback}"/></td>
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