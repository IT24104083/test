package com.example.models;

public class RegularService extends Service {
    public RegularService(int serviceId, String serviceName, double price) {
        super(serviceId, serviceName, "Regular", price);
    }

    @Override
    public String toFileString() {
        return getServiceId() + "," + getServiceName() + "," + getServiceType() + "," + getPrice();
    }
}