<style>
.footer {
    background: linear-gradient(135deg, #0f172a, #1e293b);
    color: white;
    padding-top: 40px;
}

.footer-container {
    display: flex;
    justify-content: space-between;
    flex-wrap: wrap;
    padding: 0 8%;
    gap: 40px;
}

.footer-section {
    flex: 1;
    min-width: 220px;
}

.footer-section h3 {
    margin-bottom: 15px;
    font-size: 18px;
}

.footer-section p {
    font-size: 14px;
    color: #cbd5f5;
    line-height: 1.6;
}

.footer-section a {
    display: block;
    text-decoration: none;
    color: #cbd5f5;
    margin-bottom: 8px;
    font-size: 14px;
    transition: 0.3s;
}

.footer-section a:hover {
    color: white;
    transform: translateX(5px);
}

.footer-logo {
    display: flex;
    align-items: center;
    gap: 10px;
    font-weight: bold;
    font-size: 20px;
    margin-bottom: 10px;
}

.social-icons {
    margin-top: 10px;
}

.social-icons span {
    font-size: 20px;
    margin-right: 12px;
    cursor: pointer;
    transition: 0.3s;
}

.social-icons span:hover {
    transform: scale(1.2);
}

/* Bottom Bar */

.footer-bottom {
    text-align: center;
    border-top: 1px solid rgba(255,255,255,0.1);
    margin-top: 30px;
    padding: 15px;
    font-size: 13px;
    color: #94a3b8;
}
</style>
<footer class="footer">

    <div class="footer-container">

        <div class="footer-section">
            <div class="footer-logo">
                <span class="logo-box">H+</span>
                <span class="logo-text">Hospital</span>
            </div>
            <p>
                Providing quality healthcare services with advanced medical
                technology and experienced professionals.
            </p>
        </div>

        <div class="footer-section">
            <h3>Quick Links</h3>

            <a href="${pageContext.request.contextPath}/home">Home</a>

            <a href="${pageContext.request.contextPath}/about">About Us</a>

            <a href="${pageContext.request.contextPath}/contact">Contact</a>

            <a href="${pageContext.request.contextPath}/login">Login</a>

            <a href="${pageContext.request.contextPath}/register">Register</a>
        </div>

        <div class="footer-section">
            <h3>Services</h3>
            <a href="#">Cardiology</a>
            <a href="#">Neurology</a>
            <a href="#">Pediatrics</a>
            <a href="#">Orthopedics</a>
            <a href="#">Emergency Care</a>
        </div>

        <div class="footer-section">
            <h3>Contact Us</h3>
            <p>RK University Road, Rajkot</p>
            <p>+91 9876543210</p>
            <p>support@hospital.com</p>

            <div class="social-icons">
                <span></span>
                <span></span>
                <span></span>
                <span></span>
            </div>
        </div>

    </div>

    <div class="footer-bottom">
        © 2026 Hospital Management System. All rights reserved.
    </div>

</footer>