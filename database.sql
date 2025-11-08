-- 校园二手市场数据库部署脚本
-- 版本: 1.0
-- 创建时间: 2025-11-07

-- 创建数据库
CREATE DATABASE IF NOT EXISTS `campus_market`
CHARACTER SET utf8mb4
COLLATE utf8mb4_0900_ai_ci;

USE `campus_market`;

-- 设置外键检查
SET FOREIGN_KEY_CHECKS = 0;

--
-- 表结构 `users`
--

DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `password` varchar(100) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `email` varchar(50) DEFAULT NULL,
  `role` enum('user','admin') DEFAULT 'user',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- 表结构 `items`
--

DROP TABLE IF EXISTS `items`;
CREATE TABLE `items` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `description` text,
  `price` decimal(10,2) NOT NULL,
  `image` varchar(100) DEFAULT NULL,
  `category` varchar(50) DEFAULT NULL,
  `status` enum('pending','approved','sold') DEFAULT 'pending',
  `seller_id` int NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `type` enum('physical','service') DEFAULT 'physical',
  `quantity` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `seller_id` (`seller_id`),
  CONSTRAINT `items_ibfk_1` FOREIGN KEY (`seller_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- 表结构 `orders`
--

DROP TABLE IF EXISTS `orders`;
CREATE TABLE `orders` (
  `id` int NOT NULL AUTO_INCREMENT,
  `item_id` int NOT NULL,
  `buyer_id` int NOT NULL,
  `quantity` int DEFAULT '1',
  `status` enum('pending','completed','cancelled') DEFAULT 'pending',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `item_id` (`item_id`),
  KEY `buyer_id` (`buyer_id`),
  CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`item_id`) REFERENCES `items` (`id`),
  CONSTRAINT `orders_ibfk_2` FOREIGN KEY (`buyer_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- 重新启用外键检查
SET FOREIGN_KEY_CHECKS = 1;

--
-- 插入用户数据
--

INSERT INTO `users` (`id`, `username`, `password`, `phone`, `email`, `role`, `created_at`) VALUES
(1, 'admin', '123', NULL, NULL, 'admin', '2025-11-07 04:48:09'),
(2, '001', '123', NULL, NULL, 'user', '2025-11-07 04:49:05'),
(5, 'admin2', '123', '111111111111', '123@qq.com', 'admin', '2025-11-07 04:58:50');

--
-- 插入商品数据
--

INSERT INTO `items` (`id`, `name`, `description`, `price`, `image`, `category`, `status`, `seller_id`, `created_at`, `type`, `quantity`) VALUES
(1, '笔记本电脑', '九成新笔记本电脑，配置良好', 3500.00, NULL, '电子产品', 'approved', 2, '2025-11-07 04:49:14', 'physical', 1),
(2, ' textbooks', '大学教材，几乎全新', 100.00, NULL, '图书文具', 'approved', 2, '2025-11-07 04:49:14', 'physical', 1),
(3, '自行车修理', '校园内自行车修理服务', 50.00, NULL, '生活服务', 'approved', 2, '2025-11-07 04:49:14', 'service', NULL),
(4, '冰箱', '无', 1000.00, '/uploads/048f0f3b-b6a0-4b16-8f76-97bb0e749442_115.jpg', '电子产品', 'approved', 2, '2025-11-07 07:20:35', 'physical', 1),
(5, '手办', '无', 249.97, '/uploads/b98b665a-4497-4cc7-b513-e12bd7f5268e_0015.jpg', '其他', 'approved', 2, '2025-11-07 08:29:32', 'physical', 1),
(6, '手办', 'w', 250.00, '/uploads/f7c8040b-93f3-4f3d-8d3e-876b395007c1_0013.jpg', '其他', 'sold', 2, '2025-11-07 08:36:47', 'physical', 0);



--
-- 重置自增ID
--

ALTER TABLE `users` AUTO_INCREMENT = 8;
ALTER TABLE `items` AUTO_INCREMENT = 10;
ALTER TABLE `orders` AUTO_INCREMENT = 6;

-- 部署完成提示
SELECT '数据库部署完成！' AS '状态';

-- 显示部署结果
SELECT
    (SELECT COUNT(*) FROM `users`) AS '用户数量',
    (SELECT COUNT(*) FROM `items`) AS '商品数量',
    (SELECT COUNT(*) FROM `orders`) AS '订单数量';