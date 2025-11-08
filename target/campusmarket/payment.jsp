<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.Map" %>
<html>
<head>
    <title>订单支付 - 在线商城</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .payment-card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            transition: transform 0.3s ease;
        }
        .payment-card:hover {
            transform: translateY(-5px);
        }
        .payment-method {
            border: 2px solid #e9ecef;
            border-radius: 10px;
            padding: 15px;
            margin-bottom: 15px;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .payment-method:hover {
            border-color: #007bff;
            background-color: #f8f9fa;
        }
        .payment-method.selected {
            border-color: #007bff;
            background-color: #e7f3ff;
        }
        .payment-icon {
            width: 40px;
            height: 40px;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 15px;
        }
        .alipay-icon {
            background: #1677FF;
        }
        .wechat-icon {
            background: #07C160;
        }
        .card-icon {
            background: #6C63FF;
        }
        .btn-pay {
            background: linear-gradient(45deg, #FF6B6B, #FF8E53);
            border: none;
            padding: 12px 30px;
            font-size: 18px;
            font-weight: bold;
            border-radius: 25px;
            width: 100%;
            margin-top: 20px;
        }
        .order-summary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 15px;
        }
    </style>
</head>
<body>
<div class="container py-4">
    <div class="row justify-content-center">
        <div class="col-lg-8">
            <!-- 页面标题 -->
            <div class="text-center mb-5">
                <h1 class="display-6 fw-bold text-primary">
                    <i class="fas fa-credit-card me-2"></i>订单支付
                </h1>
                <p class="text-muted">请完成支付以确认您的订单</p>
            </div>

            <%-- 显示错误信息 --%>
            <% if (session.getAttribute("error") != null) { %>
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="fas fa-exclamation-triangle me-2"></i>
                    <%= session.getAttribute("error") %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
                <% session.removeAttribute("error"); %>
            <% } %>

            <%-- 显示成功信息 --%>
            <% if (session.getAttribute("success") != null) { %>
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="fas fa-check-circle me-2"></i>
                    <%= session.getAttribute("success") %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
                <% session.removeAttribute("success"); %>
            <% } %>

            <%-- 检查是否有订单信息 --%>
            <% Map<String, Object> orderInfo = (Map<String, Object>) session.getAttribute("orderInfo"); %>
            <% if (orderInfo == null) { %>
                <div class="alert alert-warning text-center" role="alert">
                    <i class="fas fa-shopping-cart me-2"></i>
                    未找到订单信息，请重新选择商品购买。
                </div>
                <div class="text-center">
                    <a href="index" class="btn btn-primary btn-lg">
                        <i class="fas fa-home me-2"></i>返回首页
                    </a>
                </div>
            <% } else { %>
                <div class="row">
                    <!-- 订单信息 -->
                    <div class="col-md-6 mb-4">
                        <div class="card payment-card h-100">
                            <div class="card-header bg-primary text-white">
                                <h5 class="card-title mb-0">
                                    <i class="fas fa-receipt me-2"></i>订单详情
                                </h5>
                            </div>
                            <div class="card-body">
                                <div class="order-summary p-4 mb-4 text-center">
                                    <h4 class="fw-bold">¥<%= orderInfo.get("price") %></h4>
                                    <p class="mb-0">应付金额</p>
                                </div>

                                <div class="order-details">
                                    <div class="d-flex justify-content-between mb-3">
                                        <span class="text-muted">订单号:</span>
                                        <span class="fw-bold"><%= orderInfo.get("orderId") %></span>
                                    </div>
                                    <div class="d-flex justify-content-between mb-3">
                                        <span class="text-muted">商品名称:</span>
                                        <span class="fw-bold"><%= orderInfo.get("itemName") %></span>
                                    </div>
                                    <div class="d-flex justify-content-between mb-3">
                                        <span class="text-muted">订单时间:</span>
                                        <span class="fw-bold"><%= orderInfo.get("createTime") != null ? orderInfo.get("createTime") : "刚刚" %></span>
                                    </div>
                                    <% if (orderInfo.get("quantity") != null) { %>
                                    <div class="d-flex justify-content-between mb-3">
                                        <span class="text-muted">数量:</span>
                                        <span class="fw-bold"><%= orderInfo.get("quantity") %></span>
                                    </div>
                                    <% } %>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- 支付方式 -->
                    <div class="col-md-6 mb-4">
                        <div class="card payment-card h-100">
                            <div class="card-header bg-success text-white">
                                <h5 class="card-title mb-0">
                                    <i class="fas fa-wallet me-2"></i>选择支付方式
                                </h5>
                            </div>
                            <div class="card-body">
                                <form id="paymentForm" action="orders" method="post">
                                    <input type="hidden" name="action" value="payment">
                                    <input type="hidden" name="orderId" value="<%= orderInfo.get("orderId") %>">

                                    <div class="payment-options">
                                        <!-- 支付宝 -->
                                        <div class="payment-method" onclick="selectPayment('alipay')">
                                            <div class="form-check">
                                                <input class="form-check-input" type="radio" name="paymentMethod" id="alipay" value="alipay" checked>
                                                <label class="form-check-label d-flex align-items-center" for="alipay">
                                                    <div class="payment-icon alipay-icon">
                                                        <i class="fab fa-alipay text-white"></i>
                                                    </div>
                                                    <div>
                                                        <h6 class="mb-1">支付宝</h6>
                                                        <small class="text-muted">安全快捷的支付方式</small>
                                                    </div>
                                                </label>
                                            </div>
                                        </div>

                                        <!-- 微信支付 -->
                                        <div class="payment-method" onclick="selectPayment('wechat')">
                                            <div class="form-check">
                                                <input class="form-check-input" type="radio" name="paymentMethod" id="wechat" value="wechat">
                                                <label class="form-check-label d-flex align-items-center" for="wechat">
                                                    <div class="payment-icon wechat-icon">
                                                        <i class="fab fa-weixin text-white"></i>
                                                    </div>
                                                    <div>
                                                        <h6 class="mb-1">微信支付</h6>
                                                        <small class="text-muted">推荐微信用户使用</small>
                                                    </div>
                                                </label>
                                            </div>
                                        </div>

                                        <!-- 银行卡支付 -->
                                        <div class="payment-method" onclick="selectPayment('card')">
                                            <div class="form-check">
                                                <input class="form-check-input" type="radio" name="paymentMethod" id="card" value="card">
                                                <label class="form-check-label d-flex align-items-center" for="card">
                                                    <div class="payment-icon card-icon">
                                                        <i class="fas fa-credit-card text-white"></i>
                                                    </div>
                                                    <div>
                                                        <h6 class="mb-1">银行卡支付</h6>
                                                        <small class="text-muted">支持储蓄卡/信用卡</small>
                                                    </div>
                                                </label>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- 支付按钮 -->
                                    <button type="submit" class="btn btn-pay">
                                        <i class="fas fa-lock me-2"></i>立即支付 ¥<%= orderInfo.get("price") %>
                                    </button>

                                    <!-- 取消按钮 -->
                                    <a href="index" class="btn btn-outline-secondary w-100 mt-2">
                                        <i class="fas fa-arrow-left me-2"></i>取消支付
                                    </a>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- 安全提示 -->
                <div class="card payment-card">
                    <div class="card-body text-center">
                        <div class="row">
                            <div class="col-md-4">
                                <i class="fas fa-shield-alt text-primary fa-2x mb-2"></i>
                                <h6>支付安全</h6>
                                <small class="text-muted">银行级数据加密</small>
                            </div>
                            <div class="col-md-4">
                                <i class="fas fa-bolt text-warning fa-2x mb-2"></i>
                                <h6>极速到账</h6>
                                <small class="text-muted">实时处理订单</small>
                            </div>
                            <div class="col-md-4">
                                <i class="fas fa-headset text-success fa-2x mb-2"></i>
                                <h6>客服支持</h6>
                                <small class="text-muted">7×24小时服务</small>
                            </div>
                        </div>
                    </div>
                </div>
            <% } %>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // 支付方式选择效果
    function selectPayment(method) {
        // 移除所有选中样式
        document.querySelectorAll('.payment-method').forEach(item => {
            item.classList.remove('selected');
        });

        // 添加当前选中样式
        document.querySelector(`[for="${method}"]`).closest('.payment-method').classList.add('selected');

        // 设置radio选中
        document.getElementById(method).checked = true;
    }

    // 初始化选中第一个支付方式
    document.addEventListener('DOMContentLoaded', function() {
        selectPayment('alipay');

        // 表单提交验证
        document.getElementById('paymentForm').addEventListener('submit', function(e) {
            const submitBtn = this.querySelector('button[type="submit"]');
            submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>支付处理中...';
            submitBtn.disabled = true;
        });
    });
</script>
</body>
</html>