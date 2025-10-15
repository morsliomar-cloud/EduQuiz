<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Import Questions - EduQuiz Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .import-container {
            max-width: 800px;
            margin: 2rem auto;
        }
        .category-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 0.5rem;
            margin-top: 1rem;
        }
        .category-option {
            padding: 0.75rem;
            border: 1px solid #ddd;
            border-radius: 0.375rem;
            cursor: pointer;
            transition: all 0.2s;
            text-align: center;
        }
        .category-option:hover {
            background-color: #f8f9fa;
            border-color: #007bff;
            transform: translateY(-1px);
        }
        .category-option.selected {
            background-color: #007bff;
            color: white;
            border-color: #007bff;
        }
        .preview-section {
            display: none;
            margin-top: 2rem;
            padding: 1rem;
            background-color: #f8f9fa;
            border-radius: 0.375rem;
        }
        .question-preview {
            background: white;
            padding: 1rem;
            margin-bottom: 1rem;
            border-radius: 0.375rem;
            border-left: 4px solid #007bff;
        }
        .loading-spinner {
            display: none;
        }
        .category-refresh-section {
            background-color: #f8f9fa;
            padding: 0.75rem;
            border-radius: 0.375rem;
            margin-bottom: 1rem;
        }
        .refresh-btn {
            border: none;
            background: transparent;
            color: #007bff;
            font-size: 0.9rem;
        }
        .refresh-btn:hover {
            color: #0056b3;
        }
        .cache-status {
            font-size: 0.8rem;
            color: #6c757d;
        }
        .category-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 0.5rem;
        }
        .category-option.selected {
    background-color: #007bff;
    color: white;
    border-color: #007bff;
    box-shadow: 0 0 0 0.2rem rgba(0, 123, 255, 0.25);
}
    </style>
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/admin/dashboard">
                <i class="fas fa-graduation-cap me-2"></i>EduQuiz Admin
            </a>
            <div class="navbar-nav ms-auto">
                <a class="nav-link" href="${pageContext.request.contextPath}/admin/dashboard">
                    <i class="fas fa-tachometer-alt me-1"></i>Dashboard
                </a>
                <a class="nav-link" href="${pageContext.request.contextPath}/logout">
                    <i class="fas fa-sign-out-alt me-1"></i>Logout
                </a>
            </div>
        </div>
    </nav>

    <div class="container import-container">
        <div class="row mb-4">
            <div class="col">
                <h2><i class="fas fa-download me-2"></i>Import Questions from API</h2>
                <p class="text-muted">Import high-quality questions from OpenTDB (Open Trivia Database)</p>
            </div>
        </div>

        <c:if test="${not empty successMessage}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="fas fa-check-circle me-2"></i>${successMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="fas fa-exclamation-circle me-2"></i>${errorMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <div class="card">
            <div class="card-header">
                <h5 class="mb-0"><i class="fas fa-cog me-2"></i>Import Configuration</h5>
            </div>
            <div class="card-body">
                <form id="importForm" method="post" action="${pageContext.request.contextPath}/admin/process-import">
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label for="quizTitle" class="form-label">Quiz Title *</label>
                            <input type="text" class="form-control" id="quizTitle" name="title" 
       placeholder="e.g., Science Quiz - Advanced" required>
                        </div>
                        <div class="col-md-6">
                            <label for="localCategory" class="form-label">Local Category *</label>
                            <select class="form-select" id="localCategory" name="categoryId" required>
                                <option value="">Select Category</option>
                                <c:forEach var="category" items="${categories}">
                                    <option value="${category.id}">${category.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label for="description" class="form-label">Quiz Description</label>
                        <textarea class="form-control" id="description" name="description" rows="3"
                                  placeholder="Brief description of the quiz content and difficulty"></textarea>
                    </div>

                    <div class="row mb-3">
                        <div class="col-md-4">
                            <label for="amount" class="form-label">Number of Questions *</label>
                            <select class="form-select" id="amount" name="amount" required>
                                <option value="5">5 Questions</option>
                                <option value="10" selected>10 Questions</option>
                                <option value="15">15 Questions</option>
                                <option value="20">20 Questions</option>
                                <option value="25">25 Questions</option>
                                <option value="30">30 Questions</option>
                            </select>
                        </div>
                        <div class="col-md-4">
                            <label for="difficulty" class="form-label">Difficulty Level</label>
                            <select class="form-select" id="difficulty" name="difficulty">
                                <option value="">Any Difficulty</option>
                                <option value="easy">Easy</option>
                                <option value="medium">Medium</option>
                                <option value="hard">Hard</option>
                            </select>
                        </div>
                        <div class="col-md-4">
                            <label for="timeLimit" class="form-label">Time Limit (minutes)</label>
                            <input type="number" class="form-control" id="timeLimit" name="timeLimit" 
                                   value="30" min="5" max="120">
                        </div>
                    </div>

                    <div class="mb-3">
                        <div class="category-header">
                            <label class="form-label mb-0">API Category</label>
                            <div class="d-flex align-items-center">
                                <button type="button" class="refresh-btn" id="refreshCategories" title="Refresh categories from API">
                                    <i class="fas fa-sync-alt me-1"></i>Refresh Categories
                                </button>
                            </div>
                        </div>
                        
                        <div class="category-refresh-section">
                            <div class="cache-status">
                                <i class="fas fa-info-circle me-1"></i>
                                Categories loaded from OpenTDB API
                                <c:choose>
                                    <c:when test="${not empty cacheStatus and not empty cacheStatus.lastUpdated}">
                                        (Last updated: <fmt:formatDate value="${cacheStatus.lastUpdated}" pattern="MMM dd, yyyy HH:mm" />)
                                        <c:if test="${cacheStatus.fromCache}">
                                            <span class="badge bg-secondary ms-2">Cached</span>
                                        </c:if>
                                        <c:if test="${not cacheStatus.fromCache}">
                                            <span class="badge bg-success ms-2">Fresh</span>
                                        </c:if>
                                    </c:when>
                                    <c:otherwise>
                                        (Using fallback categories)
                                        <span class="badge bg-warning ms-2">Fallback</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        
                        <input type="hidden" id="selectedApiCategory" name="apiCategory">
                        <div class="category-grid" id="categoryGrid">
                            <div class="category-option" data-value="">
                                <strong>Any Category</strong><br>
                                <small class="text-muted">Mixed topics</small>
                            </div>
                            
                            <c:choose>
                                <c:when test="${not empty apiCategories}">
                                    <c:forEach items="${apiCategories}" var="apiCategory">
                                        <c:set var="parts" value="${fn:split(apiCategory, '|')}" />
                                        <c:if test="${fn:length(parts) >= 2}">
                                            <div class="category-option" data-value="${parts[0]}">
                                                <strong>${parts[1]}</strong><br>
                                                <c:if test="${fn:length(parts) >= 3}">
                                                    <small class="text-muted">${parts[2]}</small>
                                                </c:if>
                                            </div>
                                        </c:if>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <div class="category-option" data-value="9">
                                        <strong>General Knowledge</strong><br>
                                        <small class="text-muted">Mixed general topics</small>
                                    </div>
                                    <div class="category-option" data-value="17">
                                        <strong>Science & Nature</strong><br>
                                        <small class="text-muted">Biology, Chemistry, Physics</small>
                                    </div>
                                    <div class="category-option" data-value="18">
                                        <strong>Science: Computers</strong><br>
                                        <small class="text-muted">Technology, Programming</small>
                                    </div>
                                    <div class="category-option" data-value="19">
                                        <strong>Science: Mathematics</strong><br>
                                        <small class="text-muted">Math problems and concepts</small>
                                    </div>
                                    <div class="category-option" data-value="20">
                                        <strong>Mythology</strong><br>
                                        <small class="text-muted">Myths and legends</small>
                                    </div>
                                    <div class="category-option" data-value="21">
                                        <strong>Sports</strong><br>
                                        <small class="text-muted">Sports and athletics</small>
                                    </div>
                                    <div class="category-option" data-value="22">
                                        <strong>Geography</strong><br>
                                        <small class="text-muted">World geography</small>
                                    </div>
                                    <div class="category-option" data-value="23">
                                        <strong>History</strong><br>
                                        <small class="text-muted">Historical events</small>
                                    </div>
                                    <div class="category-option" data-value="24">
                                        <strong>Politics</strong><br>
                                        <small class="text-muted">Government and politics</small>
                                    </div>
                                    <div class="category-option" data-value="25">
                                        <strong>Art</strong><br>
                                        <small class="text-muted">Art and artists</small>
                                    </div>
                                    <div class="category-option" data-value="27">
                                        <strong>Animals</strong><br>
                                        <small class="text-muted">Animal kingdom</small>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <div class="d-flex gap-2">
                        <button type="button" class="btn btn-outline-primary" id="previewBtn">
                            <i class="fas fa-eye me-2"></i>Preview Questions
                        </button>
                        <button type="submit" class="btn btn-primary" id="importBtn">
                            <i class="fas fa-download me-2"></i>Import Questions
                        </button>
                        <a href="${pageContext.request.contextPath}/admin/manage-questions" class="btn btn-secondary">
                            <i class="fas fa-arrow-left me-2"></i>Back to Questions
                        </a>
                    </div>
                </form>
            </div>
        </div>

        <div id="previewSection" class="preview-section">
            <h5><i class="fas fa-eye me-2"></i>Question Preview</h5>
            <div id="previewContent">
            </div>
        </div>

        <div class="text-center loading-spinner" id="loadingSpinner">
            <div class="spinner-border text-primary" role="status">
                <span class="visually-hidden">Loading...</span>
            </div>
            <p class="mt-2">Fetching questions from API...</p>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
    document.addEventListener('DOMContentLoaded', function() {
        
        const categoryOptions = document.querySelectorAll('.category-option');
        const selectedApiCategory = document.getElementById('selectedApiCategory');
        const categoryGrid = document.getElementById('categoryGrid');
        
        function handleCategoryClick() {
            categoryOptions.forEach(opt => opt.classList.remove('selected'));
            
            this.classList.add('selected');
            
            selectedApiCategory.value = this.getAttribute('data-value');
        }
        
        function initCategorySelection() {
            categoryOptions.forEach(option => {
                option.addEventListener('click', handleCategoryClick);
            });
            
            document.querySelector('.category-option[data-value=""]').click();
        }
        
        initCategorySelection();

        
        const refreshBtn = document.getElementById('refreshCategories');
        
        refreshBtn.addEventListener('click', function() {
            const button = this;
            const icon = button.querySelector('i');
            
            button.disabled = true;
            icon.classList.add('fa-spin');
            button.innerHTML = '<i class="fas fa-spinner fa-spin me-1"></i>Refreshing...';
            
            fetch('${pageContext.request.contextPath}/admin/refresh-categories', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                }
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    showAlert('Categories refreshed successfully!', 'success');
                    setTimeout(() => {
                        window.location.reload();
                    }, 1500);
                } else {
                    showAlert('Error refreshing categories: ' + (data.message || 'Unknown error'), 'danger');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                showAlert('Network error occurred while refreshing categories', 'danger');
            })
            .finally(() => {
                button.disabled = false;
                button.innerHTML = '<i class="fas fa-sync-alt me-1"></i>Refresh Categories';
            });
        });

        
        const previewBtn = document.getElementById('previewBtn');
        const previewSection = document.getElementById('previewSection');
        const previewContent = document.getElementById('previewContent');
        const loadingSpinner = document.getElementById('loadingSpinner');
        
        previewBtn.addEventListener('click', function() {
            const formData = new FormData(document.getElementById('importForm'));
            
            loadingSpinner.style.display = 'block';
            previewSection.style.display = 'none';
            
            fetch('${pageContext.request.contextPath}/admin/preview-import', {
                method: 'POST',
                body: formData
            })
            .then(response => response.json())
            .then(data => {
                loadingSpinner.style.display = 'none';
                
                if (data.success) {
                    displayPreview(data.questions);
                    previewSection.style.display = 'block';
                } else {
                    showAlert('Error fetching preview: ' + (data.message || 'Unknown error'), 'danger');
                }
            })
            .catch(error => {
                loadingSpinner.style.display = 'none';
                console.error('Preview error:', error);
                showAlert('Network error occurred during preview', 'danger');
            });
        });
        
        function displayPreview(questions) {
            let html = '<p class="mb-3"><strong>' + questions.length + ' questions found:</strong></p>';
            
            questions.forEach((question, index) => {
                html += `
                    <div class="question-preview">
                        <h6>Question ${index + 1}</h6>
                        <p><strong>${question.question}</strong></p>
                        <div class="row">
                            <div class="col-md-6">
                                <small class="text-muted">A) ${question.optionA}</small><br>
                                <small class="text-muted">B) ${question.optionB}</small>
                            </div>
                            <div class="col-md-6">
                                <small class="text-muted">C) ${question.optionC}</small><br>
                                <small class="text-muted">D) ${question.optionD}</small>
                            </div>
                        </div>
                        <small class="text-success"><strong>Correct: ${question.correctAnswer}</strong></small>
                        <small class="text-muted ms-3">Difficulty: ${question.difficulty || 'Mixed'}</small>
                    </div>
                `;
            });
            
            previewContent.innerHTML = html;
        }


        const importForm = document.getElementById('importForm');
        
        importForm.addEventListener('submit', function(e) {
            const quizTitle = document.getElementById('quizTitle').value.trim();
            const localCategory = document.getElementById('localCategory').value;
            const timeLimit = document.getElementById('timeLimit').value;
            const apiCategory = selectedApiCategory.value;
            
            if (!quizTitle) {
                e.preventDefault();
                showAlert('Please enter a quiz title.', 'warning');
                return;
            }
            
            if (!localCategory) {
                e.preventDefault();
                showAlert('Please select a local category.', 'warning');
                return;
            }
            
            if (!timeLimit || isNaN(timeLimit) || timeLimit < 1 || timeLimit > 120) {
                e.preventDefault();
                showAlert('Please enter a valid time limit (1-120 minutes).', 'warning');
                return;
            }
            
            if (apiCategory === undefined || apiCategory === null) {
                e.preventDefault();
                showAlert('Please select an API category.', 'warning');
                return;
            }
            
            const importBtn = document.getElementById('importBtn');
            importBtn.disabled = true;
            importBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Importing...';
        });


        function showAlert(message, type) {
            const alertClass = `alert-${type}`;
            const iconClass = type === 'success' ? 'fas fa-check-circle' : 'fas fa-exclamation-circle';
            
            const alertHtml = `
                <div class="alert ${alertClass} alert-dismissible fade show" role="alert">
                    <i class="${iconClass} me-2"></i>${message}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            `;
            
            const container = document.querySelector('.import-container');
            const firstChild = container.firstElementChild;
            firstChild.insertAdjacentHTML('afterend', alertHtml);
            
            setTimeout(() => {
                const alert = container.querySelector('.alert');
                if (alert) {
                    const bsAlert = new bootstrap.Alert(alert);
                    bsAlert.close();
                }
            }, 5000);
        }
    });
    </script>
</body>
</html>