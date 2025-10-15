<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EduQuiz - Quiz Results</title>
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
            padding: 2rem 0;
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

        .celebration {
            color: #FF6B6B;
            font-size: 2rem;
            animation: bounce 4s ease-in-out infinite;
        }

        .trophy {
            color: #45B7D1;
            font-size: 2.5rem;
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

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 2rem;
        }

        .results-header {
            text-align: center;
            margin-bottom: 3rem;
            animation: slideInDown 0.8s ease-out;
        }

        .results-title {
            font-size: clamp(2.5rem, 5vw, 4rem);
            font-weight: 900;
            margin-bottom: 1rem;
            background: linear-gradient(45deg, #FF6B6B, #4ECDC4, #45B7D1);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .quiz-info {
            background: white;
            border-radius: 25px;
            padding: 2rem;
            margin-bottom: 2rem;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.1);
            animation: slideInLeft 0.8s ease-out;
        }

        .quiz-info h2 {
            color: #333;
            font-size: 1.8rem;
            font-weight: 800;
            margin-bottom: 0.5rem;
        }

        .quiz-info p {
            color: #666;
            font-size: 1.1rem;
            line-height: 1.6;
        }

        .results-summary {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 2rem;
            margin-bottom: 3rem;
            animation: slideInUp 0.8s ease-out;
        }

        .result-card {
            background: white;
            border-radius: 25px;
            padding: 2.5rem 2rem;
            text-align: center;
            box-shadow: 0 15px 40px rgba(0, 0, 0, 0.1);
            position: relative;
            overflow: hidden;
            transition: all 0.3s ease;
        }

        .result-card:hover {
            transform: translateY(-10px) scale(1.02);
            box-shadow: 0 25px 50px rgba(0, 0, 0, 0.15);
        }

        .result-card::before {
            content: "";
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            opacity: 0.05;
            animation: rotate 20s linear infinite;
        }

        .result-card.score::before {
            background: linear-gradient(45deg, #FF6B6B, #FFE066);
        }

        .result-card.time::before {
            background: linear-gradient(45deg, #4ECDC4, #45B7D1);
        }

        .result-card.status::before {
            background: linear-gradient(45deg, #96CEB4, #45B7D1);
        }

        @keyframes rotate {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        .result-icon {
            font-size: 3rem;
            margin-bottom: 1rem;
            display: block;
        }

        .result-title {
            font-size: 1.2rem;
            font-weight: 700;
            color: #666;
            margin-bottom: 0.5rem;
        }

        .result-value {
            font-size: 2.5rem;
            font-weight: 900;
            margin-bottom: 0.5rem;
        }

        .result-subtitle {
            font-size: 1rem;
            color: #888;
            font-weight: 600;
        }

        .score-excellent {
            color: #28a745;
            background: linear-gradient(45deg, #28a745, #20c997);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .score-good {
            color: #ffc107;
            background: linear-gradient(45deg, #ffc107, #fd7e14);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .score-poor {
            color: #dc3545;
            background: linear-gradient(45deg, #dc3545, #e83e8c);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .questions-review {
            animation: slideInRight 0.8s ease-out;
        }

        .review-header {
            background: white;
            border-radius: 25px;
            padding: 2rem;
            margin-bottom: 2rem;
            text-align: center;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
        }

        .review-header h3 {
            font-size: 2rem;
            font-weight: 800;
            color: #333;
            margin-bottom: 0.5rem;
        }

        .review-stats {
            display: flex;
            justify-content: center;
            gap: 2rem;
            color: #666;
            font-weight: 600;
        }

        .question-card {
            background: white;
            border-radius: 25px;
            margin-bottom: 2rem;
            overflow: hidden;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease;
            border: 3px solid transparent;
        }

        .question-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.15);
        }

        .question-card.correct {
            border-color: #28a745;
        }

        .question-card.incorrect {
            border-color: #dc3545;
        }

        .question-header {
            padding: 1.5rem 2rem;
            color: white;
            font-weight: 700;
            font-size: 1.1rem;
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .question-header.correct {
            background: linear-gradient(45deg, #28a745, #20c997);
        }

        .question-header.incorrect {
            background: linear-gradient(45deg, #dc3545, #e83e8c);
        }

        .question-number {
            background: rgba(255, 255, 255, 0.2);
            border-radius: 50%;
            width: 40px;
            height: 40px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 900;
        }

        .question-body {
            padding: 2rem;
        }

        .question-text {
            font-size: 1.2rem;
            font-weight: 700;
            color: #333;
            margin-bottom: 1.5rem;
            line-height: 1.4;
        }

        .options-grid {
            display: grid;
            gap: 1rem;
            margin-bottom: 1.5rem;
        }

        .option {
            padding: 1rem 1.5rem;
            border-radius: 15px;
            font-weight: 600;
            transition: all 0.3s ease;
            border: 2px solid #e9ecef;
            background: #f8f9fa;
            color: #333;
            position: relative;
            overflow: hidden;
        }

        .option.selected {
            border-color: #007bff;
            background: #e3f2fd;
        }

        .option.correct {
            border-color: #28a745;
            background: linear-gradient(45deg, #d4edda, #c3e6cb);
            color: #155724;
        }

        .option.incorrect-selected {
            border-color: #dc3545;
            background: linear-gradient(45deg, #f8d7da, #f5c6cb);
            color: #721c24;
        }

        .option::before {
            content: "";
            position: absolute;
            left: 0;
            top: 0;
            height: 100%;
            width: 4px;
            background: transparent;
            transition: background 0.3s ease;
        }

        .option.correct::before {
            background: #28a745;
        }

        .option.incorrect-selected::before {
            background: #dc3545;
        }

        .option-label {
            font-weight: 900;
            margin-right: 0.5rem;
        }

        .answer-indicator {
            font-size: 0.9rem;
            font-weight: 700;
            margin-left: auto;
            padding: 0.3rem 0.8rem;
            border-radius: 15px;
            background: rgba(255, 255, 255, 0.8);
        }

        .explanation {
            background: linear-gradient(45deg, #f8f9fa, #e9ecef);
            border-left: 5px solid #4ECDC4;
            padding: 1.5rem;
            border-radius: 15px;
            margin-top: 1.5rem;
        }

        .explanation-title {
            font-weight: 800;
            color: #333;
            margin-bottom: 0.5rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .explanation-text {
            color: #555;
            line-height: 1.6;
        }

        .action-buttons {
            background: white;
            border-radius: 25px;
            padding: 2rem;
            text-align: center;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            margin-top: 3rem;
        }

        .btn-fun {
            padding: 1rem 2rem;
            border-radius: 25px;
            font-weight: 700;
            font-size: 1.1rem;
            cursor: pointer;
            transition: all 0.3s ease;
            border: none;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            margin: 0.5rem;
        }

        .btn-primary-fun {
            background: linear-gradient(45deg, #FF6B6B, #FFE066);
            color: #333;
            box-shadow: 0 8px 25px rgba(255, 107, 107, 0.3);
        }

        .btn-primary-fun:hover {
            transform: translateY(-3px) scale(1.05);
            box-shadow: 0 15px 40px rgba(255, 107, 107, 0.5);
            background: linear-gradient(45deg, #FFE066, #FF6B6B);
            color: #333;
            text-decoration: none;
        }

        .btn-secondary-fun {
            background: linear-gradient(45deg, #4ECDC4, #45B7D1);
            color: white;
            box-shadow: 0 8px 25px rgba(78, 205, 196, 0.3);
        }

        .btn-secondary-fun:hover {
            transform: translateY(-3px) scale(1.05);
            box-shadow: 0 15px 40px rgba(78, 205, 196, 0.5);
            background: linear-gradient(45deg, #45B7D1, #4ECDC4);
            color: white;
            text-decoration: none;
        }

        .btn-outline-fun {
            background: white;
            border: 3px solid #96CEB4;
            color: #96CEB4;
        }

        .btn-outline-fun:hover {
            background: #96CEB4;
            color: white;
            transform: translateY(-3px) scale(1.05);
            box-shadow: 0 10px 30px rgba(150, 206, 180, 0.4);
            text-decoration: none;
        }

        @keyframes slideInDown {
            from { opacity: 0; transform: translateY(-50px); }
            to { opacity: 1; transform: translateY(0); }
        }

        @keyframes slideInLeft {
            from { opacity: 0; transform: translateX(-50px); }
            to { opacity: 1; transform: translateX(0); }
        }

        @keyframes slideInRight {
            from { opacity: 0; transform: translateX(50px); }
            to { opacity: 1; transform: translateX(0); }
        }

        @keyframes slideInUp {
            from { opacity: 0; transform: translateY(50px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .celebration-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            pointer-events: none;
            z-index: 1000;
        }

        .confetti {
            position: absolute;
            font-size: 2rem;
            animation: confetti-fall 3s linear;
        }

        @keyframes confetti-fall {
            0% {
                transform: translateY(-100vh) rotate(0deg);
                opacity: 1;
            }
            100% {
                transform: translateY(100vh) rotate(360deg);
                opacity: 0;
            }
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .container {
                padding: 0 1rem;
            }
            
            .results-summary {
                grid-template-columns: 1fr;
                gap: 1rem;
            }
            
            .result-card {
                padding: 2rem 1.5rem;
            }
            
            .question-body {
                padding: 1.5rem;
            }
            
            .btn-fun {
                width: 100%;
                justify-content: center;
                margin: 0.5rem 0;
            }
        }
    </style>
</head>
<body>
    <!-- Floating Decorations -->
    <div class="decoration star" style="top: 10%; left: 10%;">⭐</div>
    <div class="decoration celebration" style="top: 20%; right: 15%;">🎉</div>
    <div class="decoration trophy" style="top: 50%; left: 5%;">🏆</div>
    <div class="decoration star" style="bottom: 30%; right: 10%;">✨</div>
    <div class="decoration celebration" style="bottom: 50%; left: 12%;">🎊</div>
    <div class="decoration trophy" style="top: 70%; right: 8%;">🥇</div>

    <div class="container">
        <!-- Results Header -->
        <div class="results-header">
            <h1 class="results-title">🎯 Quiz Results!</h1>
            <p style="font-size: 1.2rem; color: #666; font-weight: 600;">Let's see how you did! 🤔</p>
        </div>

        <!-- Quiz Info -->
        <div class="quiz-info">
            <h2>📚 ${quiz.title}</h2>
            <p>${quiz.description}</p>
        </div>

        <!-- Results Summary -->
        <div class="results-summary">
            <div class="result-card score">
                <span class="result-icon">🎯</span>
                <div class="result-title">Your Score</div>
                <div class="result-value ${score.percentage >= 70 ? 'score-excellent' : score.percentage >= 50 ? 'score-good' : 'score-poor'}">
                    ${score.score}/${score.totalQuestions}
                </div>
                <div class="result-subtitle">${score.percentage}% Accuracy</div>
            </div>

            <div class="result-card time">
                <span class="result-icon">⏱️</span>
                <div class="result-title">Time Taken</div>
                <div class="result-value" style="color: #4ECDC4;">
                    <fmt:formatNumber value="${score.completionTime / 60}" pattern="#" />:<fmt:formatNumber value="${score.completionTime % 60}" pattern="00" />
                </div>
                <div class="result-subtitle">Minutes</div>
            </div>

            <div class="result-card status">
                <span class="result-icon">${score.percentage >= 70 ? '🏆' : '💪'}</span>
                <div class="result-title">Result</div>
                <div class="result-value ${score.percentage >= 70 ? 'score-excellent' : 'score-poor'}">
                    ${score.percentage >= 70 ? 'PASSED!' : 'KEEP TRYING!'}
                </div>
                <div class="result-subtitle">Pass mark: 70%</div>
            </div>
        </div>

        <!-- Questions Review -->
        <div class="questions-review">
            <div class="review-header">
                <h3>🔍 Question Review</h3>
                <div class="review-stats">
                    <span>📊 ${score.score} Correct</span>
                    <span>❌ ${score.totalQuestions - score.score} Incorrect</span>
                </div>
            </div>

            <c:forEach items="${reviewQuestions}" var="question" varStatus="status">
                <div class="question-card ${question.correct ? 'correct' : 'incorrect'}">
                    <div class="question-header ${question.correct ? 'correct' : 'incorrect'}">
                        <div class="question-number">${status.index + 1}</div>
                        <span>${question.correct ? '✅ Correct Answer!' : '❌ Incorrect Answer'}</span>
                    </div>
                    
                    <div class="question-body">
                        <div class="question-text">❓ ${question.questionText}</div>
                        
                        <div class="options-grid">
                            <div class="option ${question.correctAnswer eq 'A' ? 'correct' : ''} ${question.userAnswer eq 'A' and question.correctAnswer ne 'A' ? 'incorrect-selected' : ''} ${question.userAnswer eq 'A' ? 'selected' : ''}">
                                <span class="option-label">A.</span>
                                ${question.optionA}
                                <c:if test="${question.correctAnswer eq 'A'}">
                                    <span class="answer-indicator">✅ Correct</span>
                                </c:if>
                                <c:if test="${question.userAnswer eq 'A' and question.correctAnswer ne 'A'}">
                                    <span class="answer-indicator">❌ Your Choice</span>
                                </c:if>
                            </div>
                            
                            <div class="option ${question.correctAnswer eq 'B' ? 'correct' : ''} ${question.userAnswer eq 'B' and question.correctAnswer ne 'B' ? 'incorrect-selected' : ''} ${question.userAnswer eq 'B' ? 'selected' : ''}">
                                <span class="option-label">B.</span>
                                ${question.optionB}
                                <c:if test="${question.correctAnswer eq 'B'}">
                                    <span class="answer-indicator">✅ Correct</span>
                                </c:if>
                                <c:if test="${question.userAnswer eq 'B' and question.correctAnswer ne 'B'}">
                                    <span class="answer-indicator">❌ Your Choice</span>
                                </c:if>
                            </div>
                            
                            <div class="option ${question.correctAnswer eq 'C' ? 'correct' : ''} ${question.userAnswer eq 'C' and question.correctAnswer ne 'C' ? 'incorrect-selected' : ''} ${question.userAnswer eq 'C' ? 'selected' : ''}">
                                <span class="option-label">C.</span>
                                ${question.optionC}
                                <c:if test="${question.correctAnswer eq 'C'}">
                                    <span class="answer-indicator">✅ Correct</span>
                                </c:if>
                                <c:if test="${question.userAnswer eq 'C' and question.correctAnswer ne 'C'}">
                                    <span class="answer-indicator">❌ Your Choice</span>
                                </c:if>
                            </div>
                            
                            <div class="option ${question.correctAnswer eq 'D' ? 'correct' : ''} ${question.userAnswer eq 'D' and question.correctAnswer ne 'D' ? 'incorrect-selected' : ''} ${question.userAnswer eq 'D' ? 'selected' : ''}">
                                <span class="option-label">D.</span>
                                ${question.optionD}
                                <c:if test="${question.correctAnswer eq 'D'}">
                                    <span class="answer-indicator">✅ Correct</span>
                                </c:if>
                                <c:if test="${question.userAnswer eq 'D' and question.correctAnswer ne 'D'}">
                                    <span class="answer-indicator">❌ Your Choice</span>
                                </c:if>
                            </div>
                        </div>
                        
                        <c:if test="${not empty question.explanation}">
                            <div class="explanation">
                                <div class="explanation-title">
                                    💡 <strong>Explanation:</strong>
                                </div>
                                <div class="explanation-text">${question.explanation}</div>
                            </div>
                        </c:if>
                    </div>
                </div>
            </c:forEach>
        </div>

        <!-- Action Buttons -->
        <div class="action-buttons">
            <h3 style="margin-bottom: 1.5rem; color: #333; font-weight: 800;">🚀 What's Next?</h3>
            <a href="${pageContext.request.contextPath}/quizzes" class="btn-fun btn-primary-fun">
                🎮 Browse More Quizzes
            </a>
            <a href="${pageContext.request.contextPath}/quiz/${quiz.id}" class="btn-fun btn-secondary-fun">
                📋 Quiz Details
            </a>
            <a href="${pageContext.request.contextPath}/history" class="btn-fun btn-outline-fun">
                📊 View History
            </a>
        </div>
    </div>

    <!-- Celebration Overlay for High Scores -->
    <div class="celebration-overlay" id="celebrationOverlay"></div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const percentage = ${score.percentage};
            
            // Add celebration effect for good scores
            if (percentage >= 70) {
                createCelebration();
            }
            
            // Animate result cards
            const resultCards = document.querySelectorAll('.result-card');
            resultCards.forEach((card, index) => {
                setTimeout(() => {
                    card.style.opacity = '1';
                    card.style.transform = 'translateY(0)';
                }, index * 200);
            });

            // Animate question cards
            const questionCards = document.querySelectorAll('.question-card');
            questionCards.forEach((card, index) => {
                setTimeout(() => {
                    card.style.opacity = '1';
                    card.style.transform = 'translateY(0)';
                }, 1000 + index * 100);
            });

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
        });

        function createCelebration() {
            const overlay = document.getElementById('celebrationOverlay');
            const emojis = ['🎉', '🎊', '🏆', '⭐', '🌟', '💫', '✨', '🎯', '🏅', '🥇'];
            
            for (let i = 0; i < 20; i++) {
                setTimeout(() => {
                    const confetti = document.createElement('div');
                    confetti.className = 'confetti';
                    confetti.textContent = emojis[Math.floor(Math.random() * emojis.length)];
                    confetti.style.left = Math.random() * 100 + '%';
                    confetti.style.animationDelay = Math.random() * 3 + 's';
                    confetti.style.animationDuration = (Math.random() * 3 + 2) + 's';
                    
                    overlay.appendChild(confetti);
                    
                    setTimeout(() => {
                        confetti.remove();
                    }, 5000);
                }, i * 100);
            }
        }
    </script>
</body>
</html>