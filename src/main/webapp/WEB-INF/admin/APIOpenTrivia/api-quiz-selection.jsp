<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Random Quiz - EduQuiz</title>
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

        .brain {
            color: #FF6B6B;
            font-size: 1.8rem;
            animation: bounce 4s ease-in-out infinite;
        }

        .rocket {
            color: #45B7D1;
            font-size: 2rem;
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

        .header {
            position: fixed;
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

        .nav-links a:hover, .nav-links a.active {
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

        .main-content {
            padding-top: 6rem;
            padding-bottom: 3rem;
            min-height: 100vh;
        }

        .quiz-builder {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 2rem;
        }

        .page-header {
            text-align: center;
            margin-bottom: 3rem;
            animation: slideInDown 1s ease-out;
        }

        @keyframes slideInDown {
            from { opacity: 0; transform: translateY(-30px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .page-header h1 {
            font-size: clamp(2.5rem, 5vw, 3.5rem);
            font-weight: 900;
            color: #333;
            margin-bottom: 1rem;
            line-height: 1.2;
        }

        .page-header .magic-text {
            background: linear-gradient(45deg, #FF6B6B, #FFE066, #4ECDC4);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .page-header p {
            font-size: 1.3rem;
            color: #666;
            font-weight: 500;
            max-width: 600px;
            margin: 0 auto;
        }

        .alert-fun {
            background: linear-gradient(45deg, #FF6B6B, #FFE066);
            color: white;
            padding: 1.5rem;
            border-radius: 20px;
            margin-bottom: 2rem;
            box-shadow: 0 8px 25px rgba(255, 107, 107, 0.3);
            border: none;
            font-weight: 600;
            animation: slideIn 0.5s ease-out;
        }

        @keyframes slideIn {
            from { opacity: 0; transform: translateX(-30px); }
            to { opacity: 1; transform: translateX(0); }
        }

        .fun-card {
            background: white;
            border-radius: 25px;
            box-shadow: 0 15px 50px rgba(0, 0, 0, 0.1);
            margin-bottom: 2rem;
            overflow: hidden;
            transition: all 0.3s ease;
            border: 3px solid transparent;
        }

        .fun-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 25px 70px rgba(0, 0, 0, 0.15);
            border-color: rgba(255, 107, 107, 0.3);
        }

        .fun-card-header {
            background: linear-gradient(45deg, #FF6B6B, #FFE066);
            color: white;
            padding: 1.5rem 2rem;
            font-size: 1.3rem;
            font-weight: 800;
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .fun-card-body {
            padding: 2rem;
        }

        .category-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 1.5rem;
            margin-top: 1rem;
        }

        .category-card {
            background: white;
            padding: 2rem;
            border-radius: 20px;
            cursor: pointer;
            transition: all 0.3s ease;
            border: 3px solid #e9ecef;
            text-align: center;
            position: relative;
            overflow: hidden;
        }

        .category-card::before {
            content: "";
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: linear-gradient(45deg, #FFE066, #FF6B6B, #4ECDC4);
            opacity: 0;
            transition: opacity 0.3s ease;
        }

        .category-card:hover {
            transform: translateY(-8px) scale(1.02);
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.15);
            border-color: #FFE066;
        }

        .category-card.selected {
            background: linear-gradient(45deg, #FF6B6B, #FFE066);
            color: white;
            border-color: #FF6B6B;
            transform: translateY(-8px) scale(1.02);
            box-shadow: 0 20px 60px rgba(255, 107, 107, 0.4);
        }

        .category-card.selected::before {
            opacity: 0.1;
        }

        .category-card.selected .text-muted {
            color: rgba(255, 255, 255, 0.9) !important;
        }

        .category-content {
            position: relative;
            z-index: 2;
        }

        .category-icon {
            font-size: 3rem;
            margin-bottom: 1rem;
            opacity: 0.9;
            transition: all 0.3s ease;
        }

        .category-card:hover .category-icon {
            transform: scale(1.1) rotate(10deg);
        }

        .category-card h6 {
            font-size: 1.2rem;
            font-weight: 800;
            margin-bottom: 0.5rem;
        }

        .category-card .text-muted {
            font-size: 0.9rem;
            font-weight: 500;
        }

        .difficulty-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
            margin-top: 1rem;
        }

        .difficulty-option {
            background: white;
            padding: 1.5rem;
            border-radius: 20px;
            cursor: pointer;
            transition: all 0.3s ease;
            text-align: center;
            border: 3px solid #e9ecef;
            position: relative;
            overflow: hidden;
        }

        .difficulty-option::before {
            content: "";
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            opacity: 0;
            transition: opacity 0.3s ease;
        }

        .difficulty-easy::before {
            background: linear-gradient(45deg, #96CEB4, #4ECDC4);
        }

        .difficulty-medium::before {
            background: linear-gradient(45deg, #FFE066, #FFA726);
        }

        .difficulty-hard::before {
            background: linear-gradient(45deg, #FF6B6B, #E57373);
        }

        .difficulty-mixed::before {
            background: linear-gradient(45deg, #45B7D1, #9C27B0);
        }

        .difficulty-option:hover {
            transform: translateY(-5px) scale(1.05);
            box-shadow: 0 15px 40px rgba(0, 0, 0, 0.15);
        }

        .difficulty-option.selected {
            color: white;
            transform: translateY(-5px) scale(1.05);
            box-shadow: 0 15px 40px rgba(0, 0, 0, 0.2);
        }

        .difficulty-option.selected::before {
            opacity: 1;
        }

        .difficulty-easy.selected {
            border-color: #96CEB4;
        }

        .difficulty-medium.selected {
            border-color: #FFE066;
        }

        .difficulty-hard.selected {
            border-color: #FF6B6B;
        }

        .difficulty-mixed.selected {
            border-color: #45B7D1;
        }

        .difficulty-content {
            position: relative;
            z-index: 2;
        }

        .difficulty-option i {
            font-size: 2rem;
            margin-bottom: 0.5rem;
            transition: transform 0.3s ease;
        }

        .difficulty-option:hover i {
            transform: scale(1.2);
        }

        .settings-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 2rem;
            margin-top: 1rem;
        }

        .settings-group {
            background: #f8f9fa;
            padding: 1.5rem;
            border-radius: 20px;
            border: 2px solid #e9ecef;
            transition: all 0.3s ease;
        }

        .settings-group:hover {
            border-color: #4ECDC4;
            background: #f0fffe;
        }

        .form-label-fun {
            font-weight: 800;
            color: #333;
            margin-bottom: 1rem;
            font-size: 1.1rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .form-select-fun {
            background: white;
            border: 3px solid #e9ecef;
            border-radius: 15px;
            padding: 1rem 1.5rem;
            font-size: 1rem;
            font-weight: 600;
            color: #333;
            transition: all 0.3s ease;
            width: 100%;
        }

        .form-select-fun:focus {
            border-color: #4ECDC4;
            box-shadow: 0 0 0 3px rgba(78, 205, 196, 0.2);
            outline: none;
        }

        .form-check-fun {
            display: flex;
            align-items: center;
            gap: 1rem;
            padding: 1rem;
            background: white;
            border-radius: 15px;
            border: 2px solid #e9ecef;
            margin-bottom: 1rem;
            transition: all 0.3s ease;
        }

        .form-check-fun:hover {
            border-color: #4ECDC4;
            background: #f0fffe;
        }

        .form-check-input-fun {
            width: 20px;
            height: 20px;
            border-radius: 50%;
            border: 3px solid #e9ecef;
            appearance: none;
            cursor: pointer;
            transition: all 0.3s ease;
            position: relative;
        }

        .form-check-input-fun:checked {
            background: linear-gradient(45deg, #4ECDC4, #45B7D1);
            border-color: #4ECDC4;
        }

        .form-check-input-fun:checked::after {
            content: "✓";
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            color: white;
            font-weight: bold;
            font-size: 12px;
        }

        .form-check-label-fun {
            font-weight: 600;
            color: #333;
            cursor: pointer;
        }

        .quiz-preview {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 25px;
            padding: 2.5rem;
            margin-top: 2rem;
            box-shadow: 0 20px 60px rgba(102, 126, 234, 0.3);
            display: none;
            animation: slideInUp 0.5s ease-out;
        }

        @keyframes slideInUp {
            from { opacity: 0; transform: translateY(30px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .quiz-preview h4 {
            font-size: 1.8rem;
            font-weight: 900;
            margin-bottom: 1rem;
        }

        .quiz-preview p {
            font-size: 1.1rem;
            margin-bottom: 0;
            font-weight: 500;
        }

        .action-buttons {
            text-align: center;
            margin-top: 3rem;
            display: flex;
            gap: 1.5rem;
            justify-content: center;
            flex-wrap: wrap;
        }

        .btn-hero-fun {
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
            gap: 0.8rem;
            position: relative;
            overflow: hidden;
        }

        .btn-hero-fun::before {
            content: "";
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.3), transparent);
            transition: left 0.5s;
        }

        .btn-hero-fun:hover::before {
            left: 100%;
        }

        .btn-back {
            background: white;
            color: #666;
            border: 3px solid #e9ecef;
        }

        .btn-back:hover {
            background: #f8f9fa;
            color: #333;
            transform: translateY(-3px) scale(1.05);
            box-shadow: 0 12px 35px rgba(0, 0, 0, 0.1);
        }

        .btn-preview {
            background: linear-gradient(45deg, #4ECDC4, #45B7D1);
            color: white;
        }

        .btn-preview:hover {
            background: linear-gradient(45deg, #45B7D1, #4ECDC4);
            transform: translateY(-3px) scale(1.05);
            box-shadow: 0 12px 35px rgba(78, 205, 196, 0.4);
        }

        .btn-start {
            background: linear-gradient(45deg, #FF6B6B, #FFE066);
            color: #333;
        }

        .btn-start:hover {
            background: linear-gradient(45deg, #FFE066, #FF6B6B);
            transform: translateY(-3px) scale(1.05);
            box-shadow: 0 12px 35px rgba(255, 107, 107, 0.4);
        }

        .loading-overlay {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.8);
            z-index: 9999;
            backdrop-filter: blur(5px);
        }

        .loading-content {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            text-align: center;
            color: white;
        }

        .loading-spinner {
            width: 4rem;
            height: 4rem;
            margin-bottom: 2rem;
            border: 4px solid rgba(255, 255, 255, 0.3);
            border-top: 4px solid #FFE066;
            border-radius: 50%;
            animation: spin 1s linear infinite;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        .loading-content h4 {
            font-size: 2rem;
            font-weight: 900;
            margin-bottom: 1rem;
            background: linear-gradient(45deg, #FFE066, #FF6B6B);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .loading-content p {
            font-size: 1.2rem;
            font-weight: 500;
            opacity: 0.9;
        }

        @media (max-width: 768px) {
            .nav-links {
                display: none;
            }
            
            .category-grid {
                grid-template-columns: 1fr;
            }
            
            .difficulty-grid {
                grid-template-columns: 1fr;
            }
            
            .settings-grid {
                grid-template-columns: 1fr;
            }
            
            .action-buttons {
                flex-direction: column;
                align-items: center;
            }
            
            .quiz-preview {
                padding: 1.5rem;
            }
            
            .quiz-preview .row {
                flex-direction: column;
                text-align: center;
            }
            
            .quiz-preview .col-md-4 {
                margin-top: 1rem;
            }
        }

        .row {
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .col-md-8 {
            flex: 1;
        }

        .col-md-4 {
            flex-shrink: 0;
        }

        .text-end {
            text-align: right;
        }
    </style>
</head>
<body>
    <div class="decoration star" style="top: 15%; left: 10%;">⭐</div>
    <div class="decoration brain" style="top: 25%; right: 15%;">🧠</div>
    <div class="decoration rocket" style="top: 60%; left: 5%;">🚀</div>
    <div class="decoration star" style="bottom: 20%; right: 10%;">✨</div>
    <div class="decoration brain" style="bottom: 40%; left: 12%;">💡</div>
    <div class="decoration rocket" style="top: 40%; right: 8%;">🎯</div>

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
                    <c:when test="${not empty sessionScope.user}">
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
                                <a href="${pageContext.request.contextPath}/my-results" class="dropdown-item">
                                    <span>📊</span>
                                    <span>My Results</span>
                                </a>
                                <hr class="dropdown-divider">
                                <a href="${pageContext.request.contextPath}/logout" class="dropdown-item">
                                    <span>🚪</span>
                                    <span>Logout</span>
                                </a>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/login" class="btn-fun btn-outline-fun">Sign In</a>
                    </c:otherwise>
                </c:choose>
            </div>
        </nav>
    </header>

    <main class="main-content">
        <div class="quiz-builder">
            <div class="page-header">
                <h1>
                    <span class="magic-text">🎪 Create Your Random Quiz</span> 
                </h1>
                <p>Choose your preferences and we'll generate a personalized quiz just for you! 🌟</p>
            </div>

            <c:if test="${not empty errorMessage}">
                <div class="alert-fun">
                    <strong>🚨 Oops!</strong> ${errorMessage}
                </div>
            </c:if>
            <form id="quizBuilderForm" method="post" action="${pageContext.request.contextPath}/quiz/take-api">
                <div class="fun-card">
                    <div class="fun-card-header">
                        <span>🏷️</span>
                        <span>Step 1: Choose Your Topic</span>
                    </div>
                    <div class="fun-card-body">
                        <input type="hidden" id="selectedCategory" name="category" value="">
                        <div class="category-grid">
                            <div class="category-card" data-category="" data-name="Mixed Topics">
                                <div class="category-content">
                                    <div class="category-icon">🎭</div>
                                    <h6>Mixed Topics</h6>
                                    <p class="text-muted">Questions from all categories</p>
                                </div>
                            </div>
                            
                            <c:forEach items="${apiCategories}" var="apiCategory">
                                <c:set var="parts" value="${fn:split(apiCategory, '|')}" />
                                <c:if test="${fn:length(parts) >= 2}">
                                    <div class="category-card" data-category="${parts[0]}" data-name="${parts[1]}">
                                        <div class="category-content">
                                            <div class="category-icon">
                                                <c:choose>
                                                    <c:when test="${parts[0] == '9'}">🧠</c:when>
                                                    <c:when test="${parts[0] == '17'}">🧪</c:when>
                                                    <c:when test="${parts[0] == '18'}">💻</c:when>
                                                    <c:when test="${parts[0] == '19'}">🔢</c:when>
                                                    <c:when test="${parts[0] == '20'}">🐉</c:when>
                                                    <c:when test="${parts[0] == '21'}">⚽</c:when>
                                                    <c:when test="${parts[0] == '22'}">🌍</c:when>
                                                    <c:when test="${parts[0] == '23'}">🏛️</c:when>
                                                    <c:when test="${parts[0] == '25'}">🎨</c:when>
                                                    <c:when test="${parts[0] == '27'}">🐾</c:when>
                                                    <c:when test="${parts[0] == '12'}">🎵</c:when>
                                                    <c:otherwise>❓</c:otherwise>
                                                </c:choose>
                                            </div>
                                            <h6>${parts[1]}</h6>
                                            <c:if test="${fn:length(parts) >= 3}">
                                                <p class="text-muted">${parts[2]}</p>
                                            </c:if>
                                        </div>
                                    </div>
                                </c:if>
                            </c:forEach>
                        </div>
                    </div>
                </div>

                <div class="fun-card">
                    <div class="fun-card-header">
                        <span>⚙️</span>
                        <span>Step 2: Quiz Settings</span>
                    </div>
                    <div class="fun-card-body">
                        <div class="settings-grid">
                            <div class="settings-group">
                                <div class="form-label-fun">
                                    <span>🎯</span>
                                    <span>Difficulty Level</span>
                                </div>
                                <input type="hidden" id="selectedDifficulty" name="difficulty" value="">
                                <div class="difficulty-grid">
                                    <div class="difficulty-option difficulty-mixed" data-difficulty="" data-name="Mixed">
                                        <div class="difficulty-content">
                                            <i>🎲</i>
                                            <div><strong>Mixed Difficulty</strong></div>
                                            <small>Easy, Medium & Hard questions</small>
                                        </div>
                                    </div>
                                    <div class="difficulty-option difficulty-easy" data-difficulty="easy" data-name="Easy">
                                        <div class="difficulty-content">
                                            <i>😊</i>
                                            <div><strong>Easy</strong></div>
                                            <small>Great for beginners</small>
                                        </div>
                                    </div>
                                    <div class="difficulty-option difficulty-medium" data-difficulty="medium" data-name="Medium">
                                        <div class="difficulty-content">
                                            <i>🤔</i>
                                            <div><strong>Medium</strong></div>
                                            <small>Moderate challenge</small>
                                        </div>
                                    </div>
                                    <div class="difficulty-option difficulty-hard" data-difficulty="hard" data-name="Hard">
                                        <div class="difficulty-content">
                                            <i>🔥</i>
                                            <div><strong>Hard</strong></div>
                                            <small>For experts only!</small>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="settings-group">
                                <div class="form-label-fun">
                                    <span>📊</span>
                                    <span>Quiz Preferences</span>
                                </div>
                                
                                <div style="margin-bottom: 1.5rem;">
                                    <label class="form-label-fun" style="font-size: 1rem; margin-bottom: 0.5rem;">
                                        <span>📝</span>
                                        <span>Number of Questions</span>
                                    </label>
                                    <select class="form-select-fun" id="questionCount" name="amount" required>
                                        <option value="5">5 Questions (Quick) ⚡</option>
                                        <option value="10" selected>10 Questions (Standard) ⭐</option>
                                        <option value="15">15 Questions (Extended) 🚀</option>
                                        <option value="20">20 Questions (Long) 💪</option>
                                        <option value="25">25 Questions (Marathon) 🏃‍♂️</option>
                                    </select>
                                </div>

                                <div style="margin-bottom: 1.5rem;">
                                    <label class="form-label-fun" style="font-size: 1rem; margin-bottom: 0.5rem;">
                                        <span>⏰</span>
                                        <span>Time per Question</span>
                                    </label>
                                    <select class="form-select-fun" id="timePerQuestion" name="timePerQuestion">
                                        <option value="30">30 seconds ⚡</option>
                                        <option value="60" selected>1 minute ⭐</option>
                                        <option value="90">1.5 minutes 🚀</option>
                                        <option value="120">2 minutes 💪</option>
                                        <option value="0">No time limit ♾️</option>
                                    </select>
                                </div>

                                <div class="form-check-fun">
                                    <input class="form-check-input-fun" type="checkbox" id="showCorrectAnswers" name="showCorrectAnswers" checked>
                                    <label class="form-check-label-fun" for="showCorrectAnswers">
                                        ✅ Show correct answers after each question
                                    </label>
                                </div>

                                <div class="form-check-fun">
                                    <input class="form-check-input-fun" type="checkbox" id="shuffleQuestions" name="shuffleQuestions" checked>
                                    <label class="form-check-label-fun" for="shuffleQuestions">
                                        🔀 Shuffle question order
                                    </label>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div id="quizPreview" class="quiz-preview">
                    <div class="row">
                        <div class="col-md-8">
                            <h4>🎉 Ready to Start!</h4>
                            <p><span id="previewText">Your quiz is ready to go!</span></p>
                        </div>
                        <div class="col-md-4 text-end">
                            <button type="submit" class="btn-hero-fun btn-start" id="startQuizBtn">
                                <span>🚀</span>
                                <span>Start Quiz</span>
                            </button>
                        </div>
                    </div>
                </div>

                <div class="action-buttons">
                    <a href="${pageContext.request.contextPath}/quizzes" class="btn-hero-fun btn-back">
                        <span>⬅️</span>
                        <span>Back to Browse</span>
                    </a>
                    <button type="button" class="btn-hero-fun btn-preview" id="generatePreview">
                        <span>👀</span>
                        <span>Preview Quiz</span>
                    </button>
                </div>
            </form>
        </div>
    </main>

    <div class="loading-overlay" id="loadingOverlay">
        <div class="loading-content">
            <div class="loading-spinner"></div>
            <h4>🎪 Generating Your Quiz...</h4>
            <p>Fetching the most amazing questions just for you! ✨</p>
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
            const categoryCards = document.querySelectorAll('.category-card');
            const difficultyOptions = document.querySelectorAll('.difficulty-option');
            const selectedCategory = document.getElementById('selectedCategory');
            const selectedDifficulty = document.getElementById('selectedDifficulty');
            const quizPreview = document.getElementById('quizPreview');
            const previewText = document.getElementById('previewText');
            const generatePreview = document.getElementById('generatePreview');
            const quizForm = document.getElementById('quizBuilderForm');
            const loadingOverlay = document.getElementById('loadingOverlay');

            categoryCards.forEach(card => {
                card.addEventListener('click', function() {
                    categoryCards.forEach(c => c.classList.remove('selected'));
                    this.classList.add('selected');
                    selectedCategory.value = this.getAttribute('data-category');
                    
                    if (quizPreview.style.display !== 'none') {
                        updatePreview();
                    }
                });
            });

            difficultyOptions.forEach(option => {
                option.addEventListener('click', function() {
                    difficultyOptions.forEach(o => o.classList.remove('selected'));
                    this.classList.add('selected');
                    selectedDifficulty.value = this.getAttribute('data-difficulty');
                    
                    if (quizPreview.style.display !== 'none') {
                        updatePreview();
                    }
                });
            });

            document.getElementById('questionCount').addEventListener('change', function() {
                if (quizPreview.style.display !== 'none') {
                    updatePreview();
                }
            });
            
            document.getElementById('timePerQuestion').addEventListener('change', function() {
                if (quizPreview.style.display !== 'none') {
                    updatePreview();
                }
            });

            generatePreview.addEventListener('click', function() {
                if (!hasValidSelections()) {
                    alert('🎯 Please select a category and difficulty level first!');
                    return;
                }
                
                updatePreview();
                quizPreview.style.display = 'block';
                quizPreview.scrollIntoView({ behavior: 'smooth' });
            });

            quizForm.addEventListener('submit', function(e) {
                if (!hasValidSelections()) {
                    e.preventDefault();
                    alert('🎯 Please select a category and difficulty level!');
                    return;
                }

                loadingOverlay.style.display = 'block';
                
                const startBtn = document.getElementById('startQuizBtn');
                if (startBtn) {
                    startBtn.innerHTML = '<span>⏳</span><span>Creating Quiz...</span>';
                    startBtn.disabled = true;
                }
            });

            function updatePreview() {
                const category = getSelectedCategoryName();
                const difficulty = getSelectedDifficultyName();
                const questionCount = document.getElementById('questionCount').value;
                const timePerQuestion = document.getElementById('timePerQuestion').value;

                let previewHtml = `<strong>🎯 ${questionCount} ${category} questions</strong>`;
                
                if (difficulty && difficulty !== 'Mixed') {
                    previewHtml += ` • <strong>📊 ${difficulty} difficulty</strong>`;
                } else if (difficulty === 'Mixed') {
                    previewHtml += ` • <strong>🎲 Mixed difficulty</strong>`;
                }
                
                if (timePerQuestion > 0) {
                    const minutes = Math.floor(timePerQuestion / 60);
                    const seconds = timePerQuestion % 60;
                    if (minutes > 0) {
                        previewHtml += ` • <strong>⏰ ${minutes}m ${seconds}s per question</strong>`;
                    } else {
                        previewHtml += ` • <strong>⏰ ${seconds} seconds per question</strong>`;
                    }
                } else {
                    previewHtml += ` • <strong>♾️ No time limit</strong>`;
                }

                previewText.innerHTML = previewHtml;
            }

            function getSelectedCategoryName() {
                const selectedCard = document.querySelector('.category-card.selected');
                return selectedCard ? selectedCard.getAttribute('data-name') : 'Mixed Topics';
            }

            function getSelectedDifficultyName() {
                const selectedOption = document.querySelector('.difficulty-option.selected');
                return selectedOption ? selectedOption.getAttribute('data-name') : '';
            }

            function hasValidSelections() {
                const hasCategory = document.querySelector('.category-card.selected') !== null;
                const hasDifficulty = document.querySelector('.difficulty-option.selected') !== null;
                return hasCategory && hasDifficulty;
            }

            categoryCards[0].click(); 
            difficultyOptions[0].click(); 
        });
    </script>
</body>
</html>