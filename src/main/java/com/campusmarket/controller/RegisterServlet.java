package com.campusmarket.controller;

import com.campusmarket.model.User;
import com.campusmarket.dao.UserDAO;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");

        // 检查用户名是否已存在
        if (userDAO.getUserByUsername(username) != null) {
            request.setAttribute("error", "用户名已存在");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        User user = new User(username, password, phone, email);
        if (userDAO.createUser(user)) {
            response.sendRedirect("login.jsp?success=" + java.net.URLEncoder.encode("注册成功，请登录", "UTF-8"));
        } else {
            request.setAttribute("error", "注册失败，请重试");
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }
}