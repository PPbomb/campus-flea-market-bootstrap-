// 校园跳蚤市场通知模块

/**
 * 显示通知消息
 * @param {string} message - 通知消息内容
 * @param {string} type - 通知类型：success, error, warning, info
 * @param {number} duration - 通知显示时长（毫秒），默认3000ms
 */
function showNotification(message, type = 'info', duration = 3000) {
    const notificationContainer = getNotificationContainer();
    const notification = createNotification(message, type);
    
    // 添加到容器
    notificationContainer.appendChild(notification);
    
    // 触发动画
    setTimeout(() => {
        notification.classList.add('show');
    }, 10);
    
    // 设置自动关闭
    if (duration > 0) {
        setTimeout(() => {
            closeNotification(notification);
        }, duration);
    }
    
    // 返回通知元素，便于手动关闭
    return notification;
}

/**
 * 获取或创建通知容器
 */
function getNotificationContainer() {
    let container = document.getElementById('notification-container');
    
    if (!container) {
        container = document.createElement('div');
        container.id = 'notification-container';
        container.className = 'notification-container';
        document.body.appendChild(container);
        
        // 注入样式
        injectNotificationStyles();
    }
    
    return container;
}

/**
 * 创建通知元素
 */
function createNotification(message, type) {
    const notification = document.createElement('div');
    notification.className = `notification notification-${type}`;
    
    // 设置图标
    const icon = getNotificationIcon(type);
    
    // 设置内容
    notification.innerHTML = `
        <div class="notification-icon">
            <i class="bi ${icon}"></i>
        </div>
        <div class="notification-content">
            ${message}
        </div>
        <button type="button" class="notification-close">
            <i class="bi bi-x"></i>
        </button>
    `;
    
    // 添加关闭事件
    const closeButton = notification.querySelector('.notification-close');
    closeButton.addEventListener('click', () => {
        closeNotification(notification);
    });
    
    return notification;
}

/**
 * 获取通知图标
 */
function getNotificationIcon(type) {
    const icons = {
        success: 'bi-check-circle',
        error: 'bi-x-circle',
        warning: 'bi-exclamation-triangle',
        info: 'bi-info-circle'
    };
    
    return icons[type] || 'bi-info-circle';
}

/**
 * 关闭通知
 */
function closeNotification(notification) {
    notification.classList.remove('show');
    
    // 等待动画完成后移除元素
    setTimeout(() => {
        if (notification.parentNode) {
            notification.parentNode.removeChild(notification);
        }
    }, 300);
}

/**
 * 关闭所有通知
 */
function closeAllNotifications() {
    const container = document.getElementById('notification-container');
    if (container) {
        const notifications = container.querySelectorAll('.notification');
        notifications.forEach(notification => {
            closeNotification(notification);
        });
    }
}

/**
 * 显示成功通知
 */
function showSuccessNotification(message, duration = 3000) {
    return showNotification(message, 'success', duration);
}

/**
 * 显示错误通知
 */
function showErrorNotification(message, duration = 5000) {
    return showNotification(message, 'error', duration);
}

/**
 * 显示警告通知
 */
function showWarningNotification(message, duration = 4000) {
    return showNotification(message, 'warning', duration);
}

/**
 * 显示信息通知
 */
function showInfoNotification(message, duration = 3000) {
    return showNotification(message, 'info', duration);
}

/**
 * 显示确认对话框
 * @param {string} message - 确认消息内容
 * @param {function} onConfirm - 确认回调函数
 * @param {function} onCancel - 取消回调函数
 * @param {string} confirmText - 确认按钮文本
 * @param {string} cancelText - 取消按钮文本
 */
function confirmAction(message, onConfirm, onCancel = null, confirmText = '确定', cancelText = '取消') {
    // 创建对话框容器
    const dialogContainer = document.createElement('div');
    dialogContainer.className = 'confirm-dialog-overlay';
    
    dialogContainer.innerHTML = `
        <div class="confirm-dialog">
            <div class="confirm-dialog-content">
                <div class="confirm-dialog-message">${message}</div>
                <div class="confirm-dialog-buttons">
                    <button type="button" class="confirm-dialog-cancel btn btn-secondary">${cancelText}</button>
                    <button type="button" class="confirm-dialog-confirm btn btn-primary">${confirmText}</button>
                </div>
            </div>
        </div>
    `;
    
    // 注入样式
    injectDialogStyles();
    
    // 添加到文档
    document.body.appendChild(dialogContainer);
    
    // 触发动画
    setTimeout(() => {
        dialogContainer.classList.add('show');
    }, 10);
    
    // 绑定事件
    const cancelButton = dialogContainer.querySelector('.confirm-dialog-cancel');
    const confirmButton = dialogContainer.querySelector('.confirm-dialog-confirm');
    
    const removeDialog = () => {
        dialogContainer.classList.remove('show');
        setTimeout(() => {
            if (dialogContainer.parentNode) {
                dialogContainer.parentNode.removeChild(dialogContainer);
            }
        }, 300);
    };
    
    cancelButton.addEventListener('click', () => {
        if (typeof onCancel === 'function') {
            onCancel();
        }
        removeDialog();
    });
    
    confirmButton.addEventListener('click', () => {
        if (typeof onConfirm === 'function') {
            onConfirm();
        }
        removeDialog();
    });
    
    // ESC键关闭
    const handleEsc = (e) => {
        if (e.key === 'Escape') {
            if (typeof onCancel === 'function') {
                onCancel();
            }
            removeDialog();
            document.removeEventListener('keydown', handleEsc);
        }
    };
    
    document.addEventListener('keydown', handleEsc);
}

/**
 * 显示加载状态
 */
function showLoading(message = '加载中...') {
    let loadingElement = document.getElementById('loading-overlay');
    
    if (!loadingElement) {
        loadingElement = document.createElement('div');
        loadingElement.id = 'loading-overlay';
        loadingElement.className = 'loading-overlay';
        
        loadingElement.innerHTML = `
            <div class="loading-spinner">
                <div class="spinner-border" role="status">
                    <span class="visually-hidden">加载中...</span>
                </div>
                <div class="loading-message">${message}</div>
            </div>
        `;
        
        document.body.appendChild(loadingElement);
        injectLoadingStyles();
    } else {
        // 更新消息
        const messageElement = loadingElement.querySelector('.loading-message');
        if (messageElement) {
            messageElement.textContent = message;
        }
    }
    
    // 显示加载层
    setTimeout(() => {
        loadingElement.classList.add('show');
    }, 10);
    
    // 禁止页面滚动
    document.body.style.overflow = 'hidden';
}

/**
 * 隐藏加载状态
 */
function hideLoading() {
    const loadingElement = document.getElementById('loading-overlay');
    if (loadingElement) {
        loadingElement.classList.remove('show');
        
        setTimeout(() => {
            if (loadingElement.parentNode) {
                loadingElement.parentNode.removeChild(loadingElement);
            }
        }, 300);
    }
    
    // 恢复页面滚动
    document.body.style.overflow = '';
}

/**
 * 注入通知样式
 */
function injectNotificationStyles() {
    if (document.getElementById('notification-styles')) return;
    
    const style = document.createElement('style');
    style.id = 'notification-styles';
    style.textContent = `
        .notification-container {
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 1055;
            display: flex;
            flex-direction: column;
            gap: 10px;
        }
        
        .notification {
            display: flex;
            align-items: center;
            padding: 12px 16px;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
            max-width: 350px;
            opacity: 0;
            transform: translateX(100%);
            transition: all 0.3s ease;
            background-color: #fff;
        }
        
        .notification.show {
            opacity: 1;
            transform: translateX(0);
        }
        
        .notification-icon {
            margin-right: 12px;
            font-size: 1.25rem;
        }
        
        .notification-content {
            flex: 1;
            word-break: break-word;
        }
        
        .notification-close {
            background: none;
            border: none;
            font-size: 1.25rem;
            cursor: pointer;
            padding: 0;
            margin-left: 12px;
            color: #6c757d;
            width: 24px;
            height: 24px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 50%;
            transition: all 0.2s ease;
        }
        
        .notification-close:hover {
            background-color: rgba(0, 0, 0, 0.05);
            color: #000;
        }
        
        .notification-success {
            border-left: 4px solid #198754;
        }
        
        .notification-success .notification-icon {
            color: #198754;
        }
        
        .notification-error {
            border-left: 4px solid #dc3545;
        }
        
        .notification-error .notification-icon {
            color: #dc3545;
        }
        
        .notification-warning {
            border-left: 4px solid #ffc107;
        }
        
        .notification-warning .notification-icon {
            color: #ffc107;
        }
        
        .notification-info {
            border-left: 4px solid #0dcaf0;
        }
        
        .notification-info .notification-icon {
            color: #0dcaf0;
        }
    `;
    
    document.head.appendChild(style);
}

/**
 * 注入对话框样式
 */
function injectDialogStyles() {
    if (document.getElementById('dialog-styles')) return;
    
    const style = document.createElement('style');
    style.id = 'dialog-styles';
    style.textContent = `
        .confirm-dialog-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5);
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 1055;
            opacity: 0;
            transition: opacity 0.3s ease;
        }
        
        .confirm-dialog-overlay.show {
            opacity: 1;
        }
        
        .confirm-dialog {
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
            max-width: 400px;
            width: 90%;
            transform: scale(0.9);
            transition: transform 0.3s ease;
        }
        
        .confirm-dialog-overlay.show .confirm-dialog {
            transform: scale(1);
        }
        
        .confirm-dialog-content {
            padding: 20px;
        }
        
        .confirm-dialog-message {
            margin-bottom: 20px;
            font-size: 1rem;
            line-height: 1.5;
        }
        
        .confirm-dialog-buttons {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
        }
    `;
    
    document.head.appendChild(style);
}

/**
 * 注入加载样式
 */
function injectLoadingStyles() {
    if (document.getElementById('loading-styles')) return;
    
    const style = document.createElement('style');
    style.id = 'loading-styles';
    style.textContent = `
        .loading-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(255, 255, 255, 0.8);
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 1060;
            opacity: 0;
            visibility: hidden;
            transition: all 0.3s ease;
        }
        
        .loading-overlay.show {
            opacity: 1;
            visibility: visible;
        }
        
        .loading-spinner {
            text-align: center;
        }
        
        .loading-spinner .spinner-border {
            width: 3rem;
            height: 3rem;
            margin-bottom: 16px;
        }
        
        .loading-message {
            font-size: 1rem;
            color: #495057;
        }
    `;
    
    document.head.appendChild(style);
}

// 导出公共方法
window.Notification = {
    show: showNotification,
    success: showSuccessNotification,
    error: showErrorNotification,
    warning: showWarningNotification,
    info: showInfoNotification,
    closeAll: closeAllNotifications,
    confirm: confirmAction,
    showLoading,
    hideLoading
};