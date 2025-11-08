
package com.campusmarket.tag;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.JspWriter;
import javax.servlet.jsp.tagext.SimpleTagSupport;
import java.io.IOException;

public class ShowStatusTag extends SimpleTagSupport {
    private String status;

    public void setStatus(String status) {
        this.status = status;
    }

    @Override
    public void doTag() throws JspException, IOException {
        if (status != null) {
            JspWriter out = getJspContext().getOut();
            String text = "";
            String badgeClass = "";

            switch (status) {
                case "pending":
                    text = "待审核";
                    badgeClass = "bg-warning";
                    break;
                case "approved":
                    text = "已上架";
                    badgeClass = "bg-success";
                    break;
                case "sold":
                    text = "已售出";
                    badgeClass = "bg-secondary";
                    break;
                default:
                    text = status;
                    badgeClass = "bg-info";
            }

            out.print("<span class=\"badge " + badgeClass + "\">" + text + "</span>");
        }
    }
}