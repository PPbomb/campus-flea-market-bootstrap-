<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>发布商品 - 校园跳蚤市场</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css">
    <link rel="stylesheet" href="css/style.css">
    <script>
        // 控制数量输入框的显示与隐藏
        function toggleQuantityField() {
            const type = document.getElementById('type').value;
            const quantityDiv = document.getElementById('quantityDiv');
            if (type === 'physical') {
                quantityDiv.style.display = 'block';
            } else {
                quantityDiv.style.display = 'none';
            }
        }
    </script>
</head>
<body>
    <%@ include file="header.jsp" %>

    <div class="container mt-4">
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="card">
                    <div class="card-body">
                        <h3 class="card-title text-center mb-4">
                            <i class="bi bi-plus-circle"></i> 发布商品
                        </h3>

                        <c:if test="${not empty error}">
                            <div class="alert alert-danger">${error}</div>
                        </c:if>

                        <form action="items" method="post" enctype="multipart/form-data" needs-validation>
                            <div class="mb-3">
                                <label for="name" class="form-label">商品名称</label>
                                <input type="text" class="form-control" id="name" name="name" required>
                            </div>

                            <div class="mb-3">
                                <label for="description" class="form-label">商品描述</label>
                                <textarea class="form-control" id="description" name="description" rows="3" required></textarea>
                            </div>

                            <div class="mb-3">
                                <label for="price" class="form-label">价格</label>
                                <input type="number" class="form-control" id="price" name="price" step="0.01" min="0" required>
                            </div>

                            <div class="mb-3">
                                <label for="category" class="form-label">分类</label>
                                <select class="form-select" id="category" name="category" required>
                                    <option value="">请选择分类</option>
                                    <option value="电子产品">电子产品</option>
                                    <option value="图书资料">图书资料</option>
                                    <option value="生活用品">生活用品</option>
                                    <option value="服装鞋帽">服装鞋帽</option>
                                    <option value="其他">其他</option>
                                </select>
                            </div>
                            
                            <div class="mb-3">
                                <label for="type" class="form-label">商品类型</label>
                                <select class="form-select" id="type" name="type" onchange="toggleQuantityField()" required>
                                    <option value="">请选择类型</option>
                                    <option value="physical">实物类</option>
                                    <option value="service">服务类</option>
                                </select>
                            </div>
                            
                            <div class="mb-3" id="quantityDiv">
                                <label for="quantity" class="form-label">数量</label>
                                <input type="number" class="form-control" id="quantity" name="quantity" min="1" value="1" required>
                            </div>

                            <div class="mb-3">
                                <label for="image" class="form-label">商品图片</label>
                                <input type="file" class="form-control" id="image" name="image" accept="image/*">
                                <div class="form-text">支持JPG、PNG等图片格式，最大10MB</div>
                                <!-- 图片预览区域 -->
                                <div id="imagePreview" class="image-preview-container mt-2"></div>
                            </div>

                            <button type="submit" class="btn btn-primary w-100">
                                <i class="bi bi-check-circle"></i> 发布商品
                            </button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <%@ include file="footer.jsp" %>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <!-- 自定义JS -->
    <script src="js/script.js"></script>
</body>
</html>