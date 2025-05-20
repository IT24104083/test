package com.example.models;

public class Schedule {
    private int scheduleId;
    private double time;
    private String date;
    private int employeeId;
    private String employeeName;

    public Schedule() {
    }

    public Schedule(int scheduleId, double time, String date, int employeeId, String employeeName) {
        this.scheduleId = scheduleId;
        this.time = time;
        this.date = date;
        this.employeeId = employeeId;
        this.employeeName = employeeName;
    }

    public int getScheduleId() {
        return scheduleId;
    }

    public void setScheduleId(int scheduleId) {
        this.scheduleId = scheduleId;
    }

    public double getTime() {
        return time;
    }

    public void setTime(double time) {
        this.time = time;
    }

    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
    }

    public int getEmployeeId() {
        return employeeId;
    }

    public void setEmployeeId(int employeeId) {
        this.employeeId = employeeId;
    }

    public String getEmployeeName() {
        return employeeName;
    }

    public void setEmployeeName(String employeeName) {
        this.employeeName = employeeName;
    }

    public void enterTime(double time) {
        this.time = time;
    }

    public void enterDate(String date) {
        this.date = date;
    }

    public String toFileString() {
        return String.format("%d,time:%.2f,date:%s,employeeId:%d,employeeName:%s",
                scheduleId,
                time,
                escapeCsv(date),
                employeeId,
                escapeCsv(employeeName));
    }

    public static Schedule fromFileString(String line) {
        String[] data = line.split(",", -1);
        if (data.length == 5) {
            try {
                int scheduleId = Integer.parseInt(data[0]);
                double time = Double.parseDouble(data[1].substring("time:".length()));
                String date = unescapeCsv(data[2].substring("date:".length()));
                int employeeId = Integer.parseInt(data[3].substring("employeeId:".length()));
                String employeeName = unescapeCsv(data[4].substring("employeeName:".length()));
                return new Schedule(scheduleId, time, date, employeeId, employeeName);
            } catch (NumberFormatException | StringIndexOutOfBoundsException e) {
                System.err.println("Error parsing schedule line: " + line);
                return null;
            }
        }
        System.err.println("Malformed schedule line: " + line);
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

    @Override
    public String toString() {
        return "Schedule{" +
                "scheduleId=" + scheduleId +
                ", time=" + time +
                ", date='" + date + '\'' +
                ", employeeId=" + employeeId +
                ", employeeName='" + employeeName + '\'' +
                '}';
    }
}