package com.example.models;

public class PremiumService extends Service {
    private int serviceTimeDuration; // Duration in minutes

    public PremiumService(int serviceId, String serviceName, double price, int serviceTimeDuration) {
        super(serviceId, serviceName, "Premium", price);
        this.serviceTimeDuration = serviceTimeDuration;
    }


    public int getServiceTimeDuration() {
        return serviceTimeDuration;
    }

    public void setServiceTimeDuration(int serviceTimeDuration) {
        this.serviceTimeDuration = serviceTimeDuration;
    }

    @Override
    public String toFileString() {
        return getServiceId() + "," + getServiceName() + "," + getServiceType() + "," + getPrice() + "," + serviceTimeDuration;
    }
}