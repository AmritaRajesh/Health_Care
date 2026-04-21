<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Hospital Management</title>
<style >
body {
    margin: 0;
    font-family: Arial, sans-serif;
    background: #0d6efd;
    color: white;
}

.hero {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 60px;
    gap: 40px;
    flex-wrap: wrap;
}

.hero-left {
    flex: 1;
    min-width: 280px;
}

.hero-left h1 {
    font-size: 48px;
    margin-bottom: 20px;
}

.hero-left p {
    font-size: 18px;
    line-height: 1.6;
}

/* ================= BUTTONS ================= */

.hero-buttons {
    margin-top: 30px;
    display: flex;
    gap: 10px;
    flex-wrap: wrap;
}

.primary-btn {
    background: white;
    color: #0d6efd;
    border: none;
    padding: 12px 20px;
    border-radius: 10px;
    font-size: 16px;
    cursor: pointer;
}

.secondary-btn {
    background: transparent;
    color: white;
    border: 2px solid white;
    padding: 10px 20px;
    border-radius: 10px;
    font-size: 16px;
    cursor: pointer;
}

/* ================= IMAGE ================= */

.hero-right img {
    width: 100%;
    max-width: 500px;
    border-radius: 15px;
    background: white;
    padding: 5px;
}
.stats {
    background: white;
    color: black;
    display: flex;
    justify-content: space-around;
    padding: 40px 60px;
    text-align: center;
    flex-wrap: wrap;
    gap: 20px;
}

.stat-box {
    flex: 1;
    min-width: 180px;
}

.stat-icon {
    font-size: 40px;
    color: #0d6efd;
    margin-bottom: 10px;
}

.stat-box h2 {
    margin: 5px 0;
    font-size: 28px;
}

/* ================= SERVICES TITLE ================= */

.services-title {
    background: #f4f6f9;
    color: black;
    text-align: center;
    padding: 30px;
}

.services-title h1 {
    font-size: 32px;
    margin-bottom: 10px;
}

.services-title p {
    color: #555;
}

/* ================= SERVICES ================= */

.services {
    background: #f4f6f9;
    display: flex;
    justify-content: space-around;
    padding: 50px 60px;
    gap: 20px;
    flex-wrap: wrap;
}

.service-card {
    background: white;
    flex: 1;
    min-width: 280px;
    max-width: 350px;
    padding: 25px;
    border-radius: 15px;
    box-shadow: 0 5px 15px rgba(0,0,0,0.08);
    transition: 0.3s;
}

.service-card:hover {
    transform: translateY(-5px);
}

/* ================= ICON CIRCLES ================= */

.service-icon {
    width: 60px;
    height: 60px;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 26px;
    margin-bottom: 15px;
}

.cardio {
    background: #e7f1ff;
    color: #0d6efd;
}

.neuro {
    background: #e9f9ee;
    color: #28a745;
}

.pediatric {
    background: #f3e8ff;
    color: #6f42c1;
}

/* ================= TEXT ================= */

.service-card h2 {
    margin: 10px 0;
    color: #2c3e50;
}

.service-card p {
    color: #555;
    font-size: 15px;
    line-height: 1.6;
}

.service-card a {
    text-decoration: none;
    color: #0d6efd;
    font-weight: bold;
}

/* ================= RESPONSIVE ================= */

/* 📱 Tablets */
@media (max-width: 992px) {

    .hero {
        flex-direction: column;
        text-align: center;
    }

    .hero-left h1 {
        font-size: 40px;
    }
}


.how-it-works {
    background: white;
    padding: 60px 40px;
    text-align: center;
}

.works-header h1 {
    font-size: 32px;
    margin-bottom: 10px;
    color: #0b132a;
}

.works-header p {
    color: #666;
    margin-bottom: 50px;
}

.works-container {
    display: flex;
    justify-content: space-around;
    gap: 20px;
}

.work-step {
    width: 30%;
}

.step-circle {
    width: 70px;
    height: 70px;
    background: #0d6efd;
    color: white;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 22px;
    font-weight: bold;
    margin: 0 auto 15px;
}

.work-step h3 {
    margin: 10px 0;
    color: #0b132a;
}

.work-step p {
    color: #555;
    font-size: 15px;
    line-height: 1.6;
}

</style>
</head>
<body>

<jsp:include page="header.jsp" />
<!-- ✅ HERO SECTION -->
<section class="hero">

    <div class="hero-left">
        <h1>Your Health, Our Priority</h1>

        <p>
            Experience world-class healthcare with our team of expert doctors 
            and state-of-the-art facilities. Book your appointment today.
        </p>

        <div class="hero-buttons">

            <!-- ✅ UPDATED -->
            <a href="${pageContext.request.contextPath}/register">
                <button class="primary-btn">Get Started →</button>
            </a>

            <button class="secondary-btn">Learn More</button>

        </div>
    </div>

    <div class="hero-right">
        <img src="https://images.unsplash.com/photo-1769147555720-71fc71bfc216?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&q=80&w=1080"
             alt="Hospital Building">
    </div>

</section>

<!-- ✅ STATISTICS -->
<section class="stats">

    <div class="stat-box">
        <div class="stat-icon">👨‍⚕️</div>
        <h2>50+</h2>
        <p>Expert Doctors</p>
    </div>

    <div class="stat-box">
        <div class="stat-icon">💙</div>
        <h2>10k+</h2>
        <p>Happy Patients</p>
    </div>

    <div class="stat-box">
        <div class="stat-icon">🏆</div>
        <h2>25+</h2>
        <p>Awards Won</p>
    </div>

    <div class="stat-box">
        <div class="stat-icon">⏰</div>
        <h2>24/7</h2>
        <p>Emergency Care</p>
    </div>

</section>

<!-- ✅ SERVICES -->
<section class="services-title">
    <h1>Our Medical Services</h1>
    <p>Comprehensive healthcare services tailored to your needs</p>
</section>

<section class="services">

    <div class="service-card">
        <div class="service-icon cardio">💙</div>
        <h2>Cardiology</h2>
        <p>Advanced cardiac care with experienced cardiologists.</p>

        <a href="${pageContext.request.contextPath}/register">Find Specialists →</a>
    </div>

    <div class="service-card">
        <div class="service-icon neuro">🧠</div>
        <h2>Neurology</h2>
        <p>Expert neurological care for brain and nervous system.</p>
        <a href="${pageContext.request.contextPath}/register">Find Specialists →</a>
    </div>

    <div class="service-card">
        <div class="service-icon pediatric">🩺</div>
        <h2>Pediatrics</h2>
        <p>Compassionate care for infants and children.</p>
        <a href="${pageContext.request.contextPath}/register">Find Specialists →</a>
    </div>

</section>

<!-- ✅ HOW IT WORKS -->
<section class="how-it-works">

    <div class="works-header">
        <h1>How It Works</h1>
        <p>Simple steps to get the care you need</p>
    </div>

    <div class="works-container">

        <div class="work-step">
            <div class="step-circle">1</div>
            <h3>Register</h3>
            <p>Create your account and complete profile.</p>
        </div>

        <div class="work-step">
            <div class="step-circle">2</div>
            <h3>Find a Doctor</h3>
            <p>Search doctors by specialization.</p>
        </div>

        <div class="work-step">
            <div class="step-circle">3</div>
            <h3>Book Appointment</h3>
            <p>Schedule & receive confirmation.</p>
        </div>

    </div>

</section>

    
<jsp:include page="footer.jsp" />

</body>
</html>
