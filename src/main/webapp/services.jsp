<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Services</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container mt-5">
    <h2>Salon Services</h2>
    <a href="createService.jsp" class="btn btn-primary mb-3">Add New Service</a>

    <c:if test="${not empty sessionScope.message}">
        <div class="alert alert-success">${sessionScope.message}</div>
        <c:remove var="message" scope="session"/>
    </c:if>
    <c:if test="${not empty sessionScope.error}">
        <div class="alert alert-danger">${sessionScope.error}</div>
        <c:remove var="error" scope="session"/>
    </c:if>

    <table class="table table-bordered table-hover">
        <thead>
        <tr>
            <th>ID</th>
            <th>Name</th>
            <th>Type</th>
            <th>Price</th>
            <th>Duration (min)</th>
            <th>Actions</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="service" items="${services}">
            <tr>
                <td>${service.serviceId}</td>
                <td>${service.serviceName}</td>
                <td>${service.serviceType}</td>
                <td>${service.price}</td>
                <td>
                    <c:if test="${service.serviceType == 'Premium'}">
                        ${service.serviceTimeDuration}
                    </c:if>
                </td>
                <td>
                    <a href="editService.jsp?serviceId=${service.serviceId}" class="btn btn-sm btn-warning">Edit</a>
                    <form action="${pageContext.request.contextPath}/services/delete" method="post" style="display:inline;">
                        <input type="hidden" name="serviceId" value="${service.serviceId}">
                        <button type="submit" class="btn btn-sm btn-danger" onclick="return confirm('Are you sure?')">Delete</button>
                    </form>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>