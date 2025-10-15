<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EduQuiz - Join the Fun! 🎉</title>
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
            position: fixed;
        }

        .nav {
            display: flex;
            justify-content: space-between;
            align-items: center;
            max-width: 1400px;
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

        .back-link {
            color: #333;
            text-decoration: none;
            font-weight: 700;
            font-size: 1.1rem;
            padding: 0.7rem 1.2rem;
            border-radius: 25px;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .back-link:hover {
            background: linear-gradient(45deg, #FFE066, #FF6B6B);
            color: white;
            transform: translateY(-2px) scale(1.05);
            box-shadow: 0 8px 25px rgba(255, 107, 107, 0.3);
        }

        /* Main Container */
        .main-container {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 8rem 2rem 2rem;
            position: relative;
            z-index: 10;
        }

        .register-container {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            border-radius: 30px;
            padding: 3rem;
            box-shadow: 0 25px 80px rgba(0, 0, 0, 0.15);
            max-width: 500px;
            width: 100%;
            animation: slideInUp 0.8s ease-out;
            position: relative;
            overflow: hidden;
        }

        @keyframes slideInUp {
            from { opacity: 0; transform: translateY(50px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .register-container::before {
            content: "";
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 5px;
            background: linear-gradient(45deg, #FFE066, #FF6B6B, #4ECDC4, #45B7D1);
            background-size: 400% 400%;
            animation: gradientShift 3s ease infinite;
        }

        .register-header {
            text-align: center;
            margin-bottom: 2.5rem;
        }

        .register-title {
            font-size: 2.5rem;
            font-weight: 900;
            background: linear-gradient(45deg, #FF6B6B, #4ECDC4);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin-bottom: 0.5rem;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
        }

        .register-subtitle {
            color: #666;
            font-size: 1.1rem;
            font-weight: 600;
            margin-bottom: 1rem;
        }

        .fun-emoji {
            font-size: 3rem;
            margin-bottom: 1rem;
            display: block;
            animation: bounceIn 1s ease-out;
        }

        @keyframes bounceIn {
            0% { transform: scale(0) rotate(0deg); }
            50% { transform: scale(1.3) rotate(180deg); }
            100% { transform: scale(1) rotate(360deg); }
        }

        /* Form Styles */
        .form-group {
            margin-bottom: 1.5rem;
            position: relative;
        }

        .form-label {
            display: block;
            font-weight: 700;
            color: #333;
            margin-bottom: 0.5rem;
            font-size: 1rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .form-input {
            width: 100%;
            padding: 1rem 1.2rem;
            border: 3px solid #e9ecef;
            border-radius: 20px;
            font-size: 1rem;
            font-weight: 600;
            transition: all 0.3s ease;
            background: white;
            color: #333;
        }

        .form-input:focus {
            outline: none;
            border-color: #4ECDC4;
            box-shadow: 0 0 0 3px rgba(78, 205, 196, 0.1);
            transform: translateY(-2px);
        }

        .form-input.valid {
            border-color: #96CEB4;
            background: rgba(150, 206, 180, 0.1);
        }

        .form-input.invalid {
            border-color: #FF6B6B;
            background: rgba(255, 107, 107, 0.1);
        }

        .form-feedback {
            margin-top: 0.5rem;
            font-size: 0.9rem;
            font-weight: 600;
            min-height: 20px;
            display: flex;
            align-items: center;
            gap: 0.3rem;
        }

        .form-feedback.valid {
            color: #96CEB4;
        }

        .form-feedback.invalid {
            color: #FF6B6B;
        }

        .password-strength {
            margin-top: 0.5rem;
            display: flex;
            gap: 0.3rem;
        }

        .strength-bar {
            height: 4px;
            flex: 1;
            background: #e9ecef;
            border-radius: 2px;
            transition: all 0.3s ease;
        }

        .strength-bar.active {
            background: linear-gradient(45deg, #FFE066, #96CEB4);
        }

        /* Alert Styles */
        .alert {
            padding: 1rem 1.5rem;
            border-radius: 20px;
            margin-bottom: 1.5rem;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            animation: slideInDown 0.5s ease-out;
        }

        @keyframes slideInDown {
            from { opacity: 0; transform: translateY(-20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .alert-danger {
            background: rgba(255, 107, 107, 0.1);
            color: #FF6B6B;
            border: 2px solid rgba(255, 107, 107, 0.3);
        }

        .alert-success {
            background: rgba(150, 206, 180, 0.1);
            color: #96CEB4;
            border: 2px solid rgba(150, 206, 180, 0.3);
        }

        /* Button Styles */
        .btn-register {
            width: 100%;
            padding: 1.2rem;
            border: none;
            border-radius: 25px;
            font-size: 1.2rem;
            font-weight: 800;
            cursor: pointer;
            transition: all 0.3s ease;
            background: linear-gradient(45deg, #FF6B6B, #FFE066);
            color: #333;
            box-shadow: 0 8px 25px rgba(255, 107, 107, 0.3);
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
        }

        .btn-register:hover:not(:disabled) {
            transform: translateY(-3px) scale(1.02);
            box-shadow: 0 15px 40px rgba(255, 107, 107, 0.5);
            background: linear-gradient(45deg, #FFE066, #FF6B6B);
        }

        .btn-register:disabled {
            opacity: 0.6;
            cursor: not-allowed;
            transform: none;
        }

        .btn-register:active {
            transform: translateY(-1px) scale(1.01);
        }

        /* Loading spinner */
        .loading-spinner {
            width: 20px;
            height: 20px;
            border: 2px solid #333;
            border-top: 2px solid transparent;
            border-radius: 50%;
            animation: spin 1s linear infinite;
            display: none;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        /* Footer */
        .register-footer {
            text-align: center;
            padding-top: 1.5rem;
            border-top: 2px solid #f8f9fa;
            margin-top: 1rem;
        }

        .register-footer p {
            color: #666;
            font-weight: 600;
            margin: 0;
        }

        .register-footer a {
            color: #4ECDC4;
            text-decoration: none;
            font-weight: 700;
            padding: 0.3rem 0.8rem;
            border-radius: 15px;
            transition: all 0.3s ease;
        }

        .register-footer a:hover {
            background: #4ECDC4;
            color: white;
            transform: scale(1.05);
        }

        /* Fun Stats */
        .fun-stats {
            display: flex;
            justify-content: space-around;
            margin: 1.5rem 0;
            padding: 1rem;
            background: rgba(78, 205, 196, 0.1);
            border-radius: 20px;
            border: 2px solid rgba(78, 205, 196, 0.2);
        }

        .fun-stat {
            text-align: center;
        }

        .fun-stat-number {
            font-size: 1.5rem;
            font-weight: 900;
            color: #4ECDC4;
            display: block;
        }

        .fun-stat-label {
            font-size: 0.8rem;
            color: #666;
            font-weight: 600;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .register-container {
                margin: 1rem;
                padding: 2rem;
            }
            
            .register-title {
                font-size: 2rem;
                flex-direction: column;
                gap: 0.5rem;
            }
            
            .nav {
                padding: 0 1rem;
            }
            
            .logo {
                font-size: 2rem;
            }
            
            .fun-stats {
                flex-direction: column;
                gap: 1rem;
            }
        }

        /* Success celebration */
        .celebration {
            position: fixed;
            pointer-events: none;
            z-index: 9999;
            font-size: 2rem;
            animation: celebrate 2s ease-out forwards;
        }

        @keyframes celebrate {
            0% { 
                opacity: 1; 
                transform: translate(0, 0) scale(1) rotate(0deg); 
            }
            100% { 
                opacity: 0; 
                transform: translate(var(--x), var(--y)) scale(0.5) rotate(360deg); 
            }
        }
    </style>
</head>
<body>
    <!-- Floating Decorations -->
    <div class="decoration star" style="top: 15%; left: 10%;">⭐</div>
    <div class="decoration heart" style="top: 25%; right: 15%;">❤️</div>
    <div class="decoration lightning" style="top: 60%; left: 5%;">⚡</div>
    <div class="decoration star" style="bottom: 20%; right: 10%;">✨</div>
    <div class="decoration heart" style="bottom: 40%; left: 12%;">💛</div>
    <div class="decoration lightning" style="top: 40%; right: 8%;">🚀</div>

    <!-- Header -->
    <header class="header">
        <nav class="nav">
            <a href="${pageContext.request.contextPath}/home" class="logo">EduQuiz</a>
            <a href="${pageContext.request.contextPath}/home" class="back-link">
                <span>←</span>
                <span>Back to Home</span>
            </a>
        </nav>
    </header>

    <!-- Main Content -->
    <div class="main-container">
        <div class="register-container">
            <div class="register-header">
                <span class="fun-emoji">🎉</span>
                <h1 class="register-title">
                    <span>Join the Fun!</span>
                </h1>
                <p class="register-subtitle">
                    Create your account and start your learning adventure! 🚀
                </p>
                
                <div class="fun-stats">
                    <div class="fun-stat">
                        <span class="fun-stat-number">50K+</span>
                        <span class="fun-stat-label">Happy Learners</span>
                    </div>
                    <div class="fun-stat">
                        <span class="fun-stat-number">1000+</span>
                        <span class="fun-stat-label">Fun Quizzes</span>
                    </div>
                    <div class="fun-stat">
                        <span class="fun-stat-number">25+</span>
                        <span class="fun-stat-label">Subjects</span>
                    </div>
                </div>
            </div>

            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger">
                    <span>😔</span>
                    <span>${errorMessage}</span>
                </div>
            </c:if>
            
            <form action="${pageContext.request.contextPath}/register" method="post" id="registerForm">
                <div class="form-group">
                    <label for="username" class="form-label">
                        <span>👤</span>
                        <span>Username</span>
                    </label>
                    <input type="text" class="form-input" id="username" name="username" required>
                    <div class="form-feedback" id="usernameFeedback">Choose a cool username! (at least 3 characters)</div>
                </div>

                <div class="form-group">
                    <label for="email" class="form-label">
                        <span>📧</span>
                        <span>Email Address</span>
                    </label>
                    <input type="email" class="form-input" id="email" name="email" required>
                    <div class="form-feedback" id="emailFeedback">We'll send you awesome quiz updates!</div>
                </div>

                <div class="form-group">
                    <label for="password" class="form-label">
                        <span>🔒</span>
                        <span>Password</span>
                    </label>
                    <input type="password" class="form-input" id="password" name="password" required>
                    <div class="password-strength" id="passwordStrength">
                        <div class="strength-bar"></div>
                        <div class="strength-bar"></div>
                        <div class="strength-bar"></div>
                        <div class="strength-bar"></div>
                    </div>
                    <div class="form-feedback" id="passwordFeedback">Make it strong! (at least 8 characters with numbers)</div>
                </div>

                <div class="form-group">
                    <label for="confirmPassword" class="form-label">
                        <span>🔐</span>
                        <span>Confirm Password</span>
                    </label>
                    <input type="password" class="form-input" id="confirmPassword" name="confirmPassword" required>
                    <div class="form-feedback" id="confirmPasswordFeedback">Make sure passwords match!</div>
                </div>

                <button type="submit" class="btn-register" id="submitBtn">
                    <span id="btnText">🎯 Join the Adventure!</span>
                    <div class="loading-spinner" id="loadingSpinner"></div>
                </button>
            </form>

            <div class="register-footer">
                <p>Already part of the family? <a href="${pageContext.request.contextPath}/login">Sign In Here! 🏠</a></p>
            </div>
        </div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const form = document.getElementById('registerForm');
            const submitBtn = document.getElementById('submitBtn');
            const btnText = document.getElementById('btnText');
            const loadingSpinner = document.getElementById('loadingSpinner');
            
            // Form inputs
            const username = document.getElementById('username');
            const email = document.getElementById('email');
            const password = document.getElementById('password');
            const confirmPassword = document.getElementById('confirmPassword');
            
            // Feedback elements
            const usernameFeedback = document.getElementById('usernameFeedback');
            const emailFeedback = document.getElementById('emailFeedback');
            const passwordFeedback = document.getElementById('passwordFeedback');
            const confirmPasswordFeedback = document.getElementById('confirmPasswordFeedback');
            const passwordStrength = document.getElementById('passwordStrength');

            // Validation functions
            function validateUsername() {
                const value = username.value.trim();
                const isValid = value.length >= 3;
                
                if (value.length === 0) {
                    setFieldState(username, usernameFeedback, 'Choose a cool username! (at least 3 characters)', 'neutral');
                } else if (isValid) {
                    setFieldState(username, usernameFeedback, '✨ Great username choice!', 'valid');
                } else {
                    setFieldState(username, usernameFeedback, '😅 Need at least 3 characters!', 'invalid');
                }
                
                return isValid;
            }

            function validateEmail() {
                const value = email.value.trim();
                const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                const isValid = emailRegex.test(value);
                
                if (value.length === 0) {
                    setFieldState(email, emailFeedback, 'We\'ll send you awesome quiz updates!', 'neutral');
                } else if (isValid) {
                    setFieldState(email, emailFeedback, '📧 Perfect email address!', 'valid');
                } else {
                    setFieldState(email, emailFeedback, '😬 Please enter a valid email!', 'invalid');
                }
                
                return isValid;
            }

            function validatePassword() {
                const value = password.value;
                const hasNumber = /\d/.test(value);
                const hasLength = value.length >= 8;
                const isValid = hasNumber && hasLength;
                
                // Update strength indicator
                const strengthBars = passwordStrength.querySelectorAll('.strength-bar');
                let strength = 0;
                
                if (value.length >= 6) strength++;
                if (value.length >= 8) strength++;
                if (hasNumber) strength++;
                if (/[A-Z]/.test(value)) strength++;
                
                strengthBars.forEach((bar, index) => {
                    bar.classList.toggle('active', index < strength);
                });
                
                if (value.length === 0) {
                    setFieldState(password, passwordFeedback, 'Make it strong! (at least 8 characters with numbers)', 'neutral');
                } else if (isValid) {
                    setFieldState(password, passwordFeedback, '🔒 Super secure password!', 'valid');
                } else {
                    setFieldState(password, passwordFeedback, '💪 Need 8+ characters with numbers!', 'invalid');
                }
                
                return isValid;
            }

            function validateConfirmPassword() {
                const value = confirmPassword.value;
                const isValid = value === password.value && value.length > 0;
                
                if (value.length === 0) {
                    setFieldState(confirmPassword, confirmPasswordFeedback, 'Make sure passwords match!', 'neutral');
                } else if (isValid) {
                    setFieldState(confirmPassword, confirmPasswordFeedback, '🎯 Passwords match perfectly!', 'valid');
                } else {
                    setFieldState(confirmPassword, confirmPasswordFeedback, '😮 Passwords don\'t match!', 'invalid');
                }
                
                return isValid;
            }

            function setFieldState(field, feedback, message, state) {
                field.classList.remove('valid', 'invalid');
                feedback.classList.remove('valid', 'invalid');
                
                if (state === 'valid') {
                    field.classList.add('valid');
                    feedback.classList.add('valid');
                } else if (state === 'invalid') {
                    field.classList.add('invalid');
                    feedback.classList.add('invalid');
                }
                
                feedback.textContent = message;
            }

            function validateForm() {
                const isUsernameValid = validateUsername();
                const isEmailValid = validateEmail();
                const isPasswordValid = validatePassword();
                const isConfirmPasswordValid = validateConfirmPassword();
                
                const isFormValid = isUsernameValid && isEmailValid && isPasswordValid && isConfirmPasswordValid;
                
                submitBtn.disabled = !isFormValid;
                
                return isFormValid;
            }

            // Event listeners
            username.addEventListener('input', validateForm);
            email.addEventListener('input', validateForm);
            password.addEventListener('input', () => {
                validateForm();
                if (confirmPassword.value) validateConfirmPassword();
            });
            confirmPassword.addEventListener('input', validateForm);

            // Form submission
            form.addEventListener('submit', function(event) {
                if (!validateForm()) {
                    event.preventDefault();
                    return;
                }

                // Show loading state
                btnText.textContent = '🚀 Creating your account...';
                loadingSpinner.style.display = 'block';
                submitBtn.disabled = true;

                // Create celebration effect
                createCelebration();
            });

            function createCelebration() {
                const emojis = ['🎉', '🎊', '⭐', '🌟', '💫', '✨', '🎈', '🎯'];
                for (let i = 0; i < 12; i++) {
                    setTimeout(() => {
                        const emoji = document.createElement('div');
                        emoji.className = 'celebration';
                        emoji.textContent = emojis[Math.floor(Math.random() * emojis.length)];
                        emoji.style.left = Math.random() * window.innerWidth + 'px';
                        emoji.style.top = Math.random() * window.innerHeight + 'px';
                        emoji.style.setProperty('--x', (Math.random() * 400 - 200) + 'px');
                        emoji.style.setProperty('--y', (Math.random() * -400 - 100) + 'px');
                        document.body.appendChild(emoji);
                        
                        setTimeout(() => emoji.remove(), 2000);
                    }, i * 100);
                }
            }

            // Add floating animation to decorations
            const decorations = document.querySelectorAll('.decoration');
            decorations.forEach((decoration, index) => {
                decoration.style.animation += `, float${index} 6s ease-in-out infinite`;
                decoration.style.animationDelay = `${index * 0.5}s`;
            });

            // Create floating keyframes dynamically
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

            // Initial validation
            validateForm();
        });
    </script>
</body>
</html>