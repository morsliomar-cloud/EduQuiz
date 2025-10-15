<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EduQuiz - Manage Categories</title>
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
                            <a href="${pageContext.request.contextPath}/admin/manage-questions" class="nav-link text-white">
                                <i class="bi bi-question-circle me-2"></i> Manage Questions
                            </a>
                        </li>
                        <li class="nav-item">
                            <a href="${pageContext.request.contextPath}/admin/manage-categories" class="nav-link active" aria-current="page">
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
            
            <div class="col-md-10 ms-auto px-4">
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1>Manage Categories</h1>
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addCategoryModal">
                            <i class="bi bi-plus-circle me-2"></i>Add Category
                        </button>
                    </div>
                </div>

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

                <div class="card">
                    <div class="card-header">
                        <h5 class="mb-0">Categories List</h5>
                    </div>
                    <div class="card-body">
                        <c:choose>
                            <c:when test="${empty categories}">
                                <div class="text-center py-4">
                                    <i class="bi bi-tags fs-1 text-muted"></i>
                                    <h5 class="mt-3 text-muted">No categories found</h5>
                                    <p class="text-muted">Create your first category to get started.</p>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="table-responsive">
                                    <table class="table table-striped table-hover">
                                        <thead class="table-dark">
                                            <tr>
                                                <th>#</th>
                                                <th>Name</th>
                                                <th>Description</th>
                                                <th>Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach items="${categories}" var="category" varStatus="status">
                                                <tr>
                                                    <td>${status.index + 1}</td>
                                                    <td>
                                                        <strong>${category.name}</strong>
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${not empty category.description}">
                                                                ${category.description}
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="text-muted">No description</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <div class="btn-group btn-group-sm" role="group">
                                                            <button type="button" class="btn btn-outline-primary" 
                                                                    onclick="editCategory(${category.id}, '${category.name}', '${category.description}')"
                                                                    data-bs-toggle="modal" data-bs-target="#editCategoryModal">
                                                                <i class="bi bi-pencil"></i> Edit
                                                            </button>
                                                            <button type="button" class="btn btn-outline-danger" 
                                                                    onclick="deleteCategory(${category.id}, '${category.name}')"
                                                                    data-bs-toggle="modal" data-bs-target="#deleteCategoryModal">
                                                                <i class="bi bi-trash"></i> Delete
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

    <div class="modal fade" id="addCategoryModal" tabindex="-1" aria-labelledby="addCategoryModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <form action="${pageContext.request.contextPath}/admin/manage-categories" method="post">
                    <input type="hidden" name="action" value="create">
                    <div class="modal-header">
                        <h5 class="modal-title" id="addCategoryModalLabel">Add New Category</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <div class="mb-3">
                            <label for="categoryName" class="form-label">Category Name <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" id="categoryName" name="name" required>
                        </div>
                        <div class="mb-3">
                            <label for="categoryDescription" class="form-label">Description</label>
                            <textarea class="form-control" id="categoryDescription" name="description" rows="3" 
                                      placeholder="Optional description for this category"></textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary">Create Category</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <div class="modal fade" id="editCategoryModal" tabindex="-1" aria-labelledby="editCategoryModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <form action="${pageContext.request.contextPath}/admin/manage-categories" method="post">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" id="editCategoryId" name="categoryId">
                    <div class="modal-header">
                        <h5 class="modal-title" id="editCategoryModalLabel">Edit Category</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <div class="mb-3">
                            <label for="editCategoryName" class="form-label">Category Name <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" id="editCategoryName" name="name" required>
                        </div>
                        <div class="mb-3">
                            <label for="editCategoryDescription" class="form-label">Description</label>
                            <textarea class="form-control" id="editCategoryDescription" name="description" rows="3" 
                                      placeholder="Optional description for this category"></textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary">Update Category</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <div class="modal fade" id="deleteCategoryModal" tabindex="-1" aria-labelledby="deleteCategoryModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <form action="${pageContext.request.contextPath}/admin/manage-categories" method="post">
                    <input type="hidden" name="action" value="delete">
                    <input type="hidden" id="deleteCategoryId" name="categoryId">
                    <div class="modal-header">
                        <h5 class="modal-title" id="deleteCategoryModalLabel">Delete Category</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <div class="alert alert-warning">
                            <i class="bi bi-exclamation-triangle me-2"></i>
                            <strong>Warning!</strong> This action cannot be undone.
                        </div>
                        <p>Are you sure you want to delete the category "<strong id="deleteCategoryName"></strong>"?</p>
                        <p class="text-muted small">
                            <i class="bi bi-info-circle"></i> 
                            Categories that have associated quizzes cannot be deleted. Please reassign or delete the quizzes first.
                        </p>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-danger">Delete Category</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <jsp:include page="/WEB-INF/footer.jsp" />
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function editCategory(id, name, description) {
            document.getElementById('editCategoryId').value = id;
            document.getElementById('editCategoryName').value = name;
            document.getElementById('editCategoryDescription').value = description || '';
        }
        
        function deleteCategory(id, name) {
            document.getElementById('deleteCategoryId').value = id;
            document.getElementById('deleteCategoryName').textContent = name;
        }
        
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