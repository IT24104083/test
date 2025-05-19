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
</head>
<body>
<div class="container mt-5">
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