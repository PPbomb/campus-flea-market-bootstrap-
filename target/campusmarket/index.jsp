<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>

 <%@ include file="header.jsp" %>

    <div class="hero-section">
        <div class="container text-center">
            <h1 class="display-4 fw-bold mb-4">校园跳蚤市场</h1>
            <p class="lead mb-4">学生闲置物品交易平台</p>
            <c:if test="${empty sessionScope.user}">
                <a href="register.jsp" class="btn btn-light btn-lg me-3">
                    <i class="bi bi-person-plus me-2"></i>立即注册
                </a>
                <a href="login.jsp" class="btn btn-outline-light btn-lg">
                    <i class="bi bi-box-arrow-in-right me-2"></i>用户登录
                </a>
            </c:if>
            <c:if test="${not empty sessionScope.user}">
                <a href="add-item.jsp" class="btn btn-light btn-lg me-3">
                    <i class="bi bi-plus-circle me-2"></i>发布商品
                </a>
                <a href="items?action=my" class="btn btn-outline-light btn-lg">
                    <i class="bi bi-box-seam me-2"></i>我的商品
                </a>
            </c:if>
        </div>
    </div>

    <div class="container mt-4">
        <!-- 登录状态提示 -->
        <c:if test="${not empty sessionScope.user}">
            <div class="alert alert-success d-flex align-items-center">
                <i class="bi bi-check-circle-fill me-2 fs-4"></i>
                <div>
                    <h5 class="mb-1">登录成功！</h5>
                    <p class="mb-0">欢迎回来，${sessionScope.user.username}！您现在可以发布商品和进行交易。</p>
                </div>
            </div>
        </c:if>

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
            <i class="bi bi-grid-3x3-gap me-2"></i>热门商品
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
                               <!-- 修改图片显示部分 -->
                               <div class="card-img-top position-relative" style="height: 200px; background: #f8f9fa; overflow: hidden;">
                                   <c:if test="${not empty item.image}">
                                       <img src="${pageContext.request.contextPath}${item.image}"
                                            class="w-100 h-100"
                                            alt="${item.name}"
                                            style="object-fit: cover;"
                                            onerror="this.style.display='none'; document.getElementById('fallback-${item.id}').style.display='flex';">
                                   </c:if>

                                   <!-- 备用显示（图片加载失败或无图片时显示） -->
                                   <div id="fallback-${item.id}"
                                        class="w-100 h-100 d-flex align-items-center justify-content-center flex-column"
                                        <c:if test="${not empty item.image}">style="display: none;"</c:if>>
                                       <i class="bi bi-image text-muted mb-2" style="font-size: 3rem;"></i>
                                       <small class="text-muted">
                                           <c:choose>
                                               <c:when test="${not empty item.image}">图片加载失败</c:when>
                                               <c:otherwise>暂无图片</c:otherwise>
                                           </c:choose>
                                       </small>
                                   </div>
                               </div>

                               <div class="card-body">
                                   <h5 class="card-title">${item.name}</h5>
                                   <p class="card-text text-muted">${item.description}</p>
                                   <p class="text-primary fw-bold fs-4">
                                       ¥<fmt:formatNumber value="${item.price}" pattern="#,##0.00"/>
                                   </p>
                                   <p class="text-muted">
                                       <i class="bi bi-person me-1"></i>卖家: ${item.sellerName}
                                   </p>
                                   <p class="text-muted">
                                       <i class="bi bi-tag me-1"></i>${item.category}
                                   </p>
                               </div>
                               <div class="card-footer">
                                   <small class="text-muted">
                                       <i class="bi bi-clock me-1"></i>
                                       <fmt:formatDate value="${item.createdAt}" pattern="yyyy-MM-dd" />
                                   </small>
                                   <c:if test="${not empty sessionScope.user && sessionScope.user.id != item.sellerId}">
                                       <div class="mt-2">
                                           <a href="orders?action=create&itemId=${item.id}" class="btn btn-primary btn-sm w-100">
                                               <i class="bi bi-cart-plus me-1"></i>立即购买
                                           </a>
                                       </div>
                                   </c:if>
                                   <c:if test="${empty sessionScope.user}">
                                       <div class="mt-2">
                                           <a href="login.jsp" class="btn btn-outline-primary btn-sm w-100">
                                               <i class="bi bi-box-arrow-in-right me-1"></i>登录后购买
                                           </a>
                                       </div>
                                   </c:if>
                               </div>
                           </div>
                       </div>
                   </c:forEach>
               </div>
           </c:when>
           <c:otherwise>
               <div class="no-items">
                   <i class="bi bi-inbox display-1 text-muted mb-3"></i>
                   <h4 class="text-muted">暂无商品</h4>
                   <p class="text-muted mb-4">目前还没有商品上架，快来发布第一个商品吧！</p>
                   <c:if test="${not empty sessionScope.user}">
                       <a href="add-item.jsp" class="btn btn-primary btn-lg">
                           <i class="bi bi-plus-circle me-2"></i>发布商品
                       </a>
                   </c:if>
                   <c:if test="${empty sessionScope.user}">
                       <p class="text-muted">登录后即可发布商品</p>
                       <a href="login.jsp" class="btn btn-primary">
                           <i class="bi bi-box-arrow-in-right me-2"></i>立即登录
                       </a>
                   </c:if>
               </div>
           </c:otherwise>
       </c:choose>
    </div>

    <%@ include file="footer.jsp" %>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>