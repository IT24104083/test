package com.example.models;

import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

public class Booking {
    private int bookingId;
    private int customerId;
    private int employeeId;
    private String customerName;
    private String employeeName;
    private List<Integer> serviceIds;
    private int scheduleId;
    private String date;
    private double time;
    private double totalPrice;

    public Booking() {

    }

    public Booking(int bookingId, int customerId, int employeeId, String customerName, String employeeName,
                   List<Integer> serviceIds, int scheduleId, String date, double time, double totalPrice) {
        this.bookingId = bookingId;
        this.customerId = customerId;
        this.employeeId = employeeId;
        this.customerName = customerName;
        this.employeeName = employeeName;
        this.serviceIds = serviceIds;
        this.scheduleId = scheduleId;
        this.date = date;
        this.time = time;
        this.totalPrice = totalPrice;
    }



    public int getBookingId() {

        return bookingId;

    }


    public void setBookingId(int bookingId) {

        this.bookingId = bookingId;
    }


    public int getCustomerId() {

        return customerId;
    }

    public void setCustomerId(int customerId) {
        this.customerId = customerId;

    }


    public int getEmployeeId() {

        return employeeId;
    }

    public void setEmployeeId(int employeeId) {
        this.employeeId = employeeId;
    }

    public String getCustomerName() {
        return customerName;
    }


    public void setCustomerName(String customerName) {

        this.customerName = customerName;
    }

    public String getEmployeeName() {
        return employeeName;
    }


    public void setEmployeeName(String employeeName) {
        this.employeeName = employeeName;
    }

    public List<Integer> getServiceIds() {
        return serviceIds;
    }

    public void setServiceIds(List<Integer> serviceIds) {
        this.serviceIds = serviceIds;

    }

    public int getScheduleId() {
        return scheduleId;
    }

    public void setScheduleId(int scheduleId) {
        this.scheduleId = scheduleId;
    }

    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
    }

    public double getTime() {
        return time;
    }

    public void setTime(double time) {
        this.time = time;
    }

    public double getTotalPrice() {
        return totalPrice;
    }

    public void setTotalPrice(double totalPrice) {
        this.totalPrice = totalPrice;

    }


    public String getServiceIdsAsString() {
        return serviceIds.stream().map(String::valueOf).collect(Collectors.joining(";"));
    }

    public String toFileString() {
        String serviceIdsStr = String.join(";", serviceIds.stream().map(String::valueOf).toList());
        return String.format("%d,%d,%d,%s,%s,%s,%d,%s,%.2f,%.2f",
                bookingId, customerId, employeeId, escapeCsv(customerName), escapeCsv(employeeName),
                serviceIdsStr, scheduleId, escapeCsv(date), time, totalPrice);
    }

    public static Booking fromFileString(String line) {
        String[] data = line.split(",", -1);
        if (data.length == 10) {
            try {
                List<Integer> serviceIds = Arrays.stream(data[5].split(";"))
                        .filter(s -> !s.isEmpty())
                        .map(Integer::parseInt)
                        .toList();
                return new Booking(
                        Integer.parseInt(data[0]), // bookingId
                        Integer.parseInt(data[1]), // customerId
                        Integer.parseInt(data[2]), // employeeId
                        unescapeCsv(data[3]),  // customer name
                        unescapeCsv(data[4]), // employee name
                        serviceIds,    // service id
                        Integer.parseInt(data[6]), //scheduleID
                        unescapeCsv(data[7]),  // date
                        Double.parseDouble(data[8]), // time
                        Double.parseDouble(data[9]) //total
                );
            } catch (NumberFormatException e) {
                System.err.println("Error parsing booking line: " + line);
                return null;
            }
        }
        System.err.println("Malformed booking line: " + line);
        return null;
    }

    private String escapeCsv(String value) {
        if (value == null) return "";
        return value.replace(",", "\\u002C");
    }

    private static String unescapeCsv(String value) {
        if (value == null) return "";
        return value.replace("\\u002C", ",");
    }
}