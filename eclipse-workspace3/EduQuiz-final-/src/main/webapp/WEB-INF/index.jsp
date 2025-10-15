<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="dz.eduquiz.util.SessionManager" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EduQuiz - Learning Made Fun!</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Comic Neue', 'Nunito', -apple-system, BlinkMacSystemFont, sans-serif;
            background: linear-gradient(135deg, #FFE066 0%, #FF6B6B 25%, #4ECDC4 50%, #45B7D1 75%, #96CEB4 100%);
            background-size: 400% 400%;
            animation: gradientShift 15s ease infinite;
            min-height: 100vh;
            overflow-x: hidden;
        }

        @keyframes gradientShift {
            0% { background-position: 0% 50%; }
            50% { background-position: 100% 50%; }
            100% { background-position: 0% 50%; }
        }

        /* Floating Decorative Elements */
        .decoration {
            position: fixed;
            pointer-events: none;
            z-index: 1;
        }

        .star {
            color: #FFE066;
            font-size: 2rem;
            animation: twinkle 3s ease-in-out infinite;
        }

        .heart {
            color: #FF6B6B;
            font-size: 1.5rem;
            animation: bounce 4s ease-in-out infinite;
        }

        .lightning {
            color: #45B7D1;
            font-size: 1.8rem;
            animation: flash 2s ease-in-out infinite;
        }

        @keyframes twinkle {
            0%, 100% { opacity: 0.3; transform: scale(1) rotate(0deg); }
            50% { opacity: 1; transform: scale(1.2) rotate(180deg); }
        }

        @keyframes bounce {
            0%, 100% { transform: translateY(0px) scale(1); }
            50% { transform: translateY(-15px) scale(1.1); }
        }

        @keyframes flash {
            0%, 100% { opacity: 0.4; }
            50% { opacity: 1; }
        }

        /* Header */
        .header {
            top: 0;
            width: 100%;
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
            z-index: 1000;
            padding: 0.5rem 0;
        }

        .nav {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin: 0 auto;
            padding: 0 2rem;
        }

        .logo {
            font-size: 2.5rem;
            font-weight: 900;
            background: linear-gradient(45deg, #FF6B6B, #4ECDC4, #45B7D1);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            text-decoration: none;
            transition: all 0.3s ease;
        }

        .logo:hover {
            transform: scale(1.05);
            filter: brightness(1.1);
        }

        .logo::before {
            content: "🎓";
            font-size: 2rem;
        }

        .nav-links {
            display: flex;
            gap: 2rem;
            list-style: none;
        }

        .nav-links a {
            color: #333;
            text-decoration: none;
            font-weight: 700;
            font-size: 1.1rem;
            padding: 0.7rem 1.2rem;
            border-radius: 25px;
            transition: all 0.3s ease;
            position: relative;
        }

        .nav-links a:hover {
            background: linear-gradient(45deg, #FFE066, #FF6B6B);
            color: white;
            transform: translateY(-2px) scale(1.05);
            box-shadow: 0 8px 25px rgba(255, 107, 107, 0.3);
        }

        .auth-buttons {
            display: flex;
            gap: 1rem;
            align-items: center;
        }

        .btn-fun {
            padding: 0.8rem 1.8rem;
            border-radius: 30px;
            font-weight: 700;
            font-size: 1rem;
            cursor: pointer;
            transition: all 0.3s ease;
            border: none;
            text-decoration: none;
            display: inline-block;
        }

        .btn-outline-fun {
            background: transparent;
            border: 3px solid #FF6B6B;
            color: #FF6B6B;
        }

        .btn-outline-fun:hover {
            background: #FF6B6B;
            color: white;
            transform: translateY(-3px) scale(1.05);
            box-shadow: 0 10px 30px rgba(255, 107, 107, 0.4);
        }

        .btn-primary-fun {
            background: linear-gradient(45deg, #4ECDC4, #45B7D1);
            color: white;
            border: none;
        }

        .btn-primary-fun:hover {
            background: linear-gradient(45deg, #45B7D1, #4ECDC4);
            transform: translateY(-3px) scale(1.05);
            box-shadow: 0 12px 35px rgba(69, 183, 209, 0.4);
        }

        /* User Profile Dropdown */
        .user-dropdown {
            position: relative;
            display: inline-block;
        }

        .user-profile {
            display: flex;
            align-items: center;
            gap: 0.8rem;
            padding: 0.8rem 1.5rem;
            background: linear-gradient(45deg, #4ECDC4, #45B7D1);
            color: white;
            border-radius: 30px;
            cursor: pointer;
            transition: all 0.3s ease;
            font-weight: 700;
            font-size: 1rem;
            border: none;
        }

        .user-profile:hover {
            background: linear-gradient(45deg, #45B7D1, #4ECDC4);
            transform: translateY(-2px) scale(1.05);
            box-shadow: 0 8px 25px rgba(78, 205, 196, 0.4);
        }

        .user-avatar {
            width: 32px;
            height: 32px;
            background: white;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.2rem;
        }

        .dropdown-menu {
            position: absolute;
            top: 100%;
            right: 0;
            background: white;
            border-radius: 20px;
            box-shadow: 0 15px 50px rgba(0, 0, 0, 0.15);
            min-width: 220px;
            opacity: 0;
            visibility: hidden;
            transform: translateY(-10px);
            transition: all 0.3s ease;
            z-index: 1001;
            margin-top: 0.5rem;
        }

        .dropdown-menu.show {
            opacity: 1;
            visibility: visible;
            transform: translateY(0);
        }

        .dropdown-item {
            display: flex;
            align-items: center;
            gap: 0.8rem;
            padding: 1rem 1.5rem;
            color: #333;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s ease;
            border-radius: 15px;
            margin: 0.3rem;
        }

        .dropdown-item:hover {
            background: linear-gradient(45deg, #FFE066, #FF6B6B);
            color: white;
            transform: translateX(5px);
        }

        .dropdown-divider {
            height: 1px;
            background: linear-gradient(45deg, #FFE066, #FF6B6B);
            margin: 0.5rem 1rem;
            border: none;
        }

        .admin-item {
            background: linear-gradient(45deg, #FF6B6B, #FFE066);
            color: white;
        }

        .admin-item:hover {
            background: linear-gradient(45deg, #FFE066, #FF6B6B);
            transform: translateX(5px) scale(1.02);
        }

        .logout-item {
            color: #dc3545;
        }

        .logout-item:hover {
            background: #dc3545;
            color: white;
        }

        /* Hero Section */
        .hero {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0 2rem;
            max-width: 1400px;
            margin: 0 auto;
            gap: 4rem;
        }

        .hero-content {
            flex: 1;
            max-width: 600px;
            animation: slideInLeft 1s ease-out;
        }

        .hero-visual {
            flex: 1;
            display: flex;
            justify-content: center;
            align-items: center;
            animation: slideInRight 1s ease-out;
        }

        @keyframes slideInLeft {
            from { opacity: 0; transform: translateX(-50px); }
            to { opacity: 1; transform: translateX(0); }
        }

        @keyframes slideInRight {
            from { opacity: 0; transform: translateX(50px); }
            to { opacity: 1; transform: translateX(0); }
        }

        .hero h1 {
            font-size: clamp(2.5rem, 6vw, 4rem);
            font-weight: 900;
            color: #333;
            margin-bottom: 1.5rem;
            line-height: 1.2;
        }

        .highlight {
            background: linear-gradient(45deg, #FFE066, #FF6B6B);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            position: relative;
        }

        .hero p {
            font-size: 1.3rem;
            color: #666;
            margin-bottom: 2.5rem;
            line-height: 1.6;
            font-weight: 500;
        }

        .cta-section {
            margin-bottom: 3rem;
        }

        .cta-buttons {
            display: flex;
            gap: 1.5rem;
            margin-bottom: 2rem;
            flex-wrap: wrap;
        }

        .btn-hero {
            padding: 1.2rem 2.5rem;
            font-size: 1.2rem;
            font-weight: 800;
            border-radius: 35px;
            cursor: pointer;
            transition: all 0.3s ease;
            border: none;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }

        .btn-hero-main {
            background: linear-gradient(45deg, #FF6B6B, #FFE066);
            color: #333;
            box-shadow: 0 8px 25px rgba(255, 107, 107, 0.3);
        }

        .btn-hero-main:hover {
            transform: translateY(-4px) scale(1.05);
            box-shadow: 0 15px 40px rgba(255, 107, 107, 0.5);
            background: linear-gradient(45deg, #FFE066, #FF6B6B);
        }

        .btn-hero-secondary {
            background: white;
            color: #333;
            border: 3px solid #4ECDC4;
            box-shadow: 0 6px 20px rgba(78, 205, 196, 0.2);
        }

        .btn-hero-secondary:hover {
            background: #4ECDC4;
            color: white;
            transform: translateY(-4px) scale(1.05);
            box-shadow: 0 12px 35px rgba(78, 205, 196, 0.4);
        }

        .quick-stats {
            display: flex;
            gap: 2rem;
            color: #666;
            font-weight: 600;
            flex-wrap: wrap;
        }

        .quick-stat {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            font-size: 1rem;
        }

        /* Playful Illustration */
        .illustration {
            width: 100%;
            max-width: 500px;
            height: 400px;
            background: white;
            border-radius: 30px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.1);
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            position: relative;
            overflow: hidden;
        }

        .illustration::before {
            content: "";
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: linear-gradient(45deg, #FFE066, #FF6B6B, #4ECDC4, #45B7D1);
            animation: rotate 20s linear infinite;
            opacity: 0.1;
        }

        @keyframes rotate {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        .quiz-mockup {
            z-index: 2;
            text-align: center;
            padding: 2rem;
        }

        .quiz-question {
            background: linear-gradient(45deg, #4ECDC4, #45B7D1);
            color: white;
            padding: 1.5rem;
            border-radius: 20px;
            margin-bottom: 1.5rem;
            font-size: 1.1rem;
            font-weight: 700;
            box-shadow: 0 10px 30px rgba(78, 205, 196, 0.3);
        }

        .quiz-options {
            display: flex;
            flex-direction: column;
            gap: 0.8rem;
        }

        .quiz-option {
            background: #f8f9fa;
            padding: 1rem;
            border-radius: 15px;
            font-weight: 600;
            color: #333;
            border: 2px solid transparent;
            transition: all 0.3s ease;
            cursor: pointer;
        }

        .quiz-option:hover {
            border-color: #FFE066;
            background: #FFE066;
            transform: scale(1.02);
        }

        .quiz-option.correct {
            background: #96CEB4;
            color: white;
            animation: correctAnswer 0.5s ease;
        }

        @keyframes correctAnswer {
            0% { transform: scale(1); }
            50% { transform: scale(1.05); }
            100% { transform: scale(1); }
        }

        /* Stats Cards */
        .stats-grid {
            position: fixed;
            bottom: 2rem;
            right: 2rem;
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 1rem;
            z-index: 100;
        }

        .stat-card {
            background: white;
            padding: 1rem;
            border-radius: 20px;
            text-align: center;
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
            min-width: 100px;
            transition: all 0.3s ease;
        }

        .stat-card:hover {
            transform: translateY(-5px) scale(1.05);
            box-shadow: 0 15px 40px rgba(0, 0, 0, 0.15);
        }

        .stat-number {
            font-size: 1.8rem;
            font-weight: 900;
            color: #FF6B6B;
            display: block;
        }

        .stat-label {
            font-size: 0.8rem;
            color: #666;
            font-weight: 600;
            margin-top: 0.2rem;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .hero {
                flex-direction: column;
                text-align: center;
                gap: 2rem;
                padding-top: 6rem;
            }
            
            .nav-links {
                display: none;
            }
            
            .stats-grid {
                position: relative;
                bottom: auto;
                right: auto;
                margin-top: 2rem;
                justify-self: center;
            }
            
            .cta-buttons {
                flex-direction: column;
                align-items: center;
            }
            
            .illustration {
                max-width: 350px;
                height: 300px;
            }

            .dropdown-menu {
                right: -1rem;
                min-width: 200px;
            }
        }
    </style>
</head>
<body>
    <div class="decoration star" style="top: 15%; left: 10%;">⭐</div>
    <div class="decoration heart" style="top: 25%; right: 15%;">❤️</div>
    <div class="decoration lightning" style="top: 60%; left: 5%;">⚡</div>
    <div class="decoration star" style="bottom: 20%; right: 10%;">✨</div>
    <div class="decoration heart" style="bottom: 40%; left: 12%;">💛</div>
    <div class="decoration lightning" style="top: 40%; right: 8%;">🚀</div>

    <header class="header">
        <nav class="nav">
            <a href="${pageContext.request.contextPath}/home" class="logo">EduQuiz</a>
            
            <ul class="nav-links">
                <li><a href="${pageContext.request.contextPath}/quizzes">Quizzes</a></li>
                <li><a href="${pageContext.request.contextPath}/leaderboard">Leaderboard</a></li>
                <li><a href="${pageContext.request.contextPath}/history">History</a></li>
            </ul>
            
            <div class="auth-buttons">
                <c:choose>
                    <c:when test="${sessionScope.user != null}">
                        <div class="user-dropdown">
                            <button class="user-profile" onclick="toggleDropdown()">
                                <div class="user-avatar">👤</div>
                                <span>${sessionScope.user.username}</span>
                                <span style="font-size: 0.8rem;">▼</span>
                            </button>
                            <div class="dropdown-menu" id="userDropdown">
                                <a href="${pageContext.request.contextPath}/profile" class="dropdown-item">
                                    <span>👤</span>
                                    <span>My Profile</span>
                                </a>
                                <a href="${pageContext.request.contextPath}/history" class="dropdown-item">
                                    <span>📊</span>
                                    <span>Quiz History</span>
                                </a>
                                <c:if test="${sessionScope.user.role eq 'ADMIN'}">
                                    <hr class="dropdown-divider">
                                    <a href="${pageContext.request.contextPath}/admin/dashboard" class="dropdown-item admin-item">
                                        <span>⚙️</span>
                                        <span>Admin Dashboard</span>
                                    </a>
                                </c:if>
                                <hr class="dropdown-divider">
                                <a href="${pageContext.request.contextPath}/logout" class="dropdown-item logout-item">
                                    <span>🚪</span>
                                    <span>Logout</span>
                                </a>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/login" class="btn-fun btn-outline-fun">Sign In</a>
                        <a href="${pageContext.request.contextPath}/register" class="btn-fun btn-primary-fun">Join Fun! 🎉</a>
                    </c:otherwise>
                </c:choose>
            </div>
        </nav>
    </header>

    <main class="hero">
        <div class="hero-content">
            <h1>
                Make Learning <span class="highlight">Super Fun</span> with Interactive Quizzes! 🎓
            </h1>
            <p>
                Turn study time into play time! Challenge friends, earn cool badges, 
                and master any subject with our colorful, engaging quizzes. Learning 
                has never been this exciting! 🌟
            </p>
            
            <div class="cta-section">
                <div class="cta-buttons">
                    <a href="${pageContext.request.contextPath}/quizzes" class="btn-hero btn-hero-main">
                        🚀 Start Playing Now!
                    </a>
                    <a href="${pageContext.request.contextPath}/quizzes" class="btn-hero btn-hero-secondary">
                        🎯 Browse Quizzes
                    </a>
                </div>
                
                <div class="quick-stats">
                    <div class="quick-stat">
                        <span>🎮</span>
                        <span>50K+ Happy Learners</span>
                    </div>
                    <div class="quick-stat">
                        <span>📚</span>
                        <span>1000+ Fun Quizzes</span>
                    </div>
                    <div class="quick-stat">
                        <span>🏆</span>
                        <span>25+ Subjects</span>
                    </div>
                </div>
            </div>
        </div>

        <div class="hero-visual">
            <div class="illustration">
                <div class="quiz-mockup">
                    <div class="quiz-question">
                        🤔 What's the capital of France?
                    </div>
                    <div class="quiz-options">
                        <div class="quiz-option">🇬🇧 London</div>
                        <div class="quiz-option correct">🇫🇷 Paris</div>
                        <div class="quiz-option">🇪🇸 Madrid</div>
                        <div class="quiz-option">🇮🇹 Rome</div>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <div class="stats-grid">
        <div class="stat-card">
            <span class="stat-number">98%</span>
            <span class="stat-label">Fun Score</span>
        </div>
        <div class="stat-card">
            <span class="stat-number">24/7</span>
            <span class="stat-label">Available</span>
        </div>
        <div class="stat-card">
            <span class="stat-number">∞</span>
            <span class="stat-label">Possibilities</span>
        </div>
        <div class="stat-card">
            <span class="stat-number">🎉</span>
            <span class="stat-label">Always</span>
        </div>
    </div>

    <script>
        function toggleDropdown() {
            const dropdown = document.getElementById('userDropdown');
            dropdown.classList.toggle('show');
        }

        document.addEventListener('click', function(event) {
            const dropdown = document.getElementById('userDropdown');
            const userProfile = document.querySelector('.user-profile');
            
            if (!userProfile.contains(event.target)) {
                dropdown.classList.remove('show');
            }
        });

        document.addEventListener('DOMContentLoaded', function() {
            const options = document.querySelectorAll('.quiz-option');
            let currentOption = 0;
            
            setInterval(() => {
                options.forEach(opt => {
                    opt.classList.remove('correct');
                    opt.style.background = '#f8f9fa';
                    opt.style.color = '#333';
                });
                
                if (currentOption < options.length) {
                    options[currentOption].style.background = '#FFE066';
                    
                    setTimeout(() => {
                        if (currentOption === 1) { 
                            options[currentOption].classList.add('correct');
                        } else {
                            options[currentOption].style.background = '#FFB6B6';
                        }
                    }, 1000);
                    
                    currentOption = (currentOption + 1) % options.length;
                }
            }, 3000);

            const decorations = document.querySelectorAll('.decoration');
            decorations.forEach((decoration, index) => {
                decoration.style.animation += `, float${index} 6s ease-in-out infinite`;
                decoration.style.animationDelay = `${index * 0.5}s`;
            });

            const style = document.createElement('style');
            let keyframes = '';
            for (let i = 0; i < decorations.length; i++) {
                keyframes += `
                    @keyframes float${i} {
                        0%, 100% { transform: translateY(0px) rotate(0deg); }
                        50% { transform: translateY(-${10 + i * 5}px) rotate(${180 + i * 45}deg); }
                    }
                `;
            }
            style.textContent = keyframes;
            document.head.appendChild(style);

            document.addEventListener('click', (e) => {
                if (e.target.classList.contains('btn-hero') || e.target.classList.contains('btn-fun')) {
                    // Create celebration effect
                    const emojis = ['🎉', '🎊', '⭐', '🌟', '💫', '✨'];
                    for (let i = 0; i < 6; i++) {
                        const emoji = document.createElement('div');
                        emoji.textContent = emojis[Math.floor(Math.random() * emojis.length)];
                        emoji.style.cssText = `
                            position: fixed;
                            left: ${e.clientX}px;
                            top: ${e.clientY}px;
                            font-size: 1.5rem;
                            pointer-events: none;
                            z-index: 9999;
                            animation: celebrate 1s ease-out forwards;
                        `;
                        document.body.appendChild(emoji);
                        
                        setTimeout(() => emoji.remove(), 1000);
                    }
                }
            });

            // Celebration animation
            const celebrateStyle = document.createElement('style');
            celebrateStyle.textContent = `
                @keyframes celebrate {
                    0% { 
                        opacity: 1; 
                        transform: translate(0, 0) scale(1) rotate(0deg); 
                    }
                    100% { 
                        opacity: 0; 
                        transform: translate(${Math.random() * 200 - 100}px, ${Math.random() * -200 - 50}px) scale(0.5) rotate(360deg); 
                    }
                }
            `;
            document.head.appendChild(celebrateStyle);
        });
    </script>
</body>
</html>