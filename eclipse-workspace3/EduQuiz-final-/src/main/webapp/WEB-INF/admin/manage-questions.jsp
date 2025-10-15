<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EduQuiz - Manage Questions</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/admin.css">
</head>
<body>
    <jsp:include page="/WEB-INF/navbar.jsp" />
    
    <div class="container-fluid mt-3">
        <div class="row">
            <div class="col-md-2 bg-dark text-white p-0 sidebar">
                <div class="d-flex flex-column p-3">
                    <h4 class="mb-3">Admin Panel</h4>
                    <ul class="nav nav-pills flex-column mb-auto">
                        <li class="nav-item">
                            <a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-link text-white">
                                <i class="bi bi-speedometer2 me-2"></i> Dashboard
                            </a>
                        </li>
                        <li class="nav-item">
                            <a href="${pageContext.request.contextPath}/admin/manage-users" class="nav-link text-white">
                                <i class="bi bi-people me-2"></i> Manage Users
                            </a>
                        </li>
                        <li class="nav-item">
                            <a href="${pageContext.request.contextPath}/admin/manage-quizzes" class="nav-link text-white">
                                <i class="bi bi-journal-text me-2"></i> Manage Quizzes
                            </a>
                        </li>
                        <li class="nav-item">
                            <a href="${pageContext.request.contextPath}/admin/manage-questions" class="nav-link active" aria-current="page">
                                <i class="bi bi-question-circle me-2"></i> Manage Questions
                            </a>
                        </li>
                        <li class="nav-item">
                            <a href="${pageContext.request.contextPath}/admin/manage-categories" class="nav-link text-white">
                                <i class="bi bi-tags me-2"></i> Manage Categories
                            </a>
                        </li>
                        <li class="nav-item">
                            <a href="${pageContext.request.contextPath}/admin/import-questions" class="nav-link text-white">
                                <i class="bi bi-cloud-download me-2"></i> Import Questions
                            </a>
                        </li>
                        <li class="nav-item">
                            <a href="${pageContext.request.contextPath}/admin/reports" class="nav-link text-white">
                                <i class="bi bi-graph-up me-2"></i> Reports
                            </a>
                        </li>
                    </ul>
                </div>
            </div>
            
            <!-- Main Content -->
            <div class="col-md-10 ms-auto px-4">
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1>Manage Questions</h1>
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <div class="btn-group me-2">
                            <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addQuestionModal">
                                <i class="bi bi-plus-circle me-1"></i> Add Question
                            </button>
                            <button type="button" class="btn btn-outline-primary" data-bs-toggle="modal" data-bs-target="#importQuestionsModal">
                                <i class="bi bi-cloud-download me-1"></i> Import Questions
                            </button>
                        </div>
                    </div>
                </div>
                
                <!-- Success/Error Messages -->
                <c:if test="${not empty sessionScope.successMessage}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        ${sessionScope.successMessage}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                    <c:remove var="successMessage" scope="session" />
                </c:if>
                
                <c:if test="${not empty sessionScope.errorMessage}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        ${sessionScope.errorMessage}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                    <c:remove var="errorMessage" scope="session" />
                </c:if>
                
                <!-- Filters -->
                <div class="card mb-4">
                    <div class="card-body">
                        <form method="GET" action="${pageContext.request.contextPath}/admin/manage-questions">
                            <div class="row g-3">
                                <div class="col-md-4">
                                    <label for="quiz" class="form-label">Filter by Quiz</label>
                                    <select class="form-select" id="quiz" name="quiz">
                                        <option value="all" ${selectedQuiz eq 'all' || empty selectedQuiz ? 'selected' : ''}>All Quizzes</option>
                                        <c:forEach items="${quizzes}" var="quiz">
                                            <option value="${quiz.id}" ${selectedQuiz eq quiz.id.toString() ? 'selected' : ''}>${quiz.title}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="col-md-4">
                                    <label for="search" class="form-label">Search Questions</label>
                                    <input type="text" class="form-control" id="search" name="search" 
                                           placeholder="Search by question text..." value="${searchTerm}">
                                </div>
                                <div class="col-md-4 d-flex align-items-end">
                                    <button type="submit" class="btn btn-outline-primary me-2">
                                        <i class="bi bi-search me-1"></i> Filter
                                    </button>
                                    <a href="${pageContext.request.contextPath}/admin/manage-questions" class="btn btn-outline-secondary">
                                        <i class="bi bi-arrow-clockwise me-1"></i> Reset
                                    </a>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
                
                <!-- Questions Table -->
                <div class="card">
                    <div class="card-header">
                        <h5 class="mb-0">Questions List</h5>
                    </div>
                    <div class="card-body p-0">
                        <c:choose>
                            <c:when test="${not empty questions}">
                                <div class="table-responsive">
                                    <table class="table table-striped table-hover mb-0">
                                        <thead class="table-dark">
                                            <tr>
                                                <th>ID</th>
                                                <th>Question Text</th>
                                                <th>Quiz</th>
                                                <th>Correct Answer</th>
                                                <th>Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach items="${questions}" var="question">
                                                <tr>
                                                    <td>${question.id}</td>
                                                    <td>
                                                        <div class="question-text" style="max-width: 300px;">
                                                            ${question.questionText}
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <c:forEach items="${quizzes}" var="quiz">
                                                            <c:if test="${quiz.id eq question.quizId}">
                                                                <span class="badge bg-info">${quiz.title}</span>
                                                            </c:if>
                                                        </c:forEach>
                                                    </td>
                                                    <td>
                                                        <span class="badge bg-success fs-6">${question.correctAnswer}</span>
                                                    </td>
                                                    <td>
                                                        <div class="btn-group" role="group">
                                                            <button type="button" class="btn btn-sm btn-outline-info" 
                                                                    onclick="viewQuestion(${question.id}, '${question.questionText}', '${question.optionA}', '${question.optionB}', '${question.optionC}', '${question.optionD}', '${question.correctAnswer}')"
                                                                    data-bs-toggle="modal" data-bs-target="#viewQuestionModal">
                                                                <i class="bi bi-eye"></i>
                                                            </button>
                                                            <button type="button" class="btn btn-sm btn-outline-primary" 
                                                                    onclick="editQuestion(${question.id}, ${question.quizId}, '${question.questionText}', '${question.optionA}', '${question.optionB}', '${question.optionC}', '${question.optionD}', '${question.correctAnswer}')"
                                                                    data-bs-toggle="modal" data-bs-target="#editQuestionModal">
                                                                <i class="bi bi-pencil"></i>
                                                            </button>
                                                            <button type="button" class="btn btn-sm btn-outline-danger" 
                                                                    onclick="deleteQuestion(${question.id}, '${question.questionText}')"
                                                                    data-bs-toggle="modal" data-bs-target="#deleteQuestionModal">
                                                                <i class="bi bi-trash"></i>
                                                            </button>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="text-center py-5">
                                    <i class="bi bi-question-circle display-1 text-muted"></i>
                                    <h3 class="mt-3 text-muted">No Questions Found</h3>
                                    <p class="text-muted">No questions match your current filters.</p>
                                    <a href="${pageContext.request.contextPath}/admin/manage-questions" class="btn btn-outline-primary">
                                        View All Questions
                                    </a>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Add Question Modal -->
    <div class="modal fade" id="addQuestionModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Add New Question</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form method="POST" action="${pageContext.request.contextPath}/admin/manage-questions">
                    <div class="modal-body">
                        <input type="hidden" name="action" value="create">
                        
                        <div class="mb-3">
                            <label for="addQuizId" class="form-label">Quiz <span class="text-danger">*</span></label>
                            <select class="form-select" id="addQuizId" name="quizId" required>
                                <option value="">Select a quiz...</option>
                                <c:forEach items="${quizzes}" var="quiz">
                                    <option value="${quiz.id}">${quiz.title}</option>
                                </c:forEach>
                            </select>
                        </div>
                        
                        <div class="mb-3">
                            <label for="addQuestionText" class="form-label">Question Text <span class="text-danger">*</span></label>
                            <textarea class="form-control" id="addQuestionText" name="questionText" rows="3" required 
                                      placeholder="Enter the question text..."></textarea>
                        </div>
                        
                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="addOptionA" class="form-label">Option A <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" id="addOptionA" name="optionA" required>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="addOptionB" class="form-label">Option B <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" id="addOptionB" name="optionB" required>
                                </div>
                            </div>
                        </div>
                        
                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="addOptionC" class="form-label">Option C <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" id="addOptionC" name="optionC" required>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="addOptionD" class="form-label">Option D <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" id="addOptionD" name="optionD" required>
                                </div>
                            </div>
                        </div>
                        
                        <div class="mb-3">
                            <label for="addCorrectAnswer" class="form-label">Correct Answer <span class="text-danger">*</span></label>
                            <select class="form-select" id="addCorrectAnswer" name="correctAnswer" required>
                                <option value="">Select correct answer...</option>
                                <option value="A">A</option>
                                <option value="B">B</option>
                                <option value="C">C</option>
                                <option value="D">D</option>
                            </select>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary">Add Question</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <!-- Import Questions Modal -->
    <div class="modal fade" id="importQuestionsModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Import Questions from OpenTDB</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form method="POST" action="${pageContext.request.contextPath}/admin/process-import">
                    <div class="modal-body">
                        <div class="mb-3">
                            <label for="importQuizTitle" class="form-label">Quiz Title <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" id="importQuizTitle" name="title" required 
                                   placeholder="Enter quiz title...">
                        </div>
                        <div class="mb-3">
                            <label for="importQuizDescription" class="form-label">Quiz Description <span class="text-danger">*</span></label>
                            <textarea class="form-control" id="importQuizDescription" name="description" rows="3" required 
                                      placeholder="Enter quiz description..."></textarea>
                        </div>
                        <div class="mb-3">
    <label for="importCategory" class="form-label">Local Category <span class="text-danger">*</span></label>
    <select class="form-select" id="importCategory" name="categoryId" required>
        <option value="">Select a category...</option>
        <c:forEach items="${categories}" var="category">
            <option value="${category.id}">${category.name}</option>
        </c:forEach>
    </select>
</div>
                        <div class="mb-3">
    <label for="importApiCategory" class="form-label">API Category <span class="text-danger">*</span></label>
    <select class="form-select" id="importApiCategory" name="apiCategory" required>
        <option value="">Select an API category...</option>
        <c:forEach items="${apiCategories}" var="apiCategory">
            <c:set var="parts" value="${fn:split(apiCategory, '|')}" />
            <option value="${parts[0]}">${parts[1]}</option>
        </c:forEach>
    </select>
</div>
                        <div class="mb-3">
                            <label for="importDifficulty" class="form-label">Difficulty <span class="text-danger">*</span></label>
                            <select class="form-select" id="importDifficulty" name="difficulty" required>
                                <option value="">Select difficulty...</option>
                                <option value="easy">Easy</option>
                                <option value="medium">Medium</option>
                                <option value="hard">Hard</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label for="importAmount" class="form-label">Number of Questions (5-50) <span class="text-danger">*</span></label>
                            <input type="number" class="form-control" id="importAmount" name="amount" min="5" max="50" required 
                                   value="10">
                        </div>
                        <div class="mb-3">
                            <label for="importTimeLimit" class="form-label">Time Limit (minutes, 1-60) <span class="text-danger">*</span></label>
                            <input type="number" class="form-control" id="importTimeLimit" name="timeLimit" min="1" max="60" required 
                                   value="30">
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary">Import Questions</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <!-- Edit Question Modal -->
    <div class="modal fade" id="editQuestionModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Edit Question</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form method="POST" action="${pageContext.request.contextPath}/admin/manage-questions">
                    <div class="modal-body">
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" name="questionId" id="editQuestionId">
                        
                        <div class="mb-3">
                            <label for="editQuizId" class="form-label">Quiz <span class="text-danger">*</span></label>
                            <select class="form-select" id="editQuizId" name="quizId" required>
                                <c:forEach items="${quizzes}" var="quiz">
                                    <option value="${quiz.id}">${quiz.title}</option>
                                </c:forEach>
                            </select>
                        </div>
                        
                        <div class="mb-3">
                            <label for="editQuestionText" class="form-label">Question Text <span class="text-danger">*</span></label>
                            <textarea class="form-control" id="editQuestionText" name="questionText" rows="3" required></textarea>
                        </div>
                        
                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="editOptionA" class="form-label">Option A <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" id="editOptionA" name="optionA" required>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="editOptionB" class="form-label">Option B <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" id="editOptionB" name="optionB" required>
                                </div>
                            </div>
                        </div>
                        
                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="editOptionC" class="form-label">Option C <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" id="editOptionC" name="optionA" required>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="editOptionD" class="form-label">Option D <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" id="editOptionD" name="optionD" required>
                                </div>
                            </div>
                        </div>
                        
                        <div class="mb-3">
                            <label for="editCorrectAnswer" class="form-label">Correct Answer <span class="text-danger">*</span></label>
                            <select class="form-select" id="editCorrectAnswer" name="correctAnswer" required>
                                <option value="A">A</option>
                                <option value="B">B</option>
                                <option value="C">C</option>
                                <option value="D">D</option>
                            </select>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary">Update Question</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <!-- View Question Modal -->
    <div class="modal fade" id="viewQuestionModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Question Details</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <h6>Question:</h6>
                        <p id="viewQuestionText" class="border p-3 bg-light rounded"></p>
                    </div>
                    
                    <div class="row">
                        <div class="col-md-6">
                            <div class="mb-3">
                                <h6>Option A:</h6>
                                <p id="viewOptionA" class="border p-2 rounded"></p>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="mb-3">
                                <h6>Option B:</h6>
                                <p id="viewOptionB" class="border p-2 rounded"></p>
                            </div>
                        </div>
                    </div>
                    
                    <div class="row">
                        <div class="col-md-6">
                            <div class="mb-3">
                                <h6>Option C:</h6>
                                <p id="viewOptionC" class="border p-2 rounded"></p>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="mb-3">
                                <h6>Option D:</h6>
                                <p id="viewOptionD" class="border p-2 rounded"></p>
                            </div>
                        </div>
                    </div>
                    
                    <div class="mb-3">
                        <h6>Correct Answer:</h6>
                        <span id="viewCorrectAnswer" class="badge bg-success fs-6"></span>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Delete Question Modal -->
    <div class="modal fade" id="deleteQuestionModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header bg-danger text-white">
                    <h5 class="modal-title">Delete Question</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <p>Are you sure you want to delete this question?</p>
                    <div class="alert alert-warning">
                        <strong>Question:</strong> <span id="deleteQuestionText"></span>
                    </div>
                    <p class="text-muted small">This action cannot be undone.</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <form method="POST" action="${pageContext.request.contextPath}/admin/manage-questions" style="display: inline;">
                        <input type="hidden" name="action" value="delete">
                        <input type="hidden" name="questionId" id="deleteQuestionId">
                        <button type="submit" class="btn btn-danger">Delete Question</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
    
    <jsp:include page="/WEB-INF/footer.jsp" />
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function viewQuestion(id, questionText, optionA, optionB, optionC, optionD, correctAnswer) {
            document.getElementById('viewQuestionText').textContent = questionText;
            document.getElementById('viewOptionA').textContent = optionA;
            document.getElementById('viewOptionB').textContent = optionB;
            document.getElementById('viewOptionC').textContent = optionC;
            document.getElementById('viewOptionD').textContent = optionD;
            document.getElementById('viewCorrectAnswer').textContent = correctAnswer;
        }
        
        function editQuestion(id, quizId, questionText, optionA, optionB, optionC, optionD, correctAnswer) {
            document.getElementById('editQuestionId').value = id;
            document.getElementById('editQuizId').value = quizId;
            document.getElementById('editQuestionText').value = questionText;
            document.getElementById('editOptionA').value = optionA;
            document.getElementById('editOptionB').value = optionB;
            document.getElementById('editOptionC').value = optionC;
            document.getElementById('editOptionD').value = optionD;
            document.getElementById('editCorrectAnswer').value = correctAnswer;
        }
        
        function deleteQuestion(id, questionText) {
            document.getElementById('deleteQuestionId').value = id;
            document.getElementById('deleteQuestionText').textContent = questionText;
        }
        
        // Auto-dismiss alerts after 5 seconds
        document.addEventListener('DOMContentLoaded', function() {
            const alerts = document.querySelectorAll('.alert');
            alerts.forEach(function(alert) {
                setTimeout(function() {
                    const bsAlert = new bootstrap.Alert(alert);
                    bsAlert.close();
                }, 5000);
            });
        });
    </script>
</body>
</html>