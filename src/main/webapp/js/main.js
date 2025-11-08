// 校园跳蚤市场JavaScript主文件

/**
 * 初始化所有功能
 */
function initCampusMarket() {
    initImagePreview();
    initFormValidation();
    initNavigation();
    initAlerts();
}

/**
 * 初始化图片预览功能
 */
function initImagePreview() {
    const imageInputs = document.querySelectorAll('input[type="file"][accept="image/*"]');
    
    imageInputs.forEach(input => {
        input.addEventListener('change', function(e) {
            const previewContainer = document.getElementById(this.id + '-preview');
            if (!previewContainer) return;
            
            // 清除之前的预览
            previewContainer.innerHTML = '';
            
            if (this.files && this.files[0]) {
                const reader = new FileReader();
                
                reader.onload = function(e) {
                    const img = document.createElement('img');
                    img.src = e.target.result;
                    img.className = 'image-preview';
                    img.alt = '图片预览';
                    previewContainer.appendChild(img);
                }
                
                reader.readAsDataURL(this.files[0]);
            }
        });
    });
}

/**
 * 初始化表单验证
 */
function initFormValidation() {
    const forms = document.querySelectorAll('form[data-validate="true"]');
    
    forms.forEach(form => {
        form.addEventListener('submit', function(e) {
            let isValid = true;
            const errorMessages = [];
            
            // 必填字段验证
            const requiredFields = this.querySelectorAll('[required]');
            requiredFields.forEach(field => {
                if (!field.value.trim()) {
                    isValid = false;
                    const label = this.querySelector(`label[for="${field.id}"]`);
                    const fieldName = label ? label.textContent : field.name || '此字段';
                    errorMessages.push(`${fieldName}不能为空`);
                    field.classList.add('is-invalid');
                } else {
                    field.classList.remove('is-invalid');
                }
            });
            
            // 密码匹配验证
            const passwordField = this.querySelector('input[name="password"]');
            const confirmPasswordField = this.querySelector('input[name="confirmPassword"]');
            if (passwordField && confirmPasswordField) {
                if (passwordField.value !== confirmPasswordField.value) {
                    isValid = false;
                    errorMessages.push('两次输入的密码不匹配');
                    confirmPasswordField.classList.add('is-invalid');
                } else {
                    confirmPasswordField.classList.remove('is-invalid');
                }
            }
            
            // 邮箱格式验证
            const emailField = this.querySelector('input[type="email"]');
            if (emailField) {
                const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                if (!emailRegex.test(emailField.value)) {
                    isValid = false;
                    errorMessages.push('请输入有效的电子邮箱地址');
                    emailField.classList.add('is-invalid');
                } else {
                    emailField.classList.remove('is-invalid');
                }
            }
            
            // 显示错误信息
            const errorContainer = this.querySelector('.error-messages');
            if (errorContainer) {
                if (!isValid) {
                    errorContainer.innerHTML = errorMessages.map(msg => `<div class="alert alert-danger">${msg}</div>`).join('');
                    errorContainer.style.display = 'block';
                } else {
                    errorContainer.innerHTML = '';
                    errorContainer.style.display = 'none';
                }
            }
            
            if (!isValid) {
                e.preventDefault();
                // 滚动到表单顶部显示错误信息
                this.scrollIntoView({ behavior: 'smooth' });
            }
        });
        
        // 输入时移除错误样式
        const inputs = form.querySelectorAll('input');
        inputs.forEach(input => {
            input.addEventListener('input', function() {
                this.classList.remove('is-invalid');
            });
        });
    });
}

/**
 * 初始化导航功能
 */
function initNavigation() {
    // 检查是否直接访问了JSP文件，如果是则重定向到Servlet
    function checkAndRedirectJsp() {
        const path = window.location.pathname;
        if (path.endsWith('.jsp') && !path.includes('WEB-INF/')) {
            const servletPath = path.replace('.jsp', '');
            window.location.href = servletPath;
        }
    }
    
    checkAndRedirectJsp();
    
    // 移动端菜单切换
    const navbarTogglers = document.querySelectorAll('.navbar-toggler');
    navbarTogglers.forEach(toggler => {
        toggler.addEventListener('click', function() {
            const target = document.querySelector(this.getAttribute('data-bs-target'));
            if (target) {
                target.classList.toggle('show');
            }
        });
    });
    
    // 导航链接高亮
    function highlightActiveNavLink() {
        const path = window.location.pathname;
        const navLinks = document.querySelectorAll('.nav-link');
        
        navLinks.forEach(link => {
            const href = link.getAttribute('href');
            if (href && (path === href || path.endsWith(href))) {
                link.classList.add('active');
            } else {
                link.classList.remove('active');
            }
        });
    }
    
    highlightActiveNavLink();
}

/**
 * 初始化提示框功能
 */
function initAlerts() {
    // 自动关闭提示框
    const alerts = document.querySelectorAll('.alert-auto-dismiss');
    alerts.forEach(alert => {
        setTimeout(() => {
            alert.style.opacity = '0';
            alert.style.transition = 'opacity 0.5s ease';
            setTimeout(() => {
                alert.remove();
            }, 500);
        }, 3000); // 3秒后自动关闭
    });
    
    // 关闭按钮功能
    const closeButtons = document.querySelectorAll('.btn-close');
    closeButtons.forEach(button => {
        button.addEventListener('click', function() {
            const alert = this.closest('.alert');
            if (alert) {
                alert.remove();
            }
        });
    });
}

/**
 * 显示加载状态
 */
function showLoading(element) {
    const originalContent = element.innerHTML;
    element.setAttribute('data-original-content', originalContent);
    element.disabled = true;
    element.innerHTML = '<span class="loading-spinner"></span> 处理中...';
}

/**
 * 隐藏加载状态
 */
function hideLoading(element) {
    const originalContent = element.getAttribute('data-original-content');
    if (originalContent) {
        element.innerHTML = originalContent;
    }
    element.disabled = false;
}

/**
 * 显示确认对话框
 */
function confirmAction(message, callback) {
    if (confirm(message)) {
        if (callback && typeof callback === 'function') {
            callback();
        }
        return true;
    }
    return false;
}

/**
 * 显示通知消息
 */
function showNotification(message, type = 'success') {
    // 创建通知元素
    const notification = document.createElement('div');
    notification.className = `alert alert-${type} fixed-bottom right-0 m-4 alert-auto-dismiss`;
    notification.style.zIndex = '9999';
    notification.innerHTML = `
        <div class="container">
            ${message}
            <button type="button" class="btn-close float-end" aria-label="Close"></button>
        </div>
    `;
    
    // 添加到页面
    document.body.appendChild(notification);
    
    // 绑定关闭按钮事件
    const closeButton = notification.querySelector('.btn-close');
    closeButton.addEventListener('click', () => notification.remove());
    
    // 自动关闭
    setTimeout(() => {
        notification.style.opacity = '0';
        notification.style.transition = 'opacity 0.5s ease';
        setTimeout(() => {
            notification.remove();
        }, 500);
    }, 3000);
}

/**
 * 格式化价格显示
 */
function formatPrice(price) {
    if (typeof price !== 'number') {
        price = parseFloat(price) || 0;
    }
    return '¥' + price.toFixed(2);
}

/**
 * 日期格式化
 */
function formatDate(date) {
    if (!date) return '';
    
    const d = new Date(date);
    const year = d.getFullYear();
    const month = String(d.getMonth() + 1).padStart(2, '0');
    const day = String(d.getDate()).padStart(2, '0');
    const hours = String(d.getHours()).padStart(2, '0');
    const minutes = String(d.getMinutes()).padStart(2, '0');
    
    return `${year}-${month}-${day} ${hours}:${minutes}`;
}

// 页面加载完成后初始化
if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initCampusMarket);
} else {
    initCampusMarket();
}

// 导出公共方法供其他脚本使用
window.CampusMarket = {
    showLoading,
    hideLoading,
    confirmAction,
    showNotification,
    formatPrice,
    formatDate
};