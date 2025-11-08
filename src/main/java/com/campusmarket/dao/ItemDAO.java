package com.campusmarket.dao;

import com.campusmarket.model.Item;
import com.campusmarket.util.DBUtil;
import java.sql.*;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

public class ItemDAO {

    public boolean createItem(Item item) {
        // 前置验证
        if (item == null) {
            System.out.println("错误: 商品对象为空");
            return false;
        }
        
        // 验证必填字段
        if (item.getName() == null || item.getName().trim().isEmpty()) {
            System.out.println("错误: 商品名称不能为空");
            return false;
        }
        
        if (item.getDescription() == null || item.getDescription().trim().isEmpty()) {
            System.out.println("错误: 商品描述不能为空");
            return false;
        }
        
        if (item.getPrice() <= 0) {
            System.out.println("错误: 商品价格必须大于0，当前值: " + item.getPrice());
            return false;
        }
        
        if (item.getSellerId() <= 0) {
            System.out.println("错误: 卖家ID无效，当前值: " + item.getSellerId());
            return false;
        }
        
        if (item.getCategory() == null || item.getCategory().trim().isEmpty()) {
            System.out.println("错误: 商品类别不能为空");
            return false;
        }
        
        // 设置默认值：如果type为空，默认为'physical'
        if (item.getType() == null || item.getType().trim().isEmpty()) {
            item.setType("physical");
        }
        
        // 设置默认值：如果quantity为空，默认为1
        if (item.getQuantity() == null) {
            item.setQuantity(1);
        }
        
        // 恢复完整SQL，包含type和quantity字段
        String sql = "INSERT INTO items (name, description, price, image, category, seller_id, status, type, quantity) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        System.out.println("执行创建商品SQL: " + sql);
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, item.getName());
            stmt.setString(2, item.getDescription());
            stmt.setDouble(3, item.getPrice());
            stmt.setString(4, item.getImage());
            stmt.setString(5, item.getCategory());
            stmt.setInt(6, item.getSellerId());
            
            // 设置商品状态为待审核
            stmt.setString(7, "pending");
            
            // 添加type和quantity参数
            stmt.setString(8, item.getType());
            
            // 为所有类型的商品设置quantity值
            stmt.setInt(9, item.getQuantity());

            int affectedRows = stmt.executeUpdate();
            System.out.println("创建商品影响行数: " + affectedRows);
            return affectedRows > 0;
        } catch (SQLException e) {
            System.out.println("创建商品SQLException: " + e.getMessage());
            System.out.println("SQL State: " + e.getSQLState());
            System.out.println("Error Code: " + e.getErrorCode());
            e.printStackTrace();
        } catch (Exception e) {
            System.out.println("创建商品异常: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    public List<Item> getApprovedItems() {
        List<Item> items = new ArrayList<>();
        // 从items表获取type和quantity字段
        String sql = "SELECT i.id, i.name, i.description, i.price, i.image, i.category, " +
                "i.seller_id, i.status, i.created_at, u.username as seller_name, i.type, i.quantity " +
                "FROM items i JOIN users u ON i.seller_id = u.id " +
                "WHERE i.status = 'approved' ORDER BY i.created_at DESC";

        System.out.println("=== ItemDAO.getApprovedItems() 被调用 ===");
        System.out.println("执行SQL: " + sql);

        try (Connection conn = DBUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            System.out.println("SQL执行成功，开始处理结果集");
            int count = 0;

            // 先检查数据库中是否有商品记录
            String countSql = "SELECT COUNT(*) as total, " +
                    "SUM(CASE WHEN status = 'approved' THEN 1 ELSE 0 END) as approved_count, " +
                    "SUM(CASE WHEN status = 'pending' THEN 1 ELSE 0 END) as pending_count " +
                    "FROM items";

            try (Statement countStmt = conn.createStatement();
                 ResultSet countRs = countStmt.executeQuery(countSql)) {
                if (countRs.next()) {
                    System.out.println("数据库商品统计：总商品=" + countRs.getInt("total") +
                            ", 已审核=" + countRs.getInt("approved_count") +
                            ", 待审核=" + countRs.getInt("pending_count"));
                }
            }

            // 处理已审核商品
            while (rs.next()) {
                Item item = new Item();
                item.setId(rs.getInt("id"));
                item.setName(rs.getString("name"));
                item.setDescription(rs.getString("description"));
                item.setPrice(rs.getDouble("price"));
                item.setImage(rs.getString("image"));
                item.setCategory(rs.getString("category"));
                item.setSellerId(rs.getInt("seller_id"));
                item.setSellerName(rs.getString("seller_name"));
                item.setCreatedAt(rs.getTimestamp("created_at"));
                item.setStatus("approved"); // 已审核商品状态固定为approved
                // 从items表获取type和quantity字段
                if (rs.getObject("type") != null) {
                    item.setType(rs.getString("type"));
                }
                if (rs.getObject("quantity") != null) {
                    item.setQuantity(rs.getInt("quantity"));
                }
                items.add(item);
                count++;
                System.out.println("添加商品: " + item.getName() + " (ID: " + item.getId() + ")");
            }

            // 如果没有找到已审核商品，显示所有商品状态
            if (items.isEmpty()) {
                System.out.println("没有找到已审核商品，尝试获取所有商品状态");
                String statusSql = "SELECT id, name, status FROM items LIMIT 10";
                try (Statement statusStmt = conn.createStatement();
                     ResultSet statusRs = statusStmt.executeQuery(statusSql)) {
                    while (statusRs.next()) {
                        System.out.println("商品ID=" + statusRs.getInt("id") +
                                ", 名称=" + statusRs.getString("name") +
                                ", 状态=" + statusRs.getString("status"));
                    }
                }
            }

            System.out.println("返回商品数量: " + items.size());
        } catch (SQLException e) {
            System.out.println("数据库查询错误: " + e.getMessage());
            e.printStackTrace();
        }
        return items;
    }

    public List<Item> getPendingItems() {
        List<Item> items = new ArrayList<>();
        // 恢复完整SQL查询，包含type和quantity字段
        String sql = "SELECT i.id, i.name, i.description, i.price, i.image, i.category, " +
                "i.seller_id, i.status, i.created_at, i.type, i.quantity, u.username as seller_name " +
                "FROM items i JOIN users u ON i.seller_id = u.id " +
                "WHERE i.status = 'pending' ORDER BY i.created_at DESC";

        try (Connection conn = DBUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Item item = new Item();
                item.setId(rs.getInt("id"));
                item.setName(rs.getString("name"));
                item.setDescription(rs.getString("description"));
                item.setPrice(rs.getDouble("price"));
                item.setImage(rs.getString("image"));
                item.setCategory(rs.getString("category"));
                item.setSellerId(rs.getInt("seller_id"));
                item.setSellerName(rs.getString("seller_name"));
                item.setCreatedAt(rs.getTimestamp("created_at"));
                item.setStatus("pending");
                // 处理type和quantity字段
                if (rs.getObject("type") != null) {
                    item.setType(rs.getString("type"));
                }
                if (rs.getObject("quantity") != null) {
                    item.setQuantity(rs.getInt("quantity"));
                }
                items.add(item);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return items;
    }

    public boolean approveItem(int itemId) {
        String sql = "UPDATE items SET status = 'approved' WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, itemId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean rejectItem(int itemId) {
        String sql = "UPDATE items SET status = 'rejected' WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, itemId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Item> getAllItems() {
        List<Item> items = new ArrayList<>();
        // 恢复type和quantity字段支持
        String sql = "SELECT id, name, description, price, image, category, seller_id, status, created_at, type, quantity FROM items ORDER BY created_at DESC";

        try (Connection conn = DBUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Item item = new Item();
                item.setId(rs.getInt("id"));
                item.setName(rs.getString("name"));
                item.setDescription(rs.getString("description"));
                item.setPrice(rs.getDouble("price"));
                item.setImage(rs.getString("image"));
                item.setCategory(rs.getString("category"));
                item.setSellerId(rs.getInt("seller_id"));
                item.setStatus(rs.getString("status"));
                item.setCreatedAt(rs.getTimestamp("created_at"));
                // 恢复type和quantity字段处理
                if (rs.getObject("type") != null) {
                    item.setType(rs.getString("type"));
                }
                if (rs.getObject("quantity") != null) {
                    item.setQuantity(rs.getInt("quantity"));
                }
                items.add(item);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return items;
    }

    public List<Item> getItemsBySeller(int sellerId) {
        List<Item> items = new ArrayList<>();
        // 恢复完整SQL查询，包含type和quantity字段
        String sql = "SELECT id, name, description, price, image, category, seller_id, status, created_at, type, quantity FROM items WHERE seller_id = ? ORDER BY created_at DESC";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, sellerId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Item item = new Item();
                item.setId(rs.getInt("id"));
                item.setName(rs.getString("name"));
                item.setDescription(rs.getString("description"));
                item.setPrice(rs.getDouble("price"));
                item.setImage(rs.getString("image"));
                item.setCategory(rs.getString("category"));
                item.setStatus(rs.getString("status"));
                item.setSellerId(rs.getInt("seller_id"));
                item.setCreatedAt(rs.getTimestamp("created_at"));
                // 处理type和quantity字段
                if (rs.getObject("type") != null) {
                    item.setType(rs.getString("type"));
                }
                if (rs.getObject("quantity") != null) {
                    item.setQuantity(rs.getInt("quantity"));
                }
                items.add(item);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return items;
    }
}