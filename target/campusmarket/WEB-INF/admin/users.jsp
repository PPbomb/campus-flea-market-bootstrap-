<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>用户管理 - 校园跳蚤市场</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css">
    <style>
        .admin-sidebar {
            background-color: #f8f9fa;
            min-height: calc(100vh - 56px);
            padding: 0;
        }
        .admin-sidebar .nav-link {
            color: #333;
            padding: 12px 20px;
            border-radius: 0;
        }
        .admin-sidebar .nav-link.active {
            background-color: #0d6efd;
            color: white;
        }
        .admin-sidebar .nav-link:hover {
            background-color: #e9ecef;
        }
        .custom-header {
            background-color: #0d6efd;
            color: white;
            padding: 1rem 0;
        }
    </style>
</head>
<body>
    <!-- 自定义header -->
    <nav class="navbar navbar-expand-lg navbar-dark custom-header">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/index">
                <i class="bi bi-shop me-2"></i>校园跳蚤市场 - 管理后台
            </a>
            <div class="navbar-nav ms-auto">
                <span class="navbar-text me-3">
                    <i class="bi bi-person-circle me-1"></i>欢迎，${sessionScope.user.username}
                </span>
                <a class="nav-link" href="${pageContext.request.contextPath}/logout">
                    <i class="bi bi-box-arrow-right me-1"></i>退出
                </a>
            </div>
        </div>
    </nav>

    <div class="container-fluid">
        <div class="row">
            <div class="col-md-3 col-lg-2 admin-sidebar">
                <div class="d-flex flex-column flex-shrink-0 p-3">
                    <h4 class="mb-3">管理后台</h4>
                    <ul class="nav nav-pills flex-column mb-auto">
                        <li class="nav-item">
                            <a href="dashboard" class="nav-link">
                                <i class="bi bi-speedometer2 me-2"></i>仪表盘
                            </a>
                        </li>
                        <li class="nav-item">
                            <a href="items" class="nav-link">
                                <i class="bi bi-box-seam me-2"></i>商品审核
                            </a>
                        </li>
                        <li class="nav-item">
                            <a href="users" class="nav-link active">
                                <i class="bi bi-people me-2"></i>用户管理
                            </a>
                        </li>
                        <li class="nav-item">
                            <a href="admin_accounts" class="nav-link">
                                <i class="bi bi-shield-check me-2"></i>管理员账号管理
                            </a>
                        </li>
                        <li class="nav-item">
                            <a href="statistics" class="nav-link">
                                <i class="bi bi-bar-chart me-2"></i>数据统计
                            </a>
                        </li>
                    </ul>
                </div>
            </div>

            <div class="col-md-9 col-lg-10 p-4">
                <h2 class="mb-4">用户管理</h2>

                <div class="table-responsive">
                    <table class="table table-striped">
                        <thead>
                            <tr>
                                <th>用户名</th>
                                <th>手机号</th>
                                <th>邮箱</th>
                                <th>注册时间</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="user" items="${users}">
                                <tr>
                                    <td>${user.username}</td>
                                    <td>${user.phone}</td>
                                    <td>${user.email}</td>
                                    <td>
                                        <fmt:formatDate value="${user.createdAt}" pattern="yyyy-MM-dd HH:mm" />
                                    </td>
                                    <td>
                                        <button class="btn btn-sm btn-outline-primary me-2" 
                                                data-bs-toggle="modal" 
                                                data-bs-target="#editUserModal"
                                                data-id="${user.id}"
                                                data-username="${user.username}"
                                                data-phone="${user.phone}"
                                                data-email="${user.email}">
                                            <i class="bi bi-pencil"></i> 编辑
                                        </button>
                                        <button class="btn btn-sm btn-outline-warning me-2" 
                                                data-bs-toggle="modal" 
                                                data-bs-target="#resetUserPasswordModal"
                                                data-id="${user.id}"
                                                data-username="${user.username}">
                                            <i class="bi bi-key"></i> 重置密码
                                        </button>
                                        <button class="btn btn-sm btn-outline-danger" 
                                                data-bs-toggle="modal" 
                                                data-bs-target="#deleteUserModal"
                                                data-id="${user.id}"
                                                data-username="${user.username}">
                                            <i class="bi bi-trash"></i> 删除
                                        </button>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <!-- 编辑用户模态框 -->
    <div class="modal fade" id="editUserModal" tabindex="-1" aria-labelledby="editUserModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header bg-primary text-white">
                    <h5 class="modal-title" id="editUserModalLabel">编辑用户信息</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="users" method="post">
                    <div class="modal-body">
                        <input type="hidden" name="action" value="edit">
                        <input type="hidden" id="editUserId" name="id">
                        <div class="mb-3">
                            <label for="editUserUsername" class="form-label">用户名</label>
                            <input type="text" class="form-control" id="editUserUsername" name="username" required>
                        </div>
                        <div class="mb-3">
                            <label for="editUserPhone" class="form-label">手机号</label>
                            <input type="text" class="form-control" id="editUserPhone" name="phone">
                        </div>
                        <div class="mb-3">
                            <label for="editUserEmail" class="form-label">邮箱</label>
                            <input type="email" class="form-control" id="editUserEmail" name="email">
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">取消</button>
                        <button type="submit" class="btn btn-primary">保存</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- 重置用户密码模态框 -->
    <div class="modal fade" id="resetUserPasswordModal" tabindex="-1" aria-labelledby="resetUserPasswordModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header bg-primary text-white">
                    <h5 class="modal-title" id="resetUserPasswordModalLabel">重置密码</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="users" method="post">
                    <div class="modal-body">
                        <input type="hidden" name="action" value="resetPassword">
                        <input type="hidden" id="resetUserId" name="id">
                        <div class="mb-3">
                            <label for="resetUserNewPassword" class="form-label">新密码</label>
                            <input type="password" class="form-control" id="resetUserNewPassword" name="newPassword" required>
                        </div>
                        <div class="mb-3">
                            <label for="resetUserConfirmPassword" class="form-label">确认新密码</label>
                            <input type="password" class="form-control" id="resetUserConfirmPassword" name="confirmPassword" required>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">取消</button>
                        <button type="submit" class="btn btn-primary">重置</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- 删除用户模态框 -->
    <div class="modal fade" id="deleteUserModal" tabindex="-1" aria-labelledby="deleteUserModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header bg-danger text-white">
                    <h5 class="modal-title" id="deleteUserModalLabel">删除用户</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="users" method="post">
                    <div class="modal-body">
                        <input type="hidden" name="action" value="delete">
                        <input type="hidden" id="deleteUserId" name="id">
                        <p>确定要删除用户 <span id="deleteUserUsername" class="text-danger font-weight-bold"></span> 吗？</p>
                        <p class="text-warning"><i class="bi bi-exclamation-triangle"></i> 此操作不可撤销，删除后用户数据将丢失！</p>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">取消</button>
                        <button type="submit" class="btn btn-danger">删除</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // 编辑用户模态框初始化
        document.getElementById('editUserModal').addEventListener('show.bs.modal', function (event) {
            var button = event.relatedTarget;
            var id = button.getAttribute('data-id');
            var username = button.getAttribute('data-username');
            var phone = button.getAttribute('data-phone');
            var email = button.getAttribute('data-email');
            
            var modal = this;
            modal.querySelector('#editUserId').value = id;
            modal.querySelector('#editUserUsername').value = username;
            modal.querySelector('#editUserPhone').value = phone || '';
            modal.querySelector('#editUserEmail').value = email || '';
        });
        
        // 重置密码模态框初始化
        document.getElementById('resetUserPasswordModal').addEventListener('show.bs.modal', function (event) {
            var button = event.relatedTarget;
            var id = button.getAttribute('data-id');
            var username = button.getAttribute('data-username');
            
            var modal = this;
            modal.querySelector('#resetUserId').value = id;
        });
        
        // 删除用户模态框初始化
        document.getElementById('deleteUserModal').addEventListener('show.bs.modal', function (event) {
            var button = event.relatedTarget;
            var id = button.getAttribute('data-id');
            var username = button.getAttribute('data-username');
            
            var modal = this;
            modal.querySelector('#deleteUserId').value = id;
            modal.querySelector('#deleteUserUsername').textContent = username;
        });
    </script>
</body>
</html>