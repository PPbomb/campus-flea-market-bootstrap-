package com.campusmarket.controller;

import com.campusmarket.dao.ItemDAO;
import com.campusmarket.model.Item;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/index")
public class IndexServlet extends HttpServlet {
    private ItemDAO itemDAO = new ItemDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 从会话中获取消息并在请求中设置
        HttpSession session = request.getSession();
        
        // 获取并设置成功消息
        String success = (String) session.getAttribute("success");
        if (success != null) {
            request.setAttribute("success", success);
            // 移除会话中的消息，避免重复显示
            session.removeAttribute("success");
        }
        
        // 获取并设置错误消息
        String error = (String) session.getAttribute("error");
        if (error != null) {
            request.setAttribute("error", error);
            // 移除会话中的消息，避免重复显示
            session.removeAttribute("error");
        }

        try {
            // 获取已审核的商品
            List<Item> approvedItems = itemDAO.getApprovedItems();
            request.setAttribute("items", approvedItems);
            request.getRequestDispatcher("index.jsp").forward(request, response);
        } catch (Exception e) {
            // 错误处理
            request.setAttribute("error", "加载商品列表失败，请稍后重试");
            request.getRequestDispatcher("index.jsp").forward(request, response);
        }
    }
}