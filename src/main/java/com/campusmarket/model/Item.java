package com.campusmarket.model;

import java.util.Date;

public class Item {
    private int id;
    private String name;
    private String description;
    private double price;
    private String image;
    private String category;
    private String status;
    private int sellerId;
    private Date createdAt;
    private String sellerName; // 用于显示
    private String type; // 物品类型：physical（实物）或service（服务）
    private Integer quantity; // 数量，实物类必填，服务类可为null

    // 构造方法、getter、setter
    public Item() {}

    public Item(String name, String description, double price, String category, int sellerId) {
        this.name = name;
        this.description = description;
        this.price = price;
        this.category = category;
        this.sellerId = sellerId;
        this.status = "pending";
        this.type = "physical"; // 默认实物类
        this.quantity = 1; // 默认数量1
    }

    // getter和setter
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }
    public String getImage() { return image; }
    public void setImage(String image) { this.image = image; }
    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }
    public String getStatus() { return status; }
    public String getType() { return type; }
    public void setType(String type) { this.type = type; }
    public Integer getQuantity() { return quantity; }
    public void setQuantity(Integer quantity) { this.quantity = quantity; }
    public void setStatus(String status) { this.status = status; }
    public int getSellerId() { return sellerId; }
    public void setSellerId(int sellerId) { this.sellerId = sellerId; }
    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }
    public String getSellerName() { return sellerName; }
    public void setSellerName(String sellerName) { this.sellerName = sellerName; }
}