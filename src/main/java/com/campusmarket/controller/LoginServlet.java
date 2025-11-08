package com.campusmarket.controller;

import com.campusmarket.model.User;
import com.campusmarket.dao.UserDAO;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String remember = request.getParameter("remember");

        User user = userDAO.getUserByUsername(username);

        if (user != null && user.getPassword().equals(password)) {
            // 登录成功
            HttpSession session = request.getSession();
            session.setAttribute("user", user);

            // 记住用户名
            if ("on".equals(remember)) {
                Cookie cookie = new Cookie("username", username);
                cookie.setMaxAge(30 * 24 * 60 * 60); // 30天
                response.addCookie(cookie);
            } else {
                // 删除cookie
                Cookie cookie = new Cookie("username", "");
                cookie.setMaxAge(0);
                response.addCookie(cookie);
            }

            // 根据角色重定向
            if ("admin".equals(user.getRole())) {
                // 使用绝对路径确保始终通过Servlet
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            } else {
                // 使用绝对路径确保始终通过IndexServlet获取商品数据
                response.sendRedirect(request.getContextPath() + "/index");
            }
        } else {
            // 登录失败
            request.setAttribute("error", "用户名或密码错误");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}