<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>

<%@ include file="header.jsp" %>

     <div class="container mt-4">
        <!-- 显示成功消息 -->
        <c:if test="${not empty requestScope.success}">
            <div class="alert alert-success">${requestScope.success}</div>
        </c:if>
        
        <!-- 显示错误消息 -->
        <c:if test="${not empty requestScope.error}">
            <div class="alert alert-danger">${requestScope.error}</div>
        </c:if>
        
        <!-- 保持对URL参数传递的success消息的支持 -->
        <c:if test="${not empty param.success}">
            <div class="alert alert-success">${param.success}</div>
        </c:if>

        <h2 class="mb-4">
            <i class="bi bi-box-seam me-2"></i>我的商品
            <c:if test="${not empty items}">
                <span class="badge bg-primary fs-6">${items.size()} 个商品</span>
            </c:if>
        </h2>

        <!-- 商品列表 -->
        <c:choose>
            <c:when test="${not empty items && items.size() > 0}">
                <div class="row" id="itemsContainer">
                    <c:forEach var="item" items="${items}">
                        <div class="col-md-4 mb-4">
                            <div class="card h-100 item-card">
                                <!-- 状态标签 -->
                                <div class="position-absolute top-0 right-0 m-2">
                                    <span class="status-badge 
                                        <c:choose>
                                            <c:when test="${item.status == 'pending'}">status-pending</c:when>
                                            <c:when test="${item.status == 'approved'}">status-approved</c:when>
                                            <c:when test="${item.status == 'sold'}">status-sold</c:when>
                                        </c:choose>
                                    ">
                                        <c:choose>
                                            <c:when test="${item.status == 'pending'}">等待审核</c:when>
                                            <c:when test="${item.status == 'approved'}">已审核</c:when>
                                            <c:when test="${item.status == 'sold'}">已售出</c:when>
                                        </c:choose>
                                    </span>
                                </div>
                                
                                <c:if test="${not empty item.image}">
                                    <img src="${pageContext.request.contextPath}${item.image}" class="card-img-top" alt="${item.name}" style="height: 200px; object-fit: cover;">
                                </c:if>
                                <c:if test="${empty item.image}">
                                    <div class="card-img-top bg-light d-flex align-items-center justify-content-center" style="height: 200px;">
                                        <i class="bi bi-image text-muted" style="font-size: 3rem;"></i>
                                    </div>
                                </c:if>
                                <div class="card-body">
                                    <h5 class="card-title">${item.name}</h5>
                                    <p class="card-text text-muted">${item.description}</p>
                                    <p class="text-primary fw-bold fs-4">
                                        ¥<fmt:formatNumber value="${item.price}" pattern="#,##0.00"/>
                                    </p>
                                    <p class="text-muted">
                                        <i class="bi bi-tag me-1"></i>${item.category}
                                    </p>
                                </div>
                                <div class="card-footer">
                                    <small class="text-muted">
                                        <i class="bi bi-clock me-1"></i>
                                        <fmt:formatDate value="${item.createdAt}" pattern="yyyy-MM-dd HH:mm" />
                                    </small>
                                    <div class="mt-2 d-grid gap-2">
                                        <!-- 根据商品状态显示不同的操作按钮 -->
                                        <c:if test="${item.status == 'pending'}">
                                            <div class="text-center text-muted">
                                                <small>商品等待审核中...</small>
                                            </div>
                                        </c:if>
                                        <c:if test="${item.status == 'approved'}">
                                            <div class="text-center">
                                                <small>商品已通过审核，正在销售中</small>
                                            </div>
                                        </c:if>
                                        <c:if test="${item.status == 'sold'}">
                                            <div class="text-center text-success">
                                                <i class="bi bi-check-circle"></i> 商品已售出
                                            </div>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:when>
            <c:otherwise>
                <div class="no-items bg-white rounded-10 p-5 text-center shadow">
                    <i class="bi bi-inbox display-1 text-muted mb-3"></i>
                    <h4 class="text-muted">暂无商品</h4>
                    <p class="text-muted mb-4">您还没有发布任何商品</p>
                    <a href="add-item.jsp" class="btn btn-primary btn-lg">
                        <i class="bi bi-plus-circle me-2"></i>发布商品
                    </a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

     <%@ include file="footer.jsp" %>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>