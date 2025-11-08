package com.campusmarket.dao;

import com.campusmarket.model.Order;
import com.campusmarket.util.DBUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderDAO {

    public boolean createOrder(int itemId, int buyerId) {
        try (Connection conn = DBUtil.getConnection()) {
            // 开始事务
            conn.setAutoCommit(false);
            
            try {
                // 1. 检查商品是否已售出
                String checkItemStatusSql = "SELECT status FROM items WHERE id = ?";
                try (PreparedStatement checkItemStmt = conn.prepareStatement(checkItemStatusSql)) {
                    checkItemStmt.setInt(1, itemId);
                    ResultSet itemRs = checkItemStmt.executeQuery();
                    if (!itemRs.next() || "sold".equals(itemRs.getString("status"))) {
                        conn.rollback();
                        System.out.println("商品不存在或已售出");
                        return false;
                    }
                }
                
                // 2. 检查用户是否已经购买过该商品
                String checkOrderSql = "SELECT COUNT(*) FROM orders WHERE item_id = ? AND buyer_id = ?";
                try (PreparedStatement checkOrderStmt = conn.prepareStatement(checkOrderSql)) {
                    checkOrderStmt.setInt(1, itemId);
                    checkOrderStmt.setInt(2, buyerId);
                    ResultSet orderRs = checkOrderStmt.executeQuery();
                    orderRs.next();
                    if (orderRs.getInt(1) > 0) {
                        conn.rollback();
                        System.out.println("用户已购买过该商品");
                        return false;
                    }
                }
                
                // 3. 创建订单 - 使用新方法，设置状态为'pending'
                int orderId = createOrderWithStatus(itemId, buyerId, "pending");
                if (orderId <= 0) {
                    conn.rollback();
                    return false;
                }
                
                // 4. 更新商品状态为已售出
                String updateItemSql = "UPDATE items SET status = 'sold' WHERE id = ?";
                try (PreparedStatement updateItemStmt = conn.prepareStatement(updateItemSql)) {
                    updateItemStmt.setInt(1, itemId);
                    if (updateItemStmt.executeUpdate() <= 0) {
                        conn.rollback();
                        return false;
                    }
                }
                
                // 提交事务
                conn.commit();
                return true;
                
            } catch (SQLException e) {
                conn.rollback();
                e.printStackTrace();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public int createOrderWithStatus(int itemId, int buyerId, String status) {
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(
                     "INSERT INTO orders (item_id, buyer_id, created_at, status, quantity) VALUES (?, ?, NOW(), ?, 1)",
                     Statement.RETURN_GENERATED_KEYS)) {
            stmt.setInt(1, itemId);
            stmt.setInt(2, buyerId);
            stmt.setString(3, status);
            stmt.executeUpdate();
            
            // 获取生成的订单ID
            ResultSet rs = stmt.getGeneratedKeys();
            if (rs.next()) {
                return rs.getInt(1);
            }
            return -1;
        } catch (SQLException e) {
            e.printStackTrace();
            return -1;
        }
    }
    
    public boolean updateOrderStatus(int orderId, String status) {
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(
                     "UPDATE orders SET status = ? WHERE id = ?")) {
            stmt.setString(1, status);
            stmt.setInt(2, orderId);
            int rows = stmt.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 检查用户是否已经购买过指定商品
     */
    public boolean hasUserPurchasedItem(int itemId, int buyerId) {
        String sql = "SELECT COUNT(*) FROM orders WHERE item_id = ? AND buyer_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, itemId);
            stmt.setInt(2, buyerId);
            
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Order> getOrdersByUser(int userId) {
        List<Order> orders = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(
                     "SELECT o.id, o.item_id, o.created_at as order_date, o.status, o.quantity, i.name as item_name, i.price, u.username as seller_name " +
                     "FROM orders o " +
                     "JOIN items i ON o.item_id = i.id " +
                     "JOIN users u ON i.seller_id = u.id " +
                     "WHERE o.buyer_id = ? " +
                     "ORDER BY o.created_at DESC")) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Order order = new Order();
                order.setId(rs.getInt("id"));
                order.setItemId(rs.getInt("item_id"));
                order.setCreatedAt(rs.getTimestamp("order_date"));
                order.setStatus(rs.getString("status"));
                order.setQuantity(rs.getInt("quantity"));
                order.setItemName(rs.getString("item_name"));
                order.setPrice(rs.getDouble("price"));
                order.setSellerName(rs.getString("seller_name"));
                orders.add(order);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return orders;
    }
    
    public List<Order> getAllOrders() {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT o.*, i.name as item_name, i.price, u.username as buyer_name, " +
                "u2.username as seller_name " +
                "FROM orders o " +
                "JOIN items i ON o.item_id = i.id " +
                "JOIN users u ON o.buyer_id = u.id " +
                "JOIN users u2 ON i.seller_id = u2.id " +
                "ORDER BY o.created_at DESC";

        try (Connection conn = DBUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Order order = new Order();
                order.setId(rs.getInt("id"));
                order.setItemId(rs.getInt("item_id"));
                order.setBuyerId(rs.getInt("buyer_id"));
                order.setStatus(rs.getString("status"));
                order.setCreatedAt(rs.getTimestamp("created_at"));
                order.setItemName(rs.getString("item_name"));
                order.setPrice(rs.getDouble("price"));
                order.setSellerName(rs.getString("seller_name"));
                orders.add(order);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return orders;
    }
    
    public double getTotalSales() {
        String sql = "SELECT SUM(i.price) as total_sales " +
                "FROM orders o " +
                "JOIN items i ON o.item_id = i.id " +
                "WHERE o.status != 'cancelled'";

        try (Connection conn = DBUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            if (rs.next()) {
                return rs.getDouble("total_sales");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    public int getOrderCountByStatus(String status) {
        String sql = "SELECT COUNT(*) as count FROM orders WHERE status = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, status);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getInt("count");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    public List<Order> getRecentOrders(int limit) {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT o.*, i.name as item_name, i.price, u.username as buyer_name, " +
                "u2.username as seller_name " +
                "FROM orders o " +
                "JOIN items i ON o.item_id = i.id " +
                "JOIN users u ON o.buyer_id = u.id " +
                "JOIN users u2 ON i.seller_id = u2.id " +
                "ORDER BY o.created_at DESC LIMIT ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, limit);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Order order = new Order();
                order.setId(rs.getInt("id"));
                order.setItemId(rs.getInt("item_id"));
                order.setBuyerId(rs.getInt("buyer_id"));
                order.setStatus(rs.getString("status"));
                order.setCreatedAt(rs.getTimestamp("created_at"));
                order.setItemName(rs.getString("item_name"));
                order.setPrice(rs.getDouble("price"));
                order.setSellerName(rs.getString("seller_name"));
                orders.add(order);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return orders;
    }
}