<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>管理后台 - 校园跳蚤市场</title>
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
        .stat-card {
            border-radius: 10px;
            border: none;
            box-shadow: 0 0.125rem 0.25rem rgba(0, 0, 0, 0.075);
            transition: transform 0.2s;
        }
        .stat-card:hover {
            transform: translateY(-2px);
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
        .card-header-custom {
            background-color: #0d6efd;
            color: white;
            border: none;
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
                            <a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-link active">
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
                            <a href="${pageContext.request.contextPath}/admin/admin_accounts" class="nav-link">
                                <i class="bi bi-shield-check me-2"></i>管理员账号管理
                            </a>
                        </li>
                        <li class="nav-item">
                            <a href="${pageContext.request.contextPath}/admin/statistics" class="nav-link">
                                <i class="bi bi-bar-chart me-2"></i>数据统计
                            </a>
                        </li>
                    </ul>

                    <!-- 系统信息 -->
                    <div class="mt-4 pt-3 border-top">
                        <small class="text-muted">
                            <i class="bi bi-info-circle me-1"></i>系统信息
                        </small>
                        <div class="mt-2">
                            <small class="text-muted">
                                <i class="bi bi-clock me-1"></i>
                                <fmt:formatDate value="<%= new java.util.Date() %>" pattern="yyyy-MM-dd HH:mm" />
                            </small>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 主内容区 -->
            <div class="col-md-9 col-lg-10 main-content p-4">
                <!-- 页面标题 -->
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h2 class="mb-0">
                        <i class="bi bi-speedometer2 me-2"></i>管理仪表盘
                    </h2>
                    <div class="text-muted">
                        <small>最后更新: <fmt:formatDate value="<%= new java.util.Date() %>" pattern="HH:mm:ss" /></small>
                    </div>
                </div>

                <!-- 调试信息（开发时显示） -->
                <c:if test="${empty pendingCount}">
                    <div class="alert alert-warning">
                        <i class="bi bi-exclamation-triangle me-2"></i>
                        <strong>数据加载提示：</strong> 如果统计数字没有显示，请检查数据库连接和数据。
                        <br>
                        <small>pendingCount: ${pendingCount}, userCount: ${userCount}, itemCount: ${itemCount}</small>
                    </div>
                </c:if>

                <!-- 统计卡片 -->
                <div class="row mb-4">
                    <div class="col-xl-3 col-md-6 mb-4">
                        <div class="card stat-card border-start-primary">
                            <div class="card-body">
                                <div class="row align-items-center">
                                    <div class="col me-2">
                                        <div class="text-xs fw-bold text-primary text-uppercase mb-1">
                                            待审核商品
                                        </div>
                                        <div class="h5 mb-0 fw-bold text-gray-800">${pendingCount}</div>
                                        <div class="mt-2">
                                            <a href="${pageContext.request.contextPath}/admin/items" class="text-decoration-none">
                                                <small>查看详情 <i class="bi bi-arrow-right"></i></small>
                                            </a>
                                        </div>
                                    </div>
                                    <div class="col-auto">
                                        <i class="bi bi-clock-history fa-2x text-gray-300"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-xl-3 col-md-6 mb-4">
                        <div class="card stat-card border-start-success">
                            <div class="card-body">
                                <div class="row align-items-center">
                                    <div class="col me-2">
                                        <div class="text-xs fw-bold text-success text-uppercase mb-1">
                                            注册用户
                                        </div>
                                        <div class="h5 mb-0 fw-bold text-gray-800">${userCount}</div>
                                        <div class="mt-2">
                                            <a href="${pageContext.request.contextPath}/admin/users" class="text-decoration-none">
                                                <small>管理用户 <i class="bi bi-arrow-right"></i></small>
                                            </a>
                                        </div>
                                    </div>
                                    <div class="col-auto">
                                        <i class="bi bi-people fa-2x text-gray-300"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-xl-3 col-md-6 mb-4">
                        <div class="card stat-card border-start-info">
                            <div class="card-body">
                                <div class="row align-items-center">
                                    <div class="col me-2">
                                        <div class="text-xs fw-bold text-info text-uppercase mb-1">
                                            上架商品
                                        </div>
                                        <div class="h5 mb-0 fw-bold text-gray-800">${itemCount}</div>
                                        <div class="mt-2">
                                            <a href="${pageContext.request.contextPath}/index" class="text-decoration-none">
                                                <small>浏览商城 <i class="bi bi-arrow-right"></i></small>
                                            </a>
                                        </div>
                                    </div>
                                    <div class="col-auto">
                                        <i class="bi bi-box-seam fa-2x text-gray-300"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-xl-3 col-md-6 mb-4">
                        <div class="card stat-card border-start-warning">
                            <div class="card-body">
                                <div class="row align-items-center">
                                    <div class="col me-2">
                                        <div class="text-xs fw-bold text-warning text-uppercase mb-1">
                                            系统状态
                                        </div>
                                        <div class="h5 mb-0 fw-bold text-gray-800">正常</div>
                                        <div class="mt-2">
                                            <span class="badge bg-success">
                                                <i class="bi bi-check-circle me-1"></i>运行中
                                            </span>
                                        </div>
                                    </div>
                                    <div class="col-auto">
                                        <i class="bi bi-server fa-2x text-gray-300"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- 最近活动 -->
                <div class="row">
                    <div class="col-12">
                        <div class="card">
                            <div class="card-header">
                                <h5 class="mb-0">
                                    <i class="bi bi-activity me-2"></i>最近活动
                                </h5>
                            </div>
                            <div class="card-body">
                                <div class="alert alert-info mb-0">
                                    <i class="bi bi-info-circle me-2"></i>
                                    欢迎使用校园跳蚤市场管理后台！您可以在这里审核商品、管理用户、查看系统状态。
                                    <br>
                                    <small>当前时间: <fmt:formatDate value="<%= new java.util.Date() %>" pattern="yyyy年MM月dd日 HH:mm:ss" /></small>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>

    <!-- 自定义脚本 -->
    <script>
        // 自动刷新页面数据（可选）
        setTimeout(function() {
            window.location.reload();
        }, 300000); // 5分钟刷新一次

        // 统计卡片动画
        document.addEventListener('DOMContentLoaded', function() {
            const statCards = document.querySelectorAll('.stat-card');
            statCards.forEach(card => {
                card.addEventListener('mouseenter', function() {
                    this.style.transform = 'translateY(-5px)';
                });
                card.addEventListener('mouseleave', function() {
                    this.style.transform = 'translateY(0)';
                });
            });
        });
    </script>
</body>
</html>