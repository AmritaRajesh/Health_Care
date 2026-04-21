package com.hms.model;

public class Department {
    private int id;
    private String name;
    private String description;
    private int headDoctorId;
    private String headDoctorName;
    private String createdAt;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public int getHeadDoctorId() { return headDoctorId; }
    public void setHeadDoctorId(int headDoctorId) { this.headDoctorId = headDoctorId; }
    public String getHeadDoctorName() { return headDoctorName; }
    public void setHeadDoctorName(String headDoctorName) { this.headDoctorName = headDoctorName; }
    public String getCreatedAt() { return createdAt; }
    public void setCreatedAt(String createdAt) { this.createdAt = createdAt; }
}
