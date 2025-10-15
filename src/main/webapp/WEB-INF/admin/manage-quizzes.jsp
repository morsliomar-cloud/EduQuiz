<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EduQuiz - Manage Quizzes</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/admin.css">
</head>
<body>
    <jsp:include page="/WEB-INF/navbar.jsp" />
    
    <div class="container-fluid mt-3">
        <div class="row">
            <!-- Sidebar -->
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
                            <a href="${pageContext.request.contextPath}/admin/manage-quizzes" class="nav-link active" aria-current="page">
                                <i class="bi bi-journal-text me-2"></i> Manage Quizzes
                            </a>
                        </li>
                        <li class="nav-item">
                            <a href="${pageContext.request.contextPath}/admin/manage-questions" class="nav-link text-white">
                                <i class="bi bi-question-circle me-2"></i> Manage Questions
                            </a>
                        </li>
                        <li class="nav-item">
                            <a href="${pageContext.request.contextPath}/admin/manage-categories" class="nav-link text-white">
                                <i class="bi bi-tags me-2"></i> Manage Categories
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
                    <h1>Manage Quizzes</h1>
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addQuizModal">
                            <i class="bi bi-plus-circle"></i> Add New Quiz
                        </button>
                    </div>
                </div>

                <!-- Alert Messages -->
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

                <!-- Search and Filter Section -->
                <div class="card mb-4">
                    <div class="card-body">
                        <form method="GET" action="${pageContext.request.contextPath}/admin/manage-quizzes">
                            <div class="row g-3">
                                <div class="col-md-4">
                                    <label for="search" class="form-label">Search Quizzes</label>
                                    <input type="text" class="form-control" id="search" name="search" 
                                           value="${searchTerm}" placeholder="Search by title or description...">
                                </div>
                                <div class="col-md-3">
                                    <label for="category" class="form-label">Category</label>
                                    <select class="form-select" id="category" name="category">
                                        <option value="">All Categories</option>
                                        <c:forEach items="${categories}" var="cat">
                                            <option value="${cat.id}" ${selectedCategory eq cat.id ? 'selected' : ''}>
                                                ${cat.name}
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="col-md-3">
                                    <label for="difficulty" class="form-label">Difficulty</label>
                                    <select class="form-select" id="difficulty" name="difficulty">
                                        <option value="">All Difficulties</option>
                                        <option value="easy" ${selectedDifficulty eq 'easy' ? 'selected' : ''}>Easy</option>
                                        <option value="medium" ${selectedDifficulty eq 'medium' ? 'selected' : ''}>Medium</option>
                                        <option value="hard" ${selectedDifficulty eq 'hard' ? 'selected' : ''}>Hard</option>
                                    </select>
                                </div>
                                <div class="col-md-2 d-flex align-items-end">
                                    <button type="submit" class="btn btn-outline-primary w-100">
                                        <i class="bi bi-search"></i> Filter
                                    </button>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- Quizzes Table -->
                <div class="card">
                    <div class="card-header d-flex justify-content-between align-items-center">
                        <h5 class="mb-0">Quiz List (${quizzes.size()} quizzes)</h5>
                    </div>
                    <div class="card-body p-0">
                        <c:choose>
                            <c:when test="${empty quizzes}">
                                <div class="text-center p-4">
                                    <i class="bi bi-journal-x fs-1 text-muted"></i>
                                    <p class="text-muted mt-2">No quizzes found matching your criteria.</p>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="table-responsive">
                                    <table class="table table-striped table-hover mb-0">
                                        <thead class="table-dark">
                                            <tr>
                                                <th>ID</th>
                                                <th>Title</th>
                                                <th>Description</th>
                                                <th>Category</th>
                                                <th>Difficulty</th>
                                                <th>Time Limit</th>
                                                <th>Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach items="${quizzes}" var="quiz">
                                                <tr>
                                                    <td>${quiz.id}</td>
                                                    <td>
                                                        <strong>${quiz.title}</strong>
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${quiz.description.length() > 100}">
                                                                ${quiz.description.substring(0, 100)}...
                                                            </c:when>
                                                            <c:otherwise>
                                                                ${quiz.description}
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${not empty quiz.category}">
                                                                <span class="badge bg-info">${quiz.category.name}</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge bg-secondary">No Category</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <span class="badge bg-${quiz.difficulty eq 'easy' ? 'success' : (quiz.difficulty eq 'medium' ? 'warning' : 'danger')}">
                                                            ${quiz.difficulty.toUpperCase()}
                                                        </span>
                                                    </td>
                                                    <td>${quiz.timeLimit} min</td>
                                                    <td>
                                                        <div class="btn-group" role="group">
                                                            <button type="button" class="btn btn-sm btn-outline-primary" 
                                                                    data-bs-toggle="modal" data-bs-target="#editQuizModal"
                                                                    onclick="editQuiz(${quiz.id}, '${quiz.title}', '${quiz.description}', ${quiz.categoryId}, '${quiz.difficulty}', ${quiz.timeLimit})">
                                                                <i class="bi bi-pencil"></i>
                                                            </button>
                                                            <a href="${pageContext.request.contextPath}/admin/manage-questions?quiz=${quiz.id}" 
                                                               class="btn btn-sm btn-outline-info" title="Manage Questions">
                                                                <i class="bi bi-question-circle"></i>
                                                            </a>
                                                            <button type="button" class="btn btn-sm btn-outline-danger" 
                                                                    onclick="deleteQuiz(${quiz.id}, '${quiz.title}')">
                                                                <i class="bi bi-trash"></i>
                                                            </button>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Add Quiz Modal -->
    <div class="modal fade" id="addQuizModal" tabindex="-1" aria-labelledby="addQuizModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="addQuizModalLabel">Add New Quiz</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form method="POST" action="${pageContext.request.contextPath}/admin/manage-quizzes">
                    <div class="modal-body">
                        <input type="hidden" name="action" value="create">
                        <div class="row">
                            <div class="col-md-12 mb-3">
                                <label for="addTitle" class="form-label">Title <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" id="addTitle" name="title" required>
                            </div>
                            <div class="col-md-12 mb-3">
                                <label for="addDescription" class="form-label">Description <span class="text-danger">*</span></label>
                                <textarea class="form-control" id="addDescription" name="description" rows="3" required></textarea>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="addCategoryId" class="form-label">Category <span class="text-danger">*</span></label>
                                <select class="form-select" id="addCategoryId" name="categoryId" required>
                                    <option value="">Select Category</option>
                                    <c:forEach items="${categories}" var="cat">
                                        <option value="${cat.id}">${cat.name}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="addDifficulty" class="form-label">Difficulty <span class="text-danger">*</span></label>
                                <select class="form-select" id="addDifficulty" name="difficulty" required>
                                    <option value="">Select Difficulty</option>
                                    <option value="easy">Easy</option>
                                    <option value="medium">Medium</option>
                                    <option value="hard">Hard</option>
                                </select>
                            </div>
                            <div class="col-md-12 mb-3">
                                <label for="addTimeLimit" class="form-label">Time Limit (minutes) <span class="text-danger">*</span></label>
                                <input type="number" class="form-control" id="addTimeLimit" name="timeLimit" min="1" max="60" required>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary">Create Quiz</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Edit Quiz Modal -->
    <div class="modal fade" id="editQuizModal" tabindex="-1" aria-labelledby="editQuizModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="editQuizModalLabel">Edit Quiz</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form method="POST" action="${pageContext.request.contextPath}/admin/manage-quizzes">
                    <div class="modal-body">
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" id="editQuizId" name="quizId">
                        <div class="row">
                            <div class="col-md-12 mb-3">
                                <label for="editTitle" class="form-label">Title <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" id="editTitle" name="title" required>
                            </div>
                            <div class="col-md-12 mb-3">
                                <label for="editDescription" class="form-label">Description <span class="text-danger">*</span></label>
                                <textarea class="form-control" id="editDescription" name="description" rows="3" required></textarea>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="editCategoryId" class="form-label">Category <span class="text-danger">*</span></label>
                                <select class="form-select" id="editCategoryId" name="categoryId" required>
                                    <option value="">Select Category</option>
                                    <c:forEach items="${categories}" var="cat">
                                        <option value="${cat.id}">${cat.name}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="editDifficulty" class="form-label">Difficulty <span class="text-danger">*</span></label>
                                <select class="form-select" id="editDifficulty" name="difficulty" required>
                                    <option value="">Select Difficulty</option>
                                    <option value="easy">Easy</option>
                                    <option value="medium">Medium</option>
                                    <option value="hard">Hard</option>
                                </select>
                            </div>
                            <div class="col-md-12 mb-3">
                                <label for="editTimeLimit" class="form-label">Time Limit (minutes) <span class="text-danger">*</span></label>
                                <input type="number" class="form-control" id="editTimeLimit" name="timeLimit" min="1" max="60" required>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary">Update Quiz</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Delete Confirmation Modal -->
    <div class="modal fade" id="deleteQuizModal" tabindex="-1" aria-labelledby="deleteQuizModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="deleteQuizModalLabel">Confirm Delete</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <p>Are you sure you want to delete the quiz "<span id="deleteQuizTitle"></span>"?</p>
                    <p class="text-danger"><strong>Warning:</strong> This will also delete all associated questions and scores!</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <form method="POST" action="${pageContext.request.contextPath}/admin/manage-quizzes" style="display: inline;">
                        <input type="hidden" name="action" value="delete">
                        <input type="hidden" id="deleteQuizId" name="quizId">
                        <button type="submit" class="btn btn-danger">Delete Quiz</button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <jsp:include page="/WEB-INF/footer.jsp" />
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function editQuiz(id, title, description, categoryId, difficulty, timeLimit) {
            document.getElementById('editQuizId').value = id;
            document.getElementById('editTitle').value = title;
            document.getElementById('editDescription').value = description;
            document.getElementById('editCategoryId').value = categoryId;
            document.getElementById('editDifficulty').value = difficulty;
            document.getElementById('editTimeLimit').value = timeLimit;
        }
        
        function deleteQuiz(id, title) {
            document.getElementById('deleteQuizId').value = id;
            document.getElementById('deleteQuizTitle').textContent = title;
            
            var deleteModal = new bootstrap.Modal(document.getElementById('deleteQuizModal'));
            deleteModal.show();
        }
        
        // Auto-hide alerts after 5 seconds
        setTimeout(function() {
            var alerts = document.querySelectorAll('.alert');
            alerts.forEach(function(alert) {
                var bsAlert = new bootstrap.Alert(alert);
                bsAlert.close();
            });
        }, 5000);
    </script>
</body>
</html>