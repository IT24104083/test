package com.example.filehandler;

import com.example.models.Schedule;

import java.io.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class ScheduleFileHandler {
    private static final Logger LOGGER = Logger.getLogger(ScheduleFileHandler.class.getName());
    private static final String SCHEDULES_FILE = "C:\\Users\\thami\\OneDrive\\Desktop\\final_OOP_project\\final_pj\\src\\main\\webapp\\data\\schedules.txt";

    public synchronized void saveSchedule(Schedule schedule) throws IOException {
        if (schedule.getScheduleId() == 0) {
            int newId = getNextScheduleId();
            schedule.setScheduleId(newId);
        }
        try (PrintWriter out = new PrintWriter(new FileWriter(SCHEDULES_FILE, true))) {
            out.println(schedule.toFileString());
            LOGGER.info("Saved schedule: " + schedule.getScheduleId());
        } catch (IOException e) {
            LOGGER.log(Level.SEVERE, "Failed to save schedule: " + schedule.getScheduleId(), e);
            throw e;
        }
    }

    public synchronized List<Schedule> readSchedules() throws IOException {
        List<Schedule> schedules = new ArrayList<>();
        File file = new File(SCHEDULES_FILE);

        if (!file.exists()) {
            LOGGER.warning("Schedules file does not exist, creating new: " + file.getAbsolutePath());
            file.getParentFile().mkdirs();
            file.createNewFile();
            return schedules;
        }

        try (BufferedReader reader = new BufferedReader(new FileReader(SCHEDULES_FILE))) {
            String line;
            while ((line = reader.readLine()) != null) {
                if (!line.trim().isEmpty()) {
                    Schedule schedule = Schedule.fromFileString(line);
                    if (schedule != null) {
                        schedules.add(schedule);
                    }
                }
            }
        } catch (IOException e) {
            LOGGER.log(Level.SEVERE, "Failed to read schedules file", e);
            throw e;
        }
        LOGGER.info("Read " + schedules.size() + " schedules from file");
        return schedules;
    }

    public synchronized List<Schedule> readSchedulesByEmployeeId(int employeeId) throws IOException {
        List<Schedule> allSchedules = readSchedules();
        List<Schedule> filteredSchedules = new ArrayList<>();
        for (Schedule schedule : allSchedules) {
            if (schedule.getEmployeeId() == employeeId) {
                filteredSchedules.add(schedule);
            }
        }
        return filteredSchedules;
    }

    public synchronized List<Schedule> readAvailableSchedules() throws IOException {
        return readSchedules();
    }

    public synchronized void updateSchedules(List<Schedule> schedules) throws IOException {
        try (PrintWriter out = new PrintWriter(new FileWriter(SCHEDULES_FILE))) {
            for (Schedule schedule : schedules) {
                out.println(schedule.toFileString());
            }
            LOGGER.info("Updated schedule list in file");
        } catch (IOException e) {
            LOGGER.log(Level.SEVERE, "Failed to update schedules file", e);
            throw e;
        }
    }

    public synchronized void removeSchedule(int scheduleId) throws IOException {
        List<Schedule> schedules = readSchedules();
        schedules.removeIf(schedule -> schedule.getScheduleId() == scheduleId);
        updateSchedules(schedules);
        LOGGER.info("Removed schedule: " + scheduleId);
    }

    public synchronized boolean isTimeSlotTaken(int employeeId, String date, double time) throws IOException {
        List<Schedule> schedules = readSchedules();
        for (Schedule schedule : schedules) {
            if (schedule.getEmployeeId() == employeeId &&
                    schedule.getDate().equals(date) &&
                    Math.abs(schedule.getTime() - time) < 0.01) {
                return true;
            }
        }
        return false;
    }

    private synchronized int getNextScheduleId() throws IOException {
        List<Schedule> schedules = readSchedules();
        if (schedules.isEmpty()) {
            return 1;
        }
        int maxId = schedules.stream()
                .mapToInt(Schedule::getScheduleId)
                .max()
                .orElse(0);
        return maxId + 1;
    }
}