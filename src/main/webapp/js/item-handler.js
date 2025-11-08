// 校园跳蚤市场商品处理模块

/**
 * 初始化商品相关功能
 */
function initItemFunctions() {
    initItemSearch();
    initCategoryFilter();
    initPriceFilter();
    initSorting();
    initItemActions();
    initWishlistFunctions();
}

/**
 * 初始化商品搜索功能
 */
function initItemSearch() {
    const searchForm = document.getElementById('item-search-form');
    const searchInput = document.getElementById('search-input');
    
    if (searchForm) {
        searchForm.addEventListener('submit', function(e) {
            e.preventDefault();
            const searchTerm = searchInput.value.trim();
            
            if (searchTerm.length < 2 && searchTerm.length > 0) {
                showNotification('搜索关键词至少需要2个字符', 'warning');
                return;
            }
            
            this.submit();
        });
    }
    
    if (searchInput) {
        // 添加即时搜索提示
        searchInput.addEventListener('input', function() {
            const searchTerm = this.value.trim();
            const searchHint = document.getElementById('search-hint');
            
            if (searchTerm.length > 0 && searchTerm.length < 2) {
                if (!searchHint) {
                    const hint = document.createElement('div');
                    hint.id = 'search-hint';
                    hint.className = 'text-warning small mt-1';
                    hint.textContent = '搜索关键词至少需要2个字符';
                    this.parentNode.appendChild(hint);
                }
            } else if (searchHint) {
                searchHint.remove();
            }
        });
    }
}

/**
 * 初始化分类筛选功能
 */
function initCategoryFilter() {
    const categorySelect = document.getElementById('category-filter');
    
    if (categorySelect) {
        categorySelect.addEventListener('change', function() {
            const form = this.closest('form');
            if (form) {
                // 添加加载状态
                const submitButton = form.querySelector('button[type="submit"]');
                if (submitButton) {
                    submitButton.disabled = true;
                    submitButton.innerHTML = '<i class="bi bi-spinner bi-spin"></i> 筛选中...';
                }
                
                form.submit();
            }
        });
    }
}

/**
 * 初始化价格筛选功能
 */
function initPriceFilter() {
    const minPriceInput = document.getElementById('min-price');
    const maxPriceInput = document.getElementById('max-price');
    const priceFilterForm = document.getElementById('price-filter-form');
    
    // 验证价格输入
    function validatePriceInput(input) {
        const value = input.value.trim();
        if (value && !/^\d+(\.\d{1,2})?$/.test(value)) {
            showNotification('请输入有效的价格', 'error');
            input.value = '';
            return false;
        }
        return true;
    }
    
    if (minPriceInput) {
        minPriceInput.addEventListener('blur', function() {
            validatePriceInput(this);
        });
    }
    
    if (maxPriceInput) {
        maxPriceInput.addEventListener('blur', function() {
            validatePriceInput(this);
        });
    }
    
    if (priceFilterForm) {
        priceFilterForm.addEventListener('submit', function(e) {
            e.preventDefault();
            
            // 验证价格范围
            let valid = true;
            if (minPriceInput && minPriceInput.value.trim()) {
                valid = validatePriceInput(minPriceInput);
            }
            if (valid && maxPriceInput && maxPriceInput.value.trim()) {
                valid = validatePriceInput(maxPriceInput);
            }
            
            // 检查最小价格是否大于最大价格
            if (valid && minPriceInput && maxPriceInput && 
                minPriceInput.value.trim() && maxPriceInput.value.trim() &&
                parseFloat(minPriceInput.value) > parseFloat(maxPriceInput.value)) {
                showNotification('最低价格不能大于最高价格', 'error');
                valid = false;
            }
            
            if (valid) {
                // 添加加载状态
                const submitButton = this.querySelector('button[type="submit"]');
                if (submitButton) {
                    submitButton.disabled = true;
                    submitButton.innerHTML = '<i class="bi bi-spinner bi-spin"></i> 筛选中...';
                }
                
                this.submit();
            }
        });
    }
}

/**
 * 初始化排序功能
 */
function initSorting() {
    const sortSelect = document.getElementById('sort-by');
    
    if (sortSelect) {
        sortSelect.addEventListener('change', function() {
            const form = this.closest('form');
            if (form) {
                // 添加加载状态
                const submitButton = form.querySelector('button[type="submit"]');
                if (submitButton) {
                    submitButton.disabled = true;
                    submitButton.innerHTML = '<i class="bi bi-spinner bi-spin"></i> 排序中...';
                }
                
                form.submit();
            }
        });
    }
}

/**
 * 初始化商品操作功能
 */
function initItemActions() {
    // 处理下架商品操作
    const下架Buttons = document.querySelectorAll('.下架-item-btn');
    
    下架Buttons.forEach(button => {
        button.addEventListener('click', function(e) {
            e.preventDefault();
            const itemId = this.getAttribute('data-item-id');
            const itemName = this.getAttribute('data-item-name');
            
            confirmAction(`确定要下架商品「${itemName}」吗？`, () => {
                // 添加加载状态
                this.disabled = true;
                this.innerHTML = '<i class="bi bi-spinner bi-spin"></i> 处理中...';
                
                // 提交表单或发送请求
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = '${pageContext.request.contextPath}/items?action=下架';
                
                const idInput = document.createElement('input');
                idInput.type = 'hidden';
                idInput.name = 'id';
                idInput.value = itemId;
                
                form.appendChild(idInput);
                document.body.appendChild(form);
                form.submit();
            });
        });
    });
    
    // 处理删除商品操作
    const deleteButtons = document.querySelectorAll('.delete-item-btn');
    
    deleteButtons.forEach(button => {
        button.addEventListener('click', function(e) {
            e.preventDefault();
            const itemId = this.getAttribute('data-item-id');
            const itemName = this.getAttribute('data-item-name');
            
            confirmAction(`确定要删除商品「${itemName}」吗？此操作不可撤销。`, () => {
                // 添加加载状态
                this.disabled = true;
                this.innerHTML = '<i class="bi bi-spinner bi-spin"></i> 处理中...';
                
                // 提交表单或发送请求
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = '${pageContext.request.contextPath}/items?action=delete';
                
                const idInput = document.createElement('input');
                idInput.type = 'hidden';
                idInput.name = 'id';
                idInput.value = itemId;
                
                form.appendChild(idInput);
                document.body.appendChild(form);
                form.submit();
            });
        });
    });
    
    // 处理编辑商品操作
    const editButtons = document.querySelectorAll('.edit-item-btn');
    
    editButtons.forEach(button => {
        button.addEventListener('click', function(e) {
            const itemId = this.getAttribute('data-item-id');
            window.location.href = '${pageContext.request.contextPath}/item-edit.jsp?id=' + itemId;
        });
    });
}

/**
 * 初始化收藏夹功能
 */
function initWishlistFunctions() {
    const wishlistButtons = document.querySelectorAll('.add-to-wishlist-btn');
    
    wishlistButtons.forEach(button => {
        button.addEventListener('click', function(e) {
            e.preventDefault();
            const itemId = this.getAttribute('data-item-id');
            const icon = this.querySelector('i');
            const isFavorited = icon.classList.contains('bi-heart-fill');
            
            // 避免重复点击
            if (this.disabled) return;
            this.disabled = true;
            
            // 模拟异步请求
            setTimeout(() => {
                if (isFavorited) {
                    // 取消收藏
                    icon.classList.remove('bi-heart-fill', 'text-danger');
                    icon.classList.add('bi-heart');
                    showNotification('已从收藏夹移除', 'success');
                } else {
                    // 添加收藏
                    icon.classList.remove('bi-heart');
                    icon.classList.add('bi-heart-fill', 'text-danger');
                    showNotification('已添加到收藏夹', 'success');
                }
                
                this.disabled = false;
            }, 500);
        });
    });
}

/**
 * 商品卡片悬停效果
 */
function initItemCardEffects() {
    const itemCards = document.querySelectorAll('.item-card');
    
    itemCards.forEach(card => {
        // 添加悬停效果
        card.addEventListener('mouseenter', function() {
            this.classList.add('shadow-lg');
            this.style.transform = 'translateY(-5px)';
            this.style.transition = 'all 0.3s ease';
        });
        
        card.addEventListener('mouseleave', function() {
            this.classList.remove('shadow-lg');
            this.style.transform = 'translateY(0)';
        });
    });
}

/**
 * 显示商品详情模态框
 */
function showItemModal(itemId) {
    // 这里可以实现商品详情模态框逻辑
    // 加载商品详情并显示
    showNotification('正在加载商品详情...', 'info');
}

/**
 * 验证商品表单
 */
function validateItemForm(form) {
    let isValid = true;
    const errorMessages = [];
    
    // 验证商品名称
    const nameInput = form.querySelector('input[name="name"]');
    if (nameInput && nameInput.value.trim().length < 2) {
        errorMessages.push('商品名称至少需要2个字符');
        highlightError(nameInput);
        isValid = false;
    }
    
    // 验证商品价格
    const priceInput = form.querySelector('input[name="price"]');
    if (priceInput) {
        const price = priceInput.value.trim();
        if (!price || !/^\d+(\.\d{1,2})?$/.test(price) || parseFloat(price) <= 0) {
            errorMessages.push('请输入有效的商品价格');
            highlightError(priceInput);
            isValid = false;
        }
    }
    
    // 验证商品描述
    const descriptionInput = form.querySelector('textarea[name="description"]');
    if (descriptionInput && descriptionInput.value.trim().length < 10) {
        errorMessages.push('商品描述至少需要10个字符');
        highlightError(descriptionInput);
        isValid = false;
    }
    
    // 验证商品分类
    const categorySelect = form.querySelector('select[name="category"]');
    if (categorySelect && categorySelect.value === '') {
        errorMessages.push('请选择商品分类');
        highlightError(categorySelect);
        isValid = false;
    }
    
    // 显示错误消息
    if (errorMessages.length > 0) {
        const errorContainer = form.querySelector('.form-errors');
        if (!errorContainer) {
            const errorDiv = document.createElement('div');
            errorDiv.className = 'form-errors alert alert-danger mt-3';
            errorDiv.innerHTML = '<ul class="mb-0"><li>' + errorMessages.join('</li><li>') + '</li></ul>';
            form.prepend(errorDiv);
        } else {
            errorContainer.innerHTML = '<ul class="mb-0"><li>' + errorMessages.join('</li><li>') + '</li></ul>';
        }
    }
    
    return isValid;
}

/**
 * 高亮错误输入框
 */
function highlightError(inputElement) {
    inputElement.classList.add('is-invalid');
    
    // 添加焦点事件移除错误样式
    const handleFocus = function() {
        this.classList.remove('is-invalid');
        this.removeEventListener('focus', handleFocus);
    };
    
    inputElement.addEventListener('focus', handleFocus);
}

/**
 * 格式化商品价格显示
 */
function formatPrice(price) {
    if (typeof price === 'number') {
        return '¥' + price.toFixed(2);
    }
    return price;
}

/**
 * 获取商品状态样式
 */
function getItemStatusClass(status) {
    const statusClasses = {
        '上架': 'bg-success',
        '下架': 'bg-secondary',
        '已售出': 'bg-primary',
        '审核中': 'bg-warning',
        '已删除': 'bg-danger'
    };
    
    return statusClasses[status] || 'bg-info';
}

/**
 * 页面加载完成后初始化
 */
if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', () => {
        initItemFunctions();
        initItemCardEffects();
    });
} else {
    initItemFunctions();
    initItemCardEffects();
}

// 导出公共方法
window.ItemHandler = {
    initItemFunctions,
    validateItemForm,
    formatPrice,
    getItemStatusClass,
    showItemModal
};