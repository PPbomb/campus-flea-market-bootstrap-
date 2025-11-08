package com.campusmarket.controller;

import com.campusmarket.model.User;
import com.campusmarket.dao.OrderDAO;
import com.campusmarket.util.DBUtil;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.sql.*;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/orders")
public class OrderServlet extends HttpServlet {
    private OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        if ("payment".equals(action)) {
            try {
                int orderId = Integer.parseInt(request.getParameter("orderId"));
                String paymentMethod = request.getParameter("paymentMethod");
                
                // 处理支付请求
                processPayment(request, response, orderId, paymentMethod);
            } catch (NumberFormatException e) {
                session.setAttribute("error", "无效的订单ID");
                response.sendRedirect(request.getContextPath() + "/payment.jsp");
            }
        } else if ("create".equals(action)) {
            try {
                int itemId = Integer.parseInt(request.getParameter("itemId"));
                createOrder(request, response, itemId);
            } catch (NumberFormatException e) {
                session.setAttribute("error", "无效的商品ID");
                response.sendRedirect(request.getContextPath() + "/index");
            } catch (SQLException e) {
                e.printStackTrace();
                session.setAttribute("error", "数据库错误，请稍后重试");
                response.sendRedirect(request.getContextPath() + "/index");
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    // 创建订单
    private void createOrder(HttpServletRequest request, HttpServletResponse response, int itemId) throws ServletException, IOException, SQLException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        try {
            // 检查商品是否存在
            String itemName = null;
            double price = 0.0;
            int sellerId = -1;
            String status = null;
            
            try (Connection conn = DBUtil.getConnection();
                 PreparedStatement itemStmt = conn.prepareStatement("SELECT name, price, seller_id, status, type, quantity FROM items WHERE id = ?")) {
                itemStmt.setInt(1, itemId);
                ResultSet itemRs = itemStmt.executeQuery();
                
                if (!itemRs.next()) {
                    session.setAttribute("error", "商品不存在");
                    response.sendRedirect(request.getContextPath() + "/index");
                    return;
                }
                
                itemName = itemRs.getString("name");
                price = itemRs.getDouble("price");
                sellerId = itemRs.getInt("seller_id");
                status = itemRs.getString("status");
                
                // 对于实物类商品，检查库存
                String type = itemRs.getString("type");
                int quantity = itemRs.getInt("quantity");
                if ("physical".equals(type) && quantity <= 0) {
                    session.setAttribute("error", "商品库存不足");
                    response.sendRedirect(request.getContextPath() + "/index");
                    return;
                }
            }
            
            // 检查是否是自己发布的商品
            if (sellerId == user.getId()) {
                session.setAttribute("error", "不能购买自己发布的商品");
                response.sendRedirect(request.getContextPath() + "/index");
                return;
            }
            
            // 检查商品是否已售出
            if ("sold".equals(status)) {
                session.setAttribute("error", "商品已售出");
                response.sendRedirect(request.getContextPath() + "/index");
                return;
            }
            
            // 检查用户是否已经购买过该商品
            if (orderDAO.hasUserPurchasedItem(itemId, user.getId())) {
                session.setAttribute("error", "您已经购买过该商品");
                response.sendRedirect(request.getContextPath() + "/index");
                return;
            }
            
            // 创建待支付订单
            int orderId = orderDAO.createOrderWithStatus(itemId, user.getId(), "pending");
            if (orderId > 0) {
                // 将订单信息存储到会话中，跳转到支付页面
                Map<String, Object> orderInfo = new HashMap<>();
                orderInfo.put("orderId", orderId);
                orderInfo.put("itemName", itemName);
                orderInfo.put("price", price);
                session.setAttribute("orderInfo", orderInfo);
                response.sendRedirect(request.getContextPath() + "/payment.jsp");
            } else {
                session.setAttribute("error", "创建订单失败，请稍后重试");
                response.sendRedirect(request.getContextPath() + "/index");
            }
            
        } catch (NumberFormatException e) {
            session.setAttribute("error", "无效的商品ID");
            response.sendRedirect(request.getContextPath() + "/index");
        } catch (SQLException e) {
            e.printStackTrace();
            session.setAttribute("error", "数据库错误，请稍后重试");
            response.sendRedirect(request.getContextPath() + "/index");
        }
    }

    // 处理支付
    private void processPayment(HttpServletRequest request, HttpServletResponse response, int orderId, String paymentMethod) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        try {
            // 模拟支付过程
            boolean paymentSuccess = simulatePayment(paymentMethod);
            
            if (paymentSuccess) {
                // 支付成功，更新订单状态和商品库存
                if (orderDAO.updateOrderStatus(orderId, "completed") && updateItemStock(orderId)) {
                    session.setAttribute("success", "支付成功，订单已完成！");
                } else {
                    session.setAttribute("error", "支付成功，但更新订单状态失败");
                }
            } else {
                // 支付失败，更新订单状态为已取消
                orderDAO.updateOrderStatus(orderId, "cancelled");
                session.setAttribute("error", "支付失败，请重试");
            }
            
            // 清除订单信息并跳转到我的订单页面
            session.removeAttribute("orderInfo");
            response.sendRedirect(request.getContextPath() + "/my-orders");
            
        } catch (SQLException e) {
            e.printStackTrace();
            session.setAttribute("error", "数据库错误，请稍后重试");
            response.sendRedirect(request.getContextPath() + "/payment.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "支付过程中发生错误，请稍后重试");
            response.sendRedirect(request.getContextPath() + "/payment.jsp");
        }
    }

    // 模拟支付过程
    private boolean simulatePayment(String paymentMethod) {
        // 这里模拟支付过程，实际项目中应该调用真实的支付API
        // 简单起见，假设所有支付都成功
        return true;
    }

    // 更新商品库存
    private boolean updateItemStock(int orderId) throws SQLException {
        try (Connection conn = DBUtil.getConnection()) {
            // 获取订单对应的商品ID和类型
            String getItemSql = "SELECT i.id, i.type, i.quantity FROM orders o JOIN items i ON o.item_id = i.id WHERE o.id = ?";
            PreparedStatement getItemStmt = conn.prepareStatement(getItemSql);
            getItemStmt.setInt(1, orderId);
            ResultSet itemRs = getItemStmt.executeQuery();
            
            if (itemRs.next()) {
                int itemId = itemRs.getInt("id");
                String type = itemRs.getString("type");
                
                // 仅对实物类商品减少库存
                if ("physical".equals(type)) {
                    // 减少库存
                    String updateStockSql = "UPDATE items SET quantity = quantity - 1 WHERE id = ?";
                    PreparedStatement updateStockStmt = conn.prepareStatement(updateStockSql);
                    updateStockStmt.setInt(1, itemId);
                    int affectedRows = updateStockStmt.executeUpdate();
                    
                    // 检查是否需要标记商品为已售出
                    if (affectedRows > 0) {
                        String checkStockSql = "SELECT quantity FROM items WHERE id = ?";
                        PreparedStatement checkStockStmt = conn.prepareStatement(checkStockSql);
                        checkStockStmt.setInt(1, itemId);
                        ResultSet stockRs = checkStockStmt.executeQuery();
                        
                        if (stockRs.next() && stockRs.getInt("quantity") <= 0) {
                            String updateStatusSql = "UPDATE items SET status = 'sold' WHERE id = ?";
                            PreparedStatement updateStatusStmt = conn.prepareStatement(updateStatusSql);
                            updateStatusStmt.setInt(1, itemId);
                            updateStatusStmt.executeUpdate();
                        }
                    }
                }
            }
            return true;
        } catch (SQLException e) {
            throw e;
        }
    }
}