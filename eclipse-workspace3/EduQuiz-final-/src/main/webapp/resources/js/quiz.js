/**
 * Quiz functionality for EduQuiz application
 * Fixed timer that counts DOWN from quiz time limit to 00:00
 */

document.addEventListener('DOMContentLoaded', function() {
    // Initialize variables
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
    
    // Get time limit from data attribute
    const timeLimitMinutes = parseInt(timeLimitElement.getAttribute('data-minutes')) || 30;
    const totalSeconds = timeLimitMinutes * 60;
    let remainingSeconds = totalSeconds;
    let startTime = new Date().getTime();
    let timerInterval;
    
    // Initialize the quiz
    initializeQuiz();
    
    /**
     * Initialize the quiz UI and timer
     */
    function initializeQuiz() {
        // Show first question
        showQuestion(0);
        
        // Setup navigation
        setupNavigation();
        
        // Start the countdown timer
        startCountdownTimer();
        
        // Setup form submission
        setupSubmission();
        
        // Track answers for navigation button updates
        trackAnswers();
        
        // Initial update of navigation buttons
        updateQuestionNavStatus();
    }
    
    /**
     * Start the countdown timer (counting DOWN from time limit to 00:00)
     */
    function startCountdownTimer() {
        // Update display initially
        updateTimerDisplay();
        
        // Start countdown interval
        timerInterval = setInterval(function() {
            remainingSeconds--;
            
            // Update timer display
            updateTimerDisplay();
            
            // Update completion time (time elapsed)
            const elapsedSeconds = totalSeconds - remainingSeconds;
            if (completionTimeInput) {
                completionTimeInput.value = elapsedSeconds;
            }
            
            // Check if time is up
            if (remainingSeconds <= 0) {
                clearInterval(timerInterval);
                alert('Time is up! Your quiz will be submitted automatically.');
                quizForm.submit();
            }
        }, 1000);
    }
    
    /**
     * Update timer display and progress bar
     */
    function updateTimerDisplay() {
        // Format remaining time as mm:ss
        const minutes = Math.floor(remainingSeconds / 60);
        const seconds = remainingSeconds % 60;
        
        if (timerElement) {
            timerElement.textContent = 
                `${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}`;
        }
        
        // Update progress bar
        if (progressBar && totalSeconds > 0) {
            const progressPercent = (remainingSeconds / totalSeconds) * 100;
            progressBar.style.width = progressPercent + '%';
            
            // Change progress bar color based on time remaining
            progressBar.classList.remove('bg-success', 'bg-warning', 'bg-danger');
            
            if (progressPercent <= 25) {
                progressBar.classList.add('bg-danger');
            } else if (progressPercent <= 50) {
                progressBar.classList.add('bg-warning');
            } else {
                progressBar.classList.add('bg-success');
            }
        }
    }
    
    /**
     * Setup navigation between questions
     */
    function setupNavigation() {
        // Question navigation buttons (numbered buttons)
        navButtons.forEach(btn => {
            btn.addEventListener('click', function(e) {
                e.preventDefault();
                const index = parseInt(this.getAttribute('data-index'));
                showQuestion(index);
            });
        });
        
        // Previous buttons
        prevButtons.forEach(btn => {
            btn.addEventListener('click', function(e) {
                e.preventDefault();
                const currentIndex = getCurrentQuestionIndex();
                if (currentIndex > 0) {
                    showQuestion(currentIndex - 1);
                }
            });
        });
        
        // Next buttons
        nextButtons.forEach(btn => {
            btn.addEventListener('click', function(e) {
                e.preventDefault();
                const currentIndex = getCurrentQuestionIndex();
                if (currentIndex < questionCards.length - 1) {
                    showQuestion(currentIndex + 1);
                }
            });
        });
    }
    
    /**
     * Setup quiz submission handling
     */
    function setupSubmission() {
        submitButtons.forEach(btn => {
            btn.addEventListener('click', function(e) {
                e.preventDefault(); // Prevent immediate submission
                
                // Check for unanswered questions
                const unansweredCount = countUnansweredQuestions();
                
                if (unansweredCount > 0) {
                    const confirmSubmit = confirm(
                        `You have ${unansweredCount} unanswered question(s). ` +
                        'Are you sure you want to submit the quiz?'
                    );
                    
                    if (!confirmSubmit) {
                        return; // Don't submit if user cancels
                    }
                }
                
                // Calculate and set completion time
                const elapsedSeconds = totalSeconds - remainingSeconds;
                if (completionTimeInput) {
                    completionTimeInput.value = elapsedSeconds;
                }
                
                // Clear timer and submit
                clearInterval(timerInterval);
                quizForm.submit();
            });
        });
    }
    
    /**
     * Track answer changes to update navigation buttons
     */
    function trackAnswers() {
        const radioInputs = document.querySelectorAll('input[type="radio"]');
        
        radioInputs.forEach(input => {
            input.addEventListener('change', function() {
                updateQuestionNavStatus();
            });
        });
    }
    
    /**
     * Count unanswered questions
     * @returns {number} Number of unanswered questions
     */
    function countUnansweredQuestions() {
        let unansweredCount = 0;
        
        questionCards.forEach(card => {
            const questionId = card.querySelector('input[type="hidden"]').value;
            const answered = document.querySelector(`input[name="answer_${questionId}"]:checked`);
            
            if (!answered) {
                unansweredCount++;
            }
        });
        
        return unansweredCount;
    }
    
    /**
     * Update question navigation buttons based on answer status
     */
    function updateQuestionNavStatus() {
        questionCards.forEach((card, index) => {
            const questionId = card.querySelector('input[type="hidden"]').value;
            const answered = document.querySelector(`input[name="answer_${questionId}"]:checked`);
            
            if (navButtons[index]) {
                navButtons[index].classList.remove('btn-success', 'btn-outline-primary');
                
                if (answered) {
                    navButtons[index].classList.add('btn-success');
                } else {
                    navButtons[index].classList.add('btn-outline-primary');
                }
            }
        });
    }
    
    /**
     * Show a specific question by index
     * @param {number} index The question index to show
     */
    function showQuestion(index) {
        // Validate index
        if (index < 0 || index >= questionCards.length) {
            return;
        }
        
        // Hide all question cards
        questionCards.forEach(card => {
            card.classList.remove('active');
        });
        
        // Show the selected question
        const targetCard = questionCards[index];
        if (targetCard) {
            targetCard.classList.add('active');
        }
        
        // Update navigation button active state
        navButtons.forEach((btn, i) => {
            btn.classList.remove('active');
            if (i === index) {
                btn.classList.add('active');
            }
        });
        
        // Update prev/next button states
        updateNavigationButtonStates(index);
        
        // Update navigation buttons status
        updateQuestionNavStatus();
    }
    
    /**
     * Update the state of prev/next buttons based on current question
     * @param {number} currentIndex The current question index
     */
    function updateNavigationButtonStates(currentIndex) {
        // Update previous buttons
        prevButtons.forEach(btn => {
            if (currentIndex <= 0) {
                btn.disabled = true;
                btn.classList.add('disabled');
            } else {
                btn.disabled = false;
                btn.classList.remove('disabled');
            }
        });
        
        // Update next buttons
        nextButtons.forEach(btn => {
            if (currentIndex >= questionCards.length - 1) {
                btn.style.display = 'none'; // Hide next button on last question
            } else {
                btn.style.display = 'inline-block';
            }
        });
        
        // Update submit buttons
        submitButtons.forEach(btn => {
            if (currentIndex >= questionCards.length - 1) {
                btn.style.display = 'inline-block'; // Show submit button on last question
            } else {
                btn.style.display = 'none';
            }
        });
    }
    
    /**
     * Get the index of the currently displayed question
     * @returns {number} The current question index
     */
    function getCurrentQuestionIndex() {
        let currentIndex = 0;
        questionCards.forEach((card, index) => {
            if (card.classList.contains('active')) {
                currentIndex = index;
            }
        });
        return currentIndex;
    }
    
    // Cleanup timer when page is unloaded
    window.addEventListener('beforeunload', function() {
        if (timerInterval) {
            clearInterval(timerInterval);
        }
    });
});