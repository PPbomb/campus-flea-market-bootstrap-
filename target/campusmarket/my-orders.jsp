<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>

<%@ include file="header.jsp" %>

    <div class="container mt-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2>
                <i class="bi bi-cart-check me-2"></i>我的订单
            </h2>
            <a href="index" class="btn btn-outline-primary">
                <i class="bi bi-arrow-left me-2"></i>继续购物
            </a>
        </div>

        <c:if test="${not empty param.success}">
            <div class="alert alert-success alert-dismissible fade show">
                <i class="bi bi-check-circle me-2"></i>${param.success}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <c:choose>
            <c:when test="${not empty orders && orders.size() > 0}">
                <div class="row">
                    <c:forEach var="order" items="${orders}">
                        <div class="col-md-6 mb-4">
                            <div class="card order-card h-100">
                                <div class="card-body">
                                    <div class="d-flex justify-content-between align-items-start mb-3">
                                        <h5 class="card-title">${order.itemName}</h5>
                                        <c:choose>
                                            <c:when test="${order.status == 'pending'}">
                                                <span class="badge bg-warning">待处理</span>
                                            </c:when>
                                            <c:when test="${order.status == 'completed'}">
                                                <span class="badge bg-success">已完成</span>
                                            </c:when>
                                            <c:when test="${order.status == 'cancelled'}">
                                                <span class="badge bg-secondary">已取消</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-info">${order.status}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>

                                    <c:if test="${not empty order.image}">
                                        <img src="${order.image}" class="img-fluid rounded mb-3" alt="${order.itemName}" style="max-height: 150px; width: 100%; object-fit: cover;">
                                    </c:if>

                                    <div class="mb-3">
                                        <span class="text-primary fw-bold fs-4">
                                            ¥<fmt:formatNumber value="${order.price}" pattern="#,##0.00"/>
                                        </span>
                                    </div>

                                    <p class="text-muted mb-2">
                                        <i class="bi bi-person me-1"></i>卖家: ${order.sellerName}
                                    </p>

                                    <div class="order-meta">
                                        <small class="text-muted">
                                            <i class="bi bi-clock me-1"></i>
                                            下单时间: <fmt:formatDate value="${order.createdAt}" pattern="yyyy-MM-dd HH:mm" />
                                        </small>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:when>
            <c:otherwise>
                <div class="text-center py-5">
                    <i class="bi bi-cart-x display-1 text-muted"></i>
                    <h4 class="text-muted mt-3">您还没有任何订单</h4>
                    <p class="text-muted mb-4">快去选购心仪的商品吧！</p>
                    <a href="index" class="btn btn-primary btn-lg">
                        <i class="bi bi-shop me-2"></i>去购物
                    </a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <%@ include file="footer.jsp" %>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>