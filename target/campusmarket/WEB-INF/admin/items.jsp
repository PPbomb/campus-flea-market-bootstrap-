<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>商品审核 - 校园跳蚤市场</title>
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
                            <a href="items" class="nav-link active">
                                <i class="bi bi-box-seam me-2"></i>商品审核
                            </a>
                        </li>
                        <li class="nav-item">
                            <a href="users" class="nav-link">
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
                <h2 class="mb-4">商品审核</h2>

                <c:if test="${not empty param.success}">
                    <div class="alert alert-success">${param.success}</div>
                </c:if>

                <c:choose>
                    <c:when test="${not empty pendingItems && pendingItems.size() > 0}">
                        <div class="row">
                            <c:forEach var="item" items="${pendingItems}">
                                <div class="col-md-6 mb-4">
                                    <div class="card h-100">
                                        <div class="card-body">
                                            <h5 class="card-title">${item.name}</h5>
                                            <p class="card-text text-muted">${item.description}</p>
                                            <p class="text-primary fw-bold fs-5">¥<fmt:formatNumber value="${item.price}" pattern="#,##0.00"/></p>
                                            <p class="text-muted">
                                                <i class="bi bi-person me-1"></i>卖家: ${item.sellerName}
                                            </p>
                                            <p class="text-muted">
                                                <i class="bi bi-tag me-1"></i>分类: ${item.category}
                                            </p>
                                            <small class="text-muted">
                                                <i class="bi bi-clock me-1"></i>
                                                <fmt:formatDate value="${item.createdAt}" pattern="yyyy-MM-dd HH:mm" />
                                            </small>
                                        </div>
                                        <div class="card-footer">
                                            <form action="items" method="post" class="d-inline">
                                                <input type="hidden" name="action" value="approve">
                                                <input type="hidden" name="id" value="${item.id}">
                                                <button type="submit" class="btn btn-success btn-sm">审核通过</button>
                                            </form>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="alert alert-info">
                            <i class="bi bi-info-circle me-2"></i>暂无待审核商品
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>