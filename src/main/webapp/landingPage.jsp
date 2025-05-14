<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Salon Maleesha | Beauty & Wellness</title>
  <link rel="stylesheet" href="lp.css">
  <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;700&family=Open+Sans:wght@400;600&display=swap" rel="stylesheet">
  <script defer src="lp.js"></script>
</head>
<body>
<!-- Navigation Bar -->
<header>
  <h1>Salon Maleesha</h1>
  <nav>
    <div class="hamburger">
      <span></span>
      <span></span>
      <span></span>
    </div>
    <ul>
      <li><a href="#home">Home</a></li>
      <li><a href="#services">Services</a></li>
      <li><a href="#about">About</a></li>
      <li><a href="#contact">Contact</a></li>
      <li><a href="index.jsp">Customer Login</a></li>
      <li><a href="emplogin.jsp">Employee Login</a></li>
    </ul>
  </nav>
</header>

<!-- Hero Section -->
<section id="home" class="hero">
  <div class="hero-content">
    <h2>Enhance Your Beauty, Naturally</h2>
    <p>Premium beauty treatments for a radiant you</p>
    <a href="#services" class="btn">View Services</a>
  </div>
</section>

<!-- Services Section -->
<section id="services">
  <h2>Our Services</h2>
  <div class="services-container">
    <div class="service">
      <img src="images/haircut.jpg" alt="Haircut">
      <h3>Haircut & Styling</h3>
      <p>Trendy haircuts and professional styling.</p>
    </div>
    <div class="service">
      <img src="images/facial.jpg" alt="Facial">
      <h3>Facial & Skincare</h3>
      <p>Rejuvenating facials for glowing skin.</p>
    </div>
    <div class="service">
      <img src="images/spa.jpg" alt="Spa">
      <h3>Body Spa & Massage</h3>
      <p>Relaxing spa treatments to soothe your body.</p>
    </div>
    <div class="service">
      <img src="images/book.jpg" alt="Book Now">
      <h3><a href="bookNow.jsp" class="btn">Book Now</a></h3>
      <p>Book your appointment today.</p>
    </div>
  </div>
</section>

<!-- About Section -->
<section id="about">
  <h2>About Us</h2>
  <p>We are a luxury salon committed to providing the best beauty and wellness services.</p>
</section>

<!-- Contact Section -->
<section id="contact">
  <h2>Contact Us</h2>
  <p>Email: info@salonnaturals.com</p>
  <p>Phone: +94 123 456 789</p>
</section>

<!-- Footer -->
<footer>
  <div class="footer-container">
    <div class="footer-column">
      <h3>About Salon Maleesha</h3>
      <p>Luxury beauty and wellness services tailored for you.</p>
    </div>
    <div class="footer-column">
      <h3>Quick Links</h3>
      <ul>
        <li><a href="#home">Home</a></li>
        <li><a href="#services">Services</a></li>
        <li><a href="#about">About</a></li>
        <li><a href="#contact">Contact</a></li>
      </ul>
    </div>
    <div class="footer-column">
      <h3>Feedbacks</h3>
      <p><a href="FeedbackServlet?action=all">View Customer Feedbacks</a></p>
    </div>
    <div class="footer-column">
      <h3>Contact Info</h3>
      <p>Email: info@salonnaturals.com</p>
      <p>Phone: +94 123 456 789</p>
    </div>
  </div>
  <p class="footer-bottom">© 2025 Salon Maleesha. All Rights Reserved.</p>
</footer>
</body>
</html>