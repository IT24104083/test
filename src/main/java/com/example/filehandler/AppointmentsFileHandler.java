package com.example.filehandler;

import com.example.models.Booking;
import java.io.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class AppointmentsFileHandler {
    private static final Logger LOGGER = Logger.getLogger(AppointmentsFileHandler.class.getName());
    private static final String APPOINTMENTS_FILE = "C:\\Users\\thami\\OneDrive\\Desktop\\final_OOP_project\\final_pj\\src\\main\\webapp\\data\\appointments.txt";

    public synchronized void saveAppointments(List<Booking> appointments) throws IOException {
        File file = new File(APPOINTMENTS_FILE);
        if (!file.exists()) {
            file.getParentFile().mkdirs();
            file.createNewFile();
        }
        try (PrintWriter out = new PrintWriter(new FileWriter(APPOINTMENTS_FILE))) {
            for (Booking booking : appointments) {
                out.println(booking.toFileString());
            }
            LOGGER.info("Saved " + appointments.size() + " appointments to file");
        } catch (IOException e) {
            LOGGER.log(Level.SEVERE, "Failed to save appointments", e);
            throw e;
        }
    }

    public synchronized List<Booking> readAppointments() throws IOException {
        List<Booking> appointments = new ArrayList<>();
        File file = new File(APPOINTMENTS_FILE);

        if (!file.exists()) {
            LOGGER.warning("Appointments file does not exist, creating new: " + file.getAbsolutePath());
            file.getParentFile().mkdirs();
            file.createNewFile();
            return appointments;
        }

        try (BufferedReader reader = new BufferedReader(new FileReader(APPOINTMENTS_FILE))) {
            String line;
            while ((line = reader.readLine()) != null) {
                if (!line.trim().isEmpty()) {
                    Booking booking = Booking.fromFileString(line);
                    if (booking != null) {
                        appointments.add(booking);
                    }
                }
            }
        } catch (IOException e) {
            LOGGER.log(Level.SEVERE, "Failed to read appointments file", e);
            throw e;
        }
        LOGGER.info("Read " + appointments.size() + " appointments from file");
        return appointments;
    }

    public synchronized List<Booking> readAppointmentsByEmployeeId(int employeeId) throws IOException {
        List<Booking> allAppointments = readAppointments();
        List<Booking> filteredAppointments = new ArrayList<>();
        for (Booking booking : allAppointments) {
            if (booking.getEmployeeId() == employeeId) {
                filteredAppointments.add(booking);
            }
        }
        return filteredAppointments;
    }
}