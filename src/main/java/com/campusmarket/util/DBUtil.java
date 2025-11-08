package com.campusmarket.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBUtil {
    private static final String URL;
    private static final String USER;
    private static final String PASSWORD;

    static {
        try {
            // 从环境变量读取，如果没有则使用默认值
            URL = System.getenv("DB_URL") != null ?
                    System.getenv("DB_URL") :
                    "jdbc:mysql://localhost:3306/campus_market?useUnicode=true&characterEncoding=UTF-8&useSSL=false&serverTimezone=Asia/Shanghai";

            USER = System.getenv("DB_USER") != null ?
                    System.getenv("DB_USER") : "root";

            PASSWORD = System.getenv("DB_PASSWORD") != null ?
                    System.getenv("DB_PASSWORD") : "123456";

            Class.forName("com.mysql.cj.jdbc.Driver");
            System.out.println("数据库配置: " + URL);

        } catch (ClassNotFoundException e) {
            throw new RuntimeException("数据库驱动加载失败", e);
        }
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}