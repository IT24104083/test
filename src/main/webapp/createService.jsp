<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <title>Create Service</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container mt-5">
  <h2>Create New Service</h2>
  <form action="${pageContext.request.contextPath}/services/create" method="post" id="serviceForm">
    <div class="mb-3">
      <label for="serviceName" class="form-label">Service Name</label>
      <input type="text" class="form-control" id="serviceName" name="serviceName" required>
    </div>
    <div class="mb-3">
      <label for="serviceType" class="form-label">Service Type</label>
      <select class="form-select" id="serviceType" name="serviceType" required>
        <option value="Regular">Regular</option>
        <option value="Premium">Premium</option>
      </select>
    </div>
    <div class="mb-3">
      <label for="price" class="form-label">Price</label>
      <input type="number" step="0.01" class="form-control" id="price" name="price" required>
    </div>
    <div class="mb-3" id="durationField" style="display:none;">
      <label for="serviceTimeDuration" class="form-label">Duration (minutes)</label>
      <input type="number" class="form-control" id="serviceTimeDuration" name="serviceTimeDuration">
    </div>
    <button type="submit" class="btn btn-primary">Create Service</button>
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