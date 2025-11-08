package com.campusmarket.filter;

import com.campusmarket.model.User;
import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter({"/items", "/orders", "/my-items.jsp", "/add-item.jsp", "/my-orders.jsp", "/admin/*"})
public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);

        // 首先检查是否登录
        if (session == null || session.getAttribute("user") == null) {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login.jsp");
            return;
        }

        String path = httpRequest.getRequestURI();

        // 检查管理员权限（仅对管理员路径）
        if (path.contains("/admin/")) {
            User user = (User) session.getAttribute("user");
            if (!"admin".equals(user.getRole())) {
                httpResponse.sendRedirect(httpRequest.getContextPath() + "/index.jsp");
                return;
            }
        }
        
        // 确保直接访问my-orders.jsp的请求重定向到控制器
        if (path.endsWith("/my-orders.jsp")) {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/my-orders");
            return;
        }
        
        chain.doFilter(request, response);
    }

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void destroy() {}
}