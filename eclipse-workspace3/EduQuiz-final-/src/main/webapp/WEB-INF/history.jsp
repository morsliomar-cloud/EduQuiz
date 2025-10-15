<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EduQuiz - Quiz History</title>
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

        /* Container */
        .container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 8rem 2rem 4rem;
            animation: slideInUp 1s ease-out;
        }

        @keyframes slideInUp {
            from { opacity: 0; transform: translateY(30px); }
            to { opacity: 1; transform: translateY(0); }
        }

        /* Fun Card Style */
        .fun-card {
            background: white;
            border-radius: 30px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.1);
            backdrop-filter: blur(20px);
            padding: 2rem;
            margin-bottom: 2rem;
            transition: all 0.3s ease;
            border: 3px solid transparent;
            position: relative;
            overflow: hidden;
        }

        .fun-card:hover {
            transform: translateY(-5px) scale(1.02);
            box-shadow: 0 30px 80px rgba(0, 0, 0, 0.15);
            border-color: #FFE066;
        }

        .fun-card::before {
            content: "";
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255, 224, 102, 0.1), transparent);
            transition: left 0.5s;
        }

        .fun-card:hover::before {
            left: 100%;
        }

        /* Header Section */
        .page-header {
            text-align: center;
            margin-bottom: 3rem;
        }

        .page-title {
            font-size: clamp(2.5rem, 5vw, 3.5rem);
            font-weight: 900;
            background: linear-gradient(45deg, #FF6B6B, #4ECDC4, #45B7D1);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 1rem;
        }

        .page-title::before {
            content: "📊";
            font-size: 3rem;
        }

        .page-subtitle {
            font-size: 1.3rem;
            color: #666;
            font-weight: 600;
            margin-bottom: 2rem;
        }

        /* Filter Section */
        .filter-section {
            background: rgba(255, 255, 255, 0.9);
            border-radius: 25px;
            padding: 2rem;
            margin-bottom: 2rem;
            box-shadow: 0 15px 40px rgba(0, 0, 0, 0.1);
        }

        .filter-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1.5rem;
            align-items: end;
        }

        .filter-group {
            position: relative;
        }

        .filter-label {
            display: block;
            font-weight: 700;
            color: #333;
            margin-bottom: 0.5rem;
            font-size: 1rem;
        }

        .fun-select, .fun-input {
            width: 100%;
            padding: 0.8rem 1.2rem;
            border: 3px solid #e0e0e0;
            border-radius: 20px;
            font-size: 1rem;
            font-weight: 600;
            background: white;
            transition: all 0.3s ease;
            appearance: none;
            cursor: pointer;
        }

        .fun-select:focus, .fun-input:focus {
            outline: none;
            border-color: #FFE066;
            box-shadow: 0 0 0 3px rgba(255, 224, 102, 0.3);
            transform: scale(1.02);
        }

        .fun-select {
            background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' fill='none' viewBox='0 0 20 20'%3e%3cpath stroke='%236b7280' stroke-linecap='round' stroke-linejoin='round' stroke-width='1.5' d='m6 8 4 4 4-4'/%3e%3c/svg%3e");
            background-position: right 0.5rem center;
            background-repeat: no-repeat;
            background-size: 1.5em 1.5em;
            padding-right: 2.5rem;
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

        /* Fun Buttons */
        .btn-fun {
            padding: 0.8rem 1.8rem;
            border-radius: 25px;
            font-weight: 700;
            font-size: 1rem;
            cursor: pointer;
            transition: all 0.3s ease;
            border: none;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            white-space: nowrap;
        }

        .btn-primary-fun {
            background: linear-gradient(45deg, #4ECDC4, #45B7D1);
            color: white;
        }

        .btn-primary-fun:hover {
            background: linear-gradient(45deg, #45B7D1, #4ECDC4);
            transform: translateY(-3px) scale(1.05);
            box-shadow: 0 12px 35px rgba(69, 183, 209, 0.4);
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

        .btn-success-fun {
            background: linear-gradient(45deg, #96CEB4, #4ECDC4);
            color: white;
        }

        .btn-success-fun:hover {
            background: linear-gradient(45deg, #4ECDC4, #96CEB4);
            transform: translateY(-3px) scale(1.05);
            box-shadow: 0 10px 30px rgba(150, 206, 180, 0.4);
        }

        .btn-warning-fun {
            background: linear-gradient(45deg, #FFE066, #FFB84D);
            color: #333;
        }

        .btn-warning-fun:hover {
            background: linear-gradient(45deg, #FFB84D, #FFE066);
            transform: translateY(-3px) scale(1.05);
            box-shadow: 0 10px 30px rgba(255, 224, 102, 0.4);
        }

        /* Stats Grid */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 2rem;
            margin-bottom: 3rem;
        }

        .stat-card {
            background: white;
            border-radius: 25px;
            padding: 2rem;
            text-align: center;
            box-shadow: 0 15px 40px rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .stat-card:hover {
            transform: translateY(-10px) scale(1.05);
            box-shadow: 0 25px 60px rgba(0, 0, 0, 0.15);
        }

        .stat-card.primary {
            background: linear-gradient(135deg, #45B7D1, #4ECDC4);
            color: white;
        }

        .stat-card.success {
            background: linear-gradient(135deg, #96CEB4, #4ECDC4);
            color: white;
        }

        .stat-card.info {
            background: linear-gradient(135deg, #4ECDC4, #45B7D1);
            color: white;
        }

        .stat-card.warning {
            background: linear-gradient(135deg, #FFE066, #FFB84D);
            color: #333;
        }

        .stat-icon {
            font-size: 3rem;
            margin-bottom: 1rem;
            display: block;
        }

        .stat-number {
            font-size: 2.5rem;
            font-weight: 900;
            display: block;
            margin-bottom: 0.5rem;
        }

        .stat-label {
            font-size: 1.1rem;
            font-weight: 600;
            opacity: 0.9;
        }

        /* History Table */
        .history-table {
            background: white;
            border-radius: 25px;
            overflow: hidden;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.1);
        }

        .table-header {
            background: linear-gradient(45deg, #FF6B6B, #FFE066);
            color: white;
            padding: 1.5rem 2rem;
            font-weight: 700;
            font-size: 1.2rem;
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .table-header::before {
            content: "📋";
            font-size: 1.5rem;
        }

        .table-responsive {
            max-height: 600px;
            overflow-y: auto;
        }

        .fun-table {
            width: 100%;
            border-collapse: collapse;
        }

        .fun-table th {
            background: linear-gradient(45deg, #4ECDC4, #45B7D1);
            color: white;
            padding: 1.2rem;
            text-align: left;
            font-weight: 700;
            font-size: 1rem;
            position: sticky;
            top: 0;
            z-index: 10;
        }

        .fun-table td {
            padding: 1.5rem 1.2rem;
            border-bottom: 2px solid #f0f0f0;
            transition: all 0.3s ease;
        }

        .fun-table tr:hover td {
            background: linear-gradient(45deg, rgba(255, 224, 102, 0.1), rgba(255, 107, 107, 0.1));
            transform: scale(1.01);
        }

        /* Quiz Info */
        .quiz-info {
            display: flex;
            flex-direction: column;
            gap: 0.3rem;
        }

        .quiz-title {
            font-weight: 700;
            color: #333;
            font-size: 1.1rem;
        }

        .quiz-desc {
            color: #666;
            font-size: 0.9rem;
        }

        /* Badges */
        .fun-badge {
            padding: 0.5rem 1rem;
            border-radius: 20px;
            font-weight: 700;
            font-size: 0.9rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .badge-easy {
            background: linear-gradient(45deg, #96CEB4, #4ECDC4);
            color: white;
        }

        .badge-medium {
            background: linear-gradient(45deg, #FFE066, #FFB84D);
            color: #333;
        }

        .badge-hard {
            background: linear-gradient(45deg, #FF6B6B, #FF8E8E);
            color: white;
        }

        /* Progress Bar */
        .score-container {
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .fun-progress {
            flex-grow: 1;
            height: 12px;
            background: #e0e0e0;
            border-radius: 10px;
            overflow: hidden;
            position: relative;
        }

        .fun-progress-bar {
            height: 100%;
            border-radius: 10px;
            transition: width 0.5s ease;
            position: relative;
        }

        .progress-excellent {
            background: linear-gradient(45deg, #96CEB4, #4ECDC4);
        }

        .progress-good {
            background: linear-gradient(45deg, #FFE066, #FFB84D);
        }

        .progress-poor {
            background: linear-gradient(45deg, #FF6B6B, #FF8E8E);
        }

        .score-text {
            font-weight: 900;
            font-size: 1.1rem;
            color: #333;
        }

        /* Action Buttons */
        .action-buttons {
            display: flex;
            gap: 0.5rem;
        }

        .btn-action {
            padding: 0.5rem;
            border-radius: 15px;
            border: none;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            min-width: 40px;
            height: 40px;
        }

        .btn-view {
            background: linear-gradient(45deg, #45B7D1, #4ECDC4);
            color: white;
        }

        .btn-view:hover {
            transform: scale(1.1);
            box-shadow: 0 5px 15px rgba(69, 183, 209, 0.4);
        }

        .btn-retake {
            background: linear-gradient(45deg, #96CEB4, #4ECDC4);
            color: white;
        }

        .btn-retake:hover {
            transform: scale(1.1);
            box-shadow: 0 5px 15px rgba(150, 206, 180, 0.4);
        }

        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 4rem 2rem;
            background: white;
            border-radius: 25px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.1);
        }

        .empty-icon {
            font-size: 5rem;
            margin-bottom: 2rem;
            display: block;
        }

        .empty-title {
            font-size: 2rem;
            font-weight: 700;
            color: #333;
            margin-bottom: 1rem;
        }

        .empty-text {
            font-size: 1.2rem;
            color: #666;
            margin-bottom: 2.5rem;
        }

        /* Pagination */
        .pagination-container {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 0.5rem;
            margin-top: 2rem;
            flex-wrap: wrap;
        }

        .page-btn {
            padding: 0.8rem 1.2rem;
            border-radius: 15px;
            border: none;
            background: white;
            color: #333;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            min-width: 45px;
            text-align: center;
        }

        .page-btn:hover:not(.active):not(.disabled) {
            background: linear-gradient(45deg, #FFE066, #FF6B6B);
            color: white;
            transform: scale(1.1);
        }

        .page-btn.active {
            background: linear-gradient(45deg, #4ECDC4, #45B7D1);
            color: white;
            transform: scale(1.1);
        }

        .page-btn.disabled {
            opacity: 0.5;
            cursor: not-allowed;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .container {
                padding: 6rem 1rem 2rem;
            }
            
            .filter-grid {
                grid-template-columns: 1fr;
            }
            
            .stats-grid {
                grid-template-columns: repeat(2, 1fr);
                gap: 1rem;
            }
            
            .fun-table {
                font-size: 0.9rem;
            }
            
            .fun-table th,
            .fun-table td {
                padding: 0.8rem 0.5rem;
            }
            
            .score-container {
                flex-direction: column;
                gap: 0.5rem;
            }
            
            .nav-links {
                display: none;
            }
        }

        /* Loading Animation */
        .loading {
            opacity: 0.6;
            pointer-events: none;
        }

        .loading::after {
            content: "";
            position: absolute;
            top: 50%;
            left: 50%;
            width: 40px;
            height: 40px;
            border: 4px solid #f3f3f3;
            border-top: 4px solid #FF6B6B;
            border-radius: 50%;
            animation: spin 1s linear infinite;
            transform: translate(-50%, -50%);
        }

        @keyframes spin {
            0% { transform: translate(-50%, -50%) rotate(0deg); }
            100% { transform: translate(-50%, -50%) rotate(360deg); }
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

    <div class="container">
        <!-- Page Header -->
        <div class="page-header">
            <h1 class="page-title">My Quiz Journey</h1>
            <p class="page-subtitle">Track your amazing progress and celebrate every achievement! 🎉</p>
            <a href="${pageContext.request.contextPath}/quizzes" class="btn-fun btn-success-fun">
                🎮 Take Another Quiz!
            </a>
        </div>

        <!-- Filter Section -->
        <div class="fun-card filter-section">
            <form action="${pageContext.request.contextPath}/history" method="get" id="filterForm">
                <div class="filter-grid">
                    <div class="filter-group">
                        <label for="categoryFilter" class="filter-label">🎯 Category</label>
                        <select class="fun-select" id="categoryFilter" name="category">
                            <option value="">All Categories</option>
                            <c:forEach items="${categories}" var="category">
                                <option value="${category.id}" ${param.category == category.id ? 'selected' : ''}>
                                    ${category.name}
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="filter-group">
                        <label for="difficultyFilter" class="filter-label">⚡ Difficulty</label>
                        <select class="fun-select" id="difficultyFilter" name="difficulty">
                            <option value="">All Difficulties</option>
                            <option value="easy" ${param.difficulty == 'easy' ? 'selected' : ''}>🟢 Easy</option>
                            <option value="medium" ${param.difficulty == 'medium' ? 'selected' : ''}>🟡 Medium</option>
                            <option value="hard" ${param.difficulty == 'hard' ? 'selected' : ''}>🔴 Hard</option>
                        </select>
                    </div>
                    <div class="filter-group">
                        <label for="dateFilter" class="filter-label">📅 Time Period</label>
                        <select class="fun-select" id="dateFilter" name="dateRange">
                            <option value="">All Time</option>
                            <option value="7" ${param.dateRange == '7' ? 'selected' : ''}>Last 7 Days</option>
                            <option value="30" ${param.dateRange == '30' ? 'selected' : ''}>Last 30 Days</option>
                            <option value="90" ${param.dateRange == '90' ? 'selected' : ''}>Last 3 Months</option>
                            <option value="365" ${param.dateRange == '365' ? 'selected' : ''}>Last Year</option>
                        </select>
                    </div>
                    <div class="filter-group" style="display: flex; gap: 1rem;">
                        <button type="submit" class="btn-fun btn-primary-fun">
                            🔍 Filter
                        </button>
                        <button type="button" id="resetFilters" class="btn-fun btn-outline-fun">
                            🔄 Reset
                        </button>
                    </div>
                </div>
            </form>
        </div>

        <!-- Stats Summary -->
        <div class="stats-grid">
            <div class="stat-card primary">
                <span class="stat-icon">🎮</span>
                <span class="stat-number">${totalQuizzes}</span>
                <span class="stat-label">Total Quizzes</span>
            </div>
            <div class="stat-card success">
                <span class="stat-icon">⭐</span>
                <span class="stat-number">${averageScore}%</span>
                <span class="stat-label">Average Score</span>
            </div>
            <div class="stat-card info">
                <span class="stat-icon">🏆</span>
                <span class="stat-number">${bestScore}%</span>
                <span class="stat-label">Best Score</span>
            </div>
            <div class="stat-card warning">
                <span class="stat-icon">
                    <c:choose>
                        <c:when test="${scoreTrend > 0}">📈</c:when>
                        <c:when test="${scoreTrend < 0}">📉</c:when>
                        <c:otherwise>➡️</c:otherwise>
                    </c:choose>
                </span>
                <span class="stat-number">
                    <c:choose>
                        <c:when test="${scoreTrend > 0}">+${scoreTrend}%</c:when>
                        <c:when test="${scoreTrend < 0}">${scoreTrend}%</c:when>
                        <c:otherwise>0%</c:otherwise>
                    </c:choose>
                </span>
                <span class="stat-label">Recent Trend</span>
            </div>
        </div>

        <!-- History Table -->
        <div class="fun-card">
            <c:choose>
                <c:when test="${empty quizHistory}">
                    <div class="empty-state">
                        <span class="empty-icon">📚</span>
                        <h3 class="empty-title">No Quiz Adventures Yet!</h3>
                        <p class="empty-text">Start your learning journey now and watch your progress grow! Every expert was once a beginner. 🌱</p>
                        <a href="${pageContext.request.contextPath}/quizzes" class="btn-fun btn-primary-fun">
                            🚀 Start Your First Quiz!
                        </a>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="history-table">
                        <div class="table-header">
                            Your Quiz Adventures
                        </div>
                        <div class="table-responsive">
                            <table class="fun-table">
                                <thead>
                                    <tr>
                                        <th>🎯 Quiz</th>
                                        <th>📂 Category</th>
                                        <th>⚡ Difficulty</th>
                                        <th>🎯 Score</th>
                                        <th>⏱️ Time</th>
                                        <th>📅 Date</th>
                                        <th>🔧 Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${quizHistory}" var="history">
                                        <tr>
                                            <td><td>
                                                <div class="quiz-info">
                                                    <div class="quiz-title">${history.quiz.title}</div>
                                                    <div class="quiz-desc">${history.quiz.description}</div>
                                                </div>
                                            </td>
                                            <td>${history.quiz.category.name}</td>
                                            <td>
                                                <span class="fun-badge
                                                    ${history.quiz.difficulty == 'easy' ? 'badge-easy' : 
                                                     history.quiz.difficulty == 'medium' ? 'badge-medium' : 'badge-hard'}">
                                                    ${history.quiz.difficulty == 'easy' ? '🟢' : 
                                                     history.quiz.difficulty == 'medium' ? '🟡' : '🔴'} 
                                                    ${history.quiz.difficulty}
                                                </span>
                                            </td>
                                            <td>
                                                <div class="score-container">
                                                    <div class="fun-progress">
                                                        <div class="fun-progress-bar
                                                            ${history.score >= 80 ? 'progress-excellent' : 
                                                             history.score >= 60 ? 'progress-good' : 'progress-poor'}" 
                                                            style="width: ${history.score}%">
                                                        </div>
                                                    </div>
                                                    <span class="score-text">${history.score}%</span>
                                                </div>
                                            </td>
                                            <td>
                                                <fmt:formatNumber value="${history.completionTime / 60}" maxFractionDigits="0" var="minutes" />
                                                <fmt:formatNumber value="${history.completionTime % 60}" minIntegerDigits="2" var="seconds" />
                                                ⏱️ ${minutes}:${seconds}
                                            </td>
                                            <td>
                                                <fmt:formatDate value="${history.dateTaken}" pattern="MMM d, yyyy" />
                                                <br>
                                                <small style="color: #666;">
                                                    <fmt:formatDate value="${history.dateTaken}" pattern="h:mm a" />
                                                </small>
                                            </td>
                                            <td>
                                                <div class="action-buttons">
                                                    <a href="${pageContext.request.contextPath}/quiz/${history.quiz.id}" 
                                                       class="btn-action btn-view" title="View Results">
                                                        👁️
                                                    </a>
                                                    <a href="${pageContext.request.contextPath}/take-quiz/${history.quiz.id}" 
                                                       class="btn-action btn-retake" title="Retake Quiz">
                                                        🔄
                                                    </a>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                        
                        <!-- Pagination -->
                        <c:if test="${totalPages > 1}">
                            <div class="pagination-container">
                                <a href="${pageContext.request.contextPath}/history?page=${currentPage - 1}${filterParams}" 
                                   class="page-btn ${currentPage == 1 ? 'disabled' : ''}">
                                    ◀️
                                </a>
                                
                                <c:forEach begin="1" end="${totalPages}" var="i">
                                    <c:choose>
                                        <c:when test="${i == currentPage}">
                                            <span class="page-btn active">${i}</span>
                                        </c:when>
                                        <c:otherwise>
                                            <a href="${pageContext.request.contextPath}/history?page=${i}${filterParams}" 
                                               class="page-btn">${i}</a>
                                        </c:otherwise>
                                    </c:choose>
                                </c:forEach>
                                
                                <a href="${pageContext.request.contextPath}/history?page=${currentPage + 1}${filterParams}" 
                                   class="page-btn ${currentPage == totalPages ? 'disabled' : ''}">
                                    ▶️
                                </a>
                            </div>
                        </c:if>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Fun Achievement Section (Optional Enhancement) -->
        <c:if test="${not empty quizHistory}">
            <div class="fun-card" style="text-align: center; margin-top: 2rem;">
                <h3 style="font-size: 1.8rem; font-weight: 700; color: #333; margin-bottom: 1rem;">
                    🎉 Your Learning Achievements 🎉
                </h3>
                <div class="stats-grid" style="margin-bottom: 0;">
                    <c:if test="${totalQuizzes >= 1}">
                        <div class="achievement-badge" style="background: linear-gradient(45deg, #FFE066, #FF6B6B); color: white; padding: 1rem; border-radius: 20px; box-shadow: 0 10px 30px rgba(255, 224, 102, 0.3);">
                            <div style="font-size: 2rem;">🌟</div>
                            <div style="font-weight: 700;">Quiz Starter!</div>
                        </div>
                    </c:if>
                    <c:if test="${totalQuizzes >= 5}">
                        <div class="achievement-badge" style="background: linear-gradient(45deg, #4ECDC4, #45B7D1); color: white; padding: 1rem; border-radius: 20px; box-shadow: 0 10px 30px rgba(78, 205, 196, 0.3);">
                            <div style="font-size: 2rem;">🚀</div>
                            <div style="font-weight: 700;">Knowledge Seeker!</div>
                        </div>
                    </c:if>
                    <c:if test="${totalQuizzes >= 10}">
                        <div class="achievement-badge" style="background: linear-gradient(45deg, #96CEB4, #4ECDC4); color: white; padding: 1rem; border-radius: 20px; box-shadow: 0 10px 30px rgba(150, 206, 180, 0.3);">
                            <div style="font-size: 2rem;">🏆</div>
                            <div style="font-weight: 700;">Quiz Master!</div>
                        </div>
                    </c:if>
                    <c:if test="${bestScore >= 90}">
                        <div class="achievement-badge" style="background: linear-gradient(45deg, #FF6B6B, #FF8E8E); color: white; padding: 1rem; border-radius: 20px; box-shadow: 0 10px 30px rgba(255, 107, 107, 0.3);">
                            <div style="font-size: 2rem;">🎯</div>
                            <div style="font-weight: 700;">Perfect Score!</div>
                        </div>
                    </c:if>
                </div>
            </div>
        </c:if>
    </div>

    <!-- JavaScript -->
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Handle reset filters button
            document.getElementById('resetFilters').addEventListener('click', function() {
                document.getElementById('categoryFilter').value = '';
                document.getElementById('difficultyFilter').value = '';
                document.getElementById('dateFilter').value = '';
                document.getElementById('filterForm').submit();
            });
            
            // Add loading animation to filter form
            document.getElementById('filterForm').addEventListener('submit', function() {
                this.classList.add('loading');
            });
            
            // Animate stats cards on page load
            const statCards = document.querySelectorAll('.stat-card');
            statCards.forEach((card, index) => {
                card.style.animationDelay = `${index * 0.1}s`;
                card.style.animation = 'slideInUp 0.6s ease-out forwards';
            });
            
            // Animate table rows
            const tableRows = document.querySelectorAll('.fun-table tbody tr');
            tableRows.forEach((row, index) => {
                row.style.animationDelay = `${index * 0.05}s`;
                row.style.animation = 'slideInUp 0.4s ease-out forwards';
            });
            
            // Add hover sound effect (optional - you can remove this if you don't want sound)
            const buttons = document.querySelectorAll('.btn-fun, .btn-action');
            buttons.forEach(button => {
                button.addEventListener('mouseenter', function() {
                    // You can add a subtle sound effect here if desired
                    this.style.transform = this.style.transform.replace('scale(1)', 'scale(1.05)');
                });
            });
        });
        
        // Add some fun confetti effect for high scores (optional enhancement)
        function showConfetti() {
            // Simple confetti effect - you can enhance this further
            for (let i = 0; i < 50; i++) {
                const confetti = document.createElement('div');
                confetti.style.position = 'fixed';
                confetti.style.left = Math.random() * 100 + 'vw';
                confetti.style.animationDelay = Math.random() * 3 + 's';
                confetti.innerHTML = ['🎉', '🎊', '⭐', '🌟', '✨'][Math.floor(Math.random() * 5)];
                confetti.style.animation = 'fall 3s linear forwards';
                document.body.appendChild(confetti);
                
                setTimeout(() => {
                    confetti.remove();
                }, 3000);
            }
        }
        
        // CSS for confetti animation
        const style = document.createElement('style');
        style.textContent = `
            @keyframes fall {
                to {
                    transform: translateY(100vh) rotate(360deg);
                }
            }
        `;
        document.head.appendChild(style);
        
        // Show confetti if user has excellent scores
        <c:if test="${averageScore >= 85}">
            setTimeout(showConfetti, 1000);
        </c:if>
    </script>
</body>
</html>