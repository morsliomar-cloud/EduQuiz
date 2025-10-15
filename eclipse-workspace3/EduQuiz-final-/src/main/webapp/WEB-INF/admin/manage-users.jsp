<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EduQuiz - Manage Users</title>
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
                            <a href="${pageContext.request.contextPath}/admin/manage-users" class="nav-link active" aria-current="page">
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
                    <h1>User Management</h1>
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addUserModal">
                            <i class="bi bi-person-plus"></i> Add User
                        </button>
                    </div>
                </div>
                
                <!-- Alert Messages -->
                <c:if test="${not empty sessionScope.successMessage}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        ${sessionScope.successMessage}
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                    <c:remove var="successMessage" scope="session" />
                </c:if>
                
                <c:if test="${not empty sessionScope.errorMessage}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        ${sessionScope.errorMessage}
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                    <c:remove var="errorMessage" scope="session" />
                </c:if>
                
                <!-- User Statistics Cards -->
                <div class="row mb-4">
                    <div class="col-md-4">
                        <div class="card bg-primary text-white">
                            <div class="card-body">
                                <div class="d-flex justify-content-between align-items-center">
                                    <div>
                                        <h6 class="card-title">Total Users</h6>
                                        <h3 class="mb-0">${userStats.totalUsers}</h3>
                                    </div>
                                    <i class="bi bi-people fs-1"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="card bg-success text-white">
                            <div class="card-body">
                                <div class="d-flex justify-content-between align-items-center">
                                    <div>
                                        <h6 class="card-title">Active Users</h6>
                                        <h3 class="mb-0">${userStats.activeUsers}</h3>
                                    </div>
                                    <i class="bi bi-person-check fs-1"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="card bg-warning text-dark">
                            <div class="card-body">
                                <div class="d-flex justify-content-between align-items-center">
                                    <div>
                                        <h6 class="card-title">Admin Users</h6>
                                        <h3 class="mb-0">${userStats.adminUsers}</h3>
                                    </div>
                                    <i class="bi bi-shield-check fs-1"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Search and Filter Section -->
                <div class="card mb-4">
                    <div class="card-body">
                        <form method="get" action="${pageContext.request.contextPath}/admin/manage-users" class="row g-3">
                            <div class="col-md-4">
                                <label for="search" class="form-label">Search Users</label>
                                <input type="text" class="form-control" id="search" name="search" 
                                       placeholder="Username or email..." value="${searchTerm}">
                            </div>
                            <div class="col-md-3">
                                <label for="role" class="form-label">Filter by Role</label>
                                <select class="form-select" id="role" name="role">
                                    <option value="">All Roles</option>
                                    <option value="USER" ${selectedRole eq 'USER' ? 'selected' : ''}>User</option>
                                    <option value="ADMIN" ${selectedRole eq 'ADMIN' ? 'selected' : ''}>Admin</option>
                                </select>
                            </div>
                            <div class="col-md-2">
                                <label class="form-label">&nbsp;</label>
                                <button type="submit" class="btn btn-primary d-block">
                                    <i class="bi bi-search"></i> Search
                                </button>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">&nbsp;</label>
                                <a href="${pageContext.request.contextPath}/admin/manage-users" class="btn btn-secondary d-block">
                                    <i class="bi bi-arrow-clockwise"></i> Reset
                                </a>
                            </div>
                        </form>
                    </div>
                </div>
                
                <!-- Users Table -->
                <div class="card">
                    <div class="card-header">
                        <h5 class="mb-0">Users List</h5>
                    </div>
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-striped table-hover mb-0">
                                <thead class="table-dark">
                                    <tr>
                                        <th>ID</th>
                                        <th>Username</th>
                                        <th>Email</th>
                                        <th>Role</th>
                                        <th>Status</th>
                                        <th>Joined Date</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${empty users}">
                                            <tr>
                                                <td colspan="7" class="text-center py-4">
                                                    <i class="bi bi-people text-muted" style="font-size: 3rem;"></i>
                                                    <p class="text-muted mt-2">No users found</p>
                                                </td>
                                            </tr>
                                        </c:when>
                                        <c:otherwise>
                                            <c:forEach items="${users}" var="user">
                                                <tr>
                                                    <td>${user.id}</td>
                                                    <td>
                                                        <div class="d-flex align-items-center">
                                                            <div class="avatar-initial rounded-circle bg-primary text-white me-2">
                                                                ${user.username.substring(0, 1).toUpperCase()}
                                                            </div>
                                                            ${user.username}
                                                        </div>
                                                    </td>
                                                    <td>${user.email}</td>
                                                    <td>
                                                        <span class="badge bg-${user.role eq 'ADMIN' ? 'danger' : 'info'}">
                                                            ${user.role}
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <span class="badge bg-${user.active ? 'success' : 'secondary'}">
                                                            ${user.active ? 'Active' : 'Inactive'}
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <fmt:formatDate value="${user.createdAt}" pattern="MMM dd, yyyy" />
                                                    </td>
                                                    <td>
                                                        <div class="btn-group" role="group">
                                                            <button type="button" class="btn btn-sm btn-outline-primary" 
                                                                    onclick="editUser(${user.id}, '${user.username}', '${user.email}', '${user.role}', ${user.active})"
                                                                    data-bs-toggle="modal" data-bs-target="#editUserModal">
                                                                <i class="bi bi-pencil"></i>
                                                            </button>
                                                            <button type="button" class="btn btn-sm btn-outline-${user.active ? 'warning' : 'success'}" 
                                                                    onclick="toggleUserStatus(${user.id}, ${!user.active})">
                                                                <i class="bi bi-${user.active ? 'pause' : 'play'}"></i>
                                                            </button>
                                                            <button type="button" class="btn btn-sm btn-outline-danger" 
                                                                    onclick="deleteUser(${user.id}, '${user.username}')"
                                                                    data-bs-toggle="modal" data-bs-target="#deleteUserModal">
                                                                <i class="bi bi-trash"></i>
                                                            </button>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>
                        </div>
                    </div>
                    
                    <!-- Pagination -->
                    <c:if test="${totalPages > 1}">
                        <div class="card-footer">
                            <nav aria-label="Page navigation">
                                <ul class="pagination justify-content-center mb-0">
                                    <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                        <a class="page-link" href="?page=${currentPage - 1}&search=${searchTerm}&role=${selectedRole}">
                                            Previous
                                        </a>
                                    </li>
                                    
                                    <c:forEach begin="1" end="${totalPages}" var="page">
                                        <li class="page-item ${currentPage == page ? 'active' : ''}">
                                            <a class="page-link" href="?page=${page}&search=${searchTerm}&role=${selectedRole}">
                                                ${page}
                                            </a>
                                        </li>
                                    </c:forEach>
                                    
                                    <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                        <a class="page-link" href="?page=${currentPage + 1}&search=${searchTerm}&role=${selectedRole}">
                                            Next
                                        </a>
                                    </li>
                                </ul>
                            </nav>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Add User Modal -->
    <div class="modal fade" id="addUserModal" tabindex="-1" aria-labelledby="addUserModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="addUserModalLabel">Add New User</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="${pageContext.request.contextPath}/admin/add-user" method="post">
                    <div class="modal-body">
                        <div class="mb-3">
                            <label for="addUsername" class="form-label">Username</label>
                            <input type="text" class="form-control" id="addUsername" name="username" required>
                        </div>
                        <div class="mb-3">
                            <label for="addEmail" class="form-label">Email</label>
                            <input type="email" class="form-control" id="addEmail" name="email" required>
                        </div>
                        <div class="mb-3">
                            <label for="addPassword" class="form-label">Password</label>
                            <input type="password" class="form-control" id="addPassword" name="password" required>
                        </div>
                        <div class="mb-3">
                            <label for="addConfirmPassword" class="form-label">Confirm Password</label>
                            <input type="password" class="form-control" id="addConfirmPassword" name="confirmPassword" required>
                        </div>
                        <div class="mb-3">
                            <label for="addRole" class="form-label">Role</label>
                            <select class="form-select" id="addRole" name="role" required>
                                <option value="USER">User</option>
                                <option value="ADMIN">Admin</option>
                            </select>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" id="addActive" name="active" checked>
                            <label class="form-check-label" for="addActive">
                                Active User
                            </label>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary">Add User</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <!-- Edit User Modal -->
    <div class="modal fade" id="editUserModal" tabindex="-1" aria-labelledby="editUserModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="editUserModalLabel">Edit User</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="${pageContext.request.contextPath}/admin/update-user" method="post">
                    <input type="hidden" id="editUserId" name="id">
                    <div class="modal-body">
                        <div class="mb-3">
                            <label for="editUsername" class="form-label">Username</label>
                            <input type="text" class="form-control" id="editUsername" name="username" required>
                        </div>
                        <div class="mb-3">
                            <label for="editEmail" class="form-label">Email</label>
                            <input type="email" class="form-control" id="editEmail" name="email" required>
                        </div>
                        <div class="mb-3">
                            <label for="editPassword" class="form-label">New Password (leave blank to keep current)</label>
                            <input type="password" class="form-control" id="editPassword" name="password">
                        </div>
                        <div class="mb-3">
                            <label for="editRole" class="form-label">Role</label>
                            <select class="form-select" id="editRole" name="role" required>
                                <option value="USER">User</option>
                                <option value="ADMIN">Admin</option>
                            </select>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" id="editActive" name="active">
                            <label class="form-check-label" for="editActive">
                                Active User
                            </label>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary">Update User</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <!-- Delete User Modal -->
    <div class="modal fade" id="deleteUserModal" tabindex="-1" aria-labelledby="deleteUserModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="deleteUserModalLabel">Delete User</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <p>Are you sure you want to delete the user <strong id="deleteUserName"></strong>?</p>
                    <p class="text-danger"><small>This action cannot be undone and will also delete all associated quiz scores.</small></p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <form id="deleteUserForm" action="${pageContext.request.contextPath}/admin/delete-user" method="post" class="d-inline">
                        <input type="hidden" id="deleteUserId" name="id">
                        <button type="submit" class="btn btn-danger">Delete User</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
    
    <jsp:include page="/WEB-INF/footer.jsp" />
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Edit user function
        function editUser(id, username, email, role, active) {
            document.getElementById('editUserId').value = id;
            document.getElementById('editUsername').value = username;
            document.getElementById('editEmail').value = email;
            document.getElementById('editRole').value = role;
            document.getElementById('editActive').checked = active;
        }
        
        // Delete user function
        function deleteUser(id, username) {
            document.getElementById('deleteUserId').value = id;
            document.getElementById('deleteUserName').textContent = username;
        }
        
        // Toggle user status function
        function toggleUserStatus(userId, newStatus) {
            if (confirm('Are you sure you want to ' + (newStatus ? 'activate' : 'deactivate') + ' this user?')) {
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = '${pageContext.request.contextPath}/admin/toggle-user-status';
                
                const idInput = document.createElement('input');
                idInput.type = 'hidden';
                idInput.name = 'id';
                idInput.value = userId;
                
                const activeInput = document.createElement('input');
                activeInput.type = 'hidden';
                activeInput.name = 'active';
                activeInput.value = newStatus;
                
                form.appendChild(idInput);
                form.appendChild(activeInput);
                document.body.appendChild(form);
                form.submit();
            }
        }
        
        // Password confirmation validation
        document.getElementById('addConfirmPassword').addEventListener('input', function() {
            const password = document.getElementById('addPassword').value;
            const confirmPassword = this.value;
            
            if (password !== confirmPassword) {
                this.setCustomValidity('Passwords do not match');
            } else {
                this.setCustomValidity('');
            }
        });
        
        // Auto-dismiss alerts after 5 seconds
        setTimeout(function() {
            const alerts = document.querySelectorAll('.alert');
            alerts.forEach(function(alert) {
                const bsAlert = new bootstrap.Alert(alert);
                bsAlert.close();
            });
        }, 5000);
    </script>
    
    <style>
        .avatar-initial {
            width: 35px;
            height: 35px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            font-size: 14px;
        }
        
        .sidebar {
            min-height: calc(100vh - 56px);
        }
        
        .table-responsive {
            border-radius: 0.375rem;
        }
        
        .btn-group .btn {
            margin-right: 2px;
        }
        
        .btn-group .btn:last-child {
            margin-right: 0;
        }
        
        .card-header {
            background-color: #f8f9fa;
            border-bottom: 1px solid #dee2e6;
        }
        
        .badge {
            font-size: 0.75em;
        }
        
        .text-dark-50 {
            color: rgba(0, 0, 0, 0.5) !important;
        }
    </style>
</body>
</html>