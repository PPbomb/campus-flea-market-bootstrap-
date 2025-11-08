// 校园跳蚤市场图片处理模块

/**
 * 初始化图片相关功能
 */
function initImageFunctions() {
    initImageUpload();
    initImagePreview();
    initImageErrorHandling();
}

/**
 * 初始化图片上传验证
 */
function initImageUpload() {
    const imageInputs = document.querySelectorAll('input[type="file"][accept="image/*"]');
    
    imageInputs.forEach(input => {
        // 添加文件类型和大小验证
        input.addEventListener('change', function(e) {
            const file = this.files[0];
            if (!file) return;
            
            // 重置之前的错误提示
            const errorElement = document.getElementById(this.id + '-error');
            if (errorElement) {
                errorElement.remove();
            }
            
            // 文件类型验证
            const validTypes = ['image/jpeg', 'image/jpg', 'image/png', 'image/gif', 'image/webp'];
            if (!validTypes.includes(file.type)) {
                showFileError(this, '请上传有效的图片文件（JPG、PNG、GIF、WebP）');
                this.value = '';
                return;
            }
            
            // 文件大小验证（最大10MB）
            const maxSize = 10 * 1024 * 1024; // 10MB
            if (file.size > maxSize) {
                showFileError(this, '图片大小不能超过10MB');
                this.value = '';
                return;
            }
        });
    });
}

/**
 * 初始化图片预览功能
 */
function initImagePreview() {
    const imageInputs = document.querySelectorAll('input[type="file"][accept="image/*"]');
    
    imageInputs.forEach(input => {
        input.addEventListener('change', function(e) {
            if (!this.files || !this.files[0]) return;
            
            // 查找或创建预览容器
            let previewContainer = document.getElementById(this.id + '-preview');
            if (!previewContainer) {
                previewContainer = document.createElement('div');
                previewContainer.id = this.id + '-preview';
                previewContainer.className = 'image-preview-container mt-2';
                
                // 插入到输入框之后
                this.parentNode.insertBefore(previewContainer, this.nextSibling);
            }
            
            // 清除之前的预览内容
            previewContainer.innerHTML = '';
            
            // 创建预览图片
            const reader = new FileReader();
            reader.onload = function(e) {
                const previewWrapper = document.createElement('div');
                previewWrapper.className = 'preview-wrapper';
                
                const img = document.createElement('img');
                img.src = e.target.result;
                img.className = 'preview-image';
                img.alt = '图片预览';
                
                // 创建移除按钮
                const removeBtn = document.createElement('button');
                removeBtn.type = 'button';
                removeBtn.className = 'remove-preview-btn btn btn-danger btn-sm';
                removeBtn.innerHTML = '<i class="bi bi-x"></i> 移除';
                removeBtn.addEventListener('click', function() {
                    input.value = '';
                    previewContainer.innerHTML = '';
                });
                
                previewWrapper.appendChild(img);
                previewWrapper.appendChild(removeBtn);
                previewContainer.appendChild(previewWrapper);
            };
            
            reader.readAsDataURL(this.files[0]);
        });
    });
}

/**
 * 初始化图片加载错误处理
 */
function initImageErrorHandling() {
    // 为所有图片添加错误处理
    const images = document.querySelectorAll('img');
    
    images.forEach(img => {
        // 如果已经有onerror处理，则保留
        if (!img.hasAttribute('onerror')) {
            img.onerror = function() {
                handleImageError(this);
            };
        }
    });
    
    // 监听动态加载的图片
    const observer = new MutationObserver(mutations => {
        mutations.forEach(mutation => {
            mutation.addedNodes.forEach(node => {
                if (node.tagName === 'IMG') {
                    node.onerror = function() {
                        handleImageError(this);
                    };
                } else if (node.querySelectorAll) {
                    const newImages = node.querySelectorAll('img');
                    newImages.forEach(img => {
                        img.onerror = function() {
                            handleImageError(this);
                        };
                    });
                }
            });
        });
    });
    
    observer.observe(document.body, {
        childList: true,
        subtree: true
    });
}

/**
 * 处理图片加载错误
 */
function handleImageError(imgElement) {
    // 保存原始图片信息
    const originalSrc = imgElement.src;
    const originalAlt = imgElement.alt || '图片';
    
    // 创建占位符样式
    const width = imgElement.offsetWidth || 200;
    const height = imgElement.offsetHeight || 200;
    
    // 移除原图片属性，添加占位符样式
    imgElement.src = '';
    imgElement.alt = `${originalAlt} (加载失败)`;
    imgElement.style.width = `${width}px`;
    imgElement.style.height = `${height}px`;
    imgElement.style.backgroundColor = '#f8f9fa';
    imgElement.style.display = 'flex';
    imgElement.style.justifyContent = 'center';
    imgElement.style.alignItems = 'center';
    imgElement.style.color = '#6c757d';
    imgElement.style.fontSize = '2rem';
    imgElement.style.textAlign = 'center';
    
    // 移除图片标签，替换为占位符div
    const placeholder = document.createElement('div');
    placeholder.className = 'image-placeholder';
    placeholder.style.width = `${width}px`;
    placeholder.style.height = `${height}px`;
    placeholder.style.backgroundColor = '#f8f9fa';
    placeholder.style.display = 'flex';
    placeholder.style.justifyContent = 'center';
    placeholder.style.alignItems = 'center';
    placeholder.style.color = '#6c757d';
    placeholder.style.fontSize = '2rem';
    placeholder.style.textAlign = 'center';
    placeholder.style.border = '1px dashed #dee2e6';
    placeholder.style.borderRadius = '0.25rem';
    placeholder.innerHTML = '<i class="bi bi-image"></i><br><span style="font-size: 0.875rem;">图片加载失败</span>';
    
    // 添加点击重试功能
    placeholder.addEventListener('click', function() {
        // 移除占位符，恢复图片
        placeholder.replaceWith(imgElement);
        imgElement.src = originalSrc;
        // 重置样式
        imgElement.style = '';
    });
    
    // 替换图片
    imgElement.parentNode.replaceChild(placeholder, imgElement);
}

/**
 * 显示文件上传错误
 */
function showFileError(inputElement, message) {
    // 检查是否已有错误提示
    let errorElement = document.getElementById(inputElement.id + '-error');
    if (!errorElement) {
        errorElement = document.createElement('div');
        errorElement.id = inputElement.id + '-error';
        errorElement.className = 'text-danger small mt-1';
        // 插入到输入框之后
        inputElement.parentNode.insertBefore(errorElement, inputElement.nextSibling);
    }
    
    // 设置错误消息
    errorElement.textContent = message;
    
    // 5秒后自动隐藏错误消息
    setTimeout(() => {
        errorElement.textContent = '';
    }, 5000);
}

/**
 * 验证图片URL是否有效
 */
async function isValidImageUrl(url) {
    try {
        const response = await fetch(url, {
            method: 'HEAD',
            cache: 'no-cache'
        });
        
        // 检查响应是否成功且内容类型是图片
        return response.ok && response.headers.get('content-type')?.startsWith('image/');
    } catch (error) {
        return false;
    }
}

/**
 * 获取图片的自然尺寸
 */
function getImageNaturalSize(imgElement) {
    return new Promise((resolve) => {
        if (imgElement.complete) {
            resolve({
                width: imgElement.naturalWidth,
                height: imgElement.naturalHeight
            });
        } else {
            imgElement.onload = () => {
                resolve({
                    width: imgElement.naturalWidth,
                    height: imgElement.naturalHeight
                });
            };
            imgElement.onerror = () => {
                resolve(null);
            };
        }
    });
}

// 图片预览样式
function injectImageStyles() {
    const style = document.createElement('style');
    style.textContent = `
        .image-preview-container {
            margin-top: 0.5rem;
        }
        
        .preview-wrapper {
            position: relative;
            display: inline-block;
            margin-top: 0.5rem;
        }
        
        .preview-image {
            max-width: 200px;
            max-height: 150px;
            border: 1px solid #dee2e6;
            border-radius: 0.25rem;
            object-fit: contain;
        }
        
        .remove-preview-btn {
            position: absolute;
            top: -10px;
            right: -10px;
            background-color: #dc3545;
            color: white;
            border: none;
            border-radius: 50%;
            width: 24px;
            height: 24px;
            display: flex;
            justify-content: center;
            align-items: center;
            cursor: pointer;
            font-size: 12px;
        }
        
        .image-placeholder {
            cursor: pointer;
            transition: all 0.2s ease;
        }
        
        .image-placeholder:hover {
            background-color: #e9ecef;
            border-color: #adb5bd;
        }
    `;
    
    document.head.appendChild(style);
}

// 页面加载完成后初始化
if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', () => {
        injectImageStyles();
        initImageFunctions();
    });
} else {
    injectImageStyles();
    initImageFunctions();
}

// 导出公共方法
window.ImageHandler = {
    initImageFunctions,
    isValidImageUrl,
    getImageNaturalSize,
    handleImageError
};