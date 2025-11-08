package com.campusmarket.controller;

import com.campusmarket.dao.ItemDAO;
import com.campusmarket.dao.UserDAO;
import com.campusmarket.dao.OrderDAO;
import com.campusmarket.model.User;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.*;

@WebServlet("/admin/*")
public class AdminServlet extends HttpServlet {
    private ItemDAO itemDAO = new ItemDAO();
    private UserDAO userDAO = new UserDAO();
    private OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("=== AdminServlet 被调用 ===");

        String pathInfo = request.getPathInfo();
        System.out.println("请求路径: " + pathInfo);

        // 检查是否是静态资源请求
        if (isStaticResource(pathInfo)) {
            System.out.println("静态资源请求，直接返回: " + pathInfo);
            return; // 让容器处理静态资源
        }

        HttpSession session = request.getSession();
        com.campusmarket.model.User user = (com.campusmarket.model.User) session.getAttribute("user");

        // 权限检查
        if (user == null || !"admin".equals(user.getRole())) {
            System.out.println("权限不足");
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        System.out.println("管理员访问: " + user.getUsername());

        // 处理管理路径
        if (pathInfo == null || "/".equals(pathInfo) || "/dashboard".equals(pathInfo)) {
            handleDashboard(request, response);
        } else if ("/items".equals(pathInfo)) {
            handleItems(request, response);
        } else if ("/users".equals(pathInfo)) {
            handleUsers(request, response);
        } else if ("/admin_accounts".equals(pathInfo)) {
            handleAdminAccounts(request, response);
        } else if ("/statistics".equals(pathInfo)) {
            handleStatistics(request, response);
        } else {
            System.out.println("未知管理路径: " + pathInfo);
            response.sendError(404, "管理页面未找到");
        }
    }

    /**
     * 检查是否是静态资源请求
     */
    private boolean isStaticResource(String pathInfo) {
        if (pathInfo == null) return false;

        return pathInfo.endsWith(".css") ||
                pathInfo.endsWith(".js") ||
                pathInfo.endsWith(".jpg") ||
                pathInfo.endsWith(".png") ||
                pathInfo.endsWith(".gif") ||
                pathInfo.endsWith(".ico") ||
                pathInfo.contains("/css/") ||
                pathInfo.contains("/js/") ||
                pathInfo.contains("/images/");
    }

    private void handleDashboard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("处理仪表盘请求");

        int pendingCount = itemDAO.getPendingItems().size();
        // 只统计普通用户数量，不包括管理员
        int userCount = 0;
        List<User> allUsers = userDAO.getAllUsers();
        for (User u : allUsers) {
            if (!"admin".equals(u.getRole())) {
                userCount++;
            }
        }
        int itemCount = itemDAO.getApprovedItems().size();

        System.out.println("统计数据 - 待审核: " + pendingCount + ", 用户: " + userCount + ", 商品: " + itemCount);

        request.setAttribute("pendingCount", pendingCount);
        request.setAttribute("userCount", userCount);
        request.setAttribute("itemCount", itemCount);

        request.getRequestDispatcher("/WEB-INF/admin/dashboard.jsp").forward(request, response);
    }

    private void handleItems(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("处理商品审核请求");
        request.setAttribute("pendingItems", itemDAO.getPendingItems());
        request.getRequestDispatcher("/WEB-INF/admin/items.jsp").forward(request, response);
    }

    private void handleUsers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("处理用户管理请求");
        // 只获取普通用户，过滤掉管理员账号
        List<User> normalUsers = new ArrayList<>();
        List<User> allUsers = userDAO.getAllUsers();
        for (User u : allUsers) {
            if (!"admin".equals(u.getRole())) {
                normalUsers.add(u);
            }
        }
        request.setAttribute("users", normalUsers);
        request.getRequestDispatcher("/WEB-INF/admin/users.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String pathInfo = request.getPathInfo();

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || !"admin".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        if ("/items".equals(pathInfo)) {
            String action = request.getParameter("action");
            if ("approve".equals(action)) {
                int itemId = Integer.parseInt(request.getParameter("id"));
                if (itemDAO.approveItem(itemId)) {
                    response.sendRedirect("items?success=" + java.net.URLEncoder.encode("审核通过", "UTF-8"));
                } else {
                    response.sendRedirect("items?error=" + java.net.URLEncoder.encode("审核失败", "UTF-8"));
                }
            } else if ("reject".equals(action)) {
                int itemId = Integer.parseInt(request.getParameter("id"));
                if (itemDAO.rejectItem(itemId)) {
                    response.sendRedirect("items?success=" + java.net.URLEncoder.encode("已拒绝", "UTF-8"));
                } else {
                    response.sendRedirect("items?error=" + java.net.URLEncoder.encode("操作失败", "UTF-8"));
                }
            }
        } else if ("/users".equals(pathInfo)) {
            handleUserActions(request, response);
        } else if ("/admin_accounts".equals(pathInfo)) {
            handleAdminActions(request, response);
        }
    }

    // 管理员账号管理方法
    private void handleAdminAccounts(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("处理管理员账号管理请求");
        
        // 获取所有管理员
        List<User> admins = new ArrayList<>();
        List<User> allUsers = userDAO.getAllUsers();
        for (User u : allUsers) {
            if ("admin".equals(u.getRole())) {
                admins.add(u);
            }
        }
        
        // 设置统计数据
        int pendingCount = itemDAO.getPendingItems().size();
        // 只统计普通用户数量，不包括管理员
        int userCount = 0;
        // 复用已有的 allUsers 列表，不再重新查询
        for (User u : allUsers) {
            if (!"admin".equals(u.getRole())) {
                userCount++;
            }
        }
        for (User u : allUsers) {
            if (!"admin".equals(u.getRole())) {
                userCount++;
            }
        }
        
        request.setAttribute("admins", admins);
        request.setAttribute("pendingCount", pendingCount);
        request.setAttribute("userCount", userCount);
        
        request.getRequestDispatcher("/WEB-INF/admin/admin_accounts.jsp").forward(request, response);
    }
    
    private void handleAdminActions(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String action = request.getParameter("action");
        
        switch (action) {
            case "add":
                addAdmin(request, response);
                break;
            case "edit":
                editAdmin(request, response);
                break;
            case "resetPassword":
                resetAdminPassword(request, response);
                break;
            case "delete":
                deleteAdmin(request, response);
                break;
            default:
                response.sendRedirect("admin_accounts");
        }
    }
    
    private void addAdmin(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        
        // 检查用户名是否已存在
        List<User> allUsers = userDAO.getAllUsers();
        for (User u : allUsers) {
            if (username.equals(u.getUsername())) {
                response.sendRedirect("admin_accounts?error=" + java.net.URLEncoder.encode("用户名已存在", "UTF-8"));
                return;
            }
        }
        
        // 创建新管理员
        User admin = new User();
        admin.setUsername(username);
        admin.setPassword(password); // 注意：实际应用中应该加密密码
        admin.setPhone(phone);
        admin.setEmail(email);
        admin.setRole("admin");
        admin.setCreatedAt(new Date());
        
        if (userDAO.addUser(admin)) {
            response.sendRedirect("admin_accounts?success=" + java.net.URLEncoder.encode("管理员添加成功", "UTF-8"));
        } else {
            response.sendRedirect("admin_accounts?error=" + java.net.URLEncoder.encode("添加失败", "UTF-8"));
        }
    }
    
    private void editAdmin(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String username = request.getParameter("username");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        
        User admin = userDAO.getUserById(id);
        if (admin == null || !"admin".equals(admin.getRole())) {
            response.sendRedirect("admin_accounts?error=" + java.net.URLEncoder.encode("管理员不存在", "UTF-8"));
            return;
        }
        
        // 检查用户名是否被其他管理员使用
        List<User> allUsers = userDAO.getAllUsers();
        for (User u : allUsers) {
            if (username.equals(u.getUsername()) && u.getId() != id) {
                response.sendRedirect("admin_accounts?error=" + java.net.URLEncoder.encode("用户名已存在", "UTF-8"));
                return;
            }
        }
        
        admin.setUsername(username);
        admin.setPhone(phone);
        admin.setEmail(email);
        
        if (userDAO.updateUser(admin)) {
            response.sendRedirect("admin_accounts?success=" + java.net.URLEncoder.encode("管理员信息更新成功", "UTF-8"));
        } else {
            response.sendRedirect("admin_accounts?error=" + java.net.URLEncoder.encode("更新失败", "UTF-8"));
        }
    }
    
    private void resetAdminPassword(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        
        if (!newPassword.equals(confirmPassword)) {
            response.sendRedirect("admin_accounts?error=" + java.net.URLEncoder.encode("两次输入的密码不一致", "UTF-8"));
            return;
        }
        
        if (userDAO.updatePassword(id, newPassword)) {
            response.sendRedirect("admin_accounts?success=" + java.net.URLEncoder.encode("密码重置成功", "UTF-8"));
        } else {
            response.sendRedirect("admin_accounts?error=" + java.net.URLEncoder.encode("密码重置失败", "UTF-8"));
        }
    }
    
    private void deleteAdmin(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        HttpSession session = request.getSession();
        User currentAdmin = (User) session.getAttribute("user");
        
        if (currentAdmin.getId() == id) {
            response.sendRedirect("admin_accounts?error=" + java.net.URLEncoder.encode("不能删除当前登录的管理员账号", "UTF-8"));
            return;
        }
        
        User adminToDelete = userDAO.getUserById(id);
        if (adminToDelete == null || !"admin".equals(adminToDelete.getRole())) {
            response.sendRedirect("admin_accounts?error=" + java.net.URLEncoder.encode("管理员不存在", "UTF-8"));
            return;
        }
        
        if (userDAO.deleteUser(id)) {
            response.sendRedirect("admin_accounts?success=" + java.net.URLEncoder.encode("管理员删除成功", "UTF-8"));
        } else {
            response.sendRedirect("admin_accounts?error=" + java.net.URLEncoder.encode("删除失败", "UTF-8"));
        }
    }
    
    // 用户管理增强方法
    private void handleUserActions(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String action = request.getParameter("action");
        
        switch (action) {
            case "edit":
                editUser(request, response);
                break;
            case "resetPassword":
                resetUserPassword(request, response);
                break;
            case "delete":
                deleteUser(request, response);
                break;
            default:
                response.sendRedirect("users");
        }
    }
    
    private void editUser(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String username = request.getParameter("username");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        
        User user = userDAO.getUserById(id);
        if (user == null) {
            response.sendRedirect("users?error=" + java.net.URLEncoder.encode("用户不存在", "UTF-8"));
            return;
        }
        
        // 检查用户名是否被其他用户使用
        List<User> allUsers = userDAO.getAllUsers();
        for (User u : allUsers) {
            if (username.equals(u.getUsername()) && u.getId() != id) {
                response.sendRedirect("users?error=" + java.net.URLEncoder.encode("用户名已存在", "UTF-8"));
                return;
            }
        }
        
        user.setUsername(username);
        user.setPhone(phone);
        user.setEmail(email);
        
        if (userDAO.updateUser(user)) {
            response.sendRedirect("users?success=" + java.net.URLEncoder.encode("用户信息更新成功", "UTF-8"));
        } else {
            response.sendRedirect("users?error=" + java.net.URLEncoder.encode("更新失败", "UTF-8"));
        }
    }
    
    private void resetUserPassword(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        
        if (!newPassword.equals(confirmPassword)) {
            response.sendRedirect("users?error=" + java.net.URLEncoder.encode("两次输入的密码不一致", "UTF-8"));
            return;
        }
        
        if (userDAO.updatePassword(id, newPassword)) {
            response.sendRedirect("users?success=" + java.net.URLEncoder.encode("密码重置成功", "UTF-8"));
        } else {
            response.sendRedirect("users?error=" + java.net.URLEncoder.encode("密码重置失败", "UTF-8"));
        }
    }
    
    private void deleteUser(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            String idParam = request.getParameter("id");
            System.out.println("删除用户请求，id参数值: " + idParam);
            
            if (idParam == null || idParam.isEmpty()) {
                System.out.println("用户ID参数为空");
                response.sendRedirect("users?error=" + java.net.URLEncoder.encode("用户ID无效", "UTF-8"));
                return;
            }
            
            int id = Integer.parseInt(idParam);
            System.out.println("解析后的用户ID: " + id);
            
            User user = userDAO.getUserById(id);
            System.out.println("获取到的用户对象: " + (user != null ? user.getUsername() : "null"));
            
            if (user == null) {
                System.out.println("用户不存在，ID: " + id);
                response.sendRedirect("users?error=" + java.net.URLEncoder.encode("用户不存在", "UTF-8"));
                return;
            }
            
            if ("admin".equals(user.getRole())) {
                System.out.println("无法删除管理员用户: " + user.getUsername());
                response.sendRedirect("users?error=" + java.net.URLEncoder.encode("无法删除管理员账号", "UTF-8"));
                return;
            }
            
            // 由于数据库存在外键约束，需要先删除相关的订单和商品
            Connection conn = null;
            try {
                // 获取数据库连接
                conn = com.campusmarket.util.DBUtil.getConnection();
                // 开始事务
                conn.setAutoCommit(false);
                
                System.out.println("开始级联删除用户相关数据: " + user.getUsername());
                
                // 1. 删除用户作为买家的所有订单
                String deleteUserOrdersSql = "DELETE FROM orders WHERE buyer_id = ?";
                try (PreparedStatement stmt = conn.prepareStatement(deleteUserOrdersSql)) {
                    stmt.setInt(1, id);
                    int orderDeletedCount = stmt.executeUpdate();
                    System.out.println("删除用户相关订单数量: " + orderDeletedCount);
                }
                
                // 2. 获取用户发布的所有商品ID
                String getUserItemsSql = "SELECT id FROM items WHERE seller_id = ?";
                List<Integer> itemIds = new ArrayList<>();
                try (PreparedStatement stmt = conn.prepareStatement(getUserItemsSql)) {
                    stmt.setInt(1, id);
                    try (ResultSet rs = stmt.executeQuery()) {
                        while (rs.next()) {
                            itemIds.add(rs.getInt(1));
                        }
                    }
                }
                
                // 3. 删除这些商品相关的所有订单
                if (!itemIds.isEmpty()) {
                    StringBuilder itemIdPlaceholders = new StringBuilder();
                    for (int i = 0; i < itemIds.size(); i++) {
                        itemIdPlaceholders.append("?");
                        if (i < itemIds.size() - 1) {
                            itemIdPlaceholders.append(",");
                        }
                    }
                    
                    String deleteItemOrdersSql = "DELETE FROM orders WHERE item_id IN (" + itemIdPlaceholders + ")";
                    try (PreparedStatement stmt = conn.prepareStatement(deleteItemOrdersSql)) {
                        for (int i = 0; i < itemIds.size(); i++) {
                            stmt.setInt(i + 1, itemIds.get(i));
                        }
                        int itemOrderDeletedCount = stmt.executeUpdate();
                        System.out.println("删除用户商品相关订单数量: " + itemOrderDeletedCount);
                    }
                    
                    // 4. 删除用户发布的所有商品
                    String deleteItemsSql = "DELETE FROM items WHERE seller_id = ?";
                    try (PreparedStatement stmt = conn.prepareStatement(deleteItemsSql)) {
                        stmt.setInt(1, id);
                        int itemsDeletedCount = stmt.executeUpdate();
                        System.out.println("删除用户商品数量: " + itemsDeletedCount);
                    }
                }
                
                // 5. 删除用户
                String deleteUserSql = "DELETE FROM users WHERE id = ?";
                try (PreparedStatement stmt = conn.prepareStatement(deleteUserSql)) {
                    stmt.setInt(1, id);
                    int userDeletedCount = stmt.executeUpdate();
                    System.out.println("删除用户结果: " + (userDeletedCount > 0 ? "成功" : "失败"));
                    
                    if (userDeletedCount <= 0) {
                        throw new SQLException("删除用户失败");
                    }
                }
                
                // 提交事务
                conn.commit();
                System.out.println("事务提交成功");
                
                // 删除成功后重定向
                response.sendRedirect("users?success=" + java.net.URLEncoder.encode("用户及其相关数据删除成功", "UTF-8"));
                
            } catch (SQLException e) {
                // 发生异常，回滚事务
                if (conn != null) {
                    try {
                        conn.rollback();
                        System.out.println("事务回滚成功");
                    } catch (SQLException ex) {
                        System.out.println("事务回滚失败: " + ex.getMessage());
                    }
                }
                
                System.out.println("删除用户时发生SQL异常: " + e.getMessage());
                e.printStackTrace();
                response.sendRedirect("users?error=" + java.net.URLEncoder.encode("删除用户时发生数据库错误: " + e.getMessage(), "UTF-8"));
            } finally {
                // 关闭连接
                if (conn != null) {
                    try {
                        conn.setAutoCommit(true);
                        conn.close();
                    } catch (SQLException e) {
                        System.out.println("关闭连接失败: " + e.getMessage());
                    }
                }
            }
            
        } catch (NumberFormatException e) {
            System.out.println("用户ID参数格式错误: " + e.getMessage());
            response.sendRedirect("users?error=" + java.net.URLEncoder.encode("用户ID格式错误", "UTF-8"));
        } catch (Exception e) {
            System.out.println("删除用户时发生异常: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("users?error=" + java.net.URLEncoder.encode("删除用户时发生错误", "UTF-8"));
        }
    }
    
    // 数据统计方法
    private void handleStatistics(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("处理数据统计请求");
        
        // 基本统计数据
        int totalItems = itemDAO.getAllItems().size();
        int activeItems = 0;
        for (com.campusmarket.model.Item item : itemDAO.getAllItems()) {
            if ("active".equals(item.getStatus()) || "approved".equals(item.getStatus())) {
                activeItems++;
            }
        }
        
        // 使用OrderDAO获取实际订单数据
        int totalOrders = orderDAO.getAllOrders().size();
        double totalAmount = orderDAO.getTotalSales();
        List<Map<String, Object>> recentOrders = new ArrayList<>();
        
        // 获取最近订单
        List<com.campusmarket.model.Order> recentOrderList = orderDAO.getRecentOrders(10);
        for (com.campusmarket.model.Order order : recentOrderList) {
            Map<String, Object> orderMap = new HashMap<>();
            orderMap.put("itemName", order.getItemName());
            orderMap.put("price", order.getPrice());
            orderMap.put("sellerName", order.getSellerName());
            orderMap.put("status", order.getStatus());
            orderMap.put("createdAt", order.getCreatedAt());
            recentOrders.add(orderMap);
        }
        
        // 从实际商品数据中计算分类统计
        Map<String, Integer> categoryStats = new HashMap<>();
        for (com.campusmarket.model.Item item : itemDAO.getAllItems()) {
            String category = item.getCategory();
            if (category != null) {
                categoryStats.put(category, categoryStats.getOrDefault(category, 0) + 1);
            }
        }
        
        List<String> categoryLabels = new ArrayList<>(categoryStats.keySet());
        List<Integer> categoryCounts = new ArrayList<>();
        for (String category : categoryLabels) {
            categoryCounts.add(categoryStats.get(category));
        }
        
        // 如果没有分类数据，提供默认分类
        if (categoryLabels.isEmpty()) {
            categoryLabels = Arrays.asList("电子产品", "图书文具", "服饰鞋包", "生活用品", "运动器材");
            categoryCounts = Arrays.asList(0, 0, 0, 0, 0);
        }
        
        // 近30天订单趋势（可以后续扩展为实际数据统计）
        List<String> dateLabels = new ArrayList<>();
        List<Integer> orderCounts = new ArrayList<>();
        List<Double> amountData = new ArrayList<>();
        
        SimpleDateFormat sdf = new SimpleDateFormat("MM-dd");
        Date[] last30Days = getLast30Days();
        
        // 初始化日期标签
        for (Date date : last30Days) {
            dateLabels.add(sdf.format(date));
            orderCounts.add(0); // 初始化为0
            amountData.add(0.0); // 初始化为0
        }
        
        // 获取最近的商品
        List<Map<String, Object>> recentItems = new ArrayList<>();
        List<com.campusmarket.model.Item> items = itemDAO.getAllItems();
        int limit = Math.min(10, items.size());
        for (int i = 0; i < limit; i++) {
            com.campusmarket.model.Item item = items.get(i);
            Map<String, Object> itemMap = new HashMap<>();
            itemMap.put("name", item.getName());
            itemMap.put("username", userDAO.getUserById(item.getSellerId()).getUsername());
            itemMap.put("price", item.getPrice());
            itemMap.put("status", item.getStatus());
            itemMap.put("createdAt", item.getCreatedAt());
            recentItems.add(itemMap);
        }
        
        // 设置请求属性
        request.setAttribute("totalItems", totalItems);
        request.setAttribute("activeItems", activeItems);
        request.setAttribute("totalOrders", totalOrders);
        request.setAttribute("totalAmount", totalAmount);
        request.setAttribute("categoryLabels", categoryLabels);
        request.setAttribute("categoryCounts", categoryCounts);
        request.setAttribute("dateLabels", dateLabels);
        request.setAttribute("orderCounts", orderCounts);
        request.setAttribute("amountData", amountData);
        request.setAttribute("recentItems", recentItems);
        request.setAttribute("recentOrders", recentOrders);
        
        // 设置侧边栏统计数据
        int pendingCount = itemDAO.getPendingItems().size();
        int userCount = userDAO.getAllUsers().size();
        request.setAttribute("pendingCount", pendingCount);
        request.setAttribute("userCount", userCount);
        
        request.getRequestDispatcher("/WEB-INF/admin/statistics.jsp").forward(request, response);
    }
    
    // 获取近30天的日期数组
    private Date[] getLast30Days() {
        Date[] dates = new Date[30];
        long dayInMillis = 24 * 60 * 60 * 1000;
        Date today = new Date();
        
        for (int i = 0; i < 30; i++) {
            dates[i] = new Date(today.getTime() - (29 - i) * dayInMillis);
        }
        
        return dates;
    }
}