//
//  AdminBookingsView.swift
//  Yagoda
//
//  Created by Tanvir Ahmed on 14/1/25.
//

import Foundation
import SwiftUI
import FirebaseFirestore

struct AdminBookingsView: View {
    @State private var bookings: [Booking] = []
    @State private var isLoading = true
    @State private var showToast = false
    @State private var toastMessage = ""
    @State private var isError = false

    var body: some View {
        Group {
            if isLoading {
                ProgressView("Loading bookings...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if bookings.isEmpty {
                EmptyAdminBookingsView()
            } else {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        // Statistics Section
                        BookingStatsView(bookings: bookings)
                            .padding(.horizontal)
                        
                        // Bookings List
                        ForEach(bookings) { booking in
                            AdminBookingCard(booking: booking) {
                                confirmBooking(booking)
                            }
                        }
                    }
                    .padding()
                }
            }
        }
        .onAppear(perform: fetchBookings)
        .navigationTitle("Admin Dashboard")
        .overlay(
            Group {
                if showToast {
                    ToastView(message: toastMessage, isError: isError)
                        .transition(.move(edge: .top))
                        .animation(.spring(), value: showToast)
                }
            }
        )
    }

    private func fetchBookings() {
        Firestore.firestore().collection("bookings")
            .getDocuments { snapshot, error in
                isLoading = false
                if let error = error {
                    print("Error fetching bookings: \(error.localizedDescription)")
                    showErrorToast(message: error.localizedDescription)
                    return
                }
                
                bookings = snapshot?.documents.compactMap { document -> Booking? in
                    try? document.data(as: Booking.self)
                } ?? []
            }
    }

    private func confirmBooking(_ booking: Booking) {
        guard let bookingId = booking.id else { return }
        
        Firestore.firestore().collection("bookings")
            .document(bookingId)
            .updateData(["status": "confirmed"]) { error in
                if let error = error {
                    showErrorToast(message: error.localizedDescription)
                } else {
                    showSuccessToast(message: "Booking confirmed!")
                    fetchBookings()
                }
            }
    }
    
    private func showErrorToast(message: String) {
        toastMessage = message
        isError = true
        showToast = true
        hideToastAfterDelay()
    }
    
    private func showSuccessToast(message: String) {
        toastMessage = message
        isError = false
        showToast = true
        hideToastAfterDelay()
    }
    
    private func hideToastAfterDelay() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                showToast = false
            }
        }
    }
}

struct AdminBookingCard: View {
    let booking: Booking
    let onConfirm: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Image Section
            AsyncImage(url: URL(string: booking.image)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .overlay(ProgressView())
            }
            .frame(height: 150)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
            // Details Section
            VStack(alignment: .leading, spacing: 8) {
                Text(booking.name)
                    .font(.title3)
                    .fontWeight(.bold)
                
                HStack {
                    Image(systemName: "calendar")
                        .foregroundColor(.blue)
                    Text(booking.date.formatted(date: .long, time: .omitted))
                }
                
                HStack {
                    StatusBadge(status: booking.status)
                    Spacer()
                    if booking.status == "pending" {
                        Button(action: onConfirm) {
                            Text("Confirm Booking")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(Color.blue)
                                .cornerRadius(8)
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
        .background(Color(UIColor.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        .padding(.horizontal)
    }
}

struct StatusBadge: View {
    let status: String
    
    var body: some View {
        HStack {
            Image(systemName: status == "confirmed" ? "checkmark.circle.fill" : "clock.fill")
            Text(status.capitalized)
                .font(.subheadline)
                .fontWeight(.medium)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(status == "confirmed" ? Color.green.opacity(0.2) : Color.orange.opacity(0.2))
        .foregroundColor(status == "confirmed" ? .green : .orange)
        .cornerRadius(8)
    }
}

struct BookingStatsView: View {
    let bookings: [Booking]
    
    var confirmedCount: Int {
        bookings.filter { $0.status == "confirmed" }.count
    }
    
    var pendingCount: Int {
        bookings.filter { $0.status == "pending" }.count
    }
    
    var body: some View {
        HStack {
            StatCard(title: "Total", count: bookings.count, color: .blue)
            StatCard(title: "Confirmed", count: confirmedCount, color: .green)
            StatCard(title: "Pending", count: pendingCount, color: .orange)
        }
    }
}

struct StatCard: View {
    let title: String
    let count: Int
    let color: Color
    
    var body: some View {
        VStack {
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
            Text("\(count)")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(color)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(color.opacity(0.1))
        .cornerRadius(10)
    }
}

struct EmptyAdminBookingsView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "list.clipboard")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("No Bookings")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Bookings will appear here")
                .font(.body)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
