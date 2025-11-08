<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>校园跳蚤市场</title>
    <script>
        // 页面加载时检查是否直接访问了JSP文件，如果是则重定向到Servlet
        if (window.location.pathname.endsWith('index.jsp')) {
            window.location.href = 'index';
        }
    </script>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css">
    <style>
        body { background-color: #f8f9fa; }
        .hero-section {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 4rem 0;
            margin-bottom: 3rem;
        }
        .card { transition: all 0.3s ease; }
        .card:hover { transform: translateY(-5px); box-shadow: 0 0.5rem 1rem rgba(0,0,0,0.15); }
        .no-items {
            background: white;
            border-radius: 10px;
            padding: 3rem;
            text-align: center;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
    </style>
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
        <div class="container">
            <a class="navbar-brand" href="index">
                <i class="bi bi-shop me-2"></i>校园跳蚤市场[web第六组开发]
            </a>

            <div class="navbar-nav ms-auto">
                <c:choose>
                    <c:when test="${not empty sessionScope.user}">
                        <span class="navbar-text me-3">
                            <i class="bi bi-person-circle me-1"></i>欢迎，${sessionScope.user.username}
                        </span>
                        <a class="nav-link" href="my-orders">
                            <i class="bi bi-cart-check me-1"></i>我的订单
                        </a>
                        <a class="nav-link" href="items?action=my">
                            <i class="bi bi-box-seam me-1"></i>我的商品
                        </a>
                        <a class="nav-link" href="add-item.jsp">
                            <i class="bi bi-plus-circle me-1"></i>发布商品
                        </a>
                        <c:if test="${sessionScope.user.role == 'admin'}">
                            <a class="nav-link" href="admin/dashboard">
                                <i class="bi bi-gear me-1"></i>管理后台
                            </a>
                        </c:if>
                        <a class="nav-link" href="logout">
                            <i class="bi bi-box-arrow-right me-1"></i>退出
                        </a>
                    </c:when>
                    <c:otherwise>
                        <a class="nav-link" href="login.jsp">
                            <i class="bi bi-box-arrow-in-right me-1"></i>登录
                        </a>
                        <a class="nav-link" href="register.jsp">
                            <i class="bi bi-person-plus me-1"></i>注册
                        </a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </nav>