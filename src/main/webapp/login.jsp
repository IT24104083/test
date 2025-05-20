<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Salon Booking - Login</title>
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
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
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
            background-color: white;
            padding: 30px;
            border-radius: var(--border-radius);
            box-shadow: var(--box-shadow);
            width: 350px;
        }
        h2 {
            font-family: 'Playfair Display', serif;
            text-align: center;
            color: var(--primary-color);
            margin-bottom: 20px;
            font-size: 28px;
        }
        .form-group {
            margin-bottom: 15px;
        }
        label {
            font-family: 'Lora', serif;
            display: block;
            margin-bottom: 5px;
            font-weight: 500;
            color: var(--text-color);
            font-size: 14px;
        }
        input[type="email"],
        input[type="password"] {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: var(--border-radius);
            font-family: 'Lora', serif;
            font-size: 1rem;
            background-color: #fafafa;
        }
        input[type="email"]:focus,
        input[type="password"]:focus {
            border-color: var(--primary-color);
            outline: none;
            box-shadow: 0 0 5px rgba(106, 90, 205, 0.3);
        }
        button {
            background-color: var(--success-color);
            color: white;
            padding: 10px 15px;
            border: none;
            border-radius: var(--border-radius);
            cursor: pointer;
            width: 100%;
            font-family: 'Lora', serif;
            font-size: 16px;
            font-weight: 500;
            transition: background-color 0.3s, transform 0.3s, box-shadow 0.3s;
            box-shadow: var(--box-shadow);
        }
        button:hover {
            background-color: #27ae60;
            transform: scale(1.05);
            box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2);
        }
        .error {
            font-family: 'Lora', serif;
            color: var(--danger-color);
            font-size: 14px;
            margin-top: 5px;
            background-color: #fee2e2;
            padding: 0.5rem;
            border-radius: var(--border-radius);
        }
        .register-link {
            font-family: 'Lora', serif;
            text-align: center;
            margin-top: 15px;
            font-size: 14px;
        }
        .register-link a {
            color: var(--primary-color);
            text-decoration: none;
        }
        .register-link a:hover {
            text-decoration: underline;
        }
        @media (max-width: 768px) {
            .container {
                width: 90%;
                padding: 20px;
            }
            h2 {
                font-size: 24px;
            }
        }
    </style>
</head>
<body>
<div class="container">
    <h2>Login to Salon Booking</h2>
    <form action="LoginServlet" method="post">
        <div class="form-group">
            <label for="email">Email</label>
            <input type="email" id="email" name="email" required>
        </div>
        <div class="form-group">
            <label for="password">Password</label>
            <input type="password" id="password" name="password" required>
        </div>
        <div id="loginError" class="error">
            <% if(request.getAttribute("error") != null) { %>
            <%= request.getAttribute("error") %>
            <% } %>
        </div>
        <button type="submit">Login</button>
    </form>
    <div class="register-link">
        Don't have an account? <a href="index.jsp">Register here</a>
    </div>
</div>
</body>
</html>