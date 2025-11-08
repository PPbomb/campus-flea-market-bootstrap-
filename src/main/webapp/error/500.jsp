<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page isErrorPage="true" %>
<!DOCTYPE html>
<html>
<head>
    <title>服务器错误 - 500</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }
        .error-container {
            flex: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 2rem 0;
        }
        .error-content {
            text-align: center;
            max-width: 500px;
        }
        .error-code {
            font-size: 8rem;
            font-weight: bold;
            color: #ffc107;
            margin-bottom: 1rem;
        }
        .error-message {
            font-size: 1.5rem;
            margin-bottom: 2rem;
        }
        .error-details {
            text-align: left;
            background-color: #f8f9fa;
            padding: 1rem;
            border-radius: 5px;
            max-height: 200px;
            overflow-y: auto;
        }
    </style>
</head>
<body>
    <%@ include file="../header.jsp" %>
    
    <div class="error-container">
        <div class="error-content">
            <div class="error-code">500</div>
            <h1 class="error-message">服务器内部错误</h1>
            <p>处理请求时发生错误，请稍后再试。</p>
            
            <%-- 显示错误信息（开发环境）--%>
            <c:if test="${pageContext.errorData != null}">
                <div class="error-details mt-4">
                    <h5>错误详情：</h5>
                    <p>状态码: ${pageContext.errorData.statusCode}</p>
                    <p>异常类型: ${pageContext.errorData.exceptionType}</p>
                    <p>异常消息: ${pageContext.errorData.exception.message}</p>
                </div>
            </c:if>
            
            <a href="<%= request.getContextPath() %>/index.jsp" class="btn btn-primary btn-lg mt-4">
                返回首页
            </a>
            <button onclick="window.history.back()" class="btn btn-secondary btn-lg mt-4 mx-2">
                返回上一页
            </button>
        </div>
    </div>
    
    <%@ include file="../footer.jsp" %>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>