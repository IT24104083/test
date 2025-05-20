package com.example.models;

public abstract class Service {
    private int serviceId;
    private String serviceName;
    private String serviceType; // "Regular" or "Premium"
    private double price;

    public Service(int serviceId, String serviceName, String serviceType, double price) {
        this.serviceId = serviceId;
        this.serviceName = serviceName;
        this.serviceType = serviceType;
        this.price = price;
    }

    // Getters and Setters
    public int getServiceId() {
        return serviceId;
    }

    public void setServiceId(int serviceId) {
        this.serviceId = serviceId;
    }

    public String getServiceName() {
        return serviceName;
    }

    public void setServiceName(String serviceName) {
        this.serviceName = serviceName;
    }

    public String getServiceType() {
        return serviceType;
    }

    public void setServiceType(String serviceType) {
        this.serviceType = serviceType;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    // Abstract methods for file handling
    public abstract String toFileString();
    public static Service fromFileString(String line) {
        String[] parts = line.split(",");
        int serviceId = Integer.parseInt(parts[0]);
        String serviceName = parts[1];
        String serviceType = parts[2];
        double price = Double.parseDouble(parts[3]);

        if ("Premium".equals(serviceType)) {
            int serviceTimeDuration = Integer.parseInt(parts[4]);
            return new PremiumService(serviceId, serviceName, price, serviceTimeDuration);
        } else {
            return new RegularService(serviceId, serviceName, price);
        }
    }
}