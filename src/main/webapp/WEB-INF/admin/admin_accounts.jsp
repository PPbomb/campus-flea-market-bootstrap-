<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>管理员账号管理 - 校园跳蚤市场</title>
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
            border: none;
            text-align: left;
        }
        .admin-sidebar .nav-link.active {
            background-color: #0d6efd;
            color: white;
        }
        .admin-sidebar .nav-link:hover:not(.active) {
            background-color: #e9ecef;
        }
        .custom-header {
            background-color: #0d6efd;
            color: white;
            padding: 1rem 0;
        }
        .sidebar-brand {
            color: #0d6efd;
            font-weight: bold;
            border-bottom: 1px solid #dee2e6;
            padding-bottom: 1rem;
            margin-bottom: 1rem;
        }
        .main-content {
            background-color: #f8f9fa;
            min-height: calc(100vh - 56px);
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
            <!-- 侧边栏 -->
            <div class="col-md-3 col-lg-2 admin-sidebar">
                <div class="d-flex flex-column flex-shrink-0 p-3">
                    <div class="sidebar-brand">
                        <i class="bi bi-speedometer2 me-2"></i>管理面板
                    </div>
                    <ul class="nav nav-pills flex-column mb-auto">
                        <li class="nav-item">
                            <a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-link">
                                <i class="bi bi-speedometer2 me-2"></i>仪表盘
                            </a>
                        </li>
                        <li class="nav-item">
                            <a href="${pageContext.request.contextPath}/admin/items" class="nav-link">
                                <i class="bi bi-box-seam me-2"></i>商品审核
                                <c:if test="${pendingCount > 0}">
                                    <span class="badge bg-danger rounded-pill float-end">${pendingCount}</span>
                                </c:if>
                            </a>
                        </li>
                        <li class="nav-item">
                            <a href="${pageContext.request.contextPath}/admin/users" class="nav-link">
                                <i class="bi bi-people me-2"></i>用户管理
                            </a>
                        </li>
                        <li class="nav-item">
                            <a href="${pageContext.request.contextPath}/admin/admin_accounts" class="nav-link active">
                                <i class="bi bi-shield-check me-2"></i>管理员账号管理
                            </a>
                        </li>
                        <li class="nav-item">
                            <a href="${pageContext.request.contextPath}/admin/statistics" class="nav-link">
                                <i class="bi bi-bar-chart me-2"></i>数据统计
                            </a>
                        </li>
                    </ul>
                </div>
            </div>

            <!-- 主内容区 -->
            <div class="col-md-9 col-lg-10 main-content p-4">
                <!-- 页面标题 -->
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h2 class="mb-0">
                        <i class="bi bi-shield-lock me-2"></i>管理员账号管理
                    </h2>
                    <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addAdminModal">
                        <i class="bi bi-plus-circle me-2"></i>添加管理员
                    </button>
                </div>

                <!-- 消息提示 -->
                <c:if test="${not empty param.success}">
                    <div class="alert alert-success alert-dismissible fade show">
                        <i class="bi bi-check-circle me-2"></i>${param.success}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>
                <c:if test="${not empty param.error}">
                    <div class="alert alert-danger alert-dismissible fade show">
                        <i class="bi bi-exclamation-circle me-2"></i>${param.error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <!-- 管理员列表 -->
                <div class="card">
                    <div class="card-header bg-primary text-white">
                        管理员账号列表
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-striped">
                                <thead>
                                    <tr>
                                        <th>用户名</th>
                                        <th>手机号</th>
                                        <th>邮箱</th>
                                        <th>创建时间</th>
                                        <th>操作</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="admin" items="${admins}">
                                        <tr>
                                            <td>${admin.username}</td>
                                            <td>${admin.phone}</td>
                                            <td>${admin.email}</td>
                                            <td>
                                                <fmt:formatDate value="${admin.createdAt}" pattern="yyyy-MM-dd HH:mm" />
                                            </td>
                                            <td>
                                                <button class="btn btn-sm btn-warning me-2" 
                                                        data-bs-toggle="modal" 
                                                        data-bs-target="#editAdminModal"
                                                        data-id="${admin.id}"
                                                        data-username="${admin.username}"
                                                        data-phone="${admin.phone}"
                                                        data-email="${admin.email}">
                                                    <i class="bi bi-pencil"></i> 编辑
                                                </button>
                                                <button class="btn btn-sm btn-info me-2" 
                                                        data-bs-toggle="modal" 
                                                        data-bs-target="#resetPasswordModal"
                                                        data-id="${admin.id}"
                                                        data-username="${admin.username}">
                                                    <i class="bi bi-key"></i> 重置密码
                                                </button>
                                                <c:if test="${admin.id != sessionScope.user.id}">
                                                    <button class="btn btn-sm btn-danger" 
                                                            data-bs-toggle="modal" 
                                                            data-bs-target="#deleteAdminModal"
                                                            data-id="${admin.id}"
                                                            data-username="${admin.username}">
                                                        <i class="bi bi-trash"></i> 删除
                                                    </button>
                                                </c:if>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- 添加管理员模态框 -->
    <div class="modal fade" id="addAdminModal" tabindex="-1" aria-labelledby="addAdminModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header bg-primary text-white">
                    <h5 class="modal-title" id="addAdminModalLabel">添加管理员</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="admin_accounts" method="post">
                    <div class="modal-body">
                        <input type="hidden" name="action" value="add">
                        <div class="mb-3">
                            <label for="newUsername" class="form-label">用户名</label>
                            <input type="text" class="form-control" id="newUsername" name="username" required>
                        </div>
                        <div class="mb-3">
                            <label for="newPassword" class="form-label">密码</label>
                            <input type="password" class="form-control" id="newPassword" name="password" required>
                        </div>
                        <div class="mb-3">
                            <label for="newPhone" class="form-label">手机号</label>
                            <input type="text" class="form-control" id="newPhone" name="phone">
                        </div>
                        <div class="mb-3">
                            <label for="newEmail" class="form-label">邮箱</label>
                            <input type="email" class="form-control" id="newEmail" name="email">
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">取消</button>
                        <button type="submit" class="btn btn-primary">添加</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- 编辑管理员模态框 -->
    <div class="modal fade" id="editAdminModal" tabindex="-1" aria-labelledby="editAdminModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header bg-primary text-white">
                    <h5 class="modal-title" id="editAdminModalLabel">编辑管理员</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="admin_accounts" method="post">
                    <div class="modal-body">
                        <input type="hidden" name="action" value="edit">
                        <input type="hidden" id="editId" name="id">
                        <div class="mb-3">
                            <label for="editUsername" class="form-label">用户名</label>
                            <input type="text" class="form-control" id="editUsername" name="username" required>
                        </div>
                        <div class="mb-3">
                            <label for="editPhone" class="form-label">手机号</label>
                            <input type="text" class="form-control" id="editPhone" name="phone">
                        </div>
                        <div class="mb-3">
                            <label for="editEmail" class="form-label">邮箱</label>
                            <input type="email" class="form-control" id="editEmail" name="email">
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

    <!-- 重置密码模态框 -->
    <div class="modal fade" id="resetPasswordModal" tabindex="-1" aria-labelledby="resetPasswordModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header bg-primary text-white">
                    <h5 class="modal-title" id="resetPasswordModalLabel">重置密码</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="admin_accounts" method="post">
                    <div class="modal-body">
                        <input type="hidden" name="action" value="resetPassword">
                        <input type="hidden" id="resetId" name="id">
                        <div class="mb-3">
                            <label for="newPassword" class="form-label">新密码</label>
                            <input type="password" class="form-control" id="newPassword" name="newPassword" required>
                        </div>
                        <div class="mb-3">
                            <label for="confirmPassword" class="form-label">确认新密码</label>
                            <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required>
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

    <!-- 删除管理员模态框 -->
    <div class="modal fade" id="deleteAdminModal" tabindex="-1" aria-labelledby="deleteAdminModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header bg-danger text-white">
                    <h5 class="modal-title" id="deleteAdminModalLabel">删除管理员</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="admin_accounts" method="post">
                    <div class="modal-body">
                        <input type="hidden" name="action" value="delete">
                        <input type="hidden" id="deleteId" name="id">
                        <p>确定要删除管理员 <span id="deleteUsername" class="text-danger font-weight-bold"></span> 吗？</p>
                        <p class="text-warning"><i class="bi bi-exclamation-triangle"></i> 此操作不可撤销！</p>
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
        // 编辑管理员模态框初始化
        document.getElementById('editAdminModal').addEventListener('show.bs.modal', function (event) {
            var button = event.relatedTarget;
            var id = button.getAttribute('data-id');
            var username = button.getAttribute('data-username');
            var phone = button.getAttribute('data-phone');
            var email = button.getAttribute('data-email');
            
            var modal = this;
            modal.querySelector('#editId').value = id;
            modal.querySelector('#editUsername').value = username;
            modal.querySelector('#editPhone').value = phone || '';
            modal.querySelector('#editEmail').value = email || '';
        });
        
        // 重置密码模态框初始化
        document.getElementById('resetPasswordModal').addEventListener('show.bs.modal', function (event) {
            var button = event.relatedTarget;
            var id = button.getAttribute('data-id');
            
            var modal = this;
            modal.querySelector('#resetId').value = id;
        });
        
        // 删除管理员模态框初始化
        document.getElementById('deleteAdminModal').addEventListener('show.bs.modal', function (event) {
            var button = event.relatedTarget;
            var id = button.getAttribute('data-id');
            var username = button.getAttribute('data-username');
            
            var modal = this;
            modal.querySelector('#deleteId').value = id;
            modal.querySelector('#deleteUsername').textContent = username;
        });
    </script>
</body>
</html>