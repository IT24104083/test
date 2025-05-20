<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page import="com.example.models.Service, com.example.filehandler.ServiceFileHandler" %>
<%
  int serviceId = Integer.parseInt(request.getParameter("serviceId"));
  Service service = null;
  try {
    for (Service s : ServiceFileHandler.readServices()) {
      if (s.getServiceId() == serviceId) {
        service = s;
        break;
      }
    }
  } catch (Exception e) {
    request.getSession().setAttribute("error", "Error loading service: " + e.getMessage());
    response.sendRedirect(request.getContextPath() + "/services");
    return;
  }
  if (service == null) {
    request.getSession().setAttribute("error", "Service not found!");
    response.sendRedirect(request.getContextPath() + "/services");
    return;
  }
  request.setAttribute("service", service);
%>
<!DOCTYPE html>
<html>
<head>
  <title>Edit Service</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
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

    h2 {
      font-family: 'Playfair Display', serif;
      color: var(--primary-color);
      margin-bottom: 1.5rem;
      padding-bottom: 0.5rem;
      border-bottom: 2px solid var(--light-gray);
      font-size: 28px;
    }

    .mb-3 {
      margin-bottom: 1.5rem !important;
    }

    .form-label {
      font-family: 'Lora', serif;
      font-weight: 500;
      font-size: 14px;
      color: var(--text-color);
    }

    .form-control, .form-select {
      width: 100%;
      padding: 0.75rem;
      border: 1px solid #ddd;
      border-radius: var(--border-radius);
      font-family: 'Lora', serif;
      font-size: 1rem;
      background-color: #fafafa;
      box-shadow: none;
    }

    .form-control:focus, .form-select:focus {
      border-color: var(--primary-color);
      outline: none;
      box-shadow: 0 0 5px rgba(106, 90, 205, 0.3);
    }

    .btn-primary {
      background-color: var(--success-color);
      border: none;
      padding: 0.75rem 1.5rem;
      border-radius: var(--border-radius);
      font-family: 'Lora', serif;
      font-weight: 500;
      font-size: 16px;
      transition: background-color 0.3s, transform 0.3s, box-shadow 0.3s;
      box-shadow: var(--box-shadow);
    }

    .btn-primary:hover {
      background-color: #27ae60;
      transform: scale(1.05);
      box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2);
    }

    .btn-secondary {
      background-color: #666;
      border: none;
      padding: 0.75rem 1.5rem;
      border-radius: var(--border-radius);
      font-family: 'Lora', serif;
      font-weight: 500;
      font-size: 16px;
      transition: background-color 0.3s, transform 0.3s, box-shadow 0.3s;
      box-shadow: var(--box-shadow);
    }

    .btn-secondary:hover {
      background-color: #555;
      transform: scale(1.05);
      box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2);
    }

    @media (max-width: 768px) {
      .container {
        padding: 0 0.5rem;
      }

      h2 {
        font-size: 24px;
      }
    }
  </style>
</head>
<body>
<div class="container">
  <div class="form-card">
    <h2>Edit Service</h2>
    <form action="${pageContext.request.contextPath}/services/update" method="post" id="serviceForm">
      <input type="hidden" name="serviceId" value="${service.serviceId}">
      <div class="mb-3">
        <label for="serviceName" class="form-label">Service Name</label>
        <input type="text" class="form-control" id="serviceName" name="serviceName" value="${service.serviceName}" required>
      </div>
      <div class="mb-3">
        <label for="serviceType" class="form-label">Service Type</label>
        <select class="form-select" id="serviceType" name="serviceType" required>
          <option value="Regular" ${service.serviceType == 'Regular' ? 'selected' : ''}>Regular</option>
          <option value="Premium" ${service.serviceType == 'Premium' ? 'selected' : ''}>Premium</option>
        </select>
      </div>
      <div class="mb-3">
        <label for="price" class="form-label">Price</label>
        <input type="number" step="0.01" class="form-control" id="price" name="price" value="${service.price}" required>
      </div>
      <div class="mb-3" id="durationField" style="${service.serviceType == 'Premium' ? 'display:block;' : 'display:none;'}">
        <label for="serviceTimeDuration" class="form-label">Duration (minutes)</label>
        <input type="number" class="form-control" id="serviceTimeDuration" name="serviceTimeDuration"
               value="${service.serviceType == 'Premium' ? service.serviceTimeDuration : ''}"
        ${service.serviceType == 'Premium' ? 'required' : ''}>
      </div>
      <button type="submit" class="btn btn-primary">Update Service</button>
      <a href="${pageContext.request.contextPath}/services" class="btn btn-secondary">Cancel</a>
    </form>
  </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
  document.getElementById('serviceType').addEventListener('change', function() {
    const durationField = document.getElementById('durationField');
    const durationInput = document.getElementById('serviceTimeDuration');
    if (this.value === 'Premium') {
      durationField.style.display = 'block';
      durationInput.required = true;
    } else {
      durationField.style.display = 'none';
      durationInput.required = false;
    }
  });

  document.getElementById('serviceForm').addEventListener('submit', function(e) {
    const price = document.getElementById('price').value;
    if (price <= 0) {
      e.preventDefault();
      alert('Price must be greater than 0');
    }
  });
</script>
</body>
</html>