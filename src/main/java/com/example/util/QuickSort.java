package com.example.util;

import com.example.models.Booking;
import java.time.LocalDate;

public class QuickSort {

    public static void sort(Booking[] bookings) {
        if (bookings == null || bookings.length == 0) return;
        quickSort(bookings, 0, bookings.length - 1);
    }

    private static void quickSort(Booking[] bookings, int low, int high) {
        if (low < high) {
            int pi = partition(bookings, low, high);
            quickSort(bookings, low, pi - 1);
            quickSort(bookings, pi + 1, high);
        }
    }

    private static int partition(Booking[] bookings, int low, int high) {
        Booking pivot = bookings[high];
        int i = low - 1;

        for (int j = low; j < high; j++) {
            if (compareBookings(bookings[j], pivot) <= 0) {
                i++;
                swap(bookings, i, j);
            }
        }
        swap(bookings, i + 1, high);
        return i + 1;
    }

    private static void swap(Booking[] bookings, int i, int j) {
        Booking temp = bookings[i];
        bookings[i] = bookings[j];
        bookings[j] = temp;
    }

    private static int compareBookings(Booking b1, Booking b2) {
        LocalDate date1 = LocalDate.parse(b1.getDate());
        LocalDate date2 = LocalDate.parse(b2.getDate());
        int dateComparison = date1.compareTo(date2);
        if (dateComparison != 0) {
            return dateComparison;
        }
        return Double.compare(b1.getTime(), b2.getTime());
    }
}