package com.campusmarket.controller;

import com.campusmarket.model.Item;
import com.campusmarket.model.User;
import com.campusmarket.dao.ItemDAO;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.List;
import java.util.UUID;

@WebServlet("/items")
@MultipartConfig(location = "", fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10, // 10MB
        maxRequestSize = 1024 * 1024 * 50) // 50MB
public class ItemServlet extends HttpServlet {
    private ItemDAO itemDAO = new ItemDAO();
    private String uploadDirectory = null;
    
    @Override
    public void init() throws ServletException {
        // 初始化上传目录
        uploadDirectory = getServletContext().getRealPath("/uploads");
        if (uploadDirectory == null) {
            uploadDirectory = getServletContext().getRealPath("") + File.separator + "uploads";
        }
        // 确保上传目录存在
        File dir = new File(uploadDirectory);
        if (!dir.exists()) {
            dir.mkdirs();
        }
        System.out.println("[调试] 上传目录设置为: " + uploadDirectory);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("=== ItemServlet 被调用 ===");
        String action = request.getParameter("action");

        if ("my".equals(action)) {
            // 查看我的商品
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");

            if (user == null) {
                response.sendRedirect("login.jsp");
                return;
            }

            List<Item> myItems = itemDAO.getItemsBySeller(user.getId());
            System.out.println("我的商品数量: " + myItems.size());
            request.setAttribute("items", myItems);
            request.getRequestDispatcher("my-items.jsp").forward(request, response);
        } else {
            // 查看所有已审核商品
            List<Item> approvedItems = itemDAO.getApprovedItems();
            System.out.println("已审核商品数量: " + approvedItems.size());
            for (Item item : approvedItems) {
                System.out.println("商品: " + item.getName() + ", 状态: " + item.getStatus());
            }

            request.setAttribute("items", approvedItems);
            request.getRequestDispatcher("index.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");

            if (user == null) {
                response.sendRedirect("login.jsp");
                return;
            }
            System.out.println("=== 开始处理商品发布请求 ===");

        // 获取表单参数
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        
        // 验证必填字段
        if (name == null || name.trim().isEmpty()) {
            request.setAttribute("error", "请输入商品名称");
            request.getRequestDispatcher("add-item.jsp").forward(request, response);
            return;
        }
        
        if (description == null || description.trim().isEmpty()) {
            request.setAttribute("error", "请输入商品描述");
            request.getRequestDispatcher("add-item.jsp").forward(request, response);
            return;
        }
        
        // 添加价格验证
        double price = 0;
        try {
            String priceParam = request.getParameter("price");
            if (priceParam == null || priceParam.isEmpty()) {
                request.setAttribute("error", "请输入价格");
                request.getRequestDispatcher("add-item.jsp").forward(request, response);
                return;
            }
            price = Double.parseDouble(priceParam);
            if (price <= 0) {
                request.setAttribute("error", "价格必须大于0");
                request.getRequestDispatcher("add-item.jsp").forward(request, response);
                return;
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "价格格式错误，请输入数字");
            request.getRequestDispatcher("add-item.jsp").forward(request, response);
            return;
        }
        
        String category = request.getParameter("category");
        
        // 验证类别
        if (category == null || category.trim().isEmpty()) {
            request.setAttribute("error", "请选择商品类别");
            request.getRequestDispatcher("add-item.jsp").forward(request, response);
            return;
        }
        
        // 获取并设置商品类型和数量
        String type = request.getParameter("type");
        if (type == null || type.trim().isEmpty()) {
            type = "physical"; // 默认类型为实物
        }
        
        Integer quantity = null;
        if ("physical".equals(type)) {
            // 实物类商品需要设置数量
            String quantityParam = request.getParameter("quantity");
            if (quantityParam != null && !quantityParam.trim().isEmpty()) {
                try {
                    quantity = Integer.parseInt(quantityParam);
                    if (quantity <= 0) {
                        request.setAttribute("error", "数量必须大于0");
                        request.getRequestDispatcher("add-item.jsp").forward(request, response);
                        return;
                    }
                } catch (NumberFormatException e) {
                    request.setAttribute("error", "数量格式错误，请输入数字");
                    request.getRequestDispatcher("add-item.jsp").forward(request, response);
                    return;
                }
            } else {
                request.setAttribute("error", "实物类商品必须设置数量");
                request.getRequestDispatcher("add-item.jsp").forward(request, response);
                return;
            }
        }

        // 处理文件上传
        String imagePath = null;
        try {
            Part filePart = request.getPart("image");
            if (filePart != null && filePart.getSize() > 0) {
                // 获取文件名
                String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                // 生成唯一文件名
                String uniqueFileName = UUID.randomUUID().toString() + "_" + fileName;
                // 保存文件
                Path filePath = Paths.get(uploadDirectory + File.separator + uniqueFileName);
                try (InputStream input = filePart.getInputStream()) {
                    Files.copy(input, filePath, StandardCopyOption.REPLACE_EXISTING);
                }
                // 只存储文件名
                imagePath = "/uploads/"+uniqueFileName;
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "文件上传失败");
            request.getRequestDispatcher("add-item.jsp").forward(request, response);
            return;
        }

        // 创建商品对象
        Item item = new Item(name, description, price, category, user.getId());
        item.setImage(imagePath);
        item.setType(type);
        item.setQuantity(quantity);
        
        // 添加详细的商品对象日志
        System.out.println("商品对象创建完成，详细信息：");
        System.out.println("- 名称: " + item.getName());
        System.out.println("- 价格: " + item.getPrice());
        System.out.println("- 描述长度: " + (item.getDescription() != null ? item.getDescription().length() : "null") + " 字符");
        System.out.println("- 类别: " + item.getCategory());
        System.out.println("- 卖家ID: " + item.getSellerId());
        System.out.println("- 图片路径: " + item.getImage());
        System.out.println("- 状态: " + item.getStatus());
        System.out.println("- 类型: " + item.getType());
        System.out.println("- 数量: " + item.getQuantity());
        
        // 验证上传目录是否存在
        System.out.println("上传目录: " + uploadDirectory);
        File uploadDir = new File(uploadDirectory);
        System.out.println("上传目录存在: " + uploadDir.exists() + ", 可写: " + uploadDir.canWrite());

        // 添加详细日志
        System.out.println("准备创建商品: ");
        System.out.println("名称: " + name);
        System.out.println("价格: " + price);
        System.out.println("类别: " + category);
        System.out.println("图片路径: " + imagePath);

        // 尝试创建商品
        System.out.println("开始调用ItemDAO.createItem()方法创建商品...");
        boolean createResult = itemDAO.createItem(item);
        System.out.println("ItemDAO.createItem()返回结果: " + createResult);
        
        if (createResult) {
            System.out.println("商品发布成功: " + name);
            response.sendRedirect("items?action=my&success=" + java.net.URLEncoder.encode("商品发布成功，等待审核", "UTF-8"));
        } else {
            System.out.println("商品发布失败: " + name);
            request.setAttribute("error", "商品发布失败，请稍后重试");
            request.getRequestDispatcher("add-item.jsp").forward(request, response);
        }
        System.out.println("=== 商品发布请求处理完成 ===");
    } catch (Exception e) {
        // 全局异常处理
        System.out.println("=== 商品发布过程发生异常 ===");
        System.out.println("异常类型: " + e.getClass().getName());
        System.out.println("异常消息: " + e.getMessage());
        System.out.println("异常堆栈:");
        e.printStackTrace();
        request.setAttribute("error", "发布过程发生错误: " + e.getMessage());
        request.getRequestDispatcher("add-item.jsp").forward(request, response);
    }
    }
}