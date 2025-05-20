package com.example.util;

import com.example.models.Booking;

public class CustomQueue {
    private Booking[] queue;
    private int front;
    private int rear;
    private int size;
    private final int CAPACITY = 100;

    public CustomQueue() {
        queue = new Booking[CAPACITY];
        front = 0;
        rear = -1;
        size = 0;
    }

    public synchronized void enqueue(Booking booking) throws IllegalStateException {
        if (isFull()) {
            throw new IllegalStateException("Queue is full. Cannot add more bookings.");
        }
        rear = (rear + 1) % CAPACITY;
        queue[rear] = booking;
        size++;
    }

    public synchronized Booking dequeue() throws IllegalStateException {
        if (isEmpty()) {
            throw new IllegalStateException("Queue is empty. No bookings to remove.");
        }
        Booking booking = queue[front];
        queue[front] = null;
        front = (front + 1) % CAPACITY;
        size--;
        return booking;
    }

    public synchronized boolean isEmpty() {
        return size == 0;
    }

    public synchronized boolean isFull() {
        return size == CAPACITY;
    }

    public synchronized int size() {
        return size;
    }

    public synchronized Booking[] toArray() {
        Booking[] array = new Booking[size];
        for (int i = 0; i < size; i++) {
            array[i] = queue[(front + i) % CAPACITY];
        }
        return array;
    }

    public synchronized void clear() {
        for (int i = 0; i < size; i++) {
            queue[(front + i) % CAPACITY] = null;
        }
        front = 0;
        rear = -1;
        size = 0;
    }
}