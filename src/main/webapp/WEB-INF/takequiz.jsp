<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
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
            overflow-x: hidden;
        }

        @keyframes gradientShift {
            0% { background-position: 0% 50%; }
            50% { background-position: 100% 50%; }
            100% { background-position: 0% 50%; }
        }
        
        /* Update existing question nav button styles */
.question-nav-btn.btn-outline-primary {
    border-color: #e9ecef;
    background: white;
    color: #666;
}

.question-nav-btn.btn-success {
    border-color: #4ECDC4;
    background: #4ECDC4;
    color: white;
}

.question-nav-btn.active {
    border-color: #FF6B6B;
    background: #FF6B6B;
    color: white;
    transform: scale(1.1);
}

/* Timer progress bar colors */
.bg-success { background-color: #4ECDC4 !important; }
.bg-warning { background-color: #FFE066 !important; }
.bg-danger { background-color: #FF6B6B !important; }

/* Timer progress container */
.timer-progress-container {
    width: 100%;
    max-width: 300px;
    margin: 0 auto;
}

        /* Floating Decorative Elements */
        .decoration {
            position: fixed;
            pointer-events: none;
            z-index: 1;
        }

        .star {
            color: #FFE066;
            font-size: 1.5rem;
            animation: twinkle 3s ease-in-out infinite;
        }

        .heart {
            color: #FF6B6B;
            font-size: 1.2rem;
            animation: bounce 4s ease-in-out infinite;
        }

        .lightning {
            color: #45B7D1;
            font-size: 1.3rem;
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
        .quiz-header {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
            padding: 2rem;
            margin: 2rem;
            border-radius: 30px;
            text-align: center;
            position: relative;
            overflow: hidden;
        }

        .quiz-header::before {
            content: "";
            position: absolute;
            top: -50%;
            left: -50%;
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

        .quiz-header h1 {
            font-size: clamp(2rem, 5vw, 3rem);
            font-weight: 900;
            background: linear-gradient(45deg, #FF6B6B, #4ECDC4, #45B7D1);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin-bottom: 1rem;
            position: relative;
            z-index: 2;
        }

        .quiz-header p {
            font-size: 1.2rem;
            color: #666;
            margin-bottom: 1.5rem;
            position: relative;
            z-index: 2;
        }

        .quiz-meta {
            display: flex;
            justify-content: center;
            gap: 1rem;
            margin-bottom: 1.5rem;
            flex-wrap: wrap;
            position: relative;
            z-index: 2;
        }

        .badge-fun {
            padding: 0.8rem 1.5rem;
            font-size: 1rem;
            font-weight: 700;
            border-radius: 25px;
            color: white;
            display: inline-flex;
            align-items: center;
        }

        .badge-easy { background: linear-gradient(45deg, #96CEB4, #4ECDC4); }
        .badge-medium { background: linear-gradient(45deg, #FFE066, #FF6B6B); }
        .badge-hard { background: linear-gradient(45deg, #FF6B6B, #45B7D1); }
        .badge-category { background: linear-gradient(45deg, #45B7D1, #4ECDC4); }

        /* Timer Section */
        .timer-container {
            background: white;
            padding: 1.5rem;
            border-radius: 25px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 1rem;
            margin: 0 auto;
            max-width: 400px;
            position: relative;
            z-index: 2;
        }

        .timer-display {
            font-size: 2rem;
            font-weight: 900;
            color: #FF6B6B;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .progress-circle {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            background: conic-gradient(#4ECDC4 0deg, #e9ecef 0deg);
            display: flex;
            align-items: center;
            justify-content: center;
            position: relative;
            transition: all 0.3s ease;
        }

        .progress-circle::before {
            content: "";
            width: 45px;
            height: 45px;
            background: white;
            border-radius: 50%;
            position: absolute;
        }

        .progress-circle span {
            position: relative;
            z-index: 1;
            font-size: 1.2rem;
        }

        /* Question Cards */
        .questions-container {
            max-width: 900px;
            margin: 2rem auto;
            padding: 0 2rem;
        }

        .question-card {
            background: white;
            border-radius: 30px;
            box-shadow: 0 15px 50px rgba(0, 0, 0, 0.1);
            margin-bottom: 2rem;
            overflow: hidden;
            position: relative;
            transform: scale(0.95);
            opacity: 0.7;
            transition: all 0.5s ease;
            display: none;
        }

        .question-card.active {
            transform: scale(1);
            opacity: 1;
            display: block;
            animation: slideIn 0.5s ease-out;
        }

        @keyframes slideIn {
            from { opacity: 0; transform: translateY(20px) scale(0.95); }
            to { opacity: 1; transform: translateY(0) scale(1); }
        }

        .question-header {
            background: linear-gradient(45deg, #4ECDC4, #45B7D1);
            color: white;
            padding: 1.5rem 2rem;
            font-size: 1.3rem;
            font-weight: 700;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .question-number {
            background: rgba(255, 255, 255, 0.2);
            padding: 0.5rem 1rem;
            border-radius: 20px;
            font-size: 0.9rem;
        }

        .question-body {
            padding: 2.5rem;
        }

        .question-text {
            font-size: 1.4rem;
            font-weight: 700;
            color: #333;
            margin-bottom: 2rem;
            line-height: 1.4;
        }

        .options {
            display: grid;
            gap: 1rem;
        }

        .option {
            background: #f8f9fa;
            border: 3px solid transparent;
            border-radius: 20px;
            padding: 1.5rem;
            cursor: pointer;
            transition: all 0.3s ease;
            position: relative;
            display: flex;
            align-items: center;
            gap: 1rem;
            font-size: 1.1rem;
            font-weight: 600;
        }

        .option:hover {
            border-color: #FFE066;
            background: linear-gradient(45deg, #FFE066, rgba(255, 224, 102, 0.1));
            transform: translateX(10px) scale(1.02);
            box-shadow: 0 8px 25px rgba(255, 224, 102, 0.3);
        }

        .option.selected {
            border-color: #4ECDC4;
            background: linear-gradient(45deg, #4ECDC4, rgba(78, 205, 196, 0.1));
            color: #333;
            transform: translateX(10px) scale(1.02);
            box-shadow: 0 10px 30px rgba(78, 205, 196, 0.4);
        }

        .option-radio {
            appearance: none;
            width: 24px;
            height: 24px;
            border: 3px solid #ddd;
            border-radius: 50%;
            position: relative;
            transition: all 0.3s ease;
        }

        .option-radio:checked {
            border-color: #4ECDC4;
            background: #4ECDC4;
        }

        .option-radio:checked::after {
            content: "✓";
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            color: white;
            font-size: 14px;
            font-weight: bold;
        }

        .option-letter {
            width: 40px;
            height: 40px;
            background: linear-gradient(45deg, #45B7D1, #4ECDC4);
            color: white;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 900;
            font-size: 1.2rem;
        }

        /* Navigation Buttons */
        .question-footer {
            padding: 2rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            background: #f8f9fa;
        }

        .btn-fun {
            padding: 1rem 2rem;
            border-radius: 25px;
            font-weight: 700;
            font-size: 1.1rem;
            border: none;
            cursor: pointer;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            text-decoration: none;
        }

        .btn-secondary-fun {
            background: #6c757d;
            color: white;
        }

        .btn-secondary-fun:hover:not(:disabled) {
            background: #5a6268;
            transform: translateY(-2px) scale(1.05);
            box-shadow: 0 8px 25px rgba(108, 117, 125, 0.3);
        }

        .btn-primary-fun {
            background: linear-gradient(45deg, #4ECDC4, #45B7D1);
            color: white;
        }

        .btn-primary-fun:hover {
            background: linear-gradient(45deg, #45B7D1, #4ECDC4);
            transform: translateY(-2px) scale(1.05);
            box-shadow: 0 10px 30px rgba(78, 205, 196, 0.4);
        }

        .btn-success-fun {
            background: linear-gradient(45deg, #96CEB4, #4ECDC4);
            color: white;
        }

        .btn-success-fun:hover {
            background: linear-gradient(45deg, #4ECDC4, #96CEB4);
            transform: translateY(-2px) scale(1.05);
            box-shadow: 0 10px 30px rgba(150, 206, 180, 0.4);
        }

        .btn-fun:disabled {
            opacity: 0.5;
            cursor: not-allowed;
            transform: none !important;
        }

        /* Question Navigation */
        .question-nav {
            background: white;
            padding: 2rem;
            margin: 2rem;
            border-radius: 30px;
            box-shadow: 0 15px 50px rgba(0, 0, 0, 0.1);
        }

        .question-nav h6 {
            color: #333;
            font-weight: 700;
            margin-bottom: 1.5rem;
            font-size: 1.2rem;
            text-align: center;
        }

        .nav-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(60px, 1fr));
            gap: 1rem;
            max-width: 600px;
            margin: 0 auto;
        }

        .question-nav-btn {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            border: 3px solid #e9ecef;
            background: white;
            color: #666;
            font-weight: 700;
            font-size: 1.1rem;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .question-nav-btn:hover {
            border-color: #FFE066;
            background: #FFE066;
            color: #333;
            transform: scale(1.1);
        }

        .question-nav-btn.answered {
            border-color: #4ECDC4;
            background: #4ECDC4;
            color: white;
        }

        .question-nav-btn.current {
            border-color: #FF6B6B;
            background: #FF6B6B;
            color: white;
            transform: scale(1.1);
            box-shadow: 0 8px 25px rgba(255, 107, 107, 0.3);
        }

        /* Progress Indicator */
        .progress-container {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 4px;
            background: rgba(255, 255, 255, 0.3);
            z-index: 1000;
        }

        .progress-bar {
            height: 100%;
            background: linear-gradient(45deg, #4ECDC4, #45B7D1);
            transition: width 0.5s ease;
            width: 0%;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .quiz-header {
                margin: 1rem;
                padding: 1.5rem;
            }
            
            .questions-container {
                padding: 0 1rem;
            }
            
            .question-body {
                padding: 1.5rem;
            }
            
            .question-footer {
                padding: 1.5rem;
                flex-direction: column;
                gap: 1rem;
            }
            
            .quiz-meta {
                flex-direction: column;
                align-items: center;
            }
            
            .timer-container {
                flex-direction: column;
                gap: 1rem;
            }
            
            .nav-grid {
                grid-template-columns: repeat(auto-fit, minmax(50px, 1fr));
            }
            
            .question-nav-btn {
                width: 50px;
                height: 50px;
            }
        }

        /* Celebration Effects */
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
                transform: translate(var(--random-x, 0), var(--random-y, -100px)) scale(0.5) rotate(360deg); 
            }
        }

        /* Warning Animation */
        .timer-warning {
            animation: pulse 1s ease-in-out infinite;
        }

        @keyframes pulse {
            0%, 100% { transform: scale(1); }
            50% { transform: scale(1.05); }
        }

        .timer-danger {
            animation: shake 0.5s ease-in-out infinite;
        }

        @keyframes shake {
            0%, 100% { transform: translateX(0); }
            25% { transform: translateX(-5px); }
            75% { transform: translateX(5px); }
        }
    </style>
</head>
<body>
    <!-- Floating Decorations -->
    <div class="decoration star" style="top: 10%; left: 5%;">⭐</div>
    <div class="decoration heart" style="top: 20%; right: 10%;">❤️</div>
    <div class="decoration lightning" style="top: 70%; left: 3%;">⚡</div>
    <div class="decoration star" style="bottom: 15%; right: 5%;">✨</div>
    <div class="decoration heart" style="bottom: 30%; left: 8%;">💛</div>
    <div class="decoration lightning" style="top: 50%; right: 4%;">🚀</div>

    <!-- Progress Bar -->
    <div class="progress-container">
        <div class="progress-bar" id="overallProgress"></div>
    </div>

    <!-- Quiz Header -->
    <div class="quiz-header">
        <h1>🎯 ${quiz.title}</h1>
        <p>${quiz.description}</p>
        
        <div class="quiz-meta">
            <span class="badge-fun ${quiz.difficulty eq 'Easy' ? 'badge-easy' : quiz.difficulty eq 'Medium' ? 'badge-medium' : 'badge-hard'}">
                ${quiz.difficulty eq 'Easy' ? '😊' : quiz.difficulty eq 'Medium' ? '🤔' : '🔥'} ${quiz.difficulty}
            </span>
            <span class="badge-fun badge-category">📚 ${quiz.category.name}</span>
        </div>
        
<div class="timer-container">
    <div class="progress-circle" id="timerCircle">
        <span>⏰</span>
    </div>
    
    <div class="timer-display">
        <span id="timer">
            <c:set var="minutes" value="${quiz.timeLimit}" />
            <c:set var="formattedMinutes" value="${minutes < 10 ? '0' : ''}${minutes}" />
            ${formattedMinutes}:00
        </span>
    </div>
    <!-- Add hidden element for time limit data -->
    <div id="timeLimit" data-minutes="${quiz.timeLimit}" style="display: none;"></div>
</div>

    <!-- Quiz Form -->
    <form id="quizForm" action="${pageContext.request.contextPath}/submit-quiz" method="post">
        <input type="hidden" name="quizId" value="${quiz.id}">
        <input type="hidden" id="completionTime" name="completionTime" value="0">
        
        <div class="questions-container">
            <c:forEach items="${questions}" var="question" varStatus="status">
                <div class="question-card ${status.index == 0 ? 'active' : ''}" id="question-${status.index}">
                    <div class="question-header">
                        <span>🤔 Question Time!</span>
                        <span class="question-number">${status.index + 1} of ${questions.size()}</span>
                    </div>
                    
                    <div class="question-body">
                        <div class="question-text">${question.questionText}</div>
                        <input type="hidden" name="question_${question.id}" value="${question.id}">
                        
                        <div class="options">
                            <label class="option" for="option-${question.id}-A">
                                <input class="option-radio" type="radio" 
                                       name="answer_${question.id}" 
                                       id="option-${question.id}-A" 
                                       value="A" required>
                                <div class="option-letter">A</div>
                                <span>${question.optionA}</span>
                            </label>
                            
                            <label class="option" for="option-${question.id}-B">
                                <input class="option-radio" type="radio" 
                                       name="answer_${question.id}" 
                                       id="option-${question.id}-B" 
                                       value="B">
                                <div class="option-letter">B</div>
                                <span>${question.optionB}</span>
                            </label>
                            
                            <label class="option" for="option-${question.id}-C">
                                <input class="option-radio" type="radio" 
                                       name="answer_${question.id}" 
                                       id="option-${question.id}-C" 
                                       value="C">
                                <div class="option-letter">C</div>
                                <span>${question.optionC}</span>
                            </label>
                            
                            <label class="option" for="option-${question.id}-D">
                                <input class="option-radio" type="radio" 
                                       name="answer_${question.id}" 
                                       id="option-${question.id}-D" 
                                       value="D">
                                <div class="option-letter">D</div>
                                <span>${question.optionD}</span>
                            </label>
                        </div>
                    </div>
                    
<div class="question-footer">
    <button type="button" class="btn-fun btn-secondary-fun prev-btn" 
            ${status.index == 0 ? 'disabled' : ''}>
        ⬅️ Previous
    </button>
    
    <c:choose>
        <c:when test="${status.index == questions.size() - 1}">
            <button type="button" class="btn-fun btn-success-fun submit-btn">
                🎉 Submit Quiz
            </button>
        </c:when>
        <c:otherwise>
            <button type="button" class="btn-fun btn-primary-fun next-btn">
                Next ➡️
            </button>
        </c:otherwise>
    </c:choose>
</div>
                </div>
            </c:forEach>
        </div>
    </form>

    <!-- Question Navigation -->
    <div class="question-nav">
        <h6>🗺️ Question Navigator</h6>
      <div class="nav-grid">
    <c:forEach begin="0" end="${questions.size() - 1}" var="i">
        <button type="button" class="question-nav-btn btn-outline-primary" data-index="${i}">
            ${i + 1}
        </button>
    </c:forEach>
</div>

    </div>
<script src="${pageContext.request.contextPath}/resources/js/quiz.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            let currentQuestion = 0;
            const totalQuestions = ${questions.size()};
            const timeLimit = ${quiz.timeLimit} * 60; // Convert to seconds
            let timeRemaining = timeLimit;
            let timerInterval;
            const startTime = new Date().getTime();
            
            // Initialize timer
            function startTimer() {
                timerInterval = setInterval(() => {
                    timeRemaining--;
                    updateTimerDisplay();
                    updateTimerCircle();
                    
                    // Warning states
                    const timerDisplay = document.getElementById('timer');
                    if (timeRemaining <= 60) { // Last minute
                        timerDisplay.classList.add('timer-danger');
                    } else if (timeRemaining <= 300) { // Last 5 minutes
                        timerDisplay.classList.add('timer-warning');
                    }
                    
                    if (timeRemaining <= 0) {
                        clearInterval(timerInterval);
                        submitQuiz();
                    }
                }, 1000);
            }
            
            function updateTimerDisplay() {
                const minutes = Math.floor(timeRemaining / 60);
                const seconds = timeRemaining % 60;
                const formattedTime = `${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}`;
                document.getElementById('timeDisplay').textContent = formattedTime;
            }
            
            function updateTimerCircle() {
                const percentage = (timeRemaining / timeLimit) * 100;
                const circle = document.getElementById('timerCircle');
                const color = percentage > 50 ? '#4ECDC4' : percentage > 20 ? '#FFE066' : '#FF6B6B';
                circle.style.background = `conic-gradient(${color} ${percentage * 3.6}deg, #e9ecef 0deg)`;
            }
            
            function updateProgress() {
                const progress = ((currentQuestion + 1) / totalQuestions) * 100;
                document.getElementById('overallProgress').style.width = progress + '%';
            }
            
            function showQuestion(index) {
                // Hide all questions
                document.querySelectorAll('.question-card').forEach(card => {
                    card.classList.remove('active');
                });
                
                // Show current question
                document.getElementById(`question-${index}`).classList.add('active');
                
                // Update navigation buttons
                updateNavButtons();
                updateQuestionNavigation();
                updateProgress();
            }
            
            function updateNavButtons() {
                document.querySelectorAll('.prev-btn').forEach(btn => {
                    btn.disabled = currentQuestion === 0;
                });
            }
            
            function updateQuestionNavigation() {
                document.querySelectorAll('.question-nav-btn').forEach((btn, index) => {
                    btn.classList.remove('current', 'answered');
                    
                    if (index === currentQuestion) {
                        btn.classList.add('current');
                    }
                    
                    // Check if question is answered
                    const questionCard = document.getElementById(`question-${index}`);
                    const radios = questionCard.querySelectorAll('input[type="radio"]');
                    const isAnswered = Array.from(radios).some(radio => radio.checked);
                    
                    if (isAnswered) {
                        btn.classList.add('answered');
                    }
                });
            }
            
            // Navigation event listeners
            document.addEventListener('click', function(e) {
                if (e.target.classList.contains('next-btn')) {
                    if (currentQuestion < totalQuestions - 1) {
                        currentQuestion++;
                        showQuestion(currentQuestion);
                        createCelebration(e.target, ['🎉', '⭐', '🚀']);
                    }
                } else if (e.target.classList.contains('prev-btn')) {
                    if (currentQuestion > 0) {
                        currentQuestion--;
                        showQuestion(currentQuestion);
                    }
                } else if (e.target.classList.contains('question-nav-btn')) {
                    currentQuestion = parseInt(e.target.dataset.index);
                    showQuestion(currentQuestion);
                } else if (e.target.classList.contains('submit-btn')) {
                    if (confirm('🎯 Ready to submit your quiz? Make sure you\'ve answered all questions!')) {
                        submitQuiz();
                    }
                }
            });
            
            // Option selection effects
            document.addEventListener('change', function(e) {
                if (e.target.type === 'radio') {
                    // Remove selected class from all options in this question
                    const questionCard = e.target.closest('.question-card');
                    questionCard.querySelectorAll('.option').forEach(opt => {
                        opt.classList.remove('selected');
                    });
                    
                    // Add selected class to chosen option
                    e.target.closest('.option').classList.add('selected');
                    
                    // Create celebration effect
                    createCelebration(e.target.closest('.option'), ['✨', '💫', '⭐']);
                    
                    // Update navigation
                    updateQuestionNavigation();
                }
            });
            
            function createCelebration(element, emojis) {
                const rect = element.getBoundingClientRect();
                const centerX = rect.left + rect.width / 2;
                const centerY = rect.top + rect.height / 2;
                
                for (let i = 0; i < 3; i++) {
                    setTimeout(() => {
                        const celebration = document.createElement('div');
                        celebration.className = 'celebration';
                        celebration.textContent = emojis[Math.floor(Math.random() * emojis.length)];
                        celebration.style.left = centerX + 'px';
                        celebration.style.top = centerY + 'px';
                        celebration.style.setProperty('--random-x', (Math.random() - 0.5) * 200 + 'px');
                        celebration.style.setProperty('--random-y', -(Math.random() * 100 + 50) + 'px');
                        
                        document.body.appendChild(celebration);
                        
                        setTimeout(() => celebration.remove(), 2000);
                    }, i * 100);
                }
            }
            
            function submitQuiz() {
                const completionTime = Math.floor((new Date().getTime() - startTime) / 1000);
                document.getElementById('completionTime').value = completionTime;
                clearInterval(timerInterval);
                
                // Show submission celebration
                createMajorCelebration();
                
                // Submit the form
                document.getElementById('quizForm').submit();
            }
            
            function createMajorCelebration() {
                const celebrationEmojis = ['🎉', '🎊', '⭐', '🌟', '✨', '🎯', '🏆', '👏', '🚀', '💫'];
                
                for (let i = 0; i < 20; i++) {
                    setTimeout(() => {
                        const celebration = document.createElement('div');
                        celebration.className = 'celebration';
                        celebration.textContent = celebrationEmojis[Math.floor(Math.random() * celebrationEmojis.length)];
                        celebration.style.left = Math.random() * window.innerWidth + 'px';
                        celebration.style.top = Math.random() * window.innerHeight + 'px';
                        celebration.style.setProperty('--random-x', (Math.random() - 0.5) * 300 + 'px');
                        celebration.style.setProperty('--random-y', -(Math.random() * 200 + 100) + 'px');
                        
                        document.body.appendChild(celebration);
                        
                        setTimeout(() => celebration.remove(), 2000);
                    }, i * 50);
                }
            }
            
            // Keyboard navigation
            document.addEventListener('keydown', function(e) {
                if (e.key === 'ArrowRight' && currentQuestion < totalQuestions - 1) {
                    currentQuestion++;
                    showQuestion(currentQuestion);
                } else if (e.key === 'ArrowLeft' && currentQuestion > 0) {
                    currentQuestion--;
                    showQuestion(currentQuestion);
                } else if (e.key >= '1' && e.key <= '4') {
                    // Select option A-D with keys 1-4
                    const questionCard = document.getElementById(`question-${currentQuestion}`);
                    const options = ['A', 'B', 'C', 'D'];
                    const optionIndex = parseInt(e.key) - 1;
                    if (optionIndex < options.length) {
                        const radio = questionCard.querySelector(`input[value="${options[optionIndex]}"]`);
                        if (radio) {
                            radio.checked = true;
                            radio.dispatchEvent(new Event('change', { bubbles: true }));
                        }
                    }
                }
            });
            
            // Prevent form submission on Enter key
            document.addEventListener('keydown', function(e) {
                if (e.key === 'Enter' && e.target.type !== 'submit') {
                    e.preventDefault();
                }
            });
            
            // Auto-save functionality (in memory)
            const autoSaveKey = 'quiz_' + ${quiz.id} + '_answers';
            
            function saveAnswers() {
                const answers = {};
                document.querySelectorAll('input[type="radio"]:checked').forEach(radio => {
                    answers[radio.name] = radio.value;
                });
                // Note: Since localStorage is not available, we'll just keep answers in memory
                window.quizAnswers = answers;
            }
            
            function loadAnswers() {
                if (window.quizAnswers) {
                    Object.keys(window.quizAnswers).forEach(name => {
                        const radio = document.querySelector(`input[name="${name}"][value="${window.quizAnswers[name]}"]`);
                        if (radio) {
                            radio.checked = true;
                            radio.closest('.option').classList.add('selected');
                        }
                    });
                    updateQuestionNavigation();
                }
            }
            
            // Save answers when they change
            document.addEventListener('change', function(e) {
                if (e.target.type === 'radio') {
                    saveAnswers();
                }
            });
            
            // Warning before page unload
            window.addEventListener('beforeunload', function(e) {
                if (timeRemaining > 0) {
                    e.preventDefault();
                    e.returnValue = '';
                    return '';
                }
            });
            
            // Initialize everything
            startTimer();
            updateProgress();
            updateQuestionNavigation();
            loadAnswers();
            
            // Add smooth scrolling to question navigation
            document.addEventListener('click', function(e) {
                if (e.target.classList.contains('question-nav-btn')) {
                    document.querySelector('.questions-container').scrollIntoView({
                        behavior: 'smooth',
                        block: 'start'
                    });
                }
            });
            
            // Add focus management for accessibility
            function focusCurrentQuestion() {
                const currentCard = document.getElementById(`question-${currentQuestion}`);
                const firstRadio = currentCard.querySelector('input[type="radio"]');
                if (firstRadio) {
                    firstRadio.focus();
                }
            }
            
            // Focus management on question change
            const originalShowQuestion = showQuestion;
            showQuestion = function(index) {
                originalShowQuestion(index);
                setTimeout(focusCurrentQuestion, 100);
            };
            
            // Add visual feedback for time warnings
            function checkTimeWarnings() {
                const timerContainer = document.querySelector('.timer-container');
                const timeDisplay = document.getElementById('timeDisplay');
                
                if (timeRemaining <= 60) {
                    timerContainer.style.animation = 'shake 0.5s ease-in-out infinite';
                    timeDisplay.style.color = '#FF6B6B';
                } else if (timeRemaining <= 300) {
                    timerContainer.style.animation = 'pulse 2s ease-in-out infinite';
                    timeDisplay.style.color = '#FFE066';
                } else {
                    timerContainer.style.animation = 'none';
                    timeDisplay.style.color = '#FF6B6B';
                }
            }
            
            // Update the timer interval to include warning checks
            const originalStartTimer = startTimer;
            startTimer = function() {
                timerInterval = setInterval(() => {
                    timeRemaining--;
                    updateTimerDisplay();
                    updateTimerCircle();
                    checkTimeWarnings();
                    
                    if (timeRemaining <= 0) {
                        clearInterval(timerInterval);
                        alert('⏰ Time\'s up! Your quiz will be submitted automatically.');
                        submitQuiz();
                    }
                }, 1000);
            };
            
            // Re-initialize with updated timer
            clearInterval(timerInterval);
            startTimer();
        });
        
        const quizForm = document.getElementById('quizForm');
        const questionCards = document.querySelectorAll('.question-card');
        const navButtons = document.querySelectorAll('.question-nav-btn');
        const prevButtons = document.querySelectorAll('.prev-btn');
        const nextButtons = document.querySelectorAll('.next-btn');
        const submitButtons = document.querySelectorAll('.submit-btn');
        const timeLimitElement = document.getElementById('timeLimit');
        const timerElement = document.getElementById('timer');
        const progressBar = document.getElementById('timer-progress');
        const completionTimeInput = document.getElementById('completionTime');

        // Get time limit from JSP data
        const timeLimitMinutes = ${quiz.timeLimit};
        const totalSeconds = timeLimitMinutes * 60;
        let remainingSeconds = totalSeconds;
        let startTime = new Date().getTime();
        let timerInterval;

        // Your existing JavaScript functions go here...
        // (Copy all the functions from your original JS file)

        // Initialize the quiz when page loads
        document.addEventListener('DOMContentLoaded', function() {
            initializeQuiz();
        });

        // Add compatibility for celebration effects
        function createCelebration(element, emojis) {
            // Your existing celebration code or simplified version
            console.log('Celebration triggered!');
        }
    </script>
</body>
</html>