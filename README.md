校园跳蚤市场系统
项目概述
校园跳蚤市场系统是一个专为高校师生设计的二手交易平台，旨在方便校园内闲置物品的流通与交易。系统采用Java Web技术栈开发，支持用户注册、物品发布、浏览购买、订单管理等核心功能，并提供完善的管理员后台进行系统管理。

技术栈
后端框架：Java Servlet + JSP
数据库：MySQL8.0
前端技术：Bootstrap 5、JavaScript、JSTL
构建工具：Maven
服务器：Tomcat8.5.72
系统架构
系统采用经典的MVC三层架构：

Model（模型层）：包含数据实体类和数据访问层（DAO）
View（视图层）：JSP页面，负责用户界面展示
Controller（控制器层）：Servlet，处理用户请求并调用相应的模型和视图
功能模块
1. 登录管理模块
用户登录/注册
管理员登录
权限控制与访问限制
记住登录状态功能
2. 系统管理模块
管理员账号管理：添加、编辑、重置密码、删除管理员
用户管理：查看用户信息、修改基本信息、重置密码
商品审核：审核用户发布的商品
数据统计：商品统计、订单统计、销售数据分析
3. 客户端模块
用户注册功能：收集用户名、密码、手机号、邮箱等信息
物品发布：支持实物和服务类商品发布，设置价格、数量、描述、图片等
浏览购买：查看已审核物品，按类别筛选，下单购买
订单管理：查看订单状态，管理个人订单
个人中心：查看个人信息、已发布物品和购买记录
数据库设计
系统主要包含三张核心数据表：

users表：存储用户信息

主键：id
字段：username, password, phone, email, role, created_at
items表：存储商品信息

主键：id
字段：name, description, price, image, category, status, seller_id, created_at, type, quantity
外键：seller_id（关联users表）
orders表：存储订单信息

主键：id
字段：item_id, buyer_id, quantity, status, created_at
外键：item_id（关联items表）, buyer_id（关联users表）
核心功能实现
权限控制
系统通过AuthFilter过滤器实现权限控制，确保：

未登录用户无法访问受保护页面
普通用户无法访问管理员功能
确保直接访问JSP页面的请求重定向到对应的Servlet
商品审核流程
用户发布商品后，商品状态默认为"待审核"
管理员通过后台审核商品
审核通过后，商品状态变为"已审核"并在前端展示
商品售出后，状态变为"已售出"
订单处理
用户下单购买商品
系统检查库存并创建订单
更新商品状态为"已售出"
用户可以在个人中心查看订单状态
安全措施
使用Cookie保存用户名（非密码）
使用外键约束保证数据完整性
实现事务管理确保操作原子性
部署指南
环境要求
JDK 1.8+ 或更高版本
MySQL 5.7+ 或更高版本
Tomcat 8.5+ 或更高版本
Maven 3.6+（用于项目构建）
部署步骤
数据库准备

打开MySQL命令行或客户端，执行以下命令：

-- 创建数据库
CREATE DATABASE campus_market;
USE campus_market;

-- 导入数据库结构和初始数据
-- 可以使用项目中的database.sql文件
项目配置

确保项目的数据库连接配置正确（通常在DBUtil.java中）：

// 数据库连接参数示例
private static final String URL = "jdbc:mysql://localhost:3306/campus_market?useSSL=false&serverTimezone=UTC";
private static final String USERNAME = "root";
private static final String PASSWORD = "your_password";
构建项目

使用Maven构建项目：

mvn clean package
构建成功后，会在target目录下生成campusmarket.war文件。

部署到Tomcat

将campusmarket.war文件复制到Tomcat的webapps目录下
启动Tomcat服务器
Tomcat会自动解压和部署war文件
访问系统

前台访问地址：http://localhost:8080/campusmarket/
管理后台访问地址：http://localhost:8080/campusmarket/admin/dashboard
默认管理员账号：admin
默认管理员密码：123
常见问题与解决方案
1. 数据库连接失败
症状：系统无法连接数据库，页面显示数据库连接错误。

解决方案：

检查MySQL服务是否启动
确认数据库名、用户名、密码是否正确
检查防火墙是否阻止了MySQL连接
2. 商品审核后仍不显示
症状：管理员已审核商品，但前台页面不显示该商品。

解决方案：

确认商品状态已更新为"approved"
检查ItemServlet是否正确获取已审核商品
尝试重启Tomcat服务器
项目结构说明
campus-flea-market/
├── src/main/java/com/campusmarket/  # Java源代码
│   ├── controller/                   # Servlet控制器
│   ├── dao/                          # 数据访问对象
│   ├── model/                        # 实体类
│   ├── filter/                       # 过滤器
│   ├── service/                      # 业务逻辑层
│   ├── tag/                          # 自定义标签
│   └── util/                         # 工具类
├── src/main/webapp/                  # Web应用资源
│   ├── WEB-INF/                      # Web配置和JSP页面
│   ├── js/                           # JavaScript文件
│   └── uploads/                      # 上传文件目录
├── pom.xml                           # Maven配置文件
└── database.sql                      # 数据库初始化脚本
维护与扩展
添加新功能
在model包中创建新的实体类
在dao包中实现数据访问方法
创建对应的Servlet处理请求
开发JSP页面进行展示
配置web.xml或使用注解进行路由映射
性能优化建议
对频繁查询的字段建立索引
实现分页加载大量数据
优化图片存储，考虑使用CDN
合理使用数据库连接池
添加缓存机制减少数据库查询
注意事项
默认管理员账号仅用于初始登录，请及时修改密码
定期备份数据库以防止数据丢失
生产环境中应加强安全措施，如密码加密存储
建议部署HTTPS以保障传输安全
定期清理过期数据和无效文件
