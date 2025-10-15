<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="dz.eduquiz.util.SessionManager" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EduQuiz - Browse Amazing Quizzes!</title>
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

        /* Main Content */
        .main-content {
            padding-top: 8rem;
            max-width: 1400px;
            margin: 0 auto;
            padding-left: 2rem;
            padding-right: 2rem;
            position: relative;
            z-index: 10;
        }

        /* Page Header */
        .page-header {
            text-align: center;
            margin-bottom: 3rem;
            animation: slideInDown 0.8s ease-out;
        }

        @keyframes slideInDown {
            from { opacity: 0; transform: translateY(-30px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .page-title {
            font-size: clamp(2.5rem, 5vw, 4rem);
            font-weight: 900;
            color: #333;
            margin-bottom: 1rem;
            text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.1);
        }

        .highlight {
            background: linear-gradient(45deg, #FFE066, #FF6B6B);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .page-subtitle {
            font-size: 1.3rem;
            color: #666;
            margin-bottom: 2rem;
            font-weight: 600;
        }

        /* Random Quiz Button */
        .random-quiz-section {
            display: flex;
            justify-content: center;
            margin-bottom: 3rem;
            animation: bounceIn 1s ease-out 0.3s both;
        }

        @keyframes bounceIn {
            0% { opacity: 0; transform: scale(0.3); }
            50% { opacity: 1; transform: scale(1.05); }
            70% { transform: scale(0.9); }
            100% { opacity: 1; transform: scale(1); }
        }

        .btn-random {
            padding: 1.2rem 2.5rem;
            font-size: 1.2rem;
            font-weight: 800;
            border-radius: 35px;
            background: linear-gradient(45deg, #96CEB4, #4ECDC4);
            color: white;
            border: none;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.8rem;
            box-shadow: 0 8px 25px rgba(150, 206, 180, 0.4);
        }

        .btn-random:hover {
            background: linear-gradient(45deg, #4ECDC4, #96CEB4);
            transform: translateY(-4px) scale(1.05);
            box-shadow: 0 15px 40px rgba(150, 206, 180, 0.6);
            color: white;
        }

        /* Filter Section */
        .filters-section {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            border-radius: 30px;
            padding: 2rem;
            margin-bottom: 3rem;
            box-shadow: 0 15px 50px rgba(0, 0, 0, 0.1);
            animation: slideInUp 0.8s ease-out 0.5s both;
        }

        @keyframes slideInUp {
            from { opacity: 0; transform: translateY(30px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .filters-title {
            font-size: 1.5rem;
            font-weight: 800;
            color: #333;
            margin-bottom: 1.5rem;
            text-align: center;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
        }

        .filters-grid {
            display: grid;
            grid-template-columns: 2fr 1fr 1fr 1fr;
            gap: 1.5rem;
            align-items: end;
        }

        .filter-group {
            display: flex;
            flex-direction: column;
            gap: 0.5rem;
        }

        .filter-label {
            font-weight: 700;
            color: #333;
            font-size: 1rem;
        }

        .search-wrapper {
            position: relative;
        }

        .search-input {
            width: 100%;
            padding: 1rem 1.5rem;
            border: 3px solid #E0E7FF;
            border-radius: 25px;
            font-size: 1rem;
            font-weight: 600;
            background: white;
            transition: all 0.3s ease;
        }

        .search-input:focus {
            outline: none;
            border-color: #FFE066;
            box-shadow: 0 0 20px rgba(255, 224, 102, 0.3);
            transform: scale(1.02);
        }

        .filter-select {
            padding: 1rem 1.5rem;
            border: 3px solid #E0E7FF;
            border-radius: 25px;
            font-size: 1rem;
            font-weight: 600;
            background: white;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .filter-select:focus {
            outline: none;
            border-color: #4ECDC4;
            box-shadow: 0 0 20px rgba(78, 205, 196, 0.3);
            transform: scale(1.02);
        }

        .search-btn {
            padding: 1rem 2rem;
            background: linear-gradient(45deg, #FF6B6B, #FFE066);
            color: white;
            border: none;
            border-radius: 25px;
            font-weight: 700;
            font-size: 1rem;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .search-btn:hover {
            background: linear-gradient(45deg, #FFE066, #FF6B6B);
            transform: translateY(-2px) scale(1.05);
            box-shadow: 0 8px 25px rgba(255, 107, 107, 0.4);
        }

        /* Quiz Grid */
        .quiz-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
            gap: 2rem;
            margin-bottom: 3rem;
        }

        .quiz-card {
            background: white;
            border-radius: 25px;
            overflow: hidden;
            box-shadow: 0 15px 40px rgba(0, 0, 0, 0.1);
            transition: all 0.4s ease;
            cursor: pointer;
            position: relative;
            animation: fadeInUp 0.6s ease-out;
        }

        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(30px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .quiz-card:hover {
            transform: translateY(-10px) scale(1.02);
            box-shadow: 0 25px 60px rgba(0, 0, 0, 0.15);
        }

        .quiz-card::before {
            content: "";
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 5px;
            background: linear-gradient(45deg, #FFE066, #FF6B6B, #4ECDC4, #45B7D1);
            background-size: 300% 300%;
            animation: gradientShift 3s ease infinite;
        }

        .difficulty-badge {
            position: absolute;
            top: 1rem;
            right: 1rem;
            padding: 0.5rem 1rem;
            border-radius: 20px;
            font-weight: 700;
            font-size: 0.9rem;
            color: white;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            z-index: 2;
        }

        .difficulty-easy {
            background: linear-gradient(45deg, #96CEB4, #4ECDC4);
        }

        .difficulty-medium {
            background: linear-gradient(45deg, #FFE066, #FFA726);
        }

        .difficulty-hard {
            background: linear-gradient(45deg, #FF6B6B, #E57373);
        }

        .quiz-content {
            padding: 2rem;
            position: relative;
        }

        .quiz-title {
            font-size: 1.4rem;
            font-weight: 800;
            color: #333;
            margin-bottom: 1rem;
            line-height: 1.3;
        }

        .quiz-description {
            color: #666;
            font-size: 1rem;
            line-height: 1.6;
            margin-bottom: 1.5rem;
            font-weight: 500;
        }

        .quiz-meta {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1.5rem;
            font-size: 0.9rem;
            color: #888;
            font-weight: 600;
        }

        .quiz-category {
            background: linear-gradient(45deg, #E1F5FE, #F3E5F5);
            padding: 0.3rem 0.8rem;
            border-radius: 15px;
            color: #333;
        }

        .quiz-time {
            display: flex;
            align-items: center;
            gap: 0.3rem;
        }

        .quiz-actions {
            display: flex;
            gap: 1rem;
        }

        .btn-quiz {
            flex: 1;
            padding: 0.8rem 1.5rem;
            border-radius: 20px;
            font-weight: 700;
            font-size: 0.95rem;
            cursor: pointer;
            transition: all 0.3s ease;
            border: none;
            text-decoration: none;
            text-align: center;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
        }

        .btn-details {
            background: linear-gradient(45deg, #4ECDC4, #45B7D1);
            color: white;
        }

        .btn-details:hover {
            background: linear-gradient(45deg, #45B7D1, #4ECDC4);
            transform: translateY(-2px) scale(1.05);
            box-shadow: 0 8px 25px rgba(78, 205, 196, 0.4);
            color: white;
        }

        .btn-take-quiz {
            background: linear-gradient(45deg, #FF6B6B, #FFE066);
            color: white;
        }

        .btn-take-quiz:hover {
            background: linear-gradient(45deg, #FFE066, #FF6B6B);
            transform: translateY(-2px) scale(1.05);
            box-shadow: 0 8px 25px rgba(255, 107, 107, 0.4);
            color: white;
        }

        /* No Results */
        .no-results {
            text-align: center;
            padding: 4rem 2rem;
            background: rgba(255, 255, 255, 0.9);
            border-radius: 30px;
            margin: 2rem 0;
        }

        .no-results-emoji {
            font-size: 4rem;
            margin-bottom: 1rem;
        }

        .no-results-title {
            font-size: 2rem;
            font-weight: 800;
            color: #333;
            margin-bottom: 1rem;
        }

        .no-results-text {
            font-size: 1.1rem;
            color: #666;
            font-weight: 500;
        }

        /* Pagination */
        .pagination-wrapper {
            display: flex;
            justify-content: center;
            margin: 3rem 0;
        }

        .pagination {
            display: flex;
            gap: 0.5rem;
            list-style: none;
            background: rgba(255, 255, 255, 0.9);
            padding: 1rem;
            border-radius: 25px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
        }

        .page-item {
            display: flex;
        }

        .page-link {
            padding: 0.8rem 1.2rem;
            color: #333;
            text-decoration: none;
            border-radius: 15px;
            font-weight: 700;
            transition: all 0.3s ease;
        }

        .page-link:hover {
            background: linear-gradient(45deg, #FFE066, #FF6B6B);
            color: white;
            transform: scale(1.1);
        }

        .page-item.active .page-link {
            background: linear-gradient(45deg, #4ECDC4, #45B7D1);
            color: white;
        }

        .page-item.disabled .page-link {
            opacity: 0.5;
            cursor: not-allowed;
        }

        .page-item.disabled .page-link:hover {
            background: none;
            color: #333;
            transform: none;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .nav-links {
                display: none;
            }
            
            .filters-grid {
                grid-template-columns: 1fr;
                gap: 1rem;
            }
            
            .quiz-grid {
                grid-template-columns: 1fr;
                gap: 1.5rem;
            }
            
            .quiz-actions {
                flex-direction: column;
            }
            
            .main-content {
                padding-left: 1rem;
                padding-right: 1rem;
            }

            .dropdown-menu {
                right: -1rem;
                min-width: 200px;
            }
        }

        @media (max-width: 480px) {
            .page-title {
                font-size: 2rem;
            }
            
            .filters-section {
                padding: 1.5rem;
            }
            
            .quiz-content {
                padding: 1.5rem;
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
    <div class="decoration star" style="top: 70%; left: 8%;">⭐</div>
    <div class="decoration heart" style="top: 80%; right: 12%;">💚</div>

    <!-- Header -->
    <header class="header">
        <nav class="nav">
            <a href="${pageContext.request.contextPath}/home" class="logo">EduQuiz</a>
            
            <ul class="nav-links">
                <li><a href="${pageContext.request.contextPath}/quizzes" class="active">Quizzes</a></li>
                <li><a href="${pageContext.request.contextPath}/leaderboard">Leaderboard</a></li>
                <li><a href="${pageContext.request.contextPath}/history">History</a></li>
            </ul>
            
            <div class="auth-buttons">
                <c:choose>
                    <c:when test="${sessionScope.user != null}">
                        <!-- User is logged in - show profile dropdown -->
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
                        <!-- User is not logged in - show login/register buttons -->
                        <a href="${pageContext.request.contextPath}/login" class="btn-fun btn-outline-fun">Sign In</a>
                        <a href="${pageContext.request.contextPath}/register" class="btn-fun btn-primary-fun">Join Fun! 🎉</a>
                    </c:otherwise>
                </c:choose>
            </div>
        </nav>
    </header>

    <!-- Main Content -->
    <main class="main-content">
        <!-- Page Header -->
        <div class="page-header">
            <h1 class="page-title">
                Discover <span class="highlight">Amazing Quizzes!</span> 🎯
            </h1>
            <p class="page-subtitle">
                Challenge yourself with thousands of fun, interactive quizzes across all subjects! 🌟
            </p>
        </div>

        <!-- Random Quiz Section -->
        <div class="random-quiz-section">
            <a href="${pageContext.request.contextPath}/quiz/api-quiz" class="btn-random">
                🎲 Surprise Me with Random Quiz!
            </a>
        </div>

        <!-- Filters Section -->
        <div class="filters-section">
            <div class="filters-title">
                🔍 Find Your Perfect Quiz
            </div>
            <div class="filters-grid">
                <div class="filter-group">
                    <label class="filter-label">🔎 Search Quizzes</label>
                    <div class="search-wrapper">
                        <input type="text" class="search-input" id="searchQuiz" placeholder="What do you want to learn today?" value="${param.search}">
                    </div>
                </div>
                <div class="filter-group">
                    <label class="filter-label">📚 Category</label>
                    <select class="filter-select" id="categoryFilter">
                        <option value="">All Categories</option>
                        <c:forEach items="${categories}" var="category">
                            <option value="${category.id}" ${param.category eq category.id ? 'selected' : ''}>${category.name}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="filter-group">
                    <label class="filter-label">⚡ Difficulty</label>
                    <select class="filter-select" id="difficultyFilter">
                        <option value="">All Levels</option>
                        <option value="easy" ${param.difficulty eq 'easy' ? 'selected' : ''}>🟢 Easy</option>
                        <option value="medium" ${param.difficulty eq 'medium' ? 'selected' : ''}>🟡 Medium</option>
                        <option value="hard" ${param.difficulty eq 'hard' ? 'selected' : ''}>🔴 Hard</option>
                    </select>
                </div>
                <div class="filter-group">
                    <label class="filter-label">📊 Sort By </label>
                    <select class="filter-select" id="sortBy">
                        <option value="newest" ${param.sort eq 'newest' ? 'selected' : ''}>🆕 Newest First</option>
                        <option value="popular" ${param.sort eq 'popular' ? 'selected' : ''}>🔥 Most Popular</option>
                        <option value="difficulty" ${param.sort eq 'difficulty' ? 'selected' : ''}>⚡ By Difficulty</option>
                    </select>
                </div>
            </div>
            <div style="text-align: center; margin-top: 1.5rem;">
                <button class="search-btn" onclick="applyFilters()">
                    🔍 Search Quizzes
                </button>
            </div>
        </div>

        <!-- Quiz Grid -->
        <div class="quiz-grid" id="quizList">
            <c:forEach items="${quizzes}" var="quiz">
                <div class="quiz-card" onclick="viewQuizDetails('${pageContext.request.contextPath}/quiz/${quiz.id}')">
                    <div class="difficulty-badge difficulty-${quiz.difficulty.toLowerCase()}">
                        ${quiz.difficulty}
                    </div>
                    <div class="quiz-content">
                        <h3 class="quiz-title">${quiz.title}</h3>
                        <p class="quiz-description">${quiz.description}</p>
                        <div class="quiz-meta">
                            <span class="quiz-category">📚 ${quiz.category.name}</span>
                            <span class="quiz-time">⏱️ ${quiz.timeLimit} min</span>
                        </div>
                        <div class="quiz-actions">
                            <a href="${pageContext.request.contextPath}/quiz/${quiz.id}" class="btn-quiz btn-details" onclick="event.stopPropagation()">
                                👁️ View Details
                            </a>
                            <a href="${pageContext.request.contextPath}/take-quiz/${quiz.id}" class="btn-quiz btn-take-quiz" onclick="event.stopPropagation()">
                                🚀 Take Quiz
                            </a>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>

        <!-- No Results Message -->
        <c:if test="${empty quizzes}">
            <div class="no-results">
                <div class="no-results-emoji">😔</div>
                <h2 class="no-results-title">Oops! No Quizzes Found</h2>
                <p class="no-results-text">
                    Try adjusting your search filters or explore different categories to find amazing quizzes! 🎯
                </p>
            </div>
        </c:if>

        <!-- Pagination -->
        <c:if test="${totalPages > 1}">
            <div class="pagination-wrapper">
                <nav aria-label="Quiz pagination">
                    <ul class="pagination">
                        <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                            <a class="page-link" href="${pageContext.request.contextPath}/quizzes?page=${currentPage - 1}&category=${param.category}&difficulty=${param.difficulty}&search=${param.search}&sort=${param.sort}" tabindex="-1">
                                ⬅️ Previous
                            </a>
                        </li>
                        
                        <c:forEach begin="1" end="${totalPages}" var="i">
                            <li class="page-item ${currentPage == i ? 'active' : ''}">
                                <a class="page-link" href="${pageContext.request.contextPath}/quizzes?page=${i}&category=${param.category}&difficulty=${param.difficulty}&search=${param.search}&sort=${param.sort}">
                                    ${i}
                                </a>
                            </li>
                        </c:forEach>
                        
                        <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                            <a class="page-link" href="${pageContext.request.contextPath}/quizzes?page=${currentPage + 1}&category=${param.category}&difficulty=${param.difficulty}&search=${param.search}&sort=${param.sort}">
                                Next ➡️
                            </a>
                        </li>
                    </ul>
                </nav>
            </div>
        </c:if>
    </main>

    <!-- JavaScript -->
    <script>
        // Dropdown functionality
        function toggleDropdown() {
            const dropdown = document.getElementById('userDropdown');
            dropdown.classList.toggle('show');
        }

        // Close dropdown when clicking outside
        document.addEventListener('click', function(event) {
            const dropdown = document.getElementById('userDropdown');
            const userProfile = document.querySelector('.user-profile');
            
            if (!userProfile.contains(event.target)) {
                dropdown.classList.remove('show');
            }
        });

        // Quiz card click handler
        function viewQuizDetails(url) {
            window.location.href = url;
        }

        // Filter functionality
        document.addEventListener('DOMContentLoaded', function() {
            const categoryFilter = document.getElementById('categoryFilter');
            const difficultyFilter = document.getElementById('difficultyFilter');
            const sortBy = document.getElementById('sortBy');
            const searchQuiz = document.getElementById('searchQuiz');
            
            // Add event listeners
            categoryFilter.addEventListener('change', applyFilters);
            difficultyFilter.addEventListener('change', applyFilters);
            sortBy.addEventListener('change', applyFilters);
            
            // Search on Enter key
            searchQuiz.addEventListener('keypress', function(e) {
                if (e.key === 'Enter') {
                    applyFilters();
                }
            });

            // Add animation delays to quiz cards
            const quizCards = document.querySelectorAll('.quiz-card');
            quizCards.forEach((card, index) => {
                card.style.animationDelay = `${index * 0.1}s`;
            });
        });

        function applyFilters() {
            const category = document.getElementById('categoryFilter').value;
            const difficulty = document.getElementById('difficultyFilter').value;
            const sort = document.getElementById('sortBy').value;
            const search = document.getElementById('searchQuiz').value;
            
            let url = '${pageContext.request.contextPath}/quizzes?page=1';
            if (category) url += '&category=' + encodeURIComponent(category);
            if (difficulty) url += '&difficulty=' + encodeURIComponent(difficulty);
            if (sort) url += '&sort=' + encodeURIComponent(sort);
            if (search) url += '&search=' + encodeURIComponent(search);
            
            window.location.href = url;
        }

        // Add some interactive effects
        document.addEventListener('DOMContentLoaded', function() {
            // Add hover effect to decorative elements
            const decorations = document.querySelectorAll('.decoration');
            decorations.forEach(decoration => {
                decoration.addEventListener('mouseenter', function() {
                    this.style.transform = 'scale(1.3) rotate(15deg)';
                });
                
                decoration.addEventListener('mouseleave', function() {
                    this.style.transform = 'scale(1) rotate(0deg)';
                });
            });

            // Add ripple effect to buttons
            const buttons = document.querySelectorAll('.btn-fun, .btn-random, .search-btn, .btn-quiz');
            buttons.forEach(button => {
                button.addEventListener('click', function(e) {
                    const ripple = document.createElement('span');
                    const rect = this.getBoundingClientRect();
                    const size = Math.max(rect.width, rect.height);
                    const x = e.clientX - rect.left - size / 2;
                    const y = e.clientY - rect.top - size / 2;
                    
                    ripple.style.width = ripple.style.height = size + 'px';
                    ripple.style.left = x + 'px';
                    ripple.style.top = y + 'px';
                    ripple.classList.add('ripple');
                    
                    this.appendChild(ripple);
                    
                    setTimeout(() => {
                        ripple.remove();
                    }, 600);
                });
            });
        });
    </script>

    <!-- Add ripple effect CSS -->
    <style>
        .ripple {
            position: absolute;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.6);
            transform: scale(0);
            animation: ripple-animation 0.6s linear;
            pointer-events: none;
        }

        @keyframes ripple-animation {
            to {
                transform: scale(4);
                opacity: 0;
            }
        }

        button, .btn-fun, .btn-random, .search-btn, .btn-quiz {
            position: relative;
            overflow: hidden;
        }
    </style>
</body>
</html>