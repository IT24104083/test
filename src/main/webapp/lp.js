document.addEventListener("DOMContentLoaded", function () {
    // Smooth scrolling for navigation links
    const links = document.querySelectorAll("nav ul li a");
    links.forEach(link => {
        link.addEventListener("click", function (e) {
            e.preventDefault();
            const targetId = this.getAttribute("href").substring(1);
            const targetElement = document.getElementById(targetId);
            if (targetElement) {
                targetElement.scrollIntoView({ behavior: "smooth" });
            } else {
                window.location.href = this.getAttribute("href");
            }
        });
    });

    // Hamburger menu toggle
    const hamburger = document.querySelector(".hamburger");
    const navUl = document.querySelector("nav ul");
    hamburger.addEventListener("click", () => {
        navUl.classList.toggle("active");
        hamburger.classList.toggle("active");
    });

    // Service hover effect
    const services = document.querySelectorAll('.service');
    services.forEach(service => {
        service.addEventListener('mouseover', () => {
            service.style.transform = 'translateY(-10px)';
        });
        service.addEventListener('mouseout', () => {
            service.style.transform = 'translateY(0)';
        });
    });

    // Close hamburger menu when clicking a link
    links.forEach(link => {
        link.addEventListener("click", () => {
            navUl.classList.remove("active");
            hamburger.classList.remove("active");
        });
    });
});