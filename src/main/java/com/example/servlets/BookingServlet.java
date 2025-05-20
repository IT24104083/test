package com.example.servlets;

import com.example.filehandler.AppointmentsFileHandler;
import com.example.filehandler.BookingFileHandler;
import com.example.filehandler.EmployeeFileHandler;
import com.example.filehandler.ScheduleFileHandler;
import com.example.filehandler.ServiceFileHandler;
import com.example.models.Booking;
import com.example.models.Employee;
import com.example.models.Schedule;
import com.example.models.Service;
import com.example.models.User;
import com.example.util.CustomQueue;
import com.example.util.QuickSort;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(urlPatterns = {"/bookings", "/bookings/create", "/bookings/edit", "/bookings/delete"})
public class BookingServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(BookingServlet.class.getName());
    private final BookingFileHandler bookingFileHandler = new BookingFileHandler();
    private final AppointmentsFileHandler appointmentsFileHandler = new AppointmentsFileHandler();
    private final ScheduleFileHandler scheduleFileHandler = new ScheduleFileHandler();
    private final ServiceFileHandler serviceFileHandler = new ServiceFileHandler();
    private final EmployeeFileHandler employeeFileHandler = new EmployeeFileHandler();
    private final CustomQueue unsortedQueue = new CustomQueue();
    private final CustomQueue sortedQueue = new CustomQueue();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            if ("/bookings".equals(path)) {
                List<Booking> bookings = bookingFileHandler.readBookings();
                List<Booking> userBookings = new ArrayList<>();
                for (Booking booking : bookings) {
                    if (booking != null && booking.getCustomerId() == user.getCustomerId()) {
                        userBookings.add(booking);
                    }
                }
                Booking[] bookingArray = userBookings.toArray(new Booking[0]);
                QuickSort.sort(bookingArray);
                userBookings = Arrays.asList(bookingArray);

                request.setAttribute("bookings", userBookings);
                request.setAttribute("services", serviceFileHandler.readServices());
                request.setAttribute("employees", employeeFileHandler.readAllEmployees());
                request.getRequestDispatcher("/account.jsp").forward(request, response);
            } else if ("/bookings/edit".equals(path)) {
                int bookingId;
                try {
                    bookingId = Integer.parseInt(request.getParameter("bookingId"));
                } catch (NumberFormatException e) {
                    request.setAttribute("error", "Invalid booking ID.");
                    doGet(request, response);
                    return;
                }
                Booking booking = bookingFileHandler.findBookingById(bookingId);
                if (booking == null || booking.getCustomerId() != user.getCustomerId()) {
                    request.setAttribute("error", "Booking not found or you don't have permission.");
                    doGet(request, response);
                    return;
                }
                request.setAttribute("booking", booking);
                request.setAttribute("services", serviceFileHandler.readServices());
                request.setAttribute("schedules", scheduleFileHandler.readAvailableSchedules());
                request.getRequestDispatcher("/editBooking.jsp").forward(request, response);
            } else if ("/bookings/create".equals(path)) {
                request.setAttribute("services", serviceFileHandler.readServices());
                request.setAttribute("schedules", scheduleFileHandler.readAvailableSchedules());
                request.getRequestDispatcher("/createBooking.jsp").forward(request, response);
            }
        } catch (IOException e) {
            LOGGER.log(Level.SEVERE, "Error processing GET request: " + path, e);
            request.setAttribute("error", "An error occurred while processing your request.");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        if ("/bookings/create".equals(path)) {
            synchronized (this) {
                try {
                    int scheduleId = Integer.parseInt(request.getParameter("scheduleId"));
                    String[] serviceIdsStr = request.getParameterValues("serviceIds");
                    if (serviceIdsStr == null || serviceIdsStr.length == 0) {
                        throw new IllegalArgumentException("At least one service must be selected.");
                    }
                    List<Integer> serviceIds = Arrays.stream(serviceIdsStr)
                            .map(Integer::parseInt)
                            .toList();

                    Schedule schedule = null;
                    List<Schedule> schedules = scheduleFileHandler.readSchedules();
                    for (Schedule s : schedules) {
                        if (s.getScheduleId() == scheduleId) {
                            schedule = s;
                            break;
                        }
                    }
                    if (schedule == null) {
                        throw new IllegalArgumentException("Selected schedule is not available.");
                    }

                    double totalPrice = 0;
                    List<Service> services = serviceFileHandler.readServices();
                    for (Integer serviceId : serviceIds) {
                        for (Service service : services) {
                            if (service.getServiceId() == serviceId) {
                                totalPrice += service.getPrice();
                                break;
                            }
                        }
                    }

                    Booking booking = new Booking(
                            0, // Auto-generated
                            user.getCustomerId(),
                            schedule.getEmployeeId(),
                            user.getName(),
                            schedule.getEmployeeName(),
                            serviceIds,
                            scheduleId,
                            schedule.getDate(),
                            schedule.getTime(),
                            totalPrice
                    );

                    scheduleFileHandler.removeSchedule(scheduleId); // Remove schedule first to prevent race conditions
                    if (unsortedQueue.isFull()) {
                        Booking[] queuedBookings = unsortedQueue.toArray();
                        for (Booking b : queuedBookings) {
                            if (b != null) {
                                bookingFileHandler.saveBooking(b);
                            }
                        }
                        unsortedQueue.clear();
                    }
                    unsortedQueue.enqueue(booking);
                    bookingFileHandler.saveBooking(booking);

                    // Update sorted queue and appointments.txt
                    List<Booking> allBookings = bookingFileHandler.readBookings();
                    Booking[] bookingArray = allBookings.toArray(new Booking[0]);
                    QuickSort.sort(bookingArray);
                    sortedQueue.clear();
                    for (Booking b : bookingArray) {
                        if (b != null && !sortedQueue.isFull()) {
                            sortedQueue.enqueue(b);
                        }
                    }
                    appointmentsFileHandler.saveAppointments(Arrays.asList(bookingArray));

                    request.setAttribute("success", "Booking created successfully!");
                    response.sendRedirect(request.getContextPath() + "/bookings");
                } catch (NumberFormatException e) {
                    LOGGER.log(Level.WARNING, "Invalid input format", e);
                    request.setAttribute("error", "Invalid input format for schedule or services.");
                    forwardToCreate(request, response);
                } catch (IllegalArgumentException e) {
                    LOGGER.log(Level.WARNING, "Validation error: " + e.getMessage(), e);
                    request.setAttribute("error", e.getMessage());
                    forwardToCreate(request, response);
                } catch (IOException e) {
                    LOGGER.log(Level.SEVERE, "IO error creating booking", e);
                    request.setAttribute("error", "Failed to create booking due to a server error.");
                    forwardToCreate(request, response);
                } catch (Exception e) {
                    LOGGER.log(Level.SEVERE, "Unexpected error creating booking", e);
                    request.setAttribute("error", "An unexpected error occurred.");
                    forwardToCreate(request, response);
                }
            }
        } else if ("/bookings/edit".equals(path)) {
            synchronized (this) {
                try {
                    int bookingId = Integer.parseInt(request.getParameter("bookingId"));
                    Booking existingBooking = bookingFileHandler.findBookingById(bookingId);
                    if (existingBooking == null || existingBooking.getCustomerId() != user.getCustomerId()) {
                        throw new IllegalArgumentException("Booking not found or you don't have permission.");
                    }

                    int scheduleId = Integer.parseInt(request.getParameter("scheduleId"));
                    String[] serviceIdsStr = request.getParameterValues("serviceIds");
                    if (serviceIdsStr == null || serviceIdsStr.length == 0) {
                        throw new IllegalArgumentException("At least one service must be selected.");
                    }
                    List<Integer> serviceIds = Arrays.stream(serviceIdsStr)
                            .map(Integer::parseInt)
                            .toList();

                    Schedule schedule = null;
                    List<Schedule> schedules = scheduleFileHandler.readSchedules();
                    for (Schedule s : schedules) {
                        if (s.getScheduleId() == scheduleId) {
                            schedule = s;
                            break;
                        }
                    }
                    if (schedule == null) {
                        throw new IllegalArgumentException("Selected schedule is not available.");
                    }

                    double totalPrice = 0;
                    List<Service> services = serviceFileHandler.readServices();
                    for (Integer serviceId : serviceIds) {
                        for (Service service : services) {
                            if (service.getServiceId() == serviceId) {
                                totalPrice += service.getPrice();
                                break;
                            }
                        }
                    }

                    // Restore old schedule
                    Schedule oldSchedule = new Schedule(
                            existingBooking.getScheduleId(),
                            existingBooking.getTime(),
                            existingBooking.getDate(),
                            existingBooking.getEmployeeId(),
                            existingBooking.getEmployeeName()
                    );
                    scheduleFileHandler.saveSchedule(oldSchedule);

                    Booking updatedBooking = new Booking(
                            bookingId,
                            user.getCustomerId(),
                            schedule.getEmployeeId(),
                            user.getName(),
                            schedule.getEmployeeName(),
                            serviceIds,
                            scheduleId,
                            schedule.getDate(),
                            schedule.getTime(),
                            totalPrice
                    );

                    scheduleFileHandler.removeSchedule(scheduleId); // Remove new schedule
                    List<Booking> bookings = bookingFileHandler.readBookings();
                    for (int i = 0; i < bookings.size(); i++) {
                        if (bookings.get(i) != null && bookings.get(i).getBookingId() == bookingId) {
                            bookings.set(i, updatedBooking);
                            break;
                        }
                    }
                    bookingFileHandler.updateBookings(bookings);

                    // Update sorted queue and appointments.txt
                    Booking[] bookingArray = bookings.toArray(new Booking[0]);
                    QuickSort.sort(bookingArray);
                    sortedQueue.clear();
                    for (Booking b : bookingArray) {
                        if (b != null && !sortedQueue.isFull()) {
                            sortedQueue.enqueue(b);
                        }
                    }
                    appointmentsFileHandler.saveAppointments(Arrays.asList(bookingArray));

                    request.setAttribute("success", "Booking updated successfully!");
                    response.sendRedirect(request.getContextPath() + "/bookings");
                } catch (NumberFormatException e) {
                    LOGGER.log(Level.WARNING, "Invalid input format", e);
                    request.setAttribute("error", "Invalid input format for booking ID or schedule.");
                    forwardToEdit(request, response);
                } catch (IllegalArgumentException e) {
                    LOGGER.log(Level.WARNING, "Validation error: " + e.getMessage(), e);
                    request.setAttribute("error", e.getMessage());
                    forwardToEdit(request, response);
                } catch (IOException e) {
                    LOGGER.log(Level.SEVERE, "IO error updating booking", e);
                    request.setAttribute("error", "Failed to update booking due to a server error.");
                    forwardToEdit(request, response);
                } catch (Exception e) {
                    LOGGER.log(Level.SEVERE, "Unexpected error updating booking", e);
                    request.setAttribute("error", "An unexpected error occurred.");
                    forwardToEdit(request, response);
                }
            }
        } else if ("/bookings/delete".equals(path)) {
            synchronized (this) {
                try {
                    int bookingId = Integer.parseInt(request.getParameter("bookingId"));
                    Booking booking = bookingFileHandler.findBookingById(bookingId);
                    if (booking == null || booking.getCustomerId() != user.getCustomerId()) {
                        throw new IllegalArgumentException("Booking not found or you don't have permission.");
                    }

                    // Restore schedule
                    Schedule schedule = new Schedule(
                            booking.getScheduleId(),
                            booking.getTime(),
                            booking.getDate(),
                            booking.getEmployeeId(),
                            booking.getEmployeeName()
                    );
                    scheduleFileHandler.saveSchedule(schedule);

                    List<Booking> bookings = bookingFileHandler.readBookings();
                    bookings.removeIf(b -> b != null && b.getBookingId() == bookingId);
                    bookingFileHandler.updateBookings(bookings);

                    // Update sorted queue and appointments.txt
                    Booking[] bookingArray = bookings.toArray(new Booking[0]);
                    QuickSort.sort(bookingArray);
                    sortedQueue.clear();
                    for (Booking b : bookingArray) {
                        if (b != null && !sortedQueue.isFull()) {
                            sortedQueue.enqueue(b);
                        }
                    }
                    appointmentsFileHandler.saveAppointments(Arrays.asList(bookingArray));

                    request.setAttribute("success", "Booking deleted successfully!");
                    response.sendRedirect(request.getContextPath() + "/bookings");
                } catch (NumberFormatException e) {
                    LOGGER.log(Level.WARNING, "Invalid booking ID", e);
                    request.setAttribute("error", "Invalid booking ID.");
                    response.sendRedirect(request.getContextPath() + "/bookings");
                } catch (IllegalArgumentException e) {
                    LOGGER.log(Level.WARNING, "Validation error: " + e.getMessage(), e);
                    request.setAttribute("error", e.getMessage());
                    response.sendRedirect(request.getContextPath() + "/bookings");
                } catch (IOException e) {
                    LOGGER.log(Level.SEVERE, "IO error deleting booking", e);
                    request.setAttribute("error", "Failed to delete booking due to a server error.");
                    response.sendRedirect(request.getContextPath() + "/bookings");
                } catch (Exception e) {
                    LOGGER.log(Level.SEVERE, "Unexpected error deleting booking", e);
                    request.setAttribute("error", "An unexpected error occurred.");
                    response.sendRedirect(request.getContextPath() + "/bookings");
                }
            }
        }
    }

    private void forwardToCreate(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setAttribute("services", serviceFileHandler.readServices());
        request.setAttribute("schedules", scheduleFileHandler.readAvailableSchedules());
        request.getRequestDispatcher("/createBooking.jsp").forward(request, response);
    }

    private void forwardToEdit(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int bookingId = Integer.parseInt(request.getParameter("bookingId"));
            request.setAttribute("booking", bookingFileHandler.findBookingById(bookingId));
        } catch (NumberFormatException e) {
            LOGGER.log(Level.WARNING, "Invalid booking ID for edit forward", e);
            request.setAttribute("error", "Invalid booking ID.");
        }
        request.setAttribute("services", serviceFileHandler.readServices());
        request.setAttribute("schedules", scheduleFileHandler.readAvailableSchedules());
        request.getRequestDispatcher("/editBooking.jsp").forward(request, response);
    }
}