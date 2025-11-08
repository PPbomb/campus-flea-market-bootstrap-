package com.campusmarket.controller;

import com.campusmarket.dao.OrderDAO;
import com.campusmarket.model.Order;
import com.campusmarket.model.User;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/my-orders")
public class OrderListServlet extends HttpServlet {
    private OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        // 检查用户是否登录
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // 确保只获取当前登录用户的订单
        int currentUserId = user.getId();
        List<Order> orders = orderDAO.getOrdersByUser(currentUserId);
        
        // 添加调试信息
        System.out.println("用户ID: " + currentUserId + " 获取订单数量: " + orders.size());
        
        request.setAttribute("orders", orders);
        request.setAttribute("orderCount", orders.size());

        // 转发到订单页面
        request.getRequestDispatcher("my-orders.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 确保Post请求也只返回当前用户的订单
        doGet(request, response);
    }
}