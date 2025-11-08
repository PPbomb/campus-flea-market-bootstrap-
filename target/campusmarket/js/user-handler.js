// 校园跳蚤市场用户处理模块

/**
 * 初始化用户相关功能
 */
function initUserFunctions() {
    initLoginForm();
    initRegisterForm();
    initUserProfile();
    initPasswordReset();
    initLogout();
}

/**
 * 初始化登录表单
 */
function initLoginForm() {
    const loginForm = document.getElementById('login-form');
    if (loginForm) {
        loginForm.addEventListener('submit', function(e) {
            e.preventDefault();
            
            // 验证表单
            const username = document.getElementById('username');
            const password = document.getElementById('password');
            let isValid = true;
            
            // 清除之前的错误消息
            clearFormErrors(this);
            
            // 验证用户名
            if (!username.value.trim()) {
                showFormError(username, '请输入用户名');
                isValid = false;
            }
            
            // 验证密码
            if (!password.value.trim()) {
                showFormError(password, '请输入密码');
                isValid = false;
            }
            
            if (isValid) {
                // 添加加载状态
                const submitButton = this.querySelector('button[type="submit"]');
                if (submitButton) {
                    submitButton.disabled = true;
                    submitButton.innerHTML = '<i class="bi bi-spinner bi-spin"></i> 登录中...';
                }
                
                // 提交表单
                this.submit();
            }
        });
        
        // 添加记住我功能
        const rememberMe = document.getElementById('remember-me');
        if (rememberMe) {
            // 可以在这里添加记住用户的逻辑
        }
    }
}

/**
 * 初始化注册表单
 */
function initRegisterForm() {
    const registerForm = document.getElementById('register-form');
    if (registerForm) {
        registerForm.addEventListener('submit', function(e) {
            e.preventDefault();
            
            // 获取表单元素
            const username = document.getElementById('username');
            const email = document.getElementById('email');
            const password = document.getElementById('password');
            const confirmPassword = document.getElementById('confirm-password');
            const agreeTerms = document.getElementById('agree-terms');
            
            // 清除之前的错误消息
            clearFormErrors(this);
            
            let isValid = true;
            
            // 验证用户名
            if (!username.value.trim()) {
                showFormError(username, '请输入用户名');
                isValid = false;
            } else if (username.value.trim().length < 3) {
                showFormError(username, '用户名至少需要3个字符');
                isValid = false;
            }
            
            // 验证邮箱
            if (!email.value.trim()) {
                showFormError(email, '请输入邮箱');
                isValid = false;
            } else if (!isValidEmail(email.value.trim())) {
                showFormError(email, '请输入有效的邮箱地址');
                isValid = false;
            }
            
            // 验证密码
            if (!password.value.trim()) {
                showFormError(password, '请输入密码');
                isValid = false;
            } else if (password.value.trim().length < 6) {
                showFormError(password, '密码至少需要6个字符');
                isValid = false;
            }
            
            // 验证确认密码
            if (!confirmPassword.value.trim()) {
                showFormError(confirmPassword, '请确认密码');
                isValid = false;
            } else if (confirmPassword.value !== password.value) {
                showFormError(confirmPassword, '两次输入的密码不一致');
                isValid = false;
            }
            
            // 验证同意条款
            if (!agreeTerms.checked) {
                showFormError(agreeTerms, '请同意用户协议和隐私政策');
                isValid = false;
            }
            
            if (isValid) {
                // 添加加载状态
                const submitButton = this.querySelector('button[type="submit"]');
                if (submitButton) {
                    submitButton.disabled = true;
                    submitButton.innerHTML = '<i class="bi bi-spinner bi-spin"></i> 注册中...';
                }
                
                // 提交表单
                this.submit();
            }
        });
        
        // 添加密码强度提示
        const passwordInput = document.getElementById('password');
        if (passwordInput) {
            passwordInput.addEventListener('input', function() {
                const password = this.value;
                const strengthIndicator = document.getElementById('password-strength');
                
                if (!strengthIndicator) {
                    const indicator = document.createElement('div');
                    indicator.id = 'password-strength';
                    indicator.className = 'small mt-1';
                    this.parentNode.appendChild(indicator);
                }
                
                const strength = getPasswordStrength(password);
                updatePasswordStrengthIndicator(strength);
            });
        }
    }
}

/**
 * 初始化用户个人资料功能
 */
function initUserProfile() {
    const profileForm = document.getElementById('profile-form');
    if (profileForm) {
        profileForm.addEventListener('submit', function(e) {
            e.preventDefault();
            
            // 验证表单
            let isValid = true;
            
            // 清除之前的错误消息
            clearFormErrors(this);
            
            // 验证邮箱
            const email = document.getElementById('email');
            if (email && !isValidEmail(email.value.trim())) {
                showFormError(email, '请输入有效的邮箱地址');
                isValid = false;
            }
            
            // 验证手机号
            const phone = document.getElementById('phone');
            if (phone && phone.value.trim() && !isValidPhone(phone.value.trim())) {
                showFormError(phone, '请输入有效的手机号');
                isValid = false;
            }
            
            if (isValid) {
                // 添加加载状态
                const submitButton = this.querySelector('button[type="submit"]');
                if (submitButton) {
                    submitButton.disabled = true;
                    submitButton.innerHTML = '<i class="bi bi-spinner bi-spin"></i> 保存中...';
                }
                
                // 提交表单
                this.submit();
            }
        });
    }
}

/**
 * 初始化密码重置功能
 */
function initPasswordReset() {
    const resetForm = document.getElementById('password-reset-form');
    if (resetForm) {
        resetForm.addEventListener('submit', function(e) {
            e.preventDefault();
            
            // 获取表单元素
            const currentPassword = document.getElementById('current-password');
            const newPassword = document.getElementById('new-password');
            const confirmNewPassword = document.getElementById('confirm-new-password');
            
            // 清除之前的错误消息
            clearFormErrors(this);
            
            let isValid = true;
            
            // 验证当前密码
            if (!currentPassword.value.trim()) {
                showFormError(currentPassword, '请输入当前密码');
                isValid = false;
            }
            
            // 验证新密码
            if (!newPassword.value.trim()) {
                showFormError(newPassword, '请输入新密码');
                isValid = false;
            } else if (newPassword.value.trim().length < 6) {
                showFormError(newPassword, '新密码至少需要6个字符');
                isValid = false;
            }
            
            // 验证确认新密码
            if (!confirmNewPassword.value.trim()) {
                showFormError(confirmNewPassword, '请确认新密码');
                isValid = false;
            } else if (confirmNewPassword.value !== newPassword.value) {
                showFormError(confirmNewPassword, '两次输入的新密码不一致');
                isValid = false;
            }
            
            // 检查新密码是否与当前密码相同
            if (isValid && currentPassword.value === newPassword.value) {
                showFormError(newPassword, '新密码不能与当前密码相同');
                isValid = false;
            }
            
            if (isValid) {
                // 添加加载状态
                const submitButton = this.querySelector('button[type="submit"]');
                if (submitButton) {
                    submitButton.disabled = true;
                    submitButton.innerHTML = '<i class="bi bi-spinner bi-spin"></i> 重置中...';
                }
                
                // 提交表单
                this.submit();
            }
        });
    }
}

/**
 * 初始化登出功能
 */
function initLogout() {
    const logoutButtons = document.querySelectorAll('.logout-btn');
    
    logoutButtons.forEach(button => {
        button.addEventListener('click', function(e) {
            e.preventDefault();
            
            confirmAction('确定要退出登录吗？', () => {
                // 添加加载状态
                button.disabled = true;
                button.innerHTML = '<i class="bi bi-spinner bi-spin"></i> 退出中...';
                
                // 提交登出请求
                window.location.href = '${pageContext.request.contextPath}/logout';
            });
        });
    });
}

/**
 * 验证邮箱格式
 */
function isValidEmail(email) {
    const re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return re.test(email);
}

/**
 * 验证手机号格式
 */
function isValidPhone(phone) {
    const re = /^1[3-9]\d{9}$/;
    return re.test(phone);
}

/**
 * 计算密码强度
 */
function getPasswordStrength(password) {
    let strength = 0;
    
    // 密码长度
    if (password.length >= 8) strength++;
    
    // 包含小写字母
    if (/[a-z]/.test(password)) strength++;
    
    // 包含大写字母
    if (/[A-Z]/.test(password)) strength++;
    
    // 包含数字
    if (/[0-9]/.test(password)) strength++;
    
    // 包含特殊字符
    if (/[^A-Za-z0-9]/.test(password)) strength++;
    
    return strength;
}

/**
 * 更新密码强度指示器
 */
function updatePasswordStrengthIndicator(strength) {
    const indicator = document.getElementById('password-strength');
    if (!indicator) return;
    
    let text = '';
    let className = '';
    
    switch (strength) {
        case 0:
            text = '请输入密码';
            className = 'text-secondary';
            break;
        case 1:
            text = '密码强度：弱';
            className = 'text-danger';
            break;
        case 2:
            text = '密码强度：中';
            className = 'text-warning';
            break;
        case 3:
            text = '密码强度：良好';
            className = 'text-info';
            break;
        case 4:
        case 5:
            text = '密码强度：强';
            className = 'text-success';
            break;
    }
    
    // 移除所有类名
    indicator.className = 'small mt-1';
    // 添加新类名
    indicator.classList.add(className);
    // 设置文本
    indicator.textContent = text;
    
    // 添加进度条
    if (strength > 0) {
        const progress = (strength / 5) * 100;
        let progressClass = 'bg-danger';
        
        if (strength >= 3) progressClass = 'bg-warning';
        if (strength >= 4) progressClass = 'bg-success';
        
        const progressBar = document.getElementById('password-progress');
        if (!progressBar) {
            const bar = document.createElement('div');
            bar.id = 'password-progress';
            bar.className = 'mt-1 w-100 bg-light rounded-full h-2.5';
            bar.innerHTML = `<div class="h-2.5 rounded-full ${progressClass}" style="width: ${progress}%"></div>`;
            indicator.parentNode.appendChild(bar);
        } else {
            const fill = progressBar.querySelector('div');
            fill.className = `h-2.5 rounded-full ${progressClass}`;
            fill.style.width = `${progress}%`;
        }
    }
}

/**
 * 显示表单错误
 */
function showFormError(inputElement, message) {
    inputElement.classList.add('is-invalid');
    
    // 检查是否已有错误消息元素
    let errorElement = inputElement.nextElementSibling;
    if (!errorElement || !errorElement.classList.contains('invalid-feedback')) {
        errorElement = document.createElement('div');
        errorElement.className = 'invalid-feedback';
        inputElement.parentNode.appendChild(errorElement);
    }
    
    errorElement.textContent = message;
    
    // 添加焦点事件移除错误样式
    const handleFocus = function() {
        this.classList.remove('is-invalid');
        this.removeEventListener('focus', handleFocus);
    };
    
    inputElement.addEventListener('focus', handleFocus);
}

/**
 * 清除表单错误
 */
function clearFormErrors(form) {
    const errorElements = form.querySelectorAll('.is-invalid');
    errorElements.forEach(element => {
        element.classList.remove('is-invalid');
    });
    
    const feedbackElements = form.querySelectorAll('.invalid-feedback');
    feedbackElements.forEach(element => {
        element.textContent = '';
    });
    
    const errorContainers = form.querySelectorAll('.form-errors');
    errorContainers.forEach(container => {
        container.remove();
    });
}

/**
 * 显示用户通知
 */
function showUserNotification(message, type = 'info') {
    // 可以复用之前定义的showNotification函数
    showNotification(message, type);
}

/**
 * 获取用户会话信息
 */
function getUserSession() {
    const sessionData = sessionStorage.getItem('userSession');
    return sessionData ? JSON.parse(sessionData) : null;
}

/**
 * 保存用户会话信息
 */
function saveUserSession(userData) {
    sessionStorage.setItem('userSession', JSON.stringify(userData));
}

/**
 * 清除用户会话信息
 */
function clearUserSession() {
    sessionStorage.removeItem('userSession');
}

/**
 * 检查用户是否已登录
 */
function isUserLoggedIn() {
    return !!getUserSession();
}

/**
 * 页面加载完成后初始化
 */
if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', () => {
        initUserFunctions();
    });
} else {
    initUserFunctions();
}

// 导出公共方法
window.UserHandler = {
    initUserFunctions,
    isValidEmail,
    isValidPhone,
    getPasswordStrength,
    getUserSession,
    saveUserSession,
    clearUserSession,
    isUserLoggedIn,
    showUserNotification
};