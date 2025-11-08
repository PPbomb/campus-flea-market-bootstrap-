<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>数据统计 - 校园跳蚤市场</title>
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
        .stat-card {
            border-radius: 8px;
            transition: transform 0.3s, box-shadow 0.3s;
            min-height: 120px;
        }
        .stat-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        }
        .stat-icon {
            font-size: 2rem;
            opacity: 0.8;
        }
        /* 统计卡片颜色类 */
        .stat-card-blue {
            background: linear-gradient(135deg, #1976d2, #1565c0);
            color: white;
        }
        .stat-card-green {
            background: linear-gradient(135deg, #388e3c, #2e7d32);
            color: white;
        }
        .stat-card-purple {
            background: linear-gradient(135deg, #6a1b9a, #4a148c);
            color: white;
        }
        .stat-card-orange {
            background: linear-gradient(135deg, #e65100, #bf360c);
            color: white;
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
                            <a href="${pageContext.request.contextPath}/admin/statistics" class="nav-link active">
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
                        <i class="bi bi-bar-chart2 me-2"></i>数据统计
                    </h2>
                    <button class="btn btn-outline-primary btn-sm" onclick="refreshData()">
                        <i class="bi bi-arrow-clockwise me-1"></i>刷新
                    </button>
                </div>

                <!-- 统计卡片 -->
                <div class="row mb-4">
                    <div class="col-md-3 col-6 mb-3">
                        <div class="stat-card stat-card-blue p-3">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <div class="small opacity-75">总商品数</div>
                                    <div class="h4 mb-0 fw-bold">${not empty totalItems ? totalItems : '0'}</div>
                                </div>
                                <i class="bi bi-box-seam stat-icon"></i>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3 col-6 mb-3">
                        <div class="stat-card stat-card-green p-3">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <div class="small opacity-75">在售商品</div>
                                    <div class="h4 mb-0 fw-bold">${not empty activeItems ? activeItems : '0'}</div>
                                </div>
                                <i class="bi bi-check-circle stat-icon"></i>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3 col-6 mb-3">
                        <div class="stat-card stat-card-purple p-3">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <div class="small opacity-75">总订单数</div>
                                    <div class="h4 mb-0 fw-bold">${not empty totalOrders ? totalOrders : '0'}</div>
                                </div>
                                <i class="bi bi-receipt stat-icon"></i>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3 col-6 mb-3">
                        <div class="stat-card stat-card-orange p-3">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <div class="small opacity-75">总交易额</div>
                                    <div class="h4 mb-0 fw-bold">${not empty totalAmount ? '¥' += totalAmount : '¥0'}</div>
                                </div>
                                <i class="bi bi-currency-yuan stat-icon"></i>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- 数据表格 -->
                <div class="row">
                    <div class="col-lg-6 mb-3">
                        <div class="card">
                            <div class="card-header bg-info text-white">
                                <div class="d-flex justify-content-between align-items-center">
                                    <span>最近发布的商品</span>
                                    <span class="badge bg-light text-dark">${not empty recentItems ? recentItems.size() : 0} 条</span>
                                </div>
                            </div>
                            <div class="card-body p-0">
                                <div class="table-responsive">
                                    <table class="table table-sm table-hover mb-0">
                                        <thead class="table-light">
                                            <tr>
                                                <th>商品名</th>
                                                <th>价格</th>
                                                <th>状态</th>
                                                <th>发布时间</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="item" items="${recentItems}">
                                                <tr>
                                                    <td class="small">${item.name}</td>
                                                    <td class="small">¥${item.price}</td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${item.status == 'pending'}">
                                                                <span class="badge bg-warning">待审核</span>
                                                            </c:when>
                                                            <c:when test="${item.status == 'approved'}">
                                                                <span class="badge bg-success">在售</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge bg-secondary">${item.status}</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td class="small">
                                                        <fmt:formatDate value="${item.createdAt}" pattern="MM-dd HH:mm" />
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                            <c:if test="${empty recentItems}">
                                                <tr>
                                                    <td colspan="4" class="text-center text-muted py-3">
                                                        暂无商品数据
                                                    </td>
                                                </tr>
                                            </c:if>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-lg-6 mb-3">
                        <div class="card">
                            <div class="card-header bg-warning text-dark">
                                <div class="d-flex justify-content-between align-items-center">
                                    <span>最近的交易记录</span>
                                    <span class="badge bg-light text-dark">${not empty recentOrders ? recentOrders.size() : 0} 条</span>
                                </div>
                            </div>
                            <div class="card-body p-0">
                                <div class="table-responsive">
                                    <table class="table table-sm table-hover mb-0">
                                        <thead class="table-light">
                                            <tr>
                                                <th>商品</th>
                                                <th>价格</th>
                                                <th>买家</th>
                                                <th>交易时间</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="order" items="${recentOrders}">
                                                <tr>
                                                    <td class="small">${order.itemName}</td>
                                                    <td class="small">¥${order.price}</td>
                                                    <td class="small">${order.buyerName}</td>
                                                    <td class="small">
                                                        <fmt:formatDate value="${order.createdAt}" pattern="MM-dd HH:mm" />
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                            <c:if test="${empty recentOrders}">
                                                <tr>
                                                    <td colspan="4" class="text-center text-muted py-3">
                                                        暂无订单数据
                                                    </td>
                                                </tr>
                                            </c:if>
                                        </tbody>
                                    </table>
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

    <script>
        // 刷新数据
        function refreshData() {
            location.reload();
        }
    </script>
</body>
</html>