<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EduQuiz - Welcome Back!</title>
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
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 2rem 1rem;
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

        /* Main Container */
        .login-container {
            display: flex;
            max-width: 1000px;
            width: 100%;
            background: white;
            border-radius: 30px;
            box-shadow: 0 30px 80px rgba(0, 0, 0, 0.15);
            overflow: hidden;
            position: relative;
            z-index: 10;
            animation: slideUp 0.8s ease-out;
        }

        @keyframes slideUp {
            from { opacity: 0; transform: translateY(50px); }
            to { opacity: 1; transform: translateY(0); }
        }

        /* Left Side - Login Form */
        .login-form-section {
            flex: 1;
            padding: 3rem;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }

        .login-header {
            text-align: center;
            margin-bottom: 2.5rem;
        }

        .logo-link {
            display: inline-block;
            text-decoration: none;
            margin-bottom: 1rem;
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
            justify-content: center;
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

        .welcome-text {
            color: #333;
            font-size: 1.8rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
        }

        .subtitle {
            color: #666;
            font-size: 1.1rem;
            font-weight: 500;
        }

        /* Form Styling */
        .login-form {
            max-width: 400px;
            width: 100%;
            margin: 0 auto;
        }

        .form-group {
            margin-bottom: 1.5rem;
        }

        .form-label {
            display: block;
            color: #333;
            font-weight: 700;
            font-size: 1rem;
            margin-bottom: 0.5rem;
        }

        .form-input {
            width: 100%;
            padding: 1rem 1.2rem;
            border: 3px solid #e9ecef;
            border-radius: 20px;
            font-size: 1rem;
            font-weight: 600;
            color: #333;
            background: #f8f9fa;
            transition: all 0.3s ease;
            outline: none;
        }

        .form-input:focus {
            border-color: #4ECDC4;
            background: white;
            box-shadow: 0 0 0 3px rgba(78, 205, 196, 0.1);
            transform: translateY(-2px);
        }

        .form-input:hover {
            border-color: #FFE066;
            background: white;
        }

        /* Error Alert */
        .alert {
            background: linear-gradient(45deg, #FFB6B6, #FF6B6B);
            color: white;
            padding: 1rem 1.5rem;
            border-radius: 20px;
            margin-bottom: 1.5rem;
            font-weight: 600;
            text-align: center;
            animation: shake 0.5s ease-in-out;
        }

        @keyframes shake {
            0%, 100% { transform: translateX(0); }
            25% { transform: translateX(-5px); }
            75% { transform: translateX(5px); }
        }

        /* Submit Button */
        .btn-login {
            width: 100%;
            padding: 1.2rem;
            background: linear-gradient(45deg, #4ECDC4, #45B7D1);
            color: white;
            border: none;
            border-radius: 25px;
            font-size: 1.2rem;
            font-weight: 800;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 8px 25px rgba(78, 205, 196, 0.3);
            margin-bottom: 1.5rem;
        }

        .btn-login:hover {
            background: linear-gradient(45deg, #45B7D1, #4ECDC4);
            transform: translateY(-3px) scale(1.02);
            box-shadow: 0 15px 40px rgba(78, 205, 196, 0.4);
        }

        .btn-login:active {
            transform: translateY(-1px) scale(1.01);
        }

        /* Register Link */
        .register-link {
            text-align: center;
            color: #666;
            font-weight: 600;
        }

        .register-link a {
            color: #FF6B6B;
            text-decoration: none;
            font-weight: 700;
            transition: all 0.3s ease;
        }

        .register-link a:hover {
            color: #4ECDC4;
            text-decoration: underline;
        }

        /* Right Side - Illustration */
        .illustration-section {
            flex: 1;
            background: linear-gradient(135deg, #4ECDC4, #45B7D1);
            display: flex;
            align-items: center;
            justify-content: center;
            position: relative;
            overflow: hidden;
        }

        .illustration-section::before {
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

        .welcome-illustration {
            z-index: 2;
            text-align: center;
            color: white;
            padding: 2rem;
        }

        .illustration-title {
            font-size: 2.5rem;
            font-weight: 900;
            margin-bottom: 1rem;
            text-shadow: 0 4px 20px rgba(0, 0, 0, 0.2);
        }

        .illustration-subtitle {
            font-size: 1.2rem;
            font-weight: 600;
            margin-bottom: 2rem;
            opacity: 0.9;
        }

        .fun-icons {
            display: flex;
            justify-content: center;
            gap: 1.5rem;
            font-size: 3rem;
            margin-bottom: 2rem;
        }

        .fun-icon {
            animation: float 3s ease-in-out infinite;
        }

        .fun-icon:nth-child(1) { animation-delay: 0s; }
        .fun-icon:nth-child(2) { animation-delay: 0.5s; }
        .fun-icon:nth-child(3) { animation-delay: 1s; }

        @keyframes float {
            0%, 100% { transform: translateY(0px) rotate(0deg); }
            50% { transform: translateY(-10px) rotate(5deg); }
        }

        .stats-mini {
            display: flex;
            justify-content: center;
            gap: 2rem;
            font-size: 0.9rem;
            opacity: 0.8;
        }

        .stat-mini {
            text-align: center;
        }

        .stat-mini-number {
            display: block;
            font-size: 1.5rem;
            font-weight: 900;
            margin-bottom: 0.2rem;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .login-container {
                flex-direction: column;
                max-width: 500px;
                margin: 1rem;
            }
            
            .illustration-section {
                order: -1;
                min-height: 200px;
            }
            
            .login-form-section {
                padding: 2rem 1.5rem;
            }
            
            .illustration-title {
                font-size: 1.8rem;
            }
            
            .illustration-subtitle {
                font-size: 1rem;
            }
            
            .fun-icons {
                font-size: 2rem;
                gap: 1rem;
            }
            
            .stats-mini {
                gap: 1rem;
                font-size: 0.8rem;
            }
            
            .stat-mini-number {
                font-size: 1.2rem;
            }
        }

        /* Loading state */
        .btn-login.loading {
            pointer-events: none;
            opacity: 0.7;
        }

        .btn-login.loading::after {
            content: "";
            position: absolute;
            width: 20px;
            height: 20px;
            top: 50%;
            left: 50%;
            margin-left: -10px;
            margin-top: -10px;
            border: 2px solid transparent;
            border-top: 2px solid #ffffff;
            border-radius: 50%;
            animation: spin 1s linear infinite;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
    </style>
</head>
<body>
    <!-- Floating Decorations -->
    <div class="decoration star" style="top: 10%; left: 10%;">⭐</div>
    <div class="decoration heart" style="top: 20%; right: 15%;">❤️</div>
    <div class="decoration lightning" style="top: 70%; left: 5%;">⚡</div>
    <div class="decoration star" style="bottom: 20%; right: 10%;">✨</div>
    <div class="decoration heart" style="bottom: 30%; left: 12%;">💛</div>
    <div class="decoration lightning" style="top: 50%; right: 8%;">🚀</div>

    <!-- Main Container -->
    <div class="login-container">
        <!-- Left Side - Login Form -->
        <div class="login-form-section">
            <div class="login-header">
                <a href="${pageContext.request.contextPath}/home" class="logo-link">
                    <div class="logo">EduQuiz</div>
                </a>
                <h1 class="welcome-text">Welcome Back! 🎉</h1>
                <p class="subtitle">Ready to continue your learning adventure?</p>
            </div>

            <form action="${pageContext.request.contextPath}/login" method="post" id="loginForm" class="login-form">
                <c:if test="${not empty errorMessage}">
                    <div class="alert" role="alert">
                        ${errorMessage}
                    </div>
                </c:if>

                <div class="form-group">
                    <label for="username" class="form-label">Username or Email</label>
                    <input type="text" class="form-input" id="username" name="usernameOrEmail" required>
                </div>

                <div class="form-group">
                    <label for="password" class="form-label">Password</label>
                    <input type="password" class="form-input" id="password" name="password" required>
                </div>

                <button type="submit" class="btn-login" id="loginBtn">
                    🚀 Let's Go Learning!
                </button>

                <div class="register-link">
                    <p>New to EduQuiz? <a href="${pageContext.request.contextPath}/register">Join the Fun!</a></p>
                </div>
            </form>
        </div>

        <!-- Right Side - Illustration -->
        <div class="illustration-section">
            <div class="welcome-illustration">
                <h2 class="illustration-title">Learning is Fun! 🌟</h2>
                <p class="illustration-subtitle">Join thousands of happy learners</p>
                
                <div class="fun-icons">
                    <div class="fun-icon">🎮</div>
                    <div class="fun-icon">📚</div>
                    <div class="fun-icon">🏆</div>
                </div>
                
                <div class="stats-mini">
                    <div class="stat-mini">
                        <span class="stat-mini-number">50K+</span>
                        <span>Learners</span>
                    </div>
                    <div class="stat-mini">
                        <span class="stat-mini-number">1000+</span>
                        <span>Quizzes</span>
                    </div>
                    <div class="stat-mini">
                        <span class="stat-mini-number">25+</span>
                        <span>Subjects</span>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const loginForm = document.getElementById('loginForm');
            const loginBtn = document.getElementById('loginBtn');
            const inputs = document.querySelectorAll('.form-input');

            // Add form validation
            loginForm.addEventListener('submit', function(event) {
                const username = document.getElementById('username').value.trim();
                const password = document.getElementById('password').value.trim();

                if (!username || !password) {
                    event.preventDefault();
                    showError('Please fill in all fields! 😊');
                    return false;
                }

                if (username.length < 3) {
                    event.preventDefault();
                    showError('Username must be at least 3 characters long! 📝');
                    return false;
                }

                if (password.length < 6) {
                    event.preventDefault();
                    showError('Password must be at least 6 characters long! 🔒');
                    return false;
                }

                // Show loading state
                loginBtn.classList.add('loading');
                loginBtn.textContent = 'Signing you in...';
            });

            // Input animations
            inputs.forEach(input => {
                input.addEventListener('focus', function() {
                    this.parentElement.style.transform = 'scale(1.02)';
                });

                input.addEventListener('blur', function() {
                    this.parentElement.style.transform = 'scale(1)';
                });

                input.addEventListener('input', function() {
                    if (this.value.length > 0) {
                        this.style.borderColor = '#96CEB4';
                        this.style.background = 'white';
                    }
                });
            });

            // Add floating animation to decorations
            const decorations = document.querySelectorAll('.decoration');
            decorations.forEach((decoration, index) => {
                decoration.style.animation += `, float${index} 6s ease-in-out infinite`;
                decoration.style.animationDelay = `${index * 0.8}s`;
            });

            // Create floating keyframes dynamically
            const style = document.createElement('style');
            let keyframes = '';
            for (let i = 0; i < decorations.length; i++) {
                keyframes += `
                    @keyframes float${i} {
                        0%, 100% { transform: translateY(0px) rotate(0deg); }
                        50% { transform: translateY(-${15 + i * 5}px) rotate(${180 + i * 30}deg); }
                    }
                `;
            }
            style.textContent = keyframes;
            document.head.appendChild(style);

            // Success animation on form elements
            function showError(message) {
                // Remove existing alerts
                const existingAlert = document.querySelector('.alert');
                if (existingAlert) {
                    existingAlert.remove();
                }

                // Create new alert
                const alert = document.createElement('div');
                alert.className = 'alert';
                alert.textContent = message;
                
                const firstFormGroup = document.querySelector('.form-group');
                firstFormGroup.parentNode.insertBefore(alert, firstFormGroup);
            }

            // Add click celebration effect
            loginBtn.addEventListener('click', function(e) {
                if (loginForm.checkValidity()) {
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