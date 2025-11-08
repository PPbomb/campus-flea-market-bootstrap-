package com.campusmarket.tag;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.JspWriter;
import javax.servlet.jsp.tagext.SimpleTagSupport;
import java.io.IOException;
import java.text.DecimalFormat;

public class FormatPriceTag extends SimpleTagSupport {
    private Double value;

    public void setValue(Double value) {
        this.value = value;
    }

    @Override
    public void doTag() throws JspException, IOException {
        if (value != null) {
            DecimalFormat df = new DecimalFormat("¥#0.00");
            JspWriter out = getJspContext().getOut();
            out.print(df.format(value));
        }
    }
}
