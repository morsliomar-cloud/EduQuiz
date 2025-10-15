<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EduQuiz - ${quiz.title}</title>
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
            padding-top: 5rem;
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
            max-width: 1400px;
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

        .back-btn {
            background: linear-gradient(45deg, #4ECDC4, #45B7D1);
            color: white;
            padding: 0.8rem 1.5rem;
            border-radius: 25px;
            text-decoration: none;
            font-weight: 700;
            font-size: 1rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            transition: all 0.3s ease;
            border: none;
        }

        .back-btn:hover {
            background: linear-gradient(45deg, #45B7D1, #4ECDC4);
            transform: translateY(-2px) scale(1.05);
            box-shadow: 0 8px 25px rgba(78, 205, 196, 0.4);
            color: white;
        }

        /* Main Container */
        .container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 2rem;
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 2rem;
        }

        /* Quiz Hero Card */
        .quiz-hero {
            background: white;
            border-radius: 30px;
            padding: 2.5rem;
            box-shadow: 0 20px 60px rgba(255, 107, 107, 0.15);
            margin-bottom: 2rem;
            position: relative;
            overflow: hidden;
        }

        .quiz-hero::before {
            content: "";
            position: absolute;
            top: -50%;
            right: -50%;
            width: 200%;
            height: 200%;
            background: linear-gradient(45deg, #FFE066, #FF6B6B, #4ECDC4, #45B7D1);
            animation: rotate 20s linear infinite;
            opacity: 0.05;
        }

        @keyframes rotate {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        .quiz-title {
            font-size: 2.5rem;
            font-weight: 900;
            color: #333;
            margin-bottom: 1rem;
            position: relative;
            z-index: 2;
        }

        .quiz-badges {
            display: flex;
            gap: 1rem;
            margin-bottom: 1.5rem;
            flex-wrap: wrap;
            position: relative;
            z-index: 2;
        }

        .badge-fun {
            padding: 0.5rem 1.2rem;
            border-radius: 20px;
            font-weight: 700;
            font-size: 0.9rem;
            display: flex;
            align-items: center;
            gap: 0.3rem;
        }

        .badge-easy {
            background: linear-gradient(45deg, #96CEB4, #4ECDC4);
            color: white;
        }

        .badge-medium {
            background: linear-gradient(45deg, #FFE066, #FF9F43);
            color: #333;
        }

        .badge-hard {
            background: linear-gradient(45deg, #FF6B6B, #FF5722);
            color: white;
        }

        .badge-category {
            background: linear-gradient(45deg, #45B7D1, #667eea);
            color: white;
        }

        .badge-time {
            background: linear-gradient(45deg, #f093fb, #f5576c);
            color: white;
        }

        .badge-questions {
            background: linear-gradient(45deg, #4facfe, #00f2fe);
            color: white;
        }

        .quiz-description {
            font-size: 1.2rem;
            color: #666;
            line-height: 1.6;
            margin-bottom: 2rem;
            position: relative;
            z-index: 2;
        }

        .action-buttons {
            display: flex;
            gap: 1rem;
            flex-wrap: wrap;
            position: relative;
            z-index: 2;
        }

        .btn-play {
            background: linear-gradient(45deg, #FF6B6B, #FFE066);
            color: #333;
            padding: 1.2rem 2.5rem;
            border-radius: 30px;
            font-weight: 800;
            font-size: 1.2rem;
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            transition: all 0.3s ease;
            border: none;
            cursor: pointer;
            box-shadow: 0 8px 25px rgba(255, 107, 107, 0.3);
        }

        .btn-play:hover {
            background: linear-gradient(45deg, #FFE066, #FF6B6B);
            transform: translateY(-4px) scale(1.05);
            box-shadow: 0 15px 40px rgba(255, 107, 107, 0.5);
            color: #333;
        }

        /* Info Cards */
        .info-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        .info-card {
            background: white;
            border-radius: 20px;
            padding: 1.5rem;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease;
        }

        .info-card:hover {
            transform: translateY(-5px) scale(1.02);
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.15);
        }

        .info-card h3 {
            font-size: 1.2rem;
            font-weight: 800;
            color: #333;
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .info-card ul {
            list-style: none;
            padding: 0;
        }

        .info-card li {
            padding: 0.5rem 0;
            color: #666;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .info-card li:before {
            content: "✨";
            font-size: 1rem;
        }

        /* Best Score Card */
        .best-score {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 25px;
            padding: 2rem;
            margin-bottom: 2rem;
            box-shadow: 0 15px 40px rgba(102, 126, 234, 0.3);
        }

        .best-score h3 {
            font-size: 1.5rem;
            font-weight: 800;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .score-stats {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 1rem;
            text-align: center;
        }

        .score-stat {
            background: rgba(255, 255, 255, 0.1);
            border-radius: 15px;
            padding: 1rem;
            backdrop-filter: blur(10px);
        }

        .score-number {
            font-size: 2rem;
            font-weight: 900;
            display: block;
            margin-bottom: 0.5rem;
        }

        .score-label {
            font-size: 0.9rem;
            opacity: 0.8;
            font-weight: 600;
        }

        /* Sidebar */
        .sidebar {
            display: flex;
            flex-direction: column;
            gap: 1.5rem;
        }

        .sidebar-card {
            background: white;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            transition: all 0.3s ease;
        }

        .sidebar-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.15);
        }

        .sidebar-header {
            background: linear-gradient(45deg, #4ECDC4, #45B7D1);
            color: white;
            padding: 1.2rem 1.5rem;
            font-size: 1.2rem;
            font-weight: 800;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .leaderboard-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 1rem 1.5rem;
            border-bottom: 1px solid #f0f0f0;
            transition: all 0.3s ease;
        }

        .leaderboard-item:hover {
            background: linear-gradient(45deg, #FFE066, #FF6B6B);
            transform: translateX(5px);
            color: #333;
        }

        .leaderboard-item:last-child {
            border-bottom: none;
        }

        .rank-badge {
            background: linear-gradient(45deg, #FF6B6B, #FFE066);
            color: #333;
            width: 30px;
            height: 30px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 800;
            font-size: 0.9rem;
            margin-right: 0.8rem;
        }

        .user-name {
            font-weight: 700;
            color: #333;
        }

        .score-info {
            display: flex;
            flex-direction: column;
            align-items: flex-end;
            gap: 0.2rem;
        }

        .score-badge {
            background: linear-gradient(45deg, #96CEB4, #4ECDC4);
            color: white;
            padding: 0.3rem 0.8rem;
            border-radius: 15px;
            font-weight: 700;
            font-size: 0.8rem;
        }

        .time-badge {
            font-size: 0.75rem;
            color: #666;
            font-weight: 600;
        }

        /* Related Quiz Item */
        .related-quiz {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 1rem 1.5rem;
            text-decoration: none;
            color: #333;
            border-bottom: 1px solid #f0f0f0;
            transition: all 0.3s ease;
        }

        .related-quiz:hover {
            background: linear-gradient(45deg, #4ECDC4, #45B7D1);
            color: white;
            transform: translateX(5px);
        }

        .related-quiz:last-child {
            border-bottom: none;
        }

        .related-info h4 {
            font-size: 1rem;
            font-weight: 700;
            margin-bottom: 0.3rem;
        }

        .related-meta {
            font-size: 0.8rem;
            opacity: 0.7;
            font-weight: 600;
        }

        .question-count {
            background: linear-gradient(45deg, #f093fb, #f5576c);
            color: white;
            padding: 0.3rem 0.8rem;
            border-radius: 15px;
            font-weight: 700;
            font-size: 0.8rem;
        }

        /* Share Section */
        .share-buttons {
            display: flex;
            flex-direction: column;
            gap: 1rem;
            padding: 1.5rem;
        }

        .copy-btn {
            background: linear-gradient(45deg, #4ECDC4, #45B7D1);
            color: white;
            padding: 0.8rem 1.5rem;
            border-radius: 20px;
            border: none;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
        }

        .copy-btn:hover {
            background: linear-gradient(45deg, #45B7D1, #4ECDC4);
            transform: translateY(-2px) scale(1.05);
            box-shadow: 0 8px 25px rgba(78, 205, 196, 0.4);
        }

        .social-buttons {
            display: flex;
            gap: 0.5rem;
        }

        .social-btn {
            flex: 1;
            padding: 0.8rem;
            border-radius: 15px;
            border: none;
            font-size: 1.2rem;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .social-facebook {
            background: linear-gradient(45deg, #4267B2, #365899);
            color: white;
        }

        .social-twitter {
            background: linear-gradient(45deg, #1DA1F2, #0d8bd9);
            color: white;
        }

        .social-whatsapp {
            background: linear-gradient(45deg, #25D366, #128C7E);
            color: white;
        }

        .social-btn:hover {
            transform: translateY(-3px) scale(1.1);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.2);
        }

        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 2rem;
            color: #666;
        }

        .empty-state .emoji {
            font-size: 3rem;
            margin-bottom: 1rem;
            display: block;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .container {
                grid-template-columns: 1fr;
                padding: 1rem;
            }

            .quiz-hero {
                padding: 1.5rem;
            }

            .quiz-title {
                font-size: 2rem;
            }

            .info-grid {
                grid-template-columns: 1fr;
            }

            .score-stats {
                grid-template-columns: 1fr;
            }

            .action-buttons {
                flex-direction: column;
            }

            .nav {
                padding: 0 1rem;
            }

            .logo {
                font-size: 2rem;
            }
        }

        /* Success Animation */
        @keyframes celebrate {
            0% { 
                opacity: 1; 
                transform: translate(0, 0) scale(1) rotate(0deg); 
            }
            100% { 
                opacity: 0; 
                transform: translate(var(--random-x), var(--random-y)) scale(0.5) rotate(360deg); 
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
            <a href="${pageContext.request.contextPath}/quizzes" class="back-btn">
                ← Back to Quizzes
            </a>
        </nav>
    </header>

    <!-- Main Container -->
    <div class="container">
        <!-- Main Content -->
        <div class="main-content">
            <!-- Quiz Hero Section -->
            <div class="quiz-hero">
                <h1 class="quiz-title">${quiz.title}</h1>
                
                <div class="quiz-badges">
                    <span class="badge-fun badge-${quiz.difficulty.toLowerCase()}">
                        <c:choose>
                            <c:when test="${quiz.difficulty eq 'Easy'}">😊 Easy</c:when>
                            <c:when test="${quiz.difficulty eq 'Medium'}">🤔 Medium</c:when>
                            <c:otherwise>🔥 Hard</c:otherwise>
                        </c:choose>
                    </span>
                    <span class="badge-fun badge-category">📚 ${category.name}</span>
                    <span class="badge-fun badge-time">⏰ ${quiz.timeLimit} mins</span>
                    <span class="badge-fun badge-questions">❓ ${questionCount} questions</span>
                </div>
                
                <p class="quiz-description">${quiz.description}</p>
                
                <div class="action-buttons">
                    <c:choose>
                        <c:when test="${sessionScope.user != null}">
                            <a href="${pageContext.request.contextPath}/take-quiz/${quiz.id}" class="btn-play">
                                🚀 Let's Play!
                            </a>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/login" class="btn-play">
                                🔑 Login to Play
                            </a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- Info Cards -->
            <div class="info-grid">
                <div class="info-card">
                    <h3>🎮 Quiz Features</h3>
                    <ul>
                        <li>Multiple choice fun</li>
                        <li>Time limit: ${quiz.timeLimit} minutes</li>
                        <li>Difficulty: ${quiz.difficulty}</li>
                        <li>Category: ${category.name}</li>
                    </ul>
                </div>
                <div class="info-card">
                    <h3>🎁 What You'll Get</h3>
                    <ul>
                        <li>Instant performance score</li>
                        <li>Fun feedback & tips</li>
                        <li>Compare with friends</li>
                        <li>Track your progress</li>
                    </ul>
                </div>
            </div>

            <!-- Best Score Card -->
            <c:if test="${userBestScore != null}">
                <div class="best-score">
                    <h3>🏆 Your Best Performance</h3>
                    <div class="score-stats">
                        <div class="score-stat">
                            <span class="score-number">${userBestScore.score}%</span>
                            <span class="score-label">Score</span>
                        </div>
                        <div class="score-stat">
                            <span class="score-number">${userBestScore.completionTime}</span>
                            <span class="score-label">Seconds</span>
                        </div>
                        <div class="score-stat">
                            <span class="score-number"><fmt:formatDate value="${userBestScore.dateTaken}" pattern="MMM dd" /></span>
                            <span class="score-label">Date</span>
                        </div>
                    </div>
                </div>
            </c:if>
        </div>

        <!-- Sidebar -->
        <div class="sidebar">
            <!-- Top Scores -->
            <div class="sidebar-card">
                <div class="sidebar-header">
                    🏆 Top Performers
                </div>
                <div class="leaderboard">
                    <c:choose>
                        <c:when test="${topScores != null && !topScores.isEmpty()}">
                            <c:forEach items="${topScores}" var="score" varStatus="status">
                                <div class="leaderboard-item">
                                    <div style="display: flex; align-items: center;">
                                        <span class="rank-badge">${status.index + 1}</span>
                                        <span class="user-name">${score.userName}</span>
                                    </div>
                                    <div class="score-info">
                                        <span class="score-badge">${score.score}%</span>
                                        <span class="time-badge">${score.completionTime}s</span>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="empty-state">
                                <span class="emoji">🎯</span>
                                <p>Be the first to complete this quiz and claim the top spot!</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- Related Quizzes -->
            <div class="sidebar-card">
                <div class="sidebar-header">
                    🎲 More Fun Quizzes
                </div>
                <div class="related-quizzes">
                    <c:choose>
                        <c:when test="${relatedQuizzes != null && !relatedQuizzes.isEmpty()}">
                            <c:forEach items="${relatedQuizzes}" var="relatedQuiz">
                                <a href="${pageContext.request.contextPath}/quiz/${relatedQuiz.id}" class="related-quiz">
                                    <div class="related-info">
                                        <h4>${relatedQuiz.title}</h4>
                                        <div class="related-meta">${relatedQuiz.difficulty} Level</div>
                                    </div>
                                    <span class="question-count">${relatedQuiz.questionCount} Qs</span>
                                </a>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="empty-state">
                                <span class="emoji">🔍</span>
                                <p>No related quizzes found yet!</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- Share Section -->
            <div class="sidebar-card">
                <div class="sidebar-header">
                    📤 Share the Fun
                </div>
                <div class="share-buttons">
                    <button class="copy-btn" onclick="copyQuizLink()">
                        🔗 Copy Quiz Link
                    </button>
                    <div class="social-buttons">
                        <a href="#" class="social-btn social-facebook">📘</a>
                        <a href="#" class="social-btn social-twitter">🐦</a>
                        <a href="#" class="social-btn social-whatsapp">💬</a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        function copyQuizLink() {
            const url = window.location.href;
            navigator.clipboard.writeText(url)
                .then(() => {
                    // Create celebration effect
                    createCelebration(event);
                    
                    // Show success message
                    const btn = event.target;
                    const originalText = btn.innerHTML;
                    btn.innerHTML = '✅ Copied!';
                    btn.style.background = 'linear-gradient(45deg, #96CEB4, #4ECDC4)';
                    
                    setTimeout(() => {
                        btn.innerHTML = originalText;
                        btn.style.background = 'linear-gradient(45deg, #4ECDC4, #45B7D1)';
                    }, 2000);
                })
                .catch(err => {
                    console.error('Failed to copy: ', err);
                    alert('Failed to copy link. Please try again!');
                });
        }

        function createCelebration(event) {
            const emojis = ['🎉', '🎊', '⭐', '🌟', '💫', '✨', '🎈', '🎁'];
            const rect = event.target.getBoundingClientRect();
            const centerX = rect.left + rect.width / 2;
            const centerY = rect.top + rect.height / 2;
            
            for (let i = 0; i < 8; i++) {
                const emoji = document.createElement('div');
                emoji.textContent = emojis[Math.floor(Math.random() * emojis.length)];
                emoji.style.cssText = `
                    position: fixed;
                    left: ${centerX}px;
                    top: ${centerY}px;
                    font-size: 1.5rem;
                    pointer-events: none;
                    z-index: 9999;
                    --random-x: ${(Math.random() - 0.5) * 200}px;
                    --random-y: ${Math.random() * -200 - 50}px;
                    animation: celebrate 1.5s ease-out forwards;
                `;
                document.body.appendChild(emoji);
                
                setTimeout(() => emoji.remove(), 1500);
            }
        }

        // Add click effects to action buttons
        document.addEventListener('click', (e) => {
            if (e.target.classList.contains('btn-play') || 
                e.target.classList.contains('back-btn') ||
                e.target.classList.contains('social-btn')) {
                createCelebration(e);
            }
        });

     // Animate decorations
        document.addEventListener('DOMContentLoaded', function() {
            const decorations = document.querySelectorAll('.decoration');
            decorations.forEach((decoration, index) => {
                decoration.style.animationDelay = `${index * 0.5}s`;
                
                // Random movement for decorations
                setInterval(() => {
                    const randomX = Math.random() * 100;
                    const randomY = Math.random() * 100;
                    decoration.style.left = randomX + '%';
                    decoration.style.top = randomY + '%';
                }, 10000 + index * 2000);
            });
        });

        // Add hover effects to cards
        const cards = document.querySelectorAll('.info-card, .sidebar-card');
        cards.forEach(card => {
            card.addEventListener('mouseenter', function() {
                this.style.transform = 'translateY(-8px) scale(1.02)';
                this.style.boxShadow = '0 25px 50px rgba(0, 0, 0, 0.2)';
            });
            
            card.addEventListener('mouseleave', function() {
                this.style.transform = 'translateY(0) scale(1)';
                this.style.boxShadow = '0 10px 30px rgba(0, 0, 0, 0.1)';
            });
        });

        // Smooth scroll for navigation
        document.querySelectorAll('a[href^="#"]').forEach(anchor => {
            anchor.addEventListener('click', function (e) {
                e.preventDefault();
                const target = document.querySelector(this.getAttribute('href'));
                if (target) {
                    target.scrollIntoView({
                        behavior: 'smooth',
                        block: 'start'
                    });
                }
            });
        });

        // Add typing effect for quiz title
        function typeWriter(element, text, speed = 100) {
            let i = 0;
            element.innerHTML = '';
            function typing() {
                if (i < text.length) {
                    element.innerHTML += text.charAt(i);
                    i++;
                    setTimeout(typing, speed);
                }
            }
            typing();
        }

        // Initialize typing effect if quiz title exists
        const quizTitle = document.querySelector('.quiz-title');
        if (quizTitle) {
            const originalText = quizTitle.textContent;
            setTimeout(() => {
                typeWriter(quizTitle, originalText, 50);
            }, 500);
        }

        // Add ripple effect to buttons
        function createRipple(event) {
            const button = event.currentTarget;
            const circle = document.createElement('span');
            const diameter = Math.max(button.clientWidth, button.clientHeight);
            const radius = diameter / 2;
            
            circle.style.width = circle.style.height = `${diameter}px`;
            circle.style.left = `${event.clientX - button.offsetLeft - radius}px`;
            circle.style.top = `${event.clientY - button.offsetTop - radius}px`;
            circle.classList.add('ripple');
            
            const ripple = button.getElementsByClassName('ripple')[0];
            if (ripple) {
                ripple.remove();
            }
            
            button.appendChild(circle);
        }

        // Add ripple CSS
        const rippleStyle = document.createElement('style');
        rippleStyle.textContent = `
            .ripple {
                position: absolute;
                border-radius: 50%;
                background: rgba(255, 255, 255, 0.4);
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
        `;
        document.head.appendChild(rippleStyle);

        // Add ripple to buttons
        document.querySelectorAll('.btn-play, .back-btn, .copy-btn').forEach(button => {
            button.style.position = 'relative';
            button.style.overflow = 'hidden';
            button.addEventListener('click', createRipple);
        });

        // Intersection Observer for animations
        const observerOptions = {
            threshold: 0.1,
            rootMargin: '0px 0px -50px 0px'
        };

        const observer = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    entry.target.style.opacity = '1';
                    entry.target.style.transform = 'translateY(0)';
                }
            });
        }, observerOptions);

        // Observe elements for scroll animations
        document.querySelectorAll('.info-card, .sidebar-card, .best-score').forEach(el => {
            el.style.opacity = '0';
            el.style.transform = 'translateY(30px)';
            el.style.transition = 'opacity 0.6s ease, transform 0.6s ease';
            observer.observe(el);
        });

        // Add particle system for background
        function createParticle() {
            const particle = document.createElement('div');
            particle.style.cssText = `
                position: fixed;
                width: 4px;
                height: 4px;
                background: radial-gradient(circle, rgba(255,107,107,0.6) 0%, transparent 70%);
                border-radius: 50%;
                pointer-events: none;
                z-index: 1;
                animation: float 8s linear infinite;
                left: ${Math.random() * 100}vw;
                top: 100vh;
            `;
            
            document.body.appendChild(particle);
            
            setTimeout(() => {
                particle.remove();
            }, 8000);
        }

        // Particle animation keyframes
        const particleStyle = document.createElement('style');
        particleStyle.textContent = `
            @keyframes float {
                0% {
                    transform: translateY(0) rotate(0deg);
                    opacity: 0;
                }
                10% {
                    opacity: 1;
                }
                90% {
                    opacity: 1;
                }
                100% {
                    transform: translateY(-100vh) rotate(360deg);
                    opacity: 0;
                }
            }
        `;
        document.head.appendChild(particleStyle);

        // Create particles periodically
        setInterval(createParticle, 3000);

        // Enhanced social media sharing
        document.querySelector('.social-facebook')?.addEventListener('click', function(e) {
            e.preventDefault();
            const url = encodeURIComponent(window.location.href);
            const title = encodeURIComponent(document.querySelector('.quiz-title').textContent);
            window.open(`https://www.facebook.com/sharer/sharer.php?u=${url}&t=${title}`, '_blank', 'width=600,height=400');
        });

        document.querySelector('.social-twitter')?.addEventListener('click', function(e) {
            e.preventDefault();
            const url = encodeURIComponent(window.location.href);
            const title = encodeURIComponent(`Check out this amazing quiz: ${document.querySelector('.quiz-title').textContent}`);
            window.open(`https://twitter.com/intent/tweet?url=${url}&text=${title}`, '_blank', 'width=600,height=400');
        });

        document.querySelector('.social-whatsapp')?.addEventListener('click', function(e) {
            e.preventDefault();
            const url = encodeURIComponent(window.location.href);
            const title = encodeURIComponent(`Check out this quiz: ${document.querySelector('.quiz-title').textContent}`);
            window.open(`https://wa.me/?text=${title} ${url}`, '_blank');
        });

        // Add sound effects (optional - requires audio files)
        function playSound(soundName) {
            // Uncomment and add audio files if needed
            // const audio = new Audio(`/sounds/${soundName}.mp3`);
            // audio.volume = 0.3;
            // audio.play().catch(e => console.log('Audio play failed:', e));
        }

        // Play sounds on interactions
        document.addEventListener('click', (e) => {
            if (e.target.classList.contains('btn-play')) {
                playSound('success');
            } else if (e.target.classList.contains('copy-btn')) {
                playSound('copy');
            }
        });

        // Performance optimization - throttle scroll events
        let ticking = false;
        function updateScrollEffects() {
            // Add any scroll-based animations here
            ticking = false;
        }

        function requestScrollUpdate() {
            if (!ticking) {
                requestAnimationFrame(updateScrollEffects);
                ticking = true;
            }
        }

        window.addEventListener('scroll', requestScrollUpdate);

        // Clean up intervals on page unload
        window.addEventListener('beforeunload', () => {
            // Clear any intervals or timeouts here if needed
        });
    </script>
</body>
</html>