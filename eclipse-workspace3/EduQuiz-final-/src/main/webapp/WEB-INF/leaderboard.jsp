<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EduQuiz - Champions Leaderboard! 🏆</title>
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

        .trophy { color: #FFD700; font-size: 2.5rem; animation: bounce 3s ease-in-out infinite; }
        .medal { color: #FF6B6B; font-size: 2rem; animation: spin 4s linear infinite; }
        .star { color: #FFE066; font-size: 1.8rem; animation: twinkle 2s ease-in-out infinite; }

        @keyframes bounce {
            0%, 100% { transform: translateY(0px) rotate(0deg); }
            50% { transform: translateY(-20px) rotate(10deg); }
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        @keyframes twinkle {
            0%, 100% { opacity: 0.4; transform: scale(1); }
            50% { opacity: 1; transform: scale(1.2); }
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
            margin: 0 auto;
            padding: 0 2rem;
            max-width: 1400px;
        }

        .logo {
            font-size: 2rem;
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
            font-size: 1.8rem;
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
            font-size: 1rem;
            padding: 0.6rem 1rem;
            border-radius: 20px;
            transition: all 0.3s ease;
            position: relative;
        }

        .nav-links a:hover, .nav-links a.active {
            background: linear-gradient(45deg, #FFE066, #FF6B6B);
            color: white;
            transform: translateY(-2px) scale(1.05);
            box-shadow: 0 8px 25px rgba(255, 107, 107, 0.3);
        }

        .back-btn {
            background: linear-gradient(45deg, #4ECDC4, #45B7D1);
            color: white;
            padding: 0.7rem 1.5rem;
            border-radius: 25px;
            text-decoration: none;
            font-weight: 700;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            border: none;
            cursor: pointer;
        }

        .back-btn:hover {
            background: linear-gradient(45deg, #45B7D1, #4ECDC4);
            transform: translateY(-2px) scale(1.05);
            box-shadow: 0 8px 25px rgba(78, 205, 196, 0.4);
            color: white;
        }

        /* Main Content */
        .main-content {
            margin-top: 6rem;
            padding: 2rem;
            max-width: 1400px;
            margin-left: auto;
            margin-right: auto;
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

        .page-title {
            font-size: clamp(2.5rem, 5vw, 4rem);
            font-weight: 900;
            background: linear-gradient(45deg, #FF6B6B, #FFE066, #4ECDC4);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 1rem;
        }

        .page-subtitle {
            font-size: 1.3rem;
            color: #666;
            font-weight: 600;
            margin-bottom: 2rem;
        }

        /* Filters */
        .filters-section {
            background: white;
            border-radius: 25px;
            padding: 2rem;
            box-shadow: 0 15px 40px rgba(0, 0, 0, 0.1);
            margin-bottom: 2rem;
            animation: slideInUp 1s ease-out 0.2s both;
        }

        @keyframes slideInUp {
            from { opacity: 0; transform: translateY(30px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .filters-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
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
            font-size: 1.1rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .filter-select {
            padding: 1rem 1.5rem;
            border: 3px solid #f0f0f0;
            border-radius: 20px;
            font-size: 1rem;
            font-weight: 600;
            color: #333;
            background: white;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .filter-select:focus {
            outline: none;
            border-color: #4ECDC4;
            box-shadow: 0 0 0 3px rgba(78, 205, 196, 0.2);
            transform: scale(1.02);
        }

        /* Podium Section */
        .podium-section {
            margin-bottom: 3rem;
            animation: slideInUp 1s ease-out 0.4s both;
        }

        .podium {
            display: flex;
            justify-content: center;
            align-items: end;
            gap: 1rem;
            margin-bottom: 2rem;
            flex-wrap: wrap;
        }

        .podium-place {
            background: white;
            border-radius: 25px;
            padding: 2rem 1.5rem;
            text-align: center;
            box-shadow: 0 15px 40px rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease;
            min-width: 200px;
            position: relative;
            overflow: hidden;
        }

        .podium-place::before {
            content: "";
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 6px;
            background: var(--accent-gradient);
        }

        .podium-place:hover {
            transform: translateY(-10px) scale(1.05);
            box-shadow: 0 25px 60px rgba(0, 0, 0, 0.15);
        }

        .first-place {
            --accent-gradient: linear-gradient(45deg, #FFD700, #FFA500);
            order: 2;
            transform: scale(1.1);
        }

        .second-place {
            --accent-gradient: linear-gradient(45deg, #C0C0C0, #A9A9A9);
            order: 1;
        }

        .third-place {
            --accent-gradient: linear-gradient(45deg, #CD7F32, #B8860B);
            order: 3;
        }

        .podium-rank {
            font-size: 3rem;
            margin-bottom: 1rem;
        }

        .podium-user {
            font-size: 1.3rem;
            font-weight: 800;
            color: #333;
            margin-bottom: 0.5rem;
        }

        .podium-score {
            font-size: 1.1rem;
            color: #666;
            font-weight: 600;
            margin-bottom: 0.5rem;
        }

        .podium-badge {
            display: inline-block;
            padding: 0.3rem 0.8rem;
            border-radius: 15px;
            font-size: 0.8rem;
            font-weight: 700;
            color: white;
            background: var(--accent-gradient);
        }

        /* Leaderboard Table */
        .leaderboard-section {
            animation: slideInUp 1s ease-out 0.6s both;
        }

        .leaderboard-card {
            background: white;
            border-radius: 25px;
            overflow: hidden;
            box-shadow: 0 15px 40px rgba(0, 0, 0, 0.1);
        }

        .leaderboard-header {
            background: linear-gradient(45deg, #FF6B6B, #FFE066);
            color: #333;
            padding: 1.5rem 2rem;
            font-size: 1.5rem;
            font-weight: 800;
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .leaderboard-table {
            width: 100%;
            border-collapse: collapse;
        }

        .leaderboard-table th {
            background: #f8f9fa;
            padding: 1.2rem 1rem;
            font-weight: 700;
            color: #333;
            text-align: left;
            font-size: 1rem;
            border-bottom: 2px solid #e9ecef;
        }

        .leaderboard-table td {
            padding: 1.2rem 1rem;
            border-bottom: 1px solid #f0f0f0;
            font-weight: 600;
            color: #555;
        }

        .leaderboard-table tr {
            transition: all 0.3s ease;
        }

        .leaderboard-table tr:hover {
            background: linear-gradient(45deg, rgba(255, 230, 102, 0.1), rgba(255, 107, 107, 0.1));
            transform: scale(1.01);
        }

        .rank-cell {
            font-weight: 800;
            font-size: 1.2rem;
            color: #FF6B6B;
            text-align: center;
            width: 80px;
        }

        .user-cell {
            font-weight: 700;
            color: #333;
            display: flex;
            align-items: center;
            gap: 0.8rem;
        }

        .user-avatar {
            width: 40px;
            height: 40px;
            background: linear-gradient(45deg, #4ECDC4, #45B7D1);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: 800;
            font-size: 1.1rem;
        }

        .you-badge {
            background: linear-gradient(45deg, #FFE066, #FF6B6B);
            color: #333;
            padding: 0.2rem 0.6rem;
            border-radius: 10px;
            font-size: 0.7rem;
            font-weight: 800;
        }

        .score-cell {
            font-weight: 800;
            color: #4ECDC4;
            font-size: 1.1rem;
        }

        .percentage-cell {
            font-weight: 800;
            font-size: 1.1rem;
        }

        .time-cell {
            color: #666;
            font-family: monospace;
            font-size: 0.9rem;
        }

        .date-cell {
            color: #888;
            font-size: 0.9rem;
        }

        .highlight-row {
            background: linear-gradient(45deg, rgba(78, 205, 196, 0.1), rgba(69, 183, 209, 0.1)) !important;
            border-left: 4px solid #4ECDC4;
        }

        .empty-state {
            text-align: center;
            padding: 3rem;
            color: #666;
        }

        .empty-state-icon {
            font-size: 4rem;
            margin-bottom: 1rem;
        }

        .empty-state-text {
            font-size: 1.2rem;
            font-weight: 600;
        }

        /* User Rank Card */
        .user-rank-section {
            margin-top: 2rem;
            animation: slideInUp 1s ease-out 0.8s both;
        }

        .user-rank-card {
            background: linear-gradient(45deg, #4ECDC4, #45B7D1);
            color: white;
            border-radius: 25px;
            padding: 2rem;
            text-align: center;
            box-shadow: 0 15px 40px rgba(78, 205, 196, 0.3);
        }

        .user-rank-title {
            font-size: 1.8rem;
            font-weight: 800;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 1rem;
        }

        .user-stats {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 1.5rem;
        }

        .user-stat {
            background: rgba(255, 255, 255, 0.2);
            border-radius: 15px;
            padding: 1.5rem;
            backdrop-filter: blur(10px);
        }

        .user-stat-value {
            font-size: 2rem;
            font-weight: 900;
            margin-bottom: 0.5rem;
        }

        .user-stat-label {
            font-size: 0.9rem;
            font-weight: 600;
            opacity: 0.9;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .main-content {
                padding: 1rem;
                margin-top: 5rem;
            }

            .podium {
                flex-direction: column;
                align-items: center;
            }

            .podium-place {
                width: 100%;
                max-width: 300px;
                order: unset !important;
                transform: none !important;
            }

            .filters-grid {
                grid-template-columns: 1fr;
            }

            .leaderboard-table {
                font-size: 0.8rem;
            }

            .leaderboard-table th,
            .leaderboard-table td {
                padding: 0.8rem 0.5rem;
            }

            .user-cell {
                flex-direction: column;
                align-items: flex-start;
                gap: 0.3rem;
            }

            .nav-links {
                display: none;
            }
        }

        /* Loading Animation */
        .loading {
            display: inline-block;
            width: 20px;
            height: 20px;
            border: 3px solid #f3f3f3;
            border-top: 3px solid #4ECDC4;
            border-radius: 50%;
            animation: spin 1s linear infinite;
        }
    </style>
</head>
<body>
    <!-- Floating Decorations -->
    <div class="decoration trophy" style="top: 10%; left: 5%;">🏆</div>
    <div class="decoration medal" style="top: 20%; right: 8%;">🥇</div>
    <div class="decoration star" style="top: 50%; left: 3%;">⭐</div>
    <div class="decoration trophy" style="bottom: 25%; right: 5%;">🎖️</div>
    <div class="decoration medal" style="bottom: 15%; left: 8%;">🥈</div>
    <div class="decoration star" style="top: 70%; right: 12%;">✨</div>

    <!-- Header -->
    <header class="header">
        <nav class="nav">
            <a href="${pageContext.request.contextPath}/home" class="logo">EduQuiz</a>
            
            <ul class="nav-links">
                <li><a href="${pageContext.request.contextPath}/quizzes">Quizzes</a></li>
                <li><a href="${pageContext.request.contextPath}/leaderboard" class="active">Leaderboard</a></li>
                <li><a href="${pageContext.request.contextPath}/history">History</a></li>
            </ul>
            
            <a href="${pageContext.request.contextPath}/home" class="back-btn">
                🏠 Back to Home
            </a>
        </nav>
    </header>

    <!-- Main Content -->
    <main class="main-content">
        <!-- Page Header -->
        <div class="page-header">
            <h1 class="page-title">
                🏆 Champions Leaderboard 🏆
            </h1>
            <p class="page-subtitle">
                See who's crushing it! Check out the top performers and find your rank! 🌟
            </p>
        </div>

        <!-- Filters -->
        <div class="filters-section">
            <div class="filters-grid">
                <div class="filter-group">
                    <label class="filter-label">
                        📚 Category Filter
                    </label>
                    <select class="filter-select" id="categoryFilter">
                        <option value="">🌟 All Categories</option>
                        <c:forEach items="${categories}" var="category">
                            <option value="${category.id}" ${param.category eq category.id ? 'selected' : ''}>${category.name}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="filter-group">
                    <label class="filter-label">
                        📅 Time Period
                    </label>
                    <select class="filter-select" id="timeFilter">
                        <option value="all">🕰️ All Time</option>
                        <option value="month" ${param.time eq 'month' ? 'selected' : ''}>📅 This Month</option>
                        <option value="week" ${param.time eq 'week' ? 'selected' : ''}>📆 This Week</option>
                        <option value="day" ${param.time eq 'day' ? 'selected' : ''}>⏰ Today</option>
                    </select>
                </div>
            </div>
        </div>

        <!-- Podium (Top 3) -->
        <c:if test="${not empty topScores and topScores.size() >= 3}">
            <div class="podium-section">
                <div class="podium">
                    <div class="podium-place second-place">
                        <div class="podium-rank">🥈</div>
                        <div class="podium-user">${topScores[1].userName}</div>
                        <div class="podium-score">${topScores[1].score}/${topScores[1].quiz.totalQuestions}</div>
                        <div class="podium-badge">${topScores[1].percentage}%</div>
                    </div>
                    <div class="podium-place first-place">
                        <div class="podium-rank">🥇</div>
                        <div class="podium-user">${topScores[0].userName}</div>
                        <div class="podium-score">${topScores[0].score}/${topScores[0].quiz.totalQuestions}</div>
                        <div class="podium-badge">${topScores[0].percentage}%</div>
                    </div>
                    <div class="podium-place third-place">
                        <div class="podium-rank">🥉</div>
                        <div class="podium-user">${topScores[2].userName}</div>
                        <div class="podium-score">${topScores[2].score}/${topScores[2].quiz.totalQuestions}</div>
                        <div class="podium-badge">${topScores[2].percentage}%</div>
                    </div>
                </div>
            </div>
        </c:if>

        <!-- Leaderboard Table -->
        <div class="leaderboard-section">
            <div class="leaderboard-card">
                <div class="leaderboard-header">
                    📊 Complete Rankings
                </div>
                <table class="leaderboard-table">
                    <thead>
                        <tr>
                            <th class="rank-cell">Rank</th>
                            <th>Player</th>
                            <th>Quiz</th>
                            <th>Score</th>
                            <th>Accuracy</th>
                            <th>Time</th>
                            <th>Date</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${topScores}" var="score" varStatus="status">
                            <tr class="${score.userName eq sessionScope.userName ? 'highlight-row' : ''}">
                                <td class="rank-cell">
                                    <c:choose>
                                        <c:when test="${status.index == 0}">🥇</c:when>
                                        <c:when test="${status.index == 1}">🥈</c:when>
                                        <c:when test="${status.index == 2}">🥉</c:when>
                                        <c:otherwise>${status.index + 1}</c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="user-cell">
                                    <div class="user-avatar">
                                        ${score.userName.substring(0, 1).toUpperCase()}
                                    </div>
                                    <div>
                                        ${score.userName}
                                        <c:if test="${score.userName eq sessionScope.userName}">
                                            <div class="you-badge">That's You! 🎉</div>
                                        </c:if>
                                    </div>
                                </td>
                                <td>${score.quiz.title}</td>
                                <td class="score-cell">${score.score}/${score.quiz.totalQuestions}</td>
                                <td class="percentage-cell">
                                    <c:choose>
                                        <c:when test="${score.percentage >= 90}">🔥 ${score.percentage}%</c:when>
                                        <c:when test="${score.percentage >= 80}">⭐ ${score.percentage}%</c:when>
                                        <c:when test="${score.percentage >= 70}">👍 ${score.percentage}%</c:when>
                                        <c:otherwise>${score.percentage}%</c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="time-cell">
                                    <fmt:formatNumber value="${score.completionTime / 60}" pattern="#" />:<fmt:formatNumber value="${score.completionTime % 60}" pattern="00" />
                                </td>
                                <td class="date-cell">
                                    <fmt:formatDate value="${score.dateTaken}" pattern="MMM dd, yyyy" />
                                </td>
                            </tr>
                        </c:forEach>
                        
                        <c:if test="${empty topScores}">
                            <tr>
                                <td colspan="7" class="empty-state">
                                    <div class="empty-state-icon">🤔</div>
                                    <div class="empty-state-text">No champions found yet! Be the first to take a quiz! 🚀</div>
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- User Rank Card -->
        <c:if test="${not empty userRank}">
            <div class="user-rank-section">
                <div class="user-rank-card">
                    <div class="user-rank-title">
                        🎯 Your Performance Stats
                    </div>
                    <div class="user-stats">
                        <div class="user-stat">
                            <div class="user-stat-value">#${userRank.rank}</div>
                            <div class="user-stat-label">Your Rank</div>
                        </div>
                        <div class="user-stat">
                            <div class="user-stat-value">${userRank.totalScore}</div>
                            <div class="user-stat-label">Total Score</div>
                        </div>
                        <div class="user-stat">
                            <div class="user-stat-value">${userRank.quizzesTaken}</div>
                            <div class="user-stat-label">Quizzes Taken</div>
                        </div>
                        <div class="user-stat">
                            <div class="user-stat-value">${userRank.averageScore}%</div>
                            <div class="user-stat-label">Average Score</div>
                        </div>
                    </div>
                </div>
            </div>
        </c:if>
    </main>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Filter functionality
            const categoryFilter = document.getElementById('categoryFilter');
            const timeFilter = document.getElementById('timeFilter');
            
            categoryFilter.addEventListener('change', applyFilters);
            timeFilter.addEventListener('change', applyFilters);
            
            function applyFilters() {
                // Show loading state
                document.body.style.cursor = 'wait';
                
                const category = categoryFilter.value;
                const time = timeFilter.value;
                
                let url = '${pageContext.request.contextPath}/leaderboard?';
                if (category) url += 'category=' + category + '&';
                if (time && time !== 'all') url += 'time=' + time;
                
                window.location.href = url;
            }

            // Add hover effects to table rows
            const tableRows = document.querySelectorAll('.leaderboard-table tr');
            tableRows.forEach(row => {
                row.addEventListener('mouseenter', function() {
                    this.style.transform = 'scale(1.01)';
                });
                
                row.addEventListener('mouseleave', function() {
                    this.style.transform = 'scale(1)';
                });
            });

            // Animate numbers on load
            const numbers = document.querySelectorAll('.user-stat-value, .score-cell');
            numbers.forEach(num => {
                const finalValue = num.textContent;
                if (!isNaN(parseInt(finalValue))) {
                    animateNumber(num, parseInt(finalValue));
                }
            });

            function animateNumber(element, finalValue) {
                let currentValue = 0;
                const increment = finalValue / 50;
                const timer = setInterval(() => {
                    currentValue += increment;
                    if (currentValue >= finalValue) {
                        element.textContent = finalValue;
                        clearInterval(timer);
                    } else {
                        element.textContent = Math.floor(currentValue);
                    }
                }, 20);
            }

            // Add celebration effect for top performers
            const topRanks = document.querySelectorAll('.rank-cell');
            topRanks.forEach((rank, index) => {
                if (index < 3) {
                    setInterval(() => {
                        rank.style.transform = 'scale(1.1)';
                        setTimeout(() => {
                        	rank.style.transform = 'scale(1)';
                        }, 300);
                    }, 2000 + (index * 500));
                }
            });

            // Add smooth scroll for better UX
            window.addEventListener('load', function() {
                document.body.style.cursor = 'default';
            });

            // Add particle effect for celebrations
            function createParticle(x, y) {
                const particle = document.createElement('div');
                particle.innerHTML = ['🎉', '⭐', '🏆', '✨'][Math.floor(Math.random() * 4)];
                particle.style.cssText = `
                    position: fixed;
                    left: ${x}px;
                    top: ${y}px;
                    pointer-events: none;
                    font-size: 1.5rem;
                    z-index: 9999;
                    animation: particle-float 2s ease-out forwards;
                `;
                
                document.body.appendChild(particle);
                
                setTimeout(() => {
                    particle.remove();
                }, 2000);
            }

            // Add CSS for particle animation
            const style = document.createElement('style');
            style.textContent = `
                @keyframes particle-float {
                    0% {
                        transform: translateY(0) rotate(0deg);
                        opacity: 1;
                    }
                    100% {
                        transform: translateY(-100px) rotate(360deg);
                        opacity: 0;
                    }
                }
            `;
            document.head.appendChild(style);

            // Trigger particles on podium hover
            const podiumPlaces = document.querySelectorAll('.podium-place');
            podiumPlaces.forEach(place => {
                place.addEventListener('mouseenter', function(e) {
                    const rect = this.getBoundingClientRect();
                    for (let i = 0; i < 3; i++) {
                        setTimeout(() => {
                            createParticle(
                                rect.left + rect.width/2 + (Math.random() - 0.5) * 100,
                                rect.top + rect.height/2 + (Math.random() - 0.5) * 50
                            );
                        }, i * 200);
                    }
                });
            });

            // Add dynamic background color changes based on performance
            const percentageCells = document.querySelectorAll('.percentage-cell');
            percentageCells.forEach(cell => {
                const percentage = parseInt(cell.textContent);
                if (percentage >= 90) {
                    cell.style.background = 'linear-gradient(45deg, rgba(255, 215, 0, 0.2), rgba(255, 140, 0, 0.2))';
                    cell.style.borderRadius = '10px';
                    cell.style.padding = '0.5rem';
                } else if (percentage >= 80) {
                    cell.style.background = 'linear-gradient(45deg, rgba(78, 205, 196, 0.2), rgba(69, 183, 209, 0.2))';
                    cell.style.borderRadius = '10px';
                    cell.style.padding = '0.5rem';
                } else if (percentage >= 70) {
                    cell.style.background = 'linear-gradient(45deg, rgba(255, 230, 102, 0.2), rgba(255, 107, 107, 0.2))';
                    cell.style.borderRadius = '10px';
                    cell.style.padding = '0.5rem';
                }
            });

            // Add typing effect for empty state
            const emptyStateText = document.querySelector('.empty-state-text');
            if (emptyStateText) {
                const originalText = emptyStateText.textContent;
                emptyStateText.textContent = '';
                let i = 0;
                const typeInterval = setInterval(() => {
                    emptyStateText.textContent += originalText[i];
                    i++;
                    if (i >= originalText.length) {
                        clearInterval(typeInterval);
                    }
                }, 50);
            }

            // Add progress bars for scores
            const scoreCells = document.querySelectorAll('.score-cell');
            scoreCells.forEach(cell => {
                const scoreText = cell.textContent;
                const [current, total] = scoreText.split('/').map(num => parseInt(num));
                const percentage = (current / total) * 100;
                
                cell.innerHTML = `
                    <div style="display: flex; align-items: center; gap: 0.5rem;">
                        <span>${scoreText}</span>
                        <div style="
                            width: 50px; 
                            height: 6px; 
                            background: #f0f0f0; 
                            border-radius: 3px; 
                            overflow: hidden;
                        ">
                            <div style="
                                width: ${percentage}%; 
                                height: 100%; 
                                background: linear-gradient(45deg, #4ECDC4, #45B7D1);
                                transition: width 1s ease;
                            "></div>
                        </div>
                    </div>
                `;
            });

            // Add tooltip functionality
            const userAvatars = document.querySelectorAll('.user-avatar');
            userAvatars.forEach(avatar => {
                avatar.title = `Click to view ${avatar.parentElement.querySelector('div').textContent.trim()}'s profile`;
                avatar.style.cursor = 'pointer';
                
                avatar.addEventListener('click', function() {
                    // Placeholder for user profile functionality
                    console.log('Navigate to user profile');
                });
            });

            // Add keyboard navigation
            document.addEventListener('keydown', function(e) {
                if (e.key === 'Escape') {
                    // Reset filters
                    categoryFilter.value = '';
                    timeFilter.value = 'all';
                    applyFilters();
                }
            });

            // Add loading animation for filter changes
            function showLoading() {
                const loadingOverlay = document.createElement('div');
                loadingOverlay.innerHTML = `
                    <div style="
                        position: fixed;
                        top: 0;
                        left: 0;
                        width: 100%;
                        height: 100%;
                        background: rgba(255, 255, 255, 0.9);
                        display: flex;
                        justify-content: center;
                        align-items: center;
                        z-index: 10000;
                        backdrop-filter: blur(5px);
                    ">
                        <div style="
                            text-align: center;
                            color: #333;
                        ">
                            <div class="loading" style="margin: 0 auto 1rem;"></div>
                            <div style="font-size: 1.2rem; font-weight: 600;">Loading Champions... 🏆</div>
                        </div>
                    </div>
                `;
                document.body.appendChild(loadingOverlay);
            }

            // Enhanced filter function with loading
            function applyFiltersWithLoading() {
                showLoading();
                setTimeout(applyFilters, 500); // Add slight delay for better UX
            }

            // Update event listeners
            categoryFilter.removeEventListener('change', applyFilters);
            timeFilter.removeEventListener('change', applyFilters);
            categoryFilter.addEventListener('change', applyFiltersWithLoading);
            timeFilter.addEventListener('change', applyFiltersWithLoading);
        });
    </script>
</body>
</html>