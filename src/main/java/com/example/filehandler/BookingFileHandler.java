package com.example.filehandler;

import com.example.models.Booking;
import java.io.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class BookingFileHandler {
    private static final Logger LOGGER = Logger.getLogger(BookingFileHandler.class.getName());
    private static final String BOOKINGS_FILE = "C:\\Users\\thami\\OneDrive\\Desktop\\final_OOP_project\\final_pj\\src\\main\\webapp\\data\\bookings.txt";

    public synchronized void saveBooking(Booking booking) throws IOException {
        if (booking.getBookingId() == 0) {
            int newId = getNextBookingId();
            booking.setBookingId(newId);
        }
        try (PrintWriter out = new PrintWriter(new FileWriter(BOOKINGS_FILE, true))) {
            out.println(booking.toFileString());
            LOGGER.info("Saved booking: " + booking.getBookingId());
        } catch (IOException e) {
            LOGGER.log(Level.SEVERE, "Failed to save booking: " + booking.getBookingId(), e);
            throw e;
        }
    }

    public synchronized List<Booking> readBookings() throws IOException {
        List<Booking> bookings = new ArrayList<>();
        File file = new File(BOOKINGS_FILE);

        if (!file.exists()) {
            LOGGER.warning("Bookings file does not exist, creating new: " + file.getAbsolutePath());
            file.getParentFile().mkdirs();
            file.createNewFile();
            return bookings;
        }

        try (BufferedReader reader = new BufferedReader(new FileReader(BOOKINGS_FILE))) {
            String line;
            while ((line = reader.readLine()) != null) {
                if (!line.trim().isEmpty()) {
                    Booking booking = Booking.fromFileString(line);
                    if (booking != null) {
                        bookings.add(booking);
                    }
                }
            }
        } catch (IOException e) {
            LOGGER.log(Level.SEVERE, "Failed to read bookings file", e);
            throw e;
        }
        LOGGER.info("Read " + bookings.size() + " bookings from file");
        return bookings;
    }

    public synchronized void updateBookings(List<Booking> bookings) throws IOException {
        try (PrintWriter out = new PrintWriter(new FileWriter(BOOKINGS_FILE))) {
            for (Booking booking : bookings) {
                out.println(booking.toFileString());
            }
            LOGGER.info("Updated booking list in file");
        } catch (IOException e) {
            LOGGER.log(Level.SEVERE, "Failed to update bookings file", e);
            throw e;
        }
    }

    public synchronized Booking findBookingById(int bookingId) throws IOException {
        for (Booking booking : readBookings()) {
            if (booking.getBookingId() == bookingId) {
                LOGGER.info("Found booking by ID: " + bookingId);
                return booking;
            }
        }
        LOGGER.info("No booking found for ID: " + bookingId);
        return null;
    }

    private synchronized int getNextBookingId() throws IOException {
        List<Booking> bookings = readBookings();
        if (bookings.isEmpty()) {
            return 1;
        }
        int maxId = bookings.stream()
                .mapToInt(Booking::getBookingId)
                .max()
                .orElse(0);
        return maxId + 1;
    }
}