<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
    <title>Create Schedule - Salon Booking System</title>
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

        .form-group input, .form-group select {
            width: 100%;
            padding: 0.75rem;
            border: 1px solid #ddd;
            border-radius: var(--border-radius);
            font-size: 1rem;
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

        @media (max-width: 768px) {
            .container {
                padding: 0 0.5rem;
            }
        }
    </style>
</head>
<body>
<div class="container">
    <div class="form-card">
        <h3 class="section-title">Create New Schedule</h3>
        <form action="${pageContext.request.contextPath}/schedules/create" method="post" id="scheduleForm">
            <div class="form-group">
                <label for="date">Date</label>
                <input type="date" id="date" name="date" required>
            </div>
            <div class="form-group">
                <label>Time</label>
                <div class="time-group">
                    <select id="hour" name="hour" required>
                        <option value="" disabled selected>Hour</option>
                        <c:forEach var="h" begin="9" end="17">
                            <option value="${h}">${h}</option>
                        </c:forEach>
                    </select>
                    <select id="minute" name="minute" required>
                        <option value="" disabled selected>Minute</option>
                        <option value="0">00</option>
                        <option value="15">15</option>
                        <option value="30">30</option>
                        <option value="45">45</option>
                    </select>
                </div>
            </div>
            <button type="submit" class="submit-btn">Create Schedule</button>
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