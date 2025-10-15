<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EduQuiz - My Profile</title>
    <style> .auth-buttons {
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
}</style>
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
            padding-top: 80px;
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

        .back-button {
            background: linear-gradient(45deg, #4ECDC4, #45B7D1);
            color: white;
            border: none;
            padding: 0.8rem 1.8rem;
            border-radius: 30px;
            font-weight: 700;
            font-size: 1rem;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }

        .back-button:hover {
            background: linear-gradient(45deg, #45B7D1, #4ECDC4);
            transform: translateY(-3px) scale(1.05);
            box-shadow: 0 12px 35px rgba(69, 183, 209, 0.4);
            color: white;
        }

        /* Container */
        .container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 2rem;
            display: grid;
            grid-template-columns: 1fr 2fr;
            gap: 2rem;
            z-index: 100;
            position: relative;
        }

        /* Cards */
        .fun-card {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            border-radius: 30px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.1);
            padding: 2rem;
            margin-bottom: 2rem;
            transition: all 0.3s ease;
            border: 3px solid transparent;
            position: relative;
            overflow: hidden;
        }

        .fun-card::before {
            content: "";
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 5px;
            background: linear-gradient(45deg, #FFE066, #FF6B6B, #4ECDC4, #45B7D1);
            border-radius: 30px 30px 0 0;
        }

        .fun-card:hover {
            transform: translateY(-5px) scale(1.02);
            box-shadow: 0 25px 80px rgba(0, 0, 0, 0.15);
            border-color: #FFE066;
        }

        .card-header {
            display: flex;
            align-items: center;
            gap: 1rem;
            margin-bottom: 2rem;
            padding-bottom: 1rem;
            border-bottom: 2px solid #f0f0f0;
        }

        .card-header h2 {
            font-size: 1.8rem;
            font-weight: 900;
            background: linear-gradient(45deg, #FF6B6B, #4ECDC4);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin: 0;
        }

        .card-icon {
            font-size: 2.5rem;
            background: linear-gradient(45deg, #FFE066, #FF6B6B);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        /* Profile Section */
        .profile-section {
            text-align: center;
            margin-bottom: 2rem;
        }

        .profile-avatar {
            width: 120px;
            height: 120px;
            margin: 0 auto 1.5rem;
            border-radius: 50%;
            overflow: hidden;
            border: 5px solid #FFE066;
            box-shadow: 0 15px 40px rgba(255, 230, 102, 0.3);
            transition: all 0.3s ease;
            position: relative;
        }

        .profile-avatar:hover {
            transform: scale(1.1) rotate(5deg);
            box-shadow: 0 20px 50px rgba(255, 230, 102, 0.5);
        }

        .profile-avatar img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .default-avatar {
            width: 100%;
            height: 100%;
            background: linear-gradient(45deg, #4ECDC4, #45B7D1);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 3rem;
            font-weight: 900;
            color: white;
        }

        .profile-name {
            font-size: 2.2rem;
            font-weight: 900;
            margin-bottom: 0.5rem;
            background: linear-gradient(45deg, #FF6B6B, #4ECDC4);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .profile-email {
            color: #666;
            font-size: 1.1rem;
            font-weight: 600;
            margin-bottom: 1rem;
        }

        .profile-badges {
            display: flex;
            gap: 0.8rem;
            justify-content: center;
            flex-wrap: wrap;
            margin-bottom: 1.5rem;
        }

        .fun-badge {
            padding: 0.5rem 1.2rem;
            border-radius: 25px;
            font-weight: 700;
            font-size: 0.9rem;
            display: inline-flex;
            align-items: center;
            gap: 0.3rem;
        }

        .badge-role {
            background: linear-gradient(45deg, #FFE066, #FF6B6B);
            color: #333;
        }

        .badge-member {
            background: linear-gradient(45deg, #4ECDC4, #45B7D1);
            color: white;
        }

        /* Stats Grid */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 1rem;
            margin-bottom: 2rem;
        }

        .stat-item {
            background: linear-gradient(45deg, rgba(255, 230, 102, 0.1), rgba(255, 107, 107, 0.1));
            padding: 1.5rem;
            border-radius: 20px;
            text-align: center;
            transition: all 0.3s ease;
            border: 2px solid transparent;
        }

        .stat-item:hover {
            background: linear-gradient(45deg, rgba(255, 230, 102, 0.2), rgba(255, 107, 107, 0.2));
            transform: translateY(-3px) scale(1.05);
            border-color: #FFE066;
        }

        .stat-number {
            font-size: 2rem;
            font-weight: 900;
            background: linear-gradient(45deg, #FF6B6B, #4ECDC4);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            display: block;
            margin-bottom: 0.5rem;
        }

        .stat-label {
            color: #666;
            font-weight: 700;
            font-size: 0.9rem;
        }

        /* Edit Button */
        .edit-btn {
            background: linear-gradient(45deg, #FF6B6B, #FFE066);
            color: #333;
            border: none;
            padding: 1rem 2rem;
            border-radius: 30px;
            font-weight: 800;
            font-size: 1.1rem;
            cursor: pointer;
            transition: all 0.3s ease;
            width: 100%;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.8rem;
        }

        .edit-btn:hover {
            background: linear-gradient(45deg, #FFE066, #FF6B6B);
            transform: translateY(-3px) scale(1.05);
            box-shadow: 0 15px 40px rgba(255, 107, 107, 0.4);
        }

        /* Achievements */
        .achievement-item {
            display: flex;
            align-items: center;
            gap: 1.5rem;
            padding: 1.5rem;
            background: linear-gradient(45deg, rgba(78, 205, 196, 0.1), rgba(69, 183, 209, 0.1));
            border-radius: 20px;
            margin-bottom: 1rem;
            transition: all 0.3s ease;
            border: 2px solid transparent;
        }

        .achievement-item:hover {
            background: linear-gradient(45deg, rgba(78, 205, 196, 0.2), rgba(69, 183, 209, 0.2));
            transform: translateX(5px) scale(1.02);
            border-color: #4ECDC4;
        }

        .achievement-icon {
            font-size: 3rem;
            width: 60px;
            height: 60px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            background: linear-gradient(45deg, #FFE066, #FF6B6B);
        }

        .achievement-icon.locked {
            opacity: 0.3;
            filter: grayscale(100%);
        }

        .achievement-info h4 {
            margin: 0 0 0.5rem 0;
            font-weight: 800;
            color: #333;
        }

        .achievement-info p {
            margin: 0;
            color: #666;
            font-weight: 600;
        }

        .achievement-progress {
            background: #e0e0e0;
            height: 8px;
            border-radius: 10px;
            overflow: hidden;
            margin-top: 0.5rem;
        }

        .achievement-progress-bar {
            height: 100%;
            background: linear-gradient(45deg, #4ECDC4, #45B7D1);
            border-radius: 10px;
            transition: width 0.3s ease;
        }

        /* Charts */
        .chart-container {
            background: white;
            border-radius: 20px;
            padding: 1.5rem;
            margin: 1rem 0;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
        }

        /* Quiz Results Table */
        .quiz-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 1rem;
        }

        .quiz-table th,
        .quiz-table td {
            padding: 1rem;
            text-align: left;
            border-bottom: 2px solid #f0f0f0;
        }

        .quiz-table th {
            background: linear-gradient(45deg, #4ECDC4, #45B7D1);
            color: white;
            font-weight: 800;
            border-radius: 15px 15px 0 0;
        }

        .quiz-table tr:hover {
            background: linear-gradient(45deg, rgba(255, 230, 102, 0.1), rgba(255, 107, 107, 0.1));
        }

        .score-excellent { color: #28a745; font-weight: 800; }
        .score-good { color: #ffc107; font-weight: 800; }
        .score-poor { color: #dc3545; font-weight: 800; }

        .retake-btn {
            background: linear-gradient(45deg, #4ECDC4, #45B7D1);
            color: white;
            border: none;
            padding: 0.5rem 1rem;
            border-radius: 20px;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
        }

        .retake-btn:hover {
            background: linear-gradient(45deg, #45B7D1, #4ECDC4);
            transform: translateY(-2px) scale(1.05);
            color: white;
        }

        /* Modal */
        .modal-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.5);
            backdrop-filter: blur(10px);
            z-index: 2000;
            display: none;
            align-items: center;
            justify-content: center;
        }

        .modal-overlay.show {
            display: flex;
        }

        .modal-content {
            background: white;
            border-radius: 30px;
            padding: 2rem;
            max-width: 500px;
            width: 90%;
            max-height: 90vh;
            overflow-y: auto;
            position: relative;
            animation: modalSlideIn 0.3s ease;
        }

        @keyframes modalSlideIn {
            from { opacity: 0; transform: translateY(-30px) scale(0.9); }
            to { opacity: 1; transform: translateY(0) scale(1); }
        }

        .modal-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 2rem;
            padding-bottom: 1rem;
            border-bottom: 2px solid #f0f0f0;
        }

        .modal-title {
            font-size: 1.8rem;
            font-weight: 900;
            background: linear-gradient(45deg, #FF6B6B, #4ECDC4);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin: 0;
        }

        .close-btn {
            background: none;
            border: none;
            font-size: 2rem;
            cursor: pointer;
            color: #666;
            transition: all 0.3s ease;
        }

        .close-btn:hover {
            color: #FF6B6B;
            transform: scale(1.2) rotate(90deg);
        }

        .form-group {
            margin-bottom: 1.5rem;
        }

        .form-label {
            display: block;
            margin-bottom: 0.5rem;
            font-weight: 700;
            color: #333;
        }

        .form-control {
            width: 100%;
            padding: 1rem;
            border: 2px solid #e0e0e0;
            border-radius: 15px;
            font-size: 1rem;
            transition: all 0.3s ease;
            background: white;
        }

        .form-control:focus {
            outline: none;
            border-color: #FFE066;
            box-shadow: 0 0 20px rgba(255, 230, 102, 0.3);
        }

        .form-buttons {
            display: flex;
            gap: 1rem;
            justify-content: flex-end;
            margin-top: 2rem;
        }

        .btn-cancel {
            background: #6c757d;
            color: white;
            border: none;
            padding: 0.8rem 1.5rem;
            border-radius: 20px;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .btn-cancel:hover {
            background: #5a6268;
            transform: translateY(-2px);
        }

        .btn-save {
            background: linear-gradient(45deg, #4ECDC4, #45B7D1);
            color: white;
            border: none;
            padding: 0.8rem 1.5rem;
            border-radius: 20px;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .btn-save:hover {
            background: linear-gradient(45deg, #45B7D1, #4ECDC4);
            transform: translateY(-2px) scale(1.05);
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .container {
                grid-template-columns: 1fr;
                padding: 1rem;
            }
            
            .nav-links {
                display: none;
            }
            
            .stats-grid {
                grid-template-columns: 1fr;
            }
            
            .quiz-table {
                font-size: 0.9rem;
            }
            
            .modal-content {
                width: 95%;
                padding: 1.5rem;
            }
        }

        /* No results message */
        .no-results {
            text-align: center;
            padding: 3rem;
            color: #666;
            font-size: 1.2rem;
            font-weight: 600;
        }

        .no-results .emoji {
            font-size: 4rem;
            display: block;
            margin-bottom: 1rem;
        }
    </style>
</head>
<body>
    <jsp:useBean id="now" class="java.util.Date" />
    
    <!-- Floating Decorations -->
    <div class="decoration star" style="top: 15%; left: 10%;">⭐</div>
    <div class="decoration heart" style="top: 25%; right: 15%;">❤️</div>
    <div class="decoration lightning" style="top: 60%; left: 5%;">⚡</div>
    <div class="decoration star" style="bottom: 20%; right: 10%;">✨</div>
    <div class="decoration heart" style="bottom: 40%; left: 12%;">💛</div>
    <div class="decoration lightning" style="top: 40%; right: 8%;">🚀</div>

    <!-- Header -->
<!-- Header -->
<header class="header">
    <nav class="nav">
        <a href="${pageContext.request.contextPath}/home" class="logo">EduQuiz</a>
        
        <ul class="nav-links">
            <li><a href="${pageContext.request.contextPath}/quizzes">Quizzes</a></li>
            <li><a href="${pageContext.request.contextPath}/leaderboard" class="active">Leaderboard</a></li>
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
    <div class="container">
        <!-- Left Column -->
        <div class="left-column">
            <!-- Profile Card -->
            <div class="fun-card">
                <div class="card-header">
                    <span class="card-icon">👤</span>
                    <h2>My Profile</h2>
                </div>
                
                <div class="profile-section">
                    <div class="profile-avatar">
                        <c:choose>
                            <c:when test="${not empty sessionScope.user.profileImage}">
                                <img src="${pageContext.request.contextPath}/uploads/${sessionScope.user.profileImage}?ts=${now.time}" alt="Profile">
                            </c:when>
                            <c:otherwise>
                                <div class="default-avatar">
                                    ${fn:toUpperCase(fn:substring(sessionScope.user.username, 0, 1))}
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    
                    <h1 class="profile-name">${sessionScope.user.username}</h1>
                    <p class="profile-email">${sessionScope.user.email}</p>
                    
                    <div class="profile-badges">
                        <span class="fun-badge badge-role">
                            <span>⭐</span>
                            ${sessionScope.user.role}
                        </span>
                        <span class="fun-badge badge-member">
                            <span>📅</span>
                            Member since 
                            <c:choose>
                                <c:when test="${not empty sessionScope.user.createdAt}">
                                    <fmt:formatDate value="${sessionScope.user.createdAt}" pattern="MMM yyyy" />
                                </c:when>
                                <c:otherwise>
                                    Unknown
                                </c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                </div>
                
                <div class="stats-grid">
                    <div class="stat-item">
                        <span class="stat-number">${userStats.quizzesTaken}</span>
                        <span class="stat-label">🎮 Quizzes Taken</span>
                    </div>
                    <div class="stat-item">
                        <span class="stat-number">
                            <fmt:formatNumber value="${userStats.averageScore}" pattern="#.#"/>%
                        </span>
                        <span class="stat-label">📊 Average Score</span>
                    </div>
                    <div class="stat-item">
                        <span class="stat-number">
                            <fmt:formatNumber value="${userStats.highestScore}" pattern="#.#"/>%
                        </span>
                        <span class="stat-label">🏆 Best Score</span>
                    </div>
                    <div class="stat-item">
                        <span class="stat-number">${userStats.favoriteCategory}</span>
                        <span class="stat-label">❤️ Favorite Topic</span>
                    </div>
                </div>
                
                <button class="edit-btn" onclick="openEditModal()">
                    <span>✏️</span>
                    Edit Profile
                </button>
            </div>
            
            <!-- Achievements Card -->
            <div class="fun-card">
                <div class="card-header">
                    <span class="card-icon">🏅</span>
                    <h2>Achievements</h2>
                </div>
                
                <c:choose>
                    <c:when test="${empty achievements}">
                        <div class="no-results">
                            <span class="emoji">🎯</span>
                            No achievements yet! Start taking quizzes to earn cool badges!
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach items="${achievements}" var="achievement">
                            <div class="achievement-item">
                                <div class="achievement-icon ${achievement.unlocked ? '' : 'locked'}">
                                    ${achievement.icon}
                                </div>
                                <div class="achievement-info">
                                    <h4 class="${achievement.unlocked ? '' : 'text-muted'}">${achievement.name}</h4>
                                    <p class="${achievement.unlocked ? '' : 'text-muted'}">${achievement.description}</p>
                                    <c:if test="${not achievement.unlocked}">
                                        <div class="achievement-progress">
                                            <div class="achievement-progress-bar" style="width: ${achievement.progress}%"></div>
                                        </div>
                                        <p class="small text-info">Progress: ${achievement.progress}%</p>
                                    </c:if>
                                </div>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
        
        <!-- Right Column -->
        <div class="right-column">
            <!-- Performance Chart -->
            <div class="fun-card">
                <div class="card-header">
                    <span class="card-icon">📈</span>
                    <h2>Performance Overview</h2>
                </div>
                <div class="chart-container">
                    <canvas id="performanceChart" height="250"></canvas>
                </div>
            </div>
            
            <!-- Recent Quiz Results -->
            <div class="fun-card">
                <div class="card-header">
                    <span class="card-icon">🎯</span>
                    <h2>Recent Quiz Results</h2>
                    <a href="${pageContext.request.contextPath}/history" class="retake-btn" style="margin-left: auto;">
                        View All 📋
                    </a>
                </div>
                
                <c:choose>
                    <c:when test="${empty recentResults}">
                        <div class="no-results">
                            <span class="emoji">🤔</span>
                            No quiz results found. Time to start your learning journey!
                        </div>
                    </c:when>
                    <c:otherwise>
                        <table class="quiz-table">
                            <thead>
                                <tr>
                                    <th>🎲 Quiz</th>
                                    <th>📊 Score</th>
                                    <th>⏱️ Time</th>
                                    <th>📅 Date</th>
                                    <th>🎮 Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${recentResults}" var="result">
                                    <tr>
                                    <tr>
                                        <td>${result.quiz.title}</td>
                                        <td>
                                            <span class="${result.percentage >= 70 ? 'score-excellent' : result.percentage >= 50 ? 'score-good' : 'score-poor'}">
                                                ${result.score}/${result.quiz.totalQuestions} (${result.percentage}%)
                                            </span>
                                        </td>
                                        <td>
                                            <fmt:formatNumber value="${result.completionTime / 60}" pattern="#" />:<fmt:formatNumber value="${result.completionTime % 60}" pattern="00" />
                                        </td>
                                        <td>
                                            <fmt:formatDate value="${result.dateTaken}" pattern="MMM dd, yyyy HH:mm" />
                                        </td>
                                        <td>
                                            <a href="${pageContext.request.contextPath}/quiz?id=${result.quiz.id}" class="retake-btn">
                                                🔄 Retake
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </c:otherwise>
                </c:choose>
            </div>
            
            <!-- Category Performance Chart -->
            <div class="fun-card">
                <div class="card-header">
                    <span class="card-icon">📊</span>
                    <h2>Category Performance</h2>
                </div>
                <div class="chart-container">
                    <canvas id="categoryChart" height="250"></canvas>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Edit Profile Modal -->
    <div class="modal-overlay" id="editProfileModal">
        <div class="modal-content">
            <div class="modal-header">
                <h2 class="modal-title">✏️ Edit Profile</h2>
                <button class="close-btn" onclick="closeEditModal()">×</button>
            </div>
            
            <form action="${pageContext.request.contextPath}/updateProfile" method="post" id="editProfileForm" enctype="multipart/form-data">
                <div class="form-group">
                    <div class="profile-section">
                        <div class="profile-avatar" style="width: 80px; height: 80px;">
                            <c:choose>
                                <c:when test="${not empty sessionScope.user.profileImage}">
                                    <img id="profilePreview" src="${pageContext.request.contextPath}/uploads/${sessionScope.user.profileImage}?ts=${now.time}" alt="Profile">
                                </c:when>
                                <c:otherwise>
                                    <div class="default-avatar" id="defaultAvatar">
                                        ${fn:toUpperCase(fn:substring(sessionScope.user.username, 0, 1))}
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    <label class="form-label">📸 Profile Picture</label>
                    <input type="file" class="form-control" id="profileImage" name="profileImage" accept="image/*" onchange="previewImage(this)">
                    <small style="color: #666; font-size: 0.9rem;">Max file size: 2MB. Supported: JPG, PNG, GIF</small>
                </div>
                
                <div class="form-group">
                    <label for="username" class="form-label">👤 Username</label>
                    <input type="text" class="form-control" id="username" name="username" value="${sessionScope.user.username}" required>
                </div>
                
                <div class="form-group">
                    <label for="email" class="form-label">📧 Email</label>
                    <input type="email" class="form-control" id="email" name="email" value="${sessionScope.user.email}" required>
                </div>
                
                <div class="form-group">
                    <label for="currentPassword" class="form-label">🔒 Current Password</label>
                    <input type="password" class="form-control" id="currentPassword" name="currentPassword" required>
                </div>
                
                <div class="form-group">
                    <label for="newPassword" class="form-label">🔑 New Password (leave blank to keep current)</label>
                    <input type="password" class="form-control" id="newPassword" name="newPassword">
                </div>
                
                <div class="form-group">
                    <label for="confirmPassword" class="form-label">✅ Confirm New Password</label>
                    <input type="password" class="form-control" id="confirmPassword" name="confirmPassword">
                </div>
                
                <div class="form-buttons">
                    <button type="button" class="btn-cancel" onclick="closeEditModal()">Cancel</button>
                    <button type="submit" class="btn-save">💾 Save Changes</button>
                </div>
            </form>
        </div>
    </div>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js@3.7.1/dist/chart.min.js"></script>
    
    <script>
        // Modal Functions
        function openEditModal() {
            document.getElementById('editProfileModal').classList.add('show');
        }
        
        function closeEditModal() {
            document.getElementById('editProfileModal').classList.remove('show');
        }
        
        // Close modal when clicking outside
        document.getElementById('editProfileModal').addEventListener('click', function(e) {
            if (e.target === this) {
                closeEditModal();
            }
        });
        
        // Image Preview
        function previewImage(input) {
            if (input.files && input.files[0]) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    const preview = document.getElementById('profilePreview');
                    const defaultAvatar = document.getElementById('defaultAvatar');
                    
                    if (preview) {
                        preview.src = e.target.result;
                    } else if (defaultAvatar) {
                        // Replace default avatar
                        defaultAvatar.parentElement.innerHTML = `<img id="profilePreview" src="${e.target.result}" alt="Profile" style="width: 100%; height: 100%; object-fit: cover;">`;
                    }
                };
                reader.readAsDataURL(input.files[0]);
            }
        }
        
        // Form Validation
        document.getElementById('editProfileForm').addEventListener('submit', function(e) {
            const newPassword = document.getElementById('newPassword').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            
            if (newPassword && newPassword !== confirmPassword) {
                e.preventDefault();
                alert('🚨 New passwords do not match!');
                return false;
            }
            
            if (newPassword && newPassword.length < 6) {
                e.preventDefault();
                alert('🚨 New password must be at least 6 characters long!');
                return false;
            }
        });

        // Performance Chart
        const perfCtx = document.getElementById('performanceChart').getContext('2d');
        const performanceChart = new Chart(perfCtx, {
            type: 'line',
            data: {
                labels: JSON.parse('${performanceLabels != null ? performanceLabels : "[]"}'),
                datasets: [{
                    label: '🎯 Quiz Scores (%)',
                    data: JSON.parse('${performanceData != null ? performanceData : "[]"}'),
                    backgroundColor: 'rgba(255, 230, 102, 0.3)',
                    borderColor: '#FFE066',
                    borderWidth: 4,
                    tension: 0.4,
                    pointBackgroundColor: '#FF6B6B',
                    pointBorderColor: '#FFE066',
                    pointBorderWidth: 3,
                    pointRadius: 8,
                    pointHoverRadius: 12,
                    fill: true
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        labels: {
                            font: {
                                size: 14,
                                weight: 'bold'
                            },
                            color: '#333'
                        }
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        max: 100,
                        grid: {
                            color: 'rgba(0,0,0,0.1)'
                        },
                        ticks: {
                            font: {
                                weight: 'bold'
                            },
                            color: '#666'
                        }
                    },
                    x: {
                        grid: {
                            color: 'rgba(0,0,0,0.1)'
                        },
                        ticks: {
                            font: {
                                weight: 'bold'
                            },
                            color: '#666'
                        }
                    }
                }
            }
        });

        // Category Chart
        const catCtx = document.getElementById('categoryChart').getContext('2d');
        const categoryChart = new Chart(catCtx, {
            type: 'doughnut',
            data: {
                labels: JSON.parse('${categoryLabels != null ? categoryLabels : "[]"}'),
                datasets: [{
                    label: '📊 Average Score (%)',
                    data: JSON.parse('${categoryData != null ? categoryData : "[]"}'),
                    backgroundColor: [
                        '#FF6B6B',
                        '#4ECDC4',
                        '#45B7D1',
                        '#FFE066',
                        '#96CEB4',
                        '#FFEAA7',
                        '#DDA0DD',
                        '#98D8C8'
                    ],
                    borderWidth: 4,
                    borderColor: '#fff',
                    hoverBorderWidth: 6
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: 'bottom',
                        labels: {
                            font: {
                                size: 12,
                                weight: 'bold'
                            },
                            color: '#333',
                            padding: 20,
                            usePointStyle: true,
                            pointStyle: 'circle'
                        }
                    }
                }
            }
        });
        
        // Add some sparkle effects
        function createSparkle() {
            const sparkle = document.createElement('div');
            sparkle.innerHTML = '✨';
            sparkle.style.position = 'fixed';
            sparkle.style.left = Math.random() * window.innerWidth + 'px';
            sparkle.style.top = Math.random() * window.innerHeight + 'px';
            sparkle.style.fontSize = '1rem';
            sparkle.style.pointerEvents = 'none';
            sparkle.style.zIndex = '1';
            sparkle.style.animation = 'twinkle 2s ease-in-out forwards';
            
            document.body.appendChild(sparkle);
            
            setTimeout(() => {
                sparkle.remove();
            }, 2000);
        }
        
        // Create sparkles occasionally
        setInterval(createSparkle, 3000);
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
    </script>
    
</body>
</html>